Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEIu7Br228799 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 12:56:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F2E11548B1C
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 10:56:05 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	p7f1AOUPgWYCJlsV for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 10:56:05 -0800 (PST)
Date: Mon, 14 Nov 2011 13:55:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH repair: do not walk the unlinked inode list
Message-ID: <20111114185559.GA23715@infradead.org>
References: <20111109083729.GA23169@infradead.org>
	<20111109231133.GS5534@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111109231133.GS5534@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Stefan Pfetzing <stefan.pfetzing@1und1.de>, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 10:11:33AM +1100, Dave Chinner wrote:
> You're making the assumption that log recovery has done the correct
> thing any only replayed entire unlink transactions and hence the
> filesystem is otherwise consistent (i.e that there are no other
> references). I think that's a bad assumption - there's no guarantee
> that the unlinked list only contains unreferenced inodes if there's
> been corruption and/or log replay was not able to be run.

We add inodes to the uncertain list if any of the following applies

 a) are found in an inode btree record reachable from the root in
    phase2, but they are suspect based on certain factors - else
    we add them to the inode tree directly.
 b) are found on the unlinked inodes list in phase3
 c) a directory found in an reachable inode btree record points to
    them in phase3

so any inodes that either has a link pointing to it, or an inode
allocation btree record pointing to it will still be added to the
uncertain inode list if they aren't on the actual inode btree yet.

Then later in phase3 we move all uncertain inodes that appear fine
back into the main inode record tree.

> I also think there's more to it than that. The walk of the inode list
> also marks all the blocks in the block map as containing inodes, and
> all the blocks still used by those inodes as data/bmap/attr types.
> This change removes that, so we're going to potentially lose that
> state if all the inodes in a block are on the unlinked list.

We still do that walk if we have any genuine reference to the inode.
If we don't have any reference but the unlinked list they can be
considered free - we'd free every ressources assoicated with them
on log recovery anyway.

> Hence we'll end up with blocks containing inodes that are still
> marked as used in the AGINO btree, but are marked as free space in
> the block map.

They aren't.  We completely rebuild both the inode allocation and
space allocation bitmaps from the information we gather in the earlier
repair phases, and they will be in sync.

> the AG or filesystem (e.g. agi->agi_count - agi->agi_free). Yes, it will
> still spin for some time on this sort of corruption, but it won't
> get stuck, and it won't add new holes into our block/inode usage
> tracking...

This would basically take forever with thinkgs like Arek's filesystem
with almost 11 million inodes in each AG.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
