Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:53662 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752834AbcKHXgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 18:36:09 -0500
Date: Wed, 9 Nov 2016 10:34:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/4] xfs: basic cow fork speculative preallocation
Message-ID: <20161108233459.GD28922@dastard>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <20161108204800.GA16813@birch.djwong.org>
 <20161108223930.GA8167@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161108223930.GA8167@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Nov 08, 2016 at 05:39:31PM -0500, Brian Foster wrote:
> On Tue, Nov 08, 2016 at 12:48:00PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 08, 2016 at 03:27:32PM -0500, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This is an experiment based on an idea for COW fork speculative
> > > preallocation. This is experimental, lightly/barely tested and sent in
> > > RFC form to solicit thoughts, ideas or flames before I spend time taking
> > > it further.
> > > 
> > > Patch 1 probably stands on its own. Patches 2 and 3 are some refactoring
> > > and patch 4 implements the basic idea, which is described in the commit
> > > log description. The testing I've done so far is basically similar to
> > > how one would test the effects of traditional speculative preallocation:
> > > write to multiple reflinked files in parallel and examine the resulting
> > > fragmentation. Specifically, I wrote sequentially to 16 different
> > > reflinked files of the same 8GB original (which has two data extents,
> > > completely shared). Without preallocation, the test results in ~248
> > > extents across the 16 files. With preallocation, the test results in 32
> > > extents across the 16 files (i.e., 2 extents per file, same as the
> > > source file).
> > > 
> > > An obvious tradeoff is the unnecessarily aggressive allocation that
> > > might occur in the event of random writes to a large file (such as in
> > > the cloned VM disk image use case), but my thinking is that the
> > > cowblocks tagging and reclaim infrastructure should manage that
> > > sufficiently (lack of testing notwithstanding). In any event, I'm
> > > interested in any thoughts along the lines of whether this is useful at
> > > all, alternative algorithm ideas, etc.
> > 
> > Was about to step out to lunch when this came in, but...
> > 
> > Is there an xfstest for this, so I can play too? :)
> > 
> 
> Not yet.. I've only xfstests tested insofar as it hasn't blown anything
> up yet. :) Otherwise, I've just run manual write tests to observe
> whether it is doing what I expect it to in simple cases. It clearly
> needs more work, as noted in the patch, but if this is something worth
> pursuing further I can certainly come up with some tests as well.

I think it definitely has value for preventing COW overwrite
fragmentation - this will be an issue if people start reflinking
files widely (e.g. container roots) and then occasionally 
overwriting files completely.

> FWIW, that COW fork fiemap hack I sent a bit ago came in handy for
> playing with this as well. :)

It might be worth keeping these two patchsets together for the
purposes of development and review. The fiemap hack by itself is
neat, but having a demonstrated use for development of new features
makes it more than just a "neat hack". :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
