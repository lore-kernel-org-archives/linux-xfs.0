Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbeKHLLs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Nov 2018 06:11:48 -0500
Date: Wed, 7 Nov 2018 17:38:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 00/16] xfs: Block size > PAGE_SIZE support
Message-ID: <20181108013843.GB4127@magnolia>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107171405.GB4135@magnolia>
 <20181107220441.GX19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107220441.GX19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Nov 08, 2018 at 09:04:41AM +1100, Dave Chinner wrote:
> On Wed, Nov 07, 2018 at 09:14:05AM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 07, 2018 at 05:31:11PM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > We've had a fair number of problems reported on 64k block size
> > > filesystems of late, but none of the XFS developers have Power or
> > > ARM machines handy to reproduce them or even really test the fixes.
> > > 
> > > The iomap infrastructure we introduced a while back was designed
> > > with the capabity of block size > page size support in mind, but we
> > > hadn't tried to implement it.
> > > 
> > > So after another 64k block size bug report late last week I said to
> > > Darrick "How hard could it be"?
> > 
> > "Nothing is ever simple" :)
> 
> "It'll only take a couple of minutes!"
> 
> > > About 6 billion (yes, B) fsx ops later, I have most of the XFS
> > > functionality working on 64k block sizes on x86_64.  Buffered
> > > read/write, mmap read/write and direct IO read/write all work. All
> > > the fallocate() operations work correctly, as does truncate. xfsdump
> > > and xfs_restore are happy with it, as is xfs_repair. xfs-scrub
> > > needed some help, but I've tested Darrick's fixes for that quite a
> > > bit over the past few days.
> > > 
> > > It passes most of xfstests - there's some test failures that I have
> > > to determine whether they are code bugs or test problems (i.e. some
> > > tests don't deal with 64k block sizes correctly or assume block size
> > > <= page size).
> > > 
> > > What I haven't tested yet is shared extents - the COW path,
> > > clone_file_range and dedupe_file_range. I discovered earlier today
> > > that fsx doesn't support copy/clone/dedupe_file_operations
> > > operations, so before I go any further I need to enxpahnce fsx. Then
> > 
> > I assume that means you only tested this on reflink=0 filesystems?
> 
> Correct.
> 
> > Looking at fsstress, it looks like we don't test copy_file_range either.
> > I can try adding the missing clone/dedupe/copy to both programs, but
> > maybe you've already done that while I was asleep?
> 
> No, I haven't started on this yet. I've been sleeping. :P

I started wondering if we were missing anything from not having fsx
support clone/dedupe and ended up with:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsstress-clone

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
