Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030465AbcIZO2t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Sep 2016 10:28:49 -0400
Date: Mon, 26 Sep 2016 16:28:42 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Message-ID: <20160926142842.GF7733@quack2.suse.cz>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160909225557.GF30056@dastard>
 <20160910073646.GA18547@lst.de>
 <20160913155126.GA10622@linux.intel.com>
 <20160914070633.GA17278@lst.de>
 <20160923210237.GA23346@linux.intel.com>
 <20160926000805.GA32252@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926000805.GA32252@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Mon 26-09-16 02:08:05, Christoph Hellwig wrote:
> On Fri, Sep 23, 2016 at 03:02:37PM -0600, Ross Zwisler wrote:
> > I can just add a hack to hop over the writeback in generic_file_read_iter(),
> > but I hesitate to do this because it seems like the correct thing to do is to
> > separate the ext4 DAX & DIO paths, which I think you are already doing.
> 
> I've started on it, and the read path works fine.  I'm a bit stuck on
> the write side as my attempts at it seems to corrupt data fairly easily
> when running xfstests.

Well, I have a bunch of data corruption fixes for DAX sitting in my tree
which I was able to trigger. E.g. there are some missing invalidations of
blockdev aliases, also some races between fault vs write path the can lead
to data loss. But at least the second fix requires clearing of dirty bits
in the radix tree for DAX and that is a big pile of patches I have to sift
through mm people (and related mm parts are in constant churn due to PMD
pages in pagecache work so it is a mess).

> > I believe that my DAX PMD patches are ready to go, but because of this issue
> > they currently only support XFS.  I'm tempted to send them out as they are
> > right now since they add a bunch of complexity to DAX that we need to review,
> > and that review can fully happen with only XFS support. We can add ext4
> > support back in later when it's ready.
> 
> Yes, please send them out.  We really should move ext4 over to iomap for
> DAX.  I'd love to get some help from someone more familar with ext4,
> and can send my code dump to get started.

Yeah, I'd also just implement it for iomap path and XFS as a start and then
I'll port ext4 over to iomap infrastructure for DAX. There should be no
principial problem.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
