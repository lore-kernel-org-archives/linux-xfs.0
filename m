Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B471C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 05:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD1164E2E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 05:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhCAFpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 00:45:42 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49977 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231653AbhCAFpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 00:45:41 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 4B03E1ADE64;
        Mon,  1 Mar 2021 16:44:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lGbMT-009S99-RG; Mon, 01 Mar 2021 16:44:53 +1100
Date:   Mon, 1 Mar 2021 16:44:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210301054453.GE4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
 <8735xk7pr2.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735xk7pr2.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=UgL5dse1xpEXFGOvYTIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:39:05AM +0530, Chandan Babu R wrote:
> On 23 Feb 2021 at 13:35, Dave Chinner wrote:
> > @@ -2009,13 +2010,14 @@ xlog_sync(
> >  	 * synchronously here; for an internal log we can simply use the block
> >  	 * layer state machine for preflushes.
> >  	 */
> > -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> > +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> > +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
> >  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> > -		need_flush = false;
> > +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> >  	}
> 
> If a checkpoint transaction spans across 2 or more iclogs and the log is
> stored on an external device, then the above would remove XLOG_ICL_NEED_FLUSH
> flag from iclog->ic_flags causing xlog_write_iclog() to include only REQ_FUA
> flag in the corresponding bio.

Yup, good catch, this is a subtle change of behaviour only for
external logs and only for the commit iclog that needs to flush the
previous log writes to stable storage. I'll rework the logic here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
