Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37626 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbeFESot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Jun 2018 14:44:49 -0400
Subject: Re: [PATCH] xfs: mark sb_fname as nonstring
References: <20180525151421.2317292-1-arnd@arndb.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ea7ec2ef-f30f-c4dc-c1d3-c0a2a4810fd5@sandeen.net>
Date: Tue, 5 Jun 2018 13:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <20180525151421.2317292-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org



On 5/25/18 10:14 AM, Arnd Bergmann wrote:
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
> ---
>  fs/xfs/xfs_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 84fbf164cbc3..eb79f2bc4dcc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1819,12 +1819,12 @@ xfs_ioc_getlabel(
>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>  
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
> +	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	/* xfs on-disk label is 12 chars, be sure we send a null to user */
>  	label[XFSLABEL_MAX] = '\0';
> -	if (copy_to_user(user_label, label, sizeof(sbp->sb_fname)))
> +	if (copy_to_user(user_label, label, sizeof(label)))

I /think/ this also runs the risk of copying out stack memory.

I'll send another proposal based on this with slight modifications.

>  		return -EFAULT;
>  	return 0;
>  }
> @@ -1860,7 +1860,7 @@ xfs_ioc_setlabel(
>  
>  	spin_lock(&mp->m_sb_lock);
>  	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
> -	strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
> +	memcpy(sbp->sb_fname, label, len);
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	/*
> 
