Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66598C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 23:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D64613A7
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 23:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhHWXNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 19:13:23 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:47360 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233165AbhHWXNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 19:13:22 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 35CA91B6733;
        Tue, 24 Aug 2021 09:12:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mIJ7L-004CSZ-3t; Tue, 24 Aug 2021 09:12:35 +1000
Date:   Tue, 24 Aug 2021 09:12:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20210823231235.GK3657114@dread.disaster.area>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
 <20210823045701.GA2186939@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823045701.GA2186939@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=vnREMb7VAAAA:8 a=7-415B0cAAAA:8
        a=6iW4JuG-QyfroD5S37sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 02:57:01PM +1000, Chris Dunlop wrote:
> Hi,
> 
> On Thu, Jan 25, 2018 at 04:51:44PM +1100, Dave Chinner wrote:
> > The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> > snapshot support I'm working on has been uploaded and can be found
> > here:
> > 
> > https://www.youtube.com/watch?v=wG8FUvSGROw
> 
> Just out of curiosity... is anything still happening in this area, and if
> so, is there anywhere we can look to get a feel for the current state of
> affairs?

It's at the back of the queue at the moment. There's not enough
time and resources available to do everything we want to do - just
look at the review backlog we already have...

That said, this was largely an experiment to see how easily we could
retrofit subvolumes to XFS, and whether there was a compelling
reason for adding them. While there are some management benefits to
integrating reflink based subvolumes into XFS, the performance and
scalability just isn't there compared to production usage of things
like dm-snapshot.

O(1) snapshot time makes a huge difference to system performance,
but reflink-based snapshots are O(N), not O(1). Hence snapshots run
at about 100k extents/sec so a subvolume with a few million extents
will take 10s of seconds to run a snapshot. During this time, the
subvolume is completely frozen and you can't read from or write to
it....

And that's really the unsolvable problem with a reflink based
snapshot mechanism. Unless there is some other versioning mechanism
in the filesystem metadata, we have to mark all the extents in the
subvolume as shared so the next write will COW them correctly. XFS
does not have that "some other mechanism" like btrfs (COW metadata)
or bcachefs (snapshot epoch in btree keys), so it will never be able
to solve this problem effectively.

That's not to say we'll never add subvolumes and snapshots to XFS,
but because it isn't compellingly better than existing mechanisms
for snapshotting XFS filesystems it really isn't a priority.

As such, if you want a performant, scalable, robust snapshotting
subvolume capable filesystem, bcachefs is the direction you should
be looking. All of the benefits of integrated subvolume snapshots,
yet none of the fundamental architectural deficiencies and design
flaws that limit the practical usability of btrfs for many important
workloads.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
