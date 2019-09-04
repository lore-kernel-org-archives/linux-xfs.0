Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2875EC3A5A9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 21:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D0D208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 21:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfIDVny (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 17:43:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33747 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729740AbfIDVny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 17:43:54 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A0A46362D68;
        Thu,  5 Sep 2019 07:43:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5d4A-0007iD-Cl; Thu, 05 Sep 2019 07:43:50 +1000
Date:   Thu, 5 Sep 2019 07:43:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: factor iclog state processing out of
 xlog_state_do_callback()
Message-ID: <20190904214350.GH1119@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-6-david@fromorbit.com>
 <20190904064221.GA3960@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904064221.GA3960@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=Axf1hsjdTu4ihoqG9M0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 11:42:21PM -0700, Christoph Hellwig wrote:
> On Wed, Sep 04, 2019 at 02:24:49PM +1000, Dave Chinner wrote:
> > +	/* Skip all iclogs in the ACTIVE & DIRTY states */
> > +	if (iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))
> > +		return false;
> 
> Please use spaces around the "|".

Fixed.

> 
> > +			if (iclog->ic_state & XLOG_STATE_IOERROR)
> > +				ioerrors++;
> 
> This now also counts the ierrror flag for dirty and active iclogs.
> Not sure it matters given our state machine, but it does change
> behavior.

True. There's an ioerror check in xlog_state_iodone_process_iclog()
so I can pass the ioerror parameter into it and retain the existing
logic.

> > +			ret = xlog_state_iodone_process_iclog(log, iclog,
> > +								ciclog);
> > +			if (ret)
> > +				break;
> 
> No need for the ret variable.

Fixed.

> >  
> > -			} else
> > -				ioerrors++;
> > +			if (!(iclog->ic_state &
> > +			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
> > +				iclog = iclog->ic_next;
> > +				continue;
> > +			}
> 
> Btw, one cleanup I had pending is that all our loops ovr the iclog
> list can be cleaned up nicely so that continue does that right thing
> without all these manual "iclog = iclog->ic_next" next statements.  Just
> turn the loop into:
> 
> 	do {
> 		..
> 	} while ((iclog = iclog->ic_next) != first_iclog);
> 
> this might be applicable to a few of your patches.

Yup, as I mentioned earlier, that's in progress :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
