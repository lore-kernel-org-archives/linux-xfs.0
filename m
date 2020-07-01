Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D95C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827852082F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGAWlR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:41:17 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:37443 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726667AbgGAWlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:41:16 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 87E73D59028;
        Thu,  2 Jul 2020 08:41:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqlPk-0000rc-Lo; Thu, 02 Jul 2020 08:41:12 +1000
Date:   Thu, 2 Jul 2020 08:41:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200701224112.GY2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353172899.2864738.6438709598863248951.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=JzuGvXVumQK3pfYgDAoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8..46c8ca83c04d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -524,13 +524,27 @@ xfs_dquot_alloc(
>  }
>  
>  /* Copy the in-core quota fields in from the on-disk buffer. */
> -STATIC void
> +STATIC int
>  xfs_dquot_from_disk(
>  	struct xfs_dquot	*dqp,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
>  
> +	/*
> +	 * The only field the verifier didn't check was the quota type flag, so
> +	 * do that here.
> +	 */
> +	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
> +	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
> +	    dqp->q_core.d_id != ddqp->d_id) {
> +		xfs_alert(bp->b_mount,
> +			  "Metadata corruption detected at %pS, quota %u",
> +			  __this_address, be32_to_cpu(dqp->q_core.d_id));

Probably should indicate which quota type is invalid, too. Also,
looking at xfs_buf_corruption_error(), it also uses

		xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR, ....

Should that be used here, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
