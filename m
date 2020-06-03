Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E8CC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 21:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A62902077D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 21:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgFCVef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 17:34:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35321 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgFCVee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 17:34:34 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3E99B5AAFEB;
        Thu,  4 Jun 2020 07:34:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgb1m-0000ex-Kl; Thu, 04 Jun 2020 07:34:26 +1000
Date:   Thu, 4 Jun 2020 07:34:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200603213426.GO2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-14-david@fromorbit.com>
 <20200603150207.GG12332@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603150207.GG12332@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=Mg8TioSluTrJEoFv_CIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 11:02:07AM -0400, Brian Foster wrote:
> On Tue, Jun 02, 2020 at 07:42:34AM +1000, Dave Chinner wrote:
> > +	if (xfs_buf_ioerror_sync(bp))
> > +		goto out_stale;
> > +
> > +	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> > +
> > +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> > +	if (xfs_buf_ioerror_retry(bp, cfg)) {
> > +		xfs_buf_ioerror(bp, 0);
> > +		xfs_buf_submit(bp);
> > +		return 1;
> > +	}
> > +
> > +	if (xfs_buf_ioerror_permanent(bp, cfg))
> >  		goto permanent_error;
> >  
> >  	/*
> >  	 * Still a transient error, run IO completion failure callbacks and let
> >  	 * the higher layers retry the buffer.
> >  	 */
> > -	xfs_buf_do_callbacks_fail(bp);
> >  	xfs_buf_ioerror(bp, 0);
> > -	xfs_buf_relse(bp);
> > -	return true;
> > +	return 2;
> 
> ... that we now clear the buffer error code before running the failure
> callbacks. I know that nothing in the callbacks looks at it right now,
> but I think it's subtle and inelegant to split it off this way. Can we
> just move this entire block together into the type callbacks?

Sure. It's largely just deck chair rearragnement, though, because
the whole XFS_LI_FAILED ends up going away real soon. The next patchset
gets rid of it entirely for inode log items, and when the same
approach is applied to dquots, it no longer will be used by
anything and will be removed entirely.

IOWs, the future isn't "maybe error callbacks will do something
different", the future is "error callbacks don't exist any more".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
