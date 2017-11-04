Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbdKDFZH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Nov 2017 01:25:07 -0400
Date: Sat, 4 Nov 2017 13:25:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 12/14] generic/204: use available blocks to determine
 the number of files to create
Message-ID: <20171104052504.GG17339@eguan.usersys.redhat.com>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957286222.18388.3253654888670864191.stgit@magnolia>
 <20171103042619.GB1233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103042619.GB1233@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 02, 2017 at 09:26:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the available block count to compute the number of files we think
> we can create, rather than hardcoding a particular size.  This fixes
> the ENOSPC failures for xfs filesystems with rmap/reflink support.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/204 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/204 b/tests/generic/204
> index 4c203a2..ac417a7 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -69,7 +69,7 @@ _scratch_mount
>  # work out correctly. Space usages is based 22500 files and 1024 reserved blocks
>  # on a 4k block size 256 byte inode size filesystem.
>  resv_blks=1024
> -space=97920000
> +space=$(stat -f -c '%f * %S' $SCRATCH_MNT | $BC_PROG)

Hmm, this regressed test with 512B block size XFS. I'll drop it for now.

Thanks,
Eryu

>  
>  # decrease files for inode size.
>  #	22500 * (256 + 4k) = ~97MB
