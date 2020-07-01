Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B69C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB79F207E8
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGAXBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:01:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39238 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726235AbgGAXBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:01:41 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 92F57821E7D;
        Thu,  2 Jul 2020 09:01:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqljU-00011n-RZ; Thu, 02 Jul 2020 09:01:36 +1000
Date:   Thu, 2 Jul 2020 09:01:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: stop using q_core limits in the quota code
Message-ID: <20200701230136.GB2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353175596.2864738.3236954866547071975.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353175596.2864738.3236954866547071975.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=7_Lx_3k-7i-mij6Aak0A:9 a=UKaE4MGVuK8edJad:21 a=wGTRTb02GhIbc7GI:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add limits fields in the incore dquot, and use that instead of the ones
> in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> @@ -124,82 +123,67 @@ xfs_qm_adjust_dqtimers(
>  	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
>  
>  #ifdef DEBUG
> -	if (d->d_blk_hardlimit)
> -		ASSERT(be64_to_cpu(d->d_blk_softlimit) <=
> -		       be64_to_cpu(d->d_blk_hardlimit));
> -	if (d->d_ino_hardlimit)
> -		ASSERT(be64_to_cpu(d->d_ino_softlimit) <=
> -		       be64_to_cpu(d->d_ino_hardlimit));
> -	if (d->d_rtb_hardlimit)
> -		ASSERT(be64_to_cpu(d->d_rtb_softlimit) <=
> -		       be64_to_cpu(d->d_rtb_hardlimit));
> +	if (dq->q_blk.hardlimit)
> +		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> +	if (dq->q_ino.hardlimit)
> +		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> +	if (dq->q_rtb.hardlimit)
> +		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
>  #endif

You can get rid of the ifdef DEBUG here - if ASSERT is not defined
then the compiler will elide all this code anyway.

>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> @@ -1123,9 +1119,29 @@ static xfs_failaddr_t
>  xfs_qm_dqflush_check(
>  	struct xfs_dquot	*dqp)
>  {
> +	struct xfs_disk_dquot	*ddq = &dqp->q_core;
> +
>  	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
>  		return __this_address;
>  
> +	if (dqp->q_id == 0)
> +		return NULL;
> +
> +	if (dqp->q_blk.softlimit &&
> +	    be64_to_cpu(ddq->d_bcount) > dqp->q_blk.softlimit &&
> +	    !ddq->d_btimer)
> +		return __this_address;
> +
> +	if (dqp->q_ino.softlimit &&
> +	    be64_to_cpu(ddq->d_icount) > dqp->q_ino.softlimit &&
> +	    !ddq->d_itimer)
> +		return __this_address;
> +
> +	if (dqp->q_rtb.softlimit &&
> +	    be64_to_cpu(ddq->d_rtbcount) > dqp->q_rtb.softlimit &&
> +	    !ddq->d_rtbtimer)
> +		return __this_address;

These are new in this patch. These are checked by
xfs_dquot_verify(), so what's the reason for duplicating the checks
here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
