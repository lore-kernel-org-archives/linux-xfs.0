Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E212AC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B64EF61242
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhFBWUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:20:54 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41982 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFBWUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 18:20:53 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 48D921B0251;
        Thu,  3 Jun 2021 08:18:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loZCO-008Ft9-JI; Thu, 03 Jun 2021 08:18:52 +1000
Date:   Thu, 3 Jun 2021 08:18:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/39] xfs: pass lv chain length into xlog_write()
Message-ID: <20210602221852.GV664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-21-david@fromorbit.com>
 <20210527172027.GL202144@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527172027.GL202144@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=RL6bel9seZn5vHOE32YA:9 a=VVkh5hy8ODWduxvC:21 a=QojQWeJkPwKF1EIg:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 10:20:27AM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:12:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The caller of xlog_write() usually has a close accounting of the
> > aggregated vector length contained in the log vector chain passed to
> > xlog_write(). There is no need to iterate the chain to calculate he
> > length of the data in xlog_write_calculate_len() if the caller is
> > already iterating that chain to build it.
> > 
> > Passing in the vector length avoids doing an extra chain iteration,
> > which can be a significant amount of work given that large CIL
> > commits can have hundreds of thousands of vectors attached to the
> > chain.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -849,6 +850,10 @@ xlog_cil_push_work(
> >  		lv = item->li_lv;
> >  		item->li_lv = NULL;
> >  		num_iovecs += lv->lv_niovecs;
> > +
> > +		/* we don't write ordered log vectors */
> > +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> > +			num_bytes += lv->lv_bytes;
> >  	}
> >  
> >  	/*
> > @@ -887,6 +892,8 @@ xlog_cil_push_work(
> >  	 * transaction header here as it is not accounted for in xlog_write().
> >  	 */
> >  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> > +	num_iovecs += lvhdr.lv_niovecs;
> 
> I have the same question that Brian had last time, which is: What's the
> point of updating num_iovecs here?  It's not used after
> xlog_cil_build_trans_hdr, either here or at the end of the patchset.
> 
> Is the idea that num_{iovecs,bytes} will always reflect everything
> in the cil context chain that's about to be passed to xlog_write?

I left it there because I did want to keep the two variables up to
date for future use. i.e. I didn't want to leave a landmine later
down the track if I need to use num_iovecs in future changes. I've
also used it a few times for temporary debugging code, so I'd
prefer to keep it even though it isn't used.

But if "not used" is the only reason for people not giving rvbs,
then I can remove it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
