Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48865 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdH2QXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:23:14 -0400
Date: Tue, 29 Aug 2017 09:23:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflinks
Message-ID: <20170829162310.GA22552@infradead.org>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org>
 <20170829160308.GR4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829160308.GR4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Cottam <chris.cottam@bytemark.co.uk>, linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 09:03:08AM -0700, Darrick J. Wong wrote:
> First, should we land the incore extent map rework (not that I've seen a
> patchset yet) so that the increased extent map fragmentation resulting
> from cow/dedupe don't overwhelm the memory allocator with high order
> allocations?  Incore extent map memory usage hasn't been an issue here...

Working on this now, but so far this hasn't been a major issue.
The main workload where the extent list currently hurts and that
prompted my work in this area doesn't even involve reflinks (sparse
VM image).

> Second, regarding realtime + reflink: Right now we don't forbid mounting
> a filesystem with reflink enabled and a realtime device.  You can't have
> an inode with both realtime and reflink flags set, so if future xfs
> supports it, old kernels won't totally stumble over those inodes.
> (Though, EFSCORRUPTED is a little rude.)  Is that ok? or should we (a)
> make reflink work on realtime devices, (b) complain at mount time, or
> (c) leave everything the way it is?

I think the current situation is fine - if we add reflinks on the RT
device we can just add a ROCOMPAT flag.
