Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdAXRnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 12:43:19 -0500
Date: Tue, 24 Jan 2017 12:43:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20170124174318.GH60234@bfoster.bfoster>
References: <20161207190008.GC23106@bfoster.bfoster>
 <20161207193709.GA27479@lst.de>
 <20161207194634.GE23106@bfoster.bfoster>
 <20170124083732.GA17818@lst.de>
 <20170124135044.GA60234@bfoster.bfoster>
 <20170124135937.GA25885@lst.de>
 <20170124150222.GD60234@bfoster.bfoster>
 <20170124150959.GA27705@lst.de>
 <20170124161719.GE60234@bfoster.bfoster>
 <20170124162156.GA29361@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124162156.GA29361@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 05:21:56PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 11:17:20AM -0500, Brian Foster wrote:
> > I thought that while not necessarily guaranteed, generally the entire
> > extent gets converted from delalloc to real blocks.
> 
> For buffered I/O that's the case.  See the discussion on my recent
> xfs_bmapi_write patch.
> 

Yeah, that's the behavior I would have expected...

> > IIRC, that's what
> > I've seen in the past when looking into the cow fork with bmap. After
> > all, isn't that the point of the extent size hint? Allocate wider than
> > the write to accommodate potential subsequent writes into a more
> > contiguous range.
> 
> Well, for direct I/O that's not what the current code does.  Implementing
> it might be useful, but I'm not sure how much the front alignment is
> going to help in usual worksloads - you'd need a backwards write or
> random writes that happen to look almost backwards for it to make
> a difference.  I suspect most of them time we'd just allocate blocks to
> reclaim them again a little later.

Hmm, that's not what I'm seeing (not that it really matters, but I'm
curious if I'm missing something):

# xfs_io -d -c "bmap -v" -c "pwrite 8k 4k" -c "bmap -v" -c "bmap -cv" ./file
./file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..15]:         80..95            0 (80..95)            16 100000
   1: [16..2047]:      160..2191         0 (160..2191)       2032 100000
wrote 4096/4096 bytes at offset 8192
4 KiB, 1 ops; 0.0000 sec (12.440 MiB/sec and 3184.7134 ops/sec)
./file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..15]:         80..95            0 (80..95)            16 100000
   1: [16..23]:        2208..2215        0 (2208..2215)         8
   2: [24..2047]:      168..2191         0 (168..2191)       2024 100000
./file:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..15]:         2192..2207        0 (2192..2207)        16
   1: [16..23]:        hole                                     8
   2: [24..255]:       2216..2447        0 (2216..2447)       232
   3: [256..2047]:     hole                                  1792

That's on a fairly recent for-next on a fully reflinked file. It looks
to me that the cow fork extent is fully allocated immediately
(otherwise, I'm not sure what else would have converted it).

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
