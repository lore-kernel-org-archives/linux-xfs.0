Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43729 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971348AbdDTQ4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 12:56:25 -0400
Date: Thu, 20 Apr 2017 09:56:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: simplify validation of the unwritten extent bit
Message-ID: <20170420165620.GF5205@birch.djwong.org>
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-4-hch@lst.de>
 <20170419201751.GM5193@birch.djwong.org>
 <20170420143857.GB22644@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170420143857.GB22644@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 04:38:57PM +0200, Christoph Hellwig wrote:
> [can you trim the quote?  Makes reading it and properly quoting it
>  so much easier..]
> 
> > > +static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> > > +		struct xfs_bmbt_rec_host *ep)
> > 
> > Would be nice to have this function formatted the same way as most of
> > the rest of the xfs functions, even if it is static inline...
> 
> It's actually the usual style for our inlines.  But if you prefer it
> differently I can do that.

Nah, don't worry about it.

Though I do wonder why static inlines get different treatment; it's
rather nice to be able to search for ^xfs_function and find its
definition.

> > Wouldn't this be better off in xfs_iflush_int (like the inline dir
> > verifier) since we could prevent bad metadata from hitting the disk?
> > Rather than this, which doesn't do anything on non-debug kernels.
> 
> xfs_iflush_int actually calls xfs_iflush_fork which calls
> xfs_iextents_copy, so it's in the right spot already.  Converting it
> from an assert to an error would have to go through these layers
> that don't currently expect errors.  Note that we also call
> xfs_iextents_copy from xfs_inode_item_format_data_fork /
> xfs_inode_item_format_attr_fork, which are called earlier than
> xfs_iflush_int, where error propagation is even worse.

Fair enough.  The rest looks ok, so I'll go run it through testing.

--D
