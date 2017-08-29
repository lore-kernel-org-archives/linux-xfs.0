Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39804 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdH2QDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:03:39 -0400
Date: Tue, 29 Aug 2017 09:03:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS reflinks
Message-ID: <20170829160308.GR4757@magnolia>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829130046.GA28896@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Cottam <chris.cottam@bytemark.co.uk>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 06:00:46AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 29, 2017 at 12:23:13PM +0100, Chris Cottam wrote:
> > I've got a project where being able to take COW copies of a VMs disc
> > would be really useful (disc snapshots to be then archived off elsewhere)
> > 
> > How stable is the the experimental reflinks feature and do you have any
> > idea when it might be declared stable?
> 
> I've got a customer that heavily uses (and tests) reflinks.  They
> initially found a few issues, but these days the QA teams finds
> bugs in decade old XFS code but not related to reflinks..
> 
> You're mileage my vary, but I think we should be able to drop the
> experimental tag now.

I still have (at least) two unresolved questions before we drop the
experimental tag on reflink --

First, should we land the incore extent map rework (not that I've seen a
patchset yet) so that the increased extent map fragmentation resulting
from cow/dedupe don't overwhelm the memory allocator with high order
allocations?  Incore extent map memory usage hasn't been an issue here...

Second, regarding realtime + reflink: Right now we don't forbid mounting
a filesystem with reflink enabled and a realtime device.  You can't have
an inode with both realtime and reflink flags set, so if future xfs
supports it, old kernels won't totally stumble over those inodes.
(Though, EFSCORRUPTED is a little rude.)  Is that ok? or should we (a)
make reflink work on realtime devices, (b) complain at mount time, or
(c) leave everything the way it is?

(The "root a metadata btree in an inode" series, which is the first half
of realtime rmapbt, will enable us to create a refcount btree for the
realtime device, though any reflink-capable realtime device also has a
requirement that sb_rextsize <= page size unless we devise a mechanism
to cow larger blocks, which is also problematic.  I used to have a
realtime reflink patch set but it died when we went to iomap and I
haven't resurrected it.)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
