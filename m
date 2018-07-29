Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52670 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbeG2R1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jul 2018 13:27:15 -0400
Date: Sun, 29 Jul 2018 08:56:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs/288: use -d option of xfs_db write command for v5 XFS
Message-ID: <20180729155617.GA4211@magnolia>
References: <20180729142053.4240-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180729142053.4240-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Jul 29, 2018 at 10:20:53PM +0800, Zorro Lang wrote:
> The commit b3cf8b72334fd35ef961869506e5a72ab398bc82 update xfs/288
> to support v5 filesystem testing. That commit thought xfs_db write
> command can work well with -d option on V5 XFS. But the truth is
> the case doesn't use that option.
> 
> So turn to use _scratch_xfs_set_metadata_field, it will help to use
> proper options for xfs_db write command.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Looks like a reasonable replacement,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Hi,
> 
> Missing '-d' option is a case issue. But from this issue, we found another
> bug of xfsprogs. On current upstream, this case will test pass on v5 XFS,
> even there's not '-d' option for write command.
> 
> That's a bug, we'll fix it later. For now, I'd like to fix this case
> issue at first.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/288 | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/288 b/tests/xfs/288
> index bccdb6fc..f4165b6c 100755
> --- a/tests/xfs/288
> +++ b/tests/xfs/288
> @@ -56,9 +56,8 @@ $SETFATTR_PROG -n "user.testattr${seq}" \
>  
>  _scratch_unmount
>  # manually corrupt the XFS, by set the header count of attr to 0
> -_scratch_xfs_db -x -c "inode $inum" \
> -		   -c "ablock 0" \
> -		   -c "write hdr.count 0" >> $seqres.full
> +_scratch_xfs_set_metadata_field "hdr.count" "0" \
> +				"inode $inum" "ablock 0" >> $seqres.full
>  
>  # make sure xfs_repair can find above corruption. If it can't, that
>  # means we need to fix this bug on current xfs_repair
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
