Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935190AbcKDTMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 15:12:53 -0400
Subject: Re: [PATCH 6/6] xfs: don't call xfs_sb_quota_from_disk twice
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828433466.31793.7424646031402565530.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2fd6e54e-8488-6e91-bde1-af9018ac9877@sandeen.net>
Date: Fri, 4 Nov 2016 14:12:52 -0500
MIME-Version: 1.0
In-Reply-To: <147828433466.31793.7424646031402565530.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>

On 11/4/16 1:32 PM, Eric Sandeen wrote:
>>From ee3754254e8c186c99b6cdd4d59f741759d04acb Mon Sep 17 00:00:00 2001
> 
> kernel commit 5ef828c4
> xfs: avoid false quotacheck after unclean shutdown
> 
> made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
> by default.
> 
> However, when this was merged to libxfs, existing separate
> calls to libxfs_sb_quota_from_disk remained, and calling it
> twice in a row on a V4 superblock leads to issues, because:
> 
>         if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> ...
>                 sbp->sb_pquotino = sbp->sb_gquotino;
>                 sbp->sb_gquotino = NULLFSINO;
> 
> and after the second call, we have set both pquotino and gquotino
> to NULLFSINO.
> 
> Fix this by making it safe to call twice, and also remove the extra
> calls to libxfs_sb_quota_from_disk.
> 
> This is only spotted when running xfstests with "-m crc=0" because
> the sb_from_disk change came about after V5 became default, and
> the above behavior only exists on a V4 superblock.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_sb.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a70aec9..7a39240 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -338,13 +338,16 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
>  
> -	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
> +	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
> +	    sbp->sb_gquotino != NULLFSINO)  {
>  		/*
>  		 * In older version of superblock, on-disk superblock only
>  		 * has sb_gquotino, and in-core superblock has both sb_gquotino
>  		 * and sb_pquotino. But, only one of them is supported at any
>  		 * point of time. So, if PQUOTA is set in disk superblock,
> -		 * copy over sb_gquotino to sb_pquotino.
> +		 * copy over sb_gquotino to sb_pquotino.  The NULLFSINO test
> +		 * above is to make sure we don't do this twice and wipe them
> +		 * both out!
>  		 */
>  		sbp->sb_pquotino = sbp->sb_gquotino;
>  		sbp->sb_gquotino = NULLFSINO;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
