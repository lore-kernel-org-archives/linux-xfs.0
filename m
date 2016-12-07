Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbcLGHTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2016 02:19:03 -0500
Date: Tue, 6 Dec 2016 23:18:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161207071857.GA23809@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
 <20161206144559.GA14623@infradead.org>
 <20161207034903.GX16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207034903.GX16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 07:49:03PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 06, 2016 at 06:45:59AM -0800, Christoph Hellwig wrote:
> > I think the problem is that the extents -> btree conversion does not
> > use the per-AG reservations, but it should probably use it (even if it
> > predates if of course).
> > 
> > In the reproduce the fs still has enough blocks to allocate the
> > one block for the first bmap btree leave.  But all free space sits
> > in AGs with a lower agno then what we used for allocating the actual
> > extent, and thus xfs_alloc_vextent never manages to allocate it.
> 
> Wellll... I cobbled together a crappy patch that flips on
> XFS_AG_RESV_AGFL if xfs_bmap_extents_to_btree really can't get a block.
> It seems to have survived ~175 iterations of xfs/109 so I'll try to
> clean it up tomorrow.

I tried it with XFS_AG_RESV_METADATA, but that didn't work.  But then
again I didn't add an additional reservation and I was about to head
out for dinner so I didn't investigate the details.  It might have been
the case Ross pointed out yeserday, so I'll look into the details more
today.

> Not sure that helps Christoph's situation though... if you're not
> running rmap or reflink then the AG reservation is always zero.

For now I was just running xfs/109.  The customer workload uses
reflinks, but not rmap.  That being said I think this issue can
in theory happen without eithr one due to the way the AG loop
works in xfs_alloc_vextext - while we have a reservation for the
indirect block(s) there is no guarantee it is in an AG that is
greater or equal to that use for the actual extent allocation.
