Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E1BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24B264E59
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbhCDARe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38624 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447496AbhCCPDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 10:03:50 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lHSjK-0004fB-FX; Wed, 03 Mar 2021 14:44:02 +0000
Date:   Wed, 3 Mar 2021 14:44:01 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com
Subject: Re: [PATCH 1/3] xfs: fix quota accounting when a mount is idmapped
Message-ID: <20210303144401.eqmsqm7y232gn6mu@wittgenstein>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
 <161472410230.3421449.11155796770029064636.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161472410230.3421449.11155796770029064636.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 02:28:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Nowadays, we indirectly use the idmap-aware helper functions in the VFS
> to set the initial uid and gid of a file being created.  Unfortunately,
> we didn't convert the quota code, which means we attach the wrong dquots
> to files created on an idmapped mount.
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This looks good but it misses one change, I think. The
xfs_ioctl_setattr() needs to take the mapping into account as well:

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 99dfe89a8d08..067366bf9a59 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1460,8 +1460,8 @@ xfs_ioctl_setattr(
         * because the i_*dquot fields will get updated anyway.
         */
        if (XFS_IS_QUOTA_ON(mp)) {
-               error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
-                               VFS_I(ip)->i_gid, fa->fsx_projid,
+               error = xfs_qm_vop_dqalloc(ip, i_uid_into_mnt(mnt_userns, VFS_I(ip)),
+                               i_gid_into_mnt(mnt_userns, VFS_I(ip)), fa->fsx_projid,
                                XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
                if (error)
                        return error;

This should cover all callsites.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

>  fs/xfs/xfs_inode.c   |   14 ++++++++------
>  fs/xfs/xfs_symlink.c |    3 ++-
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 46a861d55e48..f93370bd7b1e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1007,9 +1007,10 @@ xfs_create(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
> -					&udqp, &gdqp, &pdqp);
> +	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
> +			fsgid_into_mnt(mnt_userns), prid,
> +			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
> +			&udqp, &gdqp, &pdqp);
>  	if (error)
>  		return error;
>  
> @@ -1157,9 +1158,10 @@ xfs_create_tmpfile(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> -				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
> -				&udqp, &gdqp, &pdqp);
> +	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
> +			fsgid_into_mnt(mnt_userns), prid,
> +			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
> +			&udqp, &gdqp, &pdqp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1379013d74b8..7f368b10ded1 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -182,7 +182,8 @@ xfs_symlink(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> +	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
> +			fsgid_into_mnt(mnt_userns), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>  			&udqp, &gdqp, &pdqp);
>  	if (error)
> 
