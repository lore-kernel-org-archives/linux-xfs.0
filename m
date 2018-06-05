Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33717 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbeFEV2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 17:28:25 -0400
Subject: Re: [PATCH V2] xfs: fix string handling in get/set functions
References: <20180525151421.2317292-1-arnd@arndb.de>
 <7aad9fc3-ed65-a016-d477-5d830e31cb43@sandeen.net>
From: Martin Sebor <msebor@gmail.com>
Message-ID: <3623eb64-1549-f3ad-d50b-dfe98781b119@gmail.com>
Date: Tue, 5 Jun 2018 15:28:21 -0600
MIME-Version: 1.0
In-Reply-To: <7aad9fc3-ed65-a016-d477-5d830e31cb43@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org

On 06/05/2018 01:49 PM, Eric Sandeen wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> [sandeen: fix subject, avoid copy-out of uninit data in getlabel]
>
> gcc-8 reports two warnings for the newly added getlabel/setlabel code:
>
> fs/xfs/xfs_ioctl.c: In function 'xfs_ioc_getlabel':
> fs/xfs/xfs_ioctl.c:1822:38: error: argument to 'sizeof' in 'strncpy' call is the same expression as the source; did you mean to use the size of the destination? [-Werror=sizeof-pointer-memaccess]
>   strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
>                                       ^
> In function 'strncpy',
>     inlined from 'xfs_ioc_setlabel' at /git/arm-soc/fs/xfs/xfs_ioctl.c:1863:2,
>     inlined from 'xfs_file_ioctl' at /git/arm-soc/fs/xfs/xfs_ioctl.c:1918:10:
> include/linux/string.h:254:9: error: '__builtin_strncpy' output may be truncated copying 12 bytes from a string of length 12 [-Werror=stringop-truncation]
>   return __builtin_strncpy(p, q, size);
>
> In both cases, part of the problem is that one of the strncpy()
> arguments is a fixed-length character array with zero-padding rather
> than a zero-terminated string. In the first one case, we also get an
> odd warning about sizeof-pointer-memaccess, which doesn't seem right
> (the sizeof is for an array that happens to be the same as the second
> strncpy argument).
>
> To work around the bogus warning, I use a plain 'XFSLABEL_MAX' for
> the strncpy() length when copying the label in getlabel. For setlabel(),
> using memcpy() with the correct length that is already known avoids
> the second warning and is slightly simpler.
>
> In a related issue, it appears that we accidentally skip the trailing
> \0 when copying a 12-character label back to user space in getlabel().
> Using the correct sizeof() argument here copies the extra character.
>
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=85602
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Martin Sebor <msebor@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 82f7c83c1dad..596e176c19a6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1828,13 +1828,13 @@ xfs_ioc_getlabel(
>  	/* Paranoia */
>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>
> +	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
> +	memset(label, 0, sizeof(label));
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
> +	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>  	spin_unlock(&mp->m_sb_lock);

I don't see this code in my copy of the kernel so I may be missing
some context but assuming label is at least one byte larger than
sb_fname then the following would be how GCC expects strncpy to be
used in this case:

   char label[sizeof sbp->sb_fname + 1];
   strncpy (label, sbp->sb_fname, sizeof label - 1);
   label[sizeof label - 1] = '\0';

Since strncpy() zeroes out the destination past the first nul this
should also obviate the call to memset() above that GCC unfortunately
doesn't eliminate (I just opened bug 86061 to add this optimization).

Martin

>
> -	/* xfs on-disk label is 12 chars, be sure we send a null to user */
> -	label[XFSLABEL_MAX] = '\0';
> -	if (copy_to_user(user_label, label, sizeof(sbp->sb_fname)))
> +	if (copy_to_user(user_label, label, sizeof(label)))
>  		return -EFAULT;
>  	return 0;
>  }
> @@ -1870,7 +1870,7 @@ xfs_ioc_setlabel(
>
>  	spin_lock(&mp->m_sb_lock);
>  	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
> -	strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
> +	memcpy(sbp->sb_fname, label, len);
>  	spin_unlock(&mp->m_sb_lock);
>
>  	/*
>

