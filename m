Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56095 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbdAXQV5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 11:21:57 -0500
Date: Tue, 24 Jan 2017 17:21:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170124162156.GA29361@lst.de>
References: <1480971924-4864-3-git-send-email-hch@lst.de> <20161207190008.GC23106@bfoster.bfoster> <20161207193709.GA27479@lst.de> <20161207194634.GE23106@bfoster.bfoster> <20170124083732.GA17818@lst.de> <20170124135044.GA60234@bfoster.bfoster> <20170124135937.GA25885@lst.de> <20170124150222.GD60234@bfoster.bfoster> <20170124150959.GA27705@lst.de> <20170124161719.GE60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124161719.GE60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 11:17:20AM -0500, Brian Foster wrote:
> I thought that while not necessarily guaranteed, generally the entire
> extent gets converted from delalloc to real blocks.

For buffered I/O that's the case.  See the discussion on my recent
xfs_bmapi_write patch.

> IIRC, that's what
> I've seen in the past when looking into the cow fork with bmap. After
> all, isn't that the point of the extent size hint? Allocate wider than
> the write to accommodate potential subsequent writes into a more
> contiguous range.

Well, for direct I/O that's not what the current code does.  Implementing
it might be useful, but I'm not sure how much the front alignment is
going to help in usual worksloads - you'd need a backwards write or
random writes that happen to look almost backwards for it to make
a difference.  I suspect most of them time we'd just allocate blocks to
reclaim them again a little later.
