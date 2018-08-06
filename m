Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56690 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbeHFSto (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Aug 2018 14:49:44 -0400
Date: Mon, 6 Aug 2018 18:45:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
        the fork didn't change
Message-ID: <20180806164504.GA18576@lst.de>
References: <20180717232405.18511-1-hch@lst.de> <20180717232405.18511-7-hch@lst.de> <20180721232311.GA1691@dastard> <20180723074940.GA18816@lst.de> <20180724223523.GO4813@magnolia> <20180727151039.GA29982@lst.de> <20180806023738.GC7395@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180806023738.GC7395@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Aug 06, 2018 at 12:37:38PM +1000, Dave Chinner wrote:
> IOWs, I can't see any reliable access serialisation being provided
> by holding the ILOCK while modifying the value. Perhaps this should
> use WRITE_ONCE/READ_ONCE to ensure the correct memory barriers are
> used to serialise tthe sequence count against itself rather than the
> wider inode extent modification process?

Yes, I think we need a barrier before the later actual modification
of the extent tree and thus should use WRITE_ONCE/READ_ONCE.

I've got a patch that is undergoing testing at the moment.
