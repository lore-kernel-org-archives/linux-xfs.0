Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56852C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 05:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A12464E31
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 05:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhCAF5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 00:57:45 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59200 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231247AbhCAF5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 00:57:43 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E31D31041272;
        Mon,  1 Mar 2021 16:56:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lGbYB-009T05-E3; Mon, 01 Mar 2021 16:56:59 +1100
Date:   Mon, 1 Mar 2021 16:56:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <20210301055659.GF4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
 <8735xk7pr2.fsf@garuda>
 <20210301054453.GE4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301054453.GE4662@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=qq_oq4w3_H_SAqW8XJ4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 01, 2021 at 04:44:53PM +1100, Dave Chinner wrote:
> On Thu, Feb 25, 2021 at 09:39:05AM +0530, Chandan Babu R wrote:
> > On 23 Feb 2021 at 13:35, Dave Chinner wrote:
> > > @@ -2009,13 +2010,14 @@ xlog_sync(
> > >  	 * synchronously here; for an internal log we can simply use the block
> > >  	 * layer state machine for preflushes.
> > >  	 */
> > > -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> > > +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> > > +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
> > >  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> > > -		need_flush = false;
> > > +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> > >  	}
> > 
> > If a checkpoint transaction spans across 2 or more iclogs and the log is
> > stored on an external device, then the above would remove XLOG_ICL_NEED_FLUSH
> > flag from iclog->ic_flags causing xlog_write_iclog() to include only REQ_FUA
> > flag in the corresponding bio.
> 
> Yup, good catch, this is a subtle change of behaviour only for
> external logs and only for the commit iclog that needs to flush the
> previous log writes to stable storage. I'll rework the logic here.

And now that I think about it, we can simply remove this code if we
put an explicit data device cache flush in the unmount recrod write
code. The CIL has already guaranteed metadata vs journal ordering
before we start writing the checkpoint, meaning the
XLOG_ICL_NEED_FLUSH flag only has meaning for internal iclog write
ordering, not external metadata ordering. ANd for the split, we can
simply clear the REQ_PREFLUSH flag from the split bio before
submitting it....

Much simpler and faster for external logs, too.

CHeers,

Dav.e
-- 
Dave Chinner
david@fromorbit.com
