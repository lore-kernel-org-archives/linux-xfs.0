Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FED8C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 23:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F78520760
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 23:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgGPX5V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:57:21 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:46013 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgGPX5U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 19:57:20 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 92AA61A90E1;
        Fri, 17 Jul 2020 09:57:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwDkZ-0001UP-U8; Fri, 17 Jul 2020 09:57:15 +1000
Date:   Fri, 17 Jul 2020 09:57:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: always use xfs_dquot_type when extracting
 type from a dquot
Message-ID: <20200716235715.GS2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488195772.3813063.4337415651120546350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488195772.3813063.4337415651120546350.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=kwpZm_1HwxUCDXddcM0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always use the xfs_dquot_type helper to extract the quota type from an
> incore dquot.  This moves responsibility for filtering internal state
> information and whatnot to anybody passing around a dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   15 ++++++++-------
>  fs/xfs/xfs_dquot.h |    2 +-
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 

looks ok, minor nit below

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index ce946d53bb61..b46a9e63b286 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -273,14 +273,15 @@ xfs_dquot_disk_alloc(
>  	struct xfs_trans	*tp = *tpp;
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp;
> -	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
> +	uint			qtype = xfs_dquot_type(dqp);
> +	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
>  	int			nmaps = 1;
>  	int			error;
>  
>  	trace_xfs_dqalloc(dqp);
>  
>  	xfs_ilock(quotip, XFS_ILOCK_EXCL);
> -	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
> +	if (!xfs_this_quota_on(dqp->q_mount, qtype)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we didn't
>  		 * have an inode lock
> @@ -317,8 +318,7 @@ xfs_dquot_disk_alloc(
>  	 * Make a chunk of dquots out of this buffer and log
>  	 * the entire thing.
>  	 */
> -	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id,
> -			      dqp->dq_flags & XFS_DQTYPE_REC_MASK, bp);
> +	xfs_qm_init_dquot_blk(tp, mp, dqp->q_id, xfs_dquot_type(dqp), bp);

This should use 'qtype' rather than call xfs_dquot_type() again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
