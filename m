Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8436EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 04:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243738AbiDZE15 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiDZE15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 00:27:57 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AED645AC5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 21:24:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0819910E5DD2;
        Tue, 26 Apr 2022 14:24:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njCkm-004cPG-AB; Tue, 26 Apr 2022 14:24:44 +1000
Date:   Tue, 26 Apr 2022 14:24:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <20220426042444.GL1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688275.383881.1038640482191339784.stgit@magnolia>
 <20220422223635.GC1544202@dread.disaster.area>
 <20220425233905.GN17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425233905.GN17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6267740f
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=Q1LaOEyYxv42E9wHLM8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 04:39:05PM -0700, Darrick J. Wong wrote:
> On Sat, Apr 23, 2022 at 08:36:35AM +1000, Dave Chinner wrote:
> > On Thu, Apr 14, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
....
> > > @@ -47,18 +48,25 @@ xfs_log_get_max_trans_res(
> > >  	struct xfs_trans_res	*max_resp)
> > >  {
> > >  	struct xfs_trans_res	*resp;
> > > +	struct xfs_trans_res	*start_resp;
> > >  	struct xfs_trans_res	*end_resp;
> > > +	struct xfs_trans_resv	*resv;
> > >  	int			log_space = 0;
> > >  	int			attr_space;
> > >  
> > >  	attr_space = xfs_log_calc_max_attrsetm_res(mp);
> > >  
> > > -	resp = (struct xfs_trans_res *)M_RES(mp);
> > > -	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> > > -	for (; resp < end_resp; resp++) {
> > > +	resv = kmem_zalloc(sizeof(struct xfs_trans_resv), 0);
> > > +	xfs_trans_resv_calc_logsize(mp, resv);
> > > +
> > > +	start_resp = (struct xfs_trans_res *)resv;
> > > +	end_resp = (struct xfs_trans_res *)(resv + 1);
> > > +	for (resp = start_resp; resp < end_resp; resp++) {
> > >  		int		tmp = resp->tr_logcount > 1 ?
> > >  				      resp->tr_logres * resp->tr_logcount :
> > >  				      resp->tr_logres;
> > > +
> > > +		trace_xfs_trans_resv_calc_logsize(mp, resp - start_resp, resp);
> > >  		if (log_space < tmp) {
> > >  			log_space = tmp;
> > >  			*max_resp = *resp;		/* struct copy */
> > 
> > This took me a while to get my head around. The minimum logsize
> > calculation stuff is all a bit of a mess.
> > 
> > Essentially, we call xfs_log_get_max_trans_res() from two places.
> > One is to calculate the minimum log size, the other is the
> > transaction reservation tracing code done when M_RES(mp) is set up
> > via xfs_trans_trace_reservations().  We don't need the call from
> > xfs_trans_trace_reservations() - it's trivial to scan the list of
> > tracepoints emitted by this function at mount time to find the
> > maximum reservation.
> 
> Here's the thing -- xfs_db also calls xfs_log_get_max_trans_res to
> figure out the transaction reservation that's used to compute the
> minimum log size.  Whenever I get a report about mount failing due to
> minlogsize checks, I can ask the reporter to send me the ftrace output
> from the mount attempt and compare it against what userspace thinks:
> 
> # xfs_db /dev/sde -c logres
> type 0 logres 168184 logcount 5 flags 0x4
> type 1 logres 293760 logcount 5 flags 0x4
> type 2 logres 307936 logcount 2 flags 0x4
> type 3 logres 187760 logcount 2 flags 0x4
> type 4 logres 170616 logcount 2 flags 0x4
> type 5 logres 244720 logcount 3 flags 0x4
> type 6 logres 243568 logcount 2 flags 0x4
> type 7 logres 260352 logcount 2 flags 0x4
> type 8 logres 243568 logcount 3 flags 0x4
> type 9 logres 278648 logcount 2 flags 0x4
> type 10 logres 2168 logcount 0 flags 0x0
> type 11 logres 73728 logcount 2 flags 0x4
> type 12 logres 99960 logcount 2 flags 0x4
> type 13 logres 760 logcount 0 flags 0x0
> type 14 logres 292992 logcount 1 flags 0x4
> type 15 logres 23288 logcount 3 flags 0x4
> type 16 logres 13312 logcount 0 flags 0x0
> type 17 logres 147584 logcount 3 flags 0x4
> type 18 logres 640 logcount 0 flags 0x0
> type 19 logres 94968 logcount 2 flags 0x4
> type 20 logres 4224 logcount 0 flags 0x0
> type 21 logres 6512 logcount 0 flags 0x0
> type 22 logres 232 logcount 1 flags 0x0
> type 23 logres 172407 logcount 5 flags 0x4
> type 24 logres 640 logcount 1 flags 0x0
> type 25 logres 760 logcount 0 flags 0x0
> type 26 logres 243568 logcount 2 flags 0x4
> type 27 logres 170616 logcount 2 flags 0x4
> type -1 logres 547200 logcount 8 flags 0x4
> 
> And this "-1" entry matches the last output of the kernel.

I look at that and thing "xfs_db output is broken" because that last
line cannot be derived from the individual transaction reservations
that are listed. It makes no sense in isolation/without
documentation. :/

> I'd rather
> not lose this tracing facility (which means keeping this function
> non-static) though I will move the tracepoint out of
> xfs_trans_trace_reservations.

You mean "remove only the '-1' tracepoint" from
xfs_trans_trace_reservations()?

> > Hence I think we should start by removing that call to this
> > function, and making this a static function called only from
> > xfs_log_calc_minimum_size().
> > 
> > At this point, we can use an on-stack struct xfs_trans_resv for the
> > calculated values - no need for memory allocation here as we will
> > never be short of stack space in this path.
> 
> ~312 bytes?  That's ~8% of the kernel stack.  I'll see if I run into any
> complaints, though I bet I won't on x64.

What architecture still uses 4kB stacks?  Filesystems have blown
through 4kB stacks without even trying on 32bit systems for years
now.

Regardless, the mount path call chain here is nowhere near deep
enough to be at risk of blowing stacks, and this is at the leaf so
it's largely irrelevant if we put this on the stack...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
