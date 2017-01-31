Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41635 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdAaTLr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 14:11:47 -0500
Date: Tue, 31 Jan 2017 11:11:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170131191120.GF9134@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
 <20170131134135.GA10866@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170131134135.GA10866@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 31, 2017 at 05:41:35AM -0800, Christoph Hellwig wrote:
> Hi Darrick,
> 
> from a quick look the code looks reasonable, but I'm worried about
> yet another set of transactions that modify all extents again.
> 
> Do you have any measurements of the overhead?  I'll see if I
> can prototype my always COW idea to see how the approaches compare.

The overhead should be pretty low -- since the cow fork never goes to
disk, the only thing we end up logging is the inode core (because the
conversion function logs it unconditionally), and I'm not even sure
that's necessary since we're performing a pure conversion of blocks that
are already allocated.

In any case I didn't see any noticeable impact on performance other
than the extra CPU overhead.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
