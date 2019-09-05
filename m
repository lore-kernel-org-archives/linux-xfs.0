Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70021C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A879B2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391112AbfIEWR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:17:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35566 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388847AbfIEWR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:17:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6B2113623B7;
        Fri,  6 Sep 2019 08:17:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i604h-0002iC-DP; Fri, 06 Sep 2019 08:17:55 +1000
Date:   Fri, 6 Sep 2019 08:17:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor callbacks out of xlog_state_do_callback()
Message-ID: <20190905221755.GI1119@dread.disaster.area>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-6-david@fromorbit.com>
 <20190905153907.GF2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905153907.GF2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=olxPpyrDeu9dZ1i6yc4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 08:39:07AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 05, 2019 at 06:47:14PM +1000, Dave Chinner wrote:
> > @@ -2795,31 +2831,13 @@ xlog_state_do_callback(
> >  			} else
> >  				ioerrors++;
> >  
> > -			spin_unlock(&log->l_icloglock);
> > -
> >  			/*
> > -			 * Keep processing entries in the callback list until
> > -			 * we come around and it is empty.  We need to
> > -			 * atomically see that the list is empty and change the
> > -			 * state to DIRTY so that we don't miss any more
> > -			 * callbacks being added.
> > +			 * Running callbacks will drop the icloglock which means
> > +			 * we'll have to run at least one more complete loop.
> >  			 */
> > -			spin_lock(&iclog->ic_callback_lock);
> > -			while (!list_empty(&iclog->ic_callbacks)) {
> > -				LIST_HEAD(tmp);
> > +			cycled_icloglock = true;
> > +			xlog_state_do_iclog_callbacks(log, iclog, aborted);
> >  
> > -				list_splice_init(&iclog->ic_callbacks, &tmp);
> > -
> > -				spin_unlock(&iclog->ic_callback_lock);
> > -				xlog_cil_process_committed(&tmp, aborted);
> > -				spin_lock(&iclog->ic_callback_lock);
> > -			}
> > -
> > -			loopdidcallbacks++;
> > -			funcdidcallbacks++;
> > -
> > -			spin_lock(&log->l_icloglock);
> > -			spin_unlock(&iclog->ic_callback_lock);
> >  			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
> >  				iclog->ic_state = XLOG_STATE_DIRTY;
> >  
> > @@ -2835,6 +2853,8 @@ xlog_state_do_callback(
> >  			iclog = iclog->ic_next;
> >  		} while (first_iclog != iclog);
> >  
> > +		funcdidcallbacks += cycled_icloglock;
> 
> funcdidcallbacks is effectively a yes/no state flag, so maybe it should
> be turned into a boolean and this statement becomes:
> 
> 	funcdidcallbacks |= cycled_icloglock;

Fixed. I renamed it to did_callbacks at the same time, just to be a
little less eye-bleedy...

> Though I guess we're not at huge risk of integer overflow and it
> controls whether or not we run a debugging check so maybe we don't care?

All that really matters is we don't need a branch to calculate it :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
