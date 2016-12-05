Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLETFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 14:05:10 -0500
Date: Mon, 5 Dec 2016 11:05:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161205190508.GA2995@infradead.org>
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

On Mon, Dec 05, 2016 at 10:28:02AM -0800, Darrick J. Wong wrote:
> Hmm.  Purely speculating here (I haven't yet been able to reproduce it)
> but I wonder if we're nearly out of space, fdblocks is still large
> enough that we can start delalloc reservations, but something is
> stealing blocks out of the AGs such that when we go to look for one
> there aren't any (or the per AG reservation denies it).
> 
> Does it happen if rmapbt=0 ?  Since xfs/109 isn't doing any CoW, it's
> possible that this could be another symptom of the bug where we reserve
> all the bmap+rmap blocks we need via indlen, but discard the entire
> reservation in the transaction roll that happens before we start the
> rmap update, which effectively means we're allocating space that we
> didn't previously reserve...

I'm pretty sure it's something like that, but I don't think rmap
needs to be in the game - at least my customer report does not have rmap
enabled.

> I suppose you could constrict the reflink exception thing further by
> passing bma->flags to xfs_bmap_extents_to_btree and only allowing the
> ENOSPC retry if XFS_BMAPI_REMAP is set.

Well, we assert on having an allocation even without that exception,
so I'm not sure that would help us - it's just an oddity I noticed
while looking at the code.
