Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58113 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750713AbdAXUI5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:08:57 -0500
Date: Tue, 24 Jan 2017 21:08:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170124200855.GA1385@lst.de>
References: <20161207193709.GA27479@lst.de> <20161207194634.GE23106@bfoster.bfoster> <20170124083732.GA17818@lst.de> <20170124135044.GA60234@bfoster.bfoster> <20170124135937.GA25885@lst.de> <20170124150222.GD60234@bfoster.bfoster> <20170124150959.GA27705@lst.de> <20170124161719.GE60234@bfoster.bfoster> <20170124162156.GA29361@lst.de> <20170124174318.GH60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124174318.GH60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 12:43:18PM -0500, Brian Foster wrote:
> Hmm, that's not what I'm seeing (not that it really matters, but I'm
> curious if I'm missing something):

Yeah, I can reproduce this on mainline.  Turns out the it was done
by the align call in xfs_bmap_btalloc that even my before run had
removed.

Took me some time to spin my head around this.

Btw, I think we have a nasty race in the current DIO code that might
expose stale data, but this is just the same kind of head spinning
exercise for now:

Thread 1 writes a range from B to c

                    B --------- C

a little later thread 2 writes from A to B

        A --------- B

but the code preallocates beyond B into the range where thread
1 has just written, but ->end_io hasn't been called yet.
But once ->end_io is called thread 2 has already allocated
up to the extent size hint into the write range of thread 1,
so the end_io handler will splice the unintialized blocks from
that preallocation back into the file right after B.
