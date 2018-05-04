Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42018 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbeEDTRA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 15:17:00 -0400
Subject: Re: [PATCH 02/11] xfs_repair: don't leak buffer on xattr remote buf
 verifier error
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401960402.13319.3526134260258053342.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b375867-dc46-d93a-582c-19e103098cb1@sandeen.net>
Date: Fri, 4 May 2018 14:16:59 -0500
MIME-Version: 1.0
In-Reply-To: <152401960402.13319.3526134260258053342.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we try to read an xattr remote buffer and hit a verifier error,
> release the buffer instead of leaking it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Good plan.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/attr_repair.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index bb5ab3d..3e6efd0 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -433,6 +433,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
>  			do_warn(
>  	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
> +			libxfs_putbuf(bp);
>  			clearit = 1;
>  			break;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
