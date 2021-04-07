Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916A4C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68DBA61353
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353906AbhDGPv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241102AbhDGPvM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F4061262;
        Wed,  7 Apr 2021 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617810662;
        bh=KfxrwXNCUNZaIz7RS4RPsa4HB9GQvKhC4kk11Km7Z68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdcnlRzyA1QskT3HEU4PGt1+UxG4/vmtkk2Yy3Ied6oXIlbbfAlEGiLJpzbU1/ow5
         VLMxZvvxeGVXT9TrMWa9kaMp/GOclZAxVE0+ThIluoj7siYs3AHiAtdFbeZ4BRBhIh
         KJMtdvNjqLaTyL8qLXLanhvukTS8P5ugCL2lqmWnIVp0TOQ66fepit3mmrw1FC1+dV
         GgKsyEyIdJzFOx8P6VLPR7fOkFTWgrrBq1wJNGONxiX5EFE7TYFrPkFjCIDutuLz13
         RmBDgqNF5bxdaS36lRxSSj1+Elyfg/6wDwGyvhJK60YgGVih2FubwEAFSmstX9zLxJ
         m4tjXVGomaBOg==
Date:   Wed, 7 Apr 2021 08:51:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: skip dquot reservations if quota is inactive
Message-ID: <20210407155102.GO3957620@magnolia>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406144238.814558-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 10:42:36AM -0400, Brian Foster wrote:
> The dquot reservation helper currently performs the associated
> reservation for any provided dquots. The dquots could have been
> acquired from inode references or explicit dquot allocation
> requests. Some reservation callers may have already checked that the
> associated quota subsystem is active (xfs_qm_dqget() returns an
> error otherwise), while others might not have checked at all
> (xfs_trans_reserve_quota_nblks() passes the inode references).
> Further, subsequent dquot modifications do actually check that the
> associated quota is active before making transactional changes
> (xfs_trans_mod_dquot_byino()).
> 
> Given all of that, the behavior to unconditionally perform
> reservation on any provided dquots is somewhat ad hoc. While it is
> currently harmless, it is not without side effect. If the quota is
> inactive by the time a transaction attempts a quota reservation, the
> dquot will be attached to the transaction and subsequently logged,
> even though no dquot modifications are ultimately made.
> 
> This is a problem for upcoming quotaoff changes that intend to
> implement a strict transactional barrier for logging dquots during a
> quotaoff operation. If a dquot is logged after the subsystem
> deactivated and the barrier released, a subsequent log recovery can
> incorrectly replay dquot changes into the filesystem.
> 
> Therefore, update the dquot reservation path to also check that a
> particular quota mode is active before associating a dquot with a
> transaction. This should have no noticeable impact on the current
> code that already accommodates checking active quota state at points
> before and after quota reservations are made.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

If you end up reposting this, please change to:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 48e09ea30ee5..eec640999148 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -40,14 +40,12 @@ xfs_trans_dqjoin(
>  }
>  
>  /*
> - * This is called to mark the dquot as needing
> - * to be logged when the transaction is committed.  The dquot must
> - * already be associated with the given transaction.
> - * Note that it marks the entire transaction as dirty. In the ordinary
> - * case, this gets called via xfs_trans_commit, after the transaction
> - * is already dirty. However, there's nothing stop this from getting
> - * called directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY
> - * flag.
> + * This is called to mark the dquot as needing to be logged when the transaction
> + * is committed. The dquot must already be associated with the given
> + * transaction. Note that it marks the entire transaction as dirty. In the
> + * ordinary case, this gets called via xfs_trans_commit, after the transaction
> + * is already dirty. However, there's nothing stop this from getting called
> + * directly, as done by xfs_qm_scall_setqlim. Hence, the TRANS_DIRTY flag.
>   */
>  void
>  xfs_trans_log_dquot(
> @@ -743,19 +741,19 @@ xfs_trans_reserve_quota_bydquots(
>  
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
> -	if (udqp) {
> +	if (XFS_IS_UQUOTA_ON(mp) && udqp) {
>  		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
>  		if (error)
>  			return error;
>  	}
>  
> -	if (gdqp) {
> +	if (XFS_IS_GQUOTA_ON(mp) && gdqp) {
>  		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
>  		if (error)
>  			goto unwind_usr;
>  	}
>  
> -	if (pdqp) {
> +	if (XFS_IS_PQUOTA_ON(mp) && pdqp) {
>  		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
>  		if (error)
>  			goto unwind_grp;
> -- 
> 2.26.3
> 
