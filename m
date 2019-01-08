Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26752 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727393AbfAHFzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 00:55:23 -0500
Date: Tue, 8 Jan 2019 16:55:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190108055518.GW4205@dastard>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
 <20190104123217.GA16751@bfoster>
 <20190105213120.GS4205@dastard>
 <20190106215737.GT4205@dastard>
 <20190107144114.GB5506@bfoster>
 <20190107191101.GC5506@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107191101.GC5506@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 07, 2019 at 02:11:01PM -0500, Brian Foster wrote:
> On Mon, Jan 07, 2019 at 09:41:14AM -0500, Brian Foster wrote:
> > On Mon, Jan 07, 2019 at 08:57:37AM +1100, Dave Chinner wrote:
> > For example, I'm concerned that something like sustained buffered writes
> > could completely break the writeback imap cache by continuously
> > invalidating it. I think speculative preallocation should help with this
> > in the common case by already spreading those writes over fewer
> > allocations, but do we care enough about the case where preallocation
> > might be turned down/off to try and restrict where we bump the sequence
> > number (to > i_size changes, for example)? Maybe it's not worth the
> > trouble just to optimize out a shared ilock cycle and lookup, since the
> > extent list is still in-core after all.
> > 
> 
> A follow up FWIW... a quick test of some changes to reuse the existing
> mechanism doesn't appear to show much of a problem in this regard, even
> with allocsize=4k. I think another thing that minimizes impact is that
> even if we end up revalidating the same imap over and over, the ioend
> construction logic is distinct and based on contiguity. IOW, writeback
> is still sending the same sized I/Os for contiguous blocks...

Ah, I think you discovered that the delay between write(),
->writepages() and the incoming write throttling in
balance_dirty_pages() creates a large enough dirty page window that
we avoid lock-stepping write and writepage in a determental way....

AFAICT, the only time we have to worry about this is if we are so
short of memory the kernel is cleaning every page as soon as it is
dirtied. If we get into that situation, invalidating the cached map
is the least of our worries :P

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com
