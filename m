Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20544 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbcLGDte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 22:49:34 -0500
Date: Tue, 6 Dec 2016 19:49:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161207034903.GX16813@birch.djwong.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
 <20161206144559.GA14623@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206144559.GA14623@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 06:45:59AM -0800, Christoph Hellwig wrote:
> I think the problem is that the extents -> btree conversion does not
> use the per-AG reservations, but it should probably use it (even if it
> predates if of course).
> 
> In the reproduce the fs still has enough blocks to allocate the
> one block for the first bmap btree leave.  But all free space sits
> in AGs with a lower agno then what we used for allocating the actual
> extent, and thus xfs_alloc_vextent never manages to allocate it.

Wellll... I cobbled together a crappy patch that flips on
XFS_AG_RESV_AGFL if xfs_bmap_extents_to_btree really can't get a block.
It seems to have survived ~175 iterations of xfs/109 so I'll try to
clean it up tomorrow.

Not sure that helps Christoph's situation though... if you're not
running rmap or reflink then the AG reservation is always zero.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
