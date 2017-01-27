Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59934 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932676AbdA0RtH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 12:49:07 -0500
Date: Fri, 27 Jan 2017 18:48:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170127174820.GA18919@lst.de>
References: <20170124135044.GA60234@bfoster.bfoster> <20170124135937.GA25885@lst.de> <20170124150222.GD60234@bfoster.bfoster> <20170124150959.GA27705@lst.de> <20170124161719.GE60234@bfoster.bfoster> <20170124162156.GA29361@lst.de> <20170124174318.GH60234@bfoster.bfoster> <20170124200855.GA1385@lst.de> <20170125000934.GG9134@birch.djwong.org> <20170127174447.GZ9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127174447.GZ9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jan 27, 2017 at 09:44:47AM -0800, Darrick J. Wong wrote:
> I think I came up with a better idea overnight: take advantage of the
> unwritten bit.  Currently, all extents in the cow fork are either
> delalloc or normal extents.  When we allocate the blocks to fill a cow
> extent, we'll flag the extent as unwritten.  When we go to write the
> data to disk, we convert the unwritten extent to a real extent, and the
> post-write remap (since it only takes a file offset and length) will
> be changed to remap only real, written extents into the data fork.

That sounds like a possibility.  My other idea was to force COW all
direct I/O writes, that way we can't have a mismatch between extents
in the data and the COW fork.  But so far this is just an idea..
