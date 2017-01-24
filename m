Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51723 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdAXIhf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 03:37:35 -0500
Date: Tue, 24 Jan 2017 09:37:32 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170124083732.GA17818@lst.de>
References: <1480971924-4864-1-git-send-email-hch@lst.de> <1480971924-4864-3-git-send-email-hch@lst.de> <20161207190008.GC23106@bfoster.bfoster> <20161207193709.GA27479@lst.de> <20161207194634.GE23106@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207194634.GE23106@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Dec 07, 2016 at 02:46:34PM -0500, Brian Foster wrote:
> Only for end_fsb... xfs_bmap_btalloc() calls xfs_bmap_extsize_align()
> with the alignment, which rounds out the start and end offsets.

... and corrupts data in the direct I/O case.

The problem is that the down-alignment in xfs_bmap_extsize_align will
now create a real extent that spans before the extent that we have
to COW in this write_begin call.  But the area before might have been
a hole before the dio write that had just before been filled with
an allocation in the data fork.  And due to the direct I/O end_io
interface that only covers the range of the whole write we don't
know at that point where exactly the COW operation started and will
happily splice back our front pad into the data fork, replacing
the just written data with garbage.  xfs/228 and sometimes generic/199
reproduce this nicely.
