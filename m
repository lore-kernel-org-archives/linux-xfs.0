Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35293 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbcLFSPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 13:15:01 -0500
Date: Tue, 6 Dec 2016 10:14:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206181420.GE8436@birch.djwong.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
 <20161206144559.GA14623@infradead.org>
 <20161206151945.GC3211@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206151945.GC3211@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 10:19:46AM -0500, Brian Foster wrote:
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
> Not that I have any insight into the problem here... :P but I'm still[1]
> kind of wondering how that mechanism is supposed to work when it
> ultimately calls xfs_mod_fdblocks() for each AG..?

Oh, heh, I was meaning to reply to that and never did. :(

Will go work on that!

--D

> 
> Brian
> 
> [1] http://www.spinics.net/lists/linux-xfs/msg01509.html
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
