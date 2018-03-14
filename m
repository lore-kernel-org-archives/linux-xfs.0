Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34522 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeCNImW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:42:22 -0400
Date: Wed, 14 Mar 2018 09:42:21 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] xfs: only clear preallocated COW blocks in
        xfs_reflink_clear_inode_flag
Message-ID: <20180314084221.GC28480@lst.de>
References: <20180313143601.30028-1-hch@lst.de> <20180313143601.30028-9-hch@lst.de> <20180313205604.GJ4865@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313205604.GJ4865@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 01:56:04PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 13, 2018 at 03:36:01PM +0100, Christoph Hellwig wrote:
> > Currently these are the only ones that should exist at this point anyway,
> > but with O_ATOMIC writes we might have legit extents around in the COW
> > fork even when clearing the reflink flag.
> 
> Hmmm... so I assume that the premise of the O_ATOMIC write series is
> still that we use the cow fork to stage writes until fsync, and the
> presence of a cow fork is now separate from the reflink inode flag?

Yes.
> 
> Therefore, it's perfectly legit to have a !reflink inode with real
> extents sitting in the cow fork and legit to be clearing the reflink
> iflag with real extents sitting around.
> 
> I think this is ok but I'd sure like to see the atomic writes patches
> before I pull this one in.

Ok.  Skip if for now then.
