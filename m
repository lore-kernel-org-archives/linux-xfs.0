Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43575 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEBSCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 14:02:55 -0400
Date: Tue, 2 May 2017 11:02:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: handle large CoW remapping requests
Message-ID: <20170502180220.GA5973@birch.djwong.org>
References: <20170427212754.GB19158@birch.djwong.org>
 <20170502075021.GA7916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502075021.GA7916@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Tue, May 02, 2017 at 12:50:21AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 27, 2017 at 02:27:54PM -0700, Darrick J. Wong wrote:
> > XFS transactions are constrained both by space and block reservation
> > limits and the fact that we have to avoid doing 64-bit divisions.  This
> > means that we can't remap more than 2^32 blocks at a time.  However,
> > file logical blocks are 64-bit in size, so if we encounter a huge remap
> > request we have to break it up into smaller pieces.
> 
> But where would we get that huge remap request from?

Nowhere, at the moment.  I had O_ATOMIC in mind for this though, since
it'll call end_cow on the entire file at fsync time.  What if you've
written 8GB to a file that you've opened with ATOMIC and then fsync it?
That would trigger a remap longer than MAX_RW_COUNT which will blow the
assert, right?

> We already did the BUILD_BUG_ON for the max read/write size at least.
> Also the remaps would now not be atomic, which would be a problem for
> my O_ATOMIC implementation at least.

Hm... you're right, if we crash midway through the remap then ideally
we'd recover by finishing whatever remapping steps we didn't get to.

The current remapping mechanism only guarantees that whatever little
part of the data fork we've bunmapi'd for each cow fork extent will also
get remapped.  There isn't anything in there that guarantees a remap of
the parts we haven't touched yet.  If one CoW fork extent maps to 2000
data fork extents, we'll atomically remap each of the 2000 extents.  If
we fail at extent 900, the remaining 1100 extents are fed to the CoW
cleanup at the next mount time.  This patch doesn't try to change that
behavior.

For O_ATOMIC I think we'll have to put in some extra log intent items
to help us track all the extents we intend to remap so that we can
pick up where we left off during recovery.  Hm.  It would be difficult
to avoid running into log space problems if there are a lot of extents.

Second half-baked idea: play games with a shadow inode -- allocate an
unlinked inode, persist all the written CoW fork extents to the shadow
inode, and reflink the extents from the shadow to the original inode.
If we crash then we can just re-reflink everything in the shadow inode.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
