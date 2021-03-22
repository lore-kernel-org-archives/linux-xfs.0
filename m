Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18A3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE02619A4
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 23:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCVXqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 19:46:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41785 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhCVXqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 19:46:38 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 243161AE959;
        Tue, 23 Mar 2021 10:46:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lOUFn-005cua-0W; Tue, 23 Mar 2021 10:46:35 +1100
Date:   Tue, 23 Mar 2021 10:46:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210322234635.GB63242@dread.disaster.area>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
 <20210316154729.GI22100@magnolia>
 <20210317152125.GA384335@infradead.org>
 <20210317154904.GE22097@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317154904.GE22097@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=D4VyCAbkQro7S9XpTbgA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 17, 2021 at 08:49:04AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 17, 2021 at 03:21:25PM +0000, Christoph Hellwig wrote:
> > On Tue, Mar 16, 2021 at 08:47:29AM -0700, Darrick J. Wong wrote:
> > > On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> > > > Still digesting this.  What trips me off a bit is the huge amount of
> > > > duplication vs the inode reclaim mechanism.  Did you look into sharing
> > > > more code there and if yes what speaks against that?
> > > 
> > > TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
> > > to replace the inode reclaim tagging and iteration with an lru list walk
> > > so I decided not to entangle the two.
> > > 
> > > [1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/
> > 
> > Well, it isn't just the radix tree tagging, but mostly the
> > infrastructure in iget that seems duplicates a lot of very delicate
> > code.
> > 
> > For the actual inactivation run:  why don't we queue up the inodes
> > for deactivation directly that, that use the work_struct in the
> > inode to directly queue up the inode to the workqueue and let the
> > workqueue manage the details?  That also means we can piggy back on
> > flush_work and flush_workqueue to force one or more entries out.
> > 
> > Again I'm not saying I know this is better, but this is something that
> > comes to my mind when reading the code.
> 
> Hmm.  You mean reuse i_ioend_work (which maybe we should just rename to
> i_work) and queueing the inodes directly into the workqueue?  I suppose
> that would mean we don't even need the radix tree tag + inode walk...
> 
> I hadn't thought about reusing i_ioend_work, since this patchset
> predates the writeback ioend chaining.  The biggest downside that I can
> think of doing it that way is that right after a rm -rf, the unbound gc
> workqueue will start hundreds of kworkers to deal with the sudden burst
> of queued work, but all those workers will end up fighting each other
> for (a) log grant space, and after that (b) the AGI buffer locks, and
> meanwhile everything else on the frontend stalls on the log.

yeah, this is not a good idea. The deferred inactivation needs to
limit concurrency to a single work per AG at most because otherwise
it will just consume all the reservation space serialising on the
AGI locks. Even so, it can still starve the front end when they
compete for AGI and AGF locks. Hence the background deferral is
going to have to be very careful about how it obtains and blocks on
locks....

(I haven't got that far iinto the patchset yet)

> The other side benefit I can think of w.r.t. keeping the inactivation
> work as a per-AG item is that (at least among AGs) we can walk the
> inodes in disk order, which probably results in less seeking (note: I
> haven't studied this) and might allow us to free inode cluster buffers
> sooner in the rm -rf case.

That is very useful because it allows the CIL to cancel the space
used modifying the inodes and the cluster buffer during the unlink,
allowing it to aggregate many more unlinks into the same checkpoint
and avoid metadata writeback part way through unlink operations. i.e
it is very efficient in terms of journal space consumption and hence
journal IO bandwidth.  (This is how we get multiple hundreds of
thousands of items into a single 32MB journal checkpoint......)

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
