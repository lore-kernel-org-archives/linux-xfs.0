Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35033 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752094AbcLFOqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 09:46:06 -0500
Date: Tue, 6 Dec 2016 06:45:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206144559.GA14623@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205182802.GB8436@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

I think the problem is that the extents -> btree conversion does not
use the per-AG reservations, but it should probably use it (even if it
predates if of course).

In the reproduce the fs still has enough blocks to allocate the
one block for the first bmap btree leave.  But all free space sits
in AGs with a lower agno then what we used for allocating the actual
extent, and thus xfs_alloc_vextent never manages to allocate it.
