Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCMtAa6126638 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:55:10 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E162A2B82CC
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 14:55:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NtlhHNF9qtkbHWBY for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 14:55:08 -0800 (PST)
Date: Tue, 13 Dec 2011 09:55:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/12] repair: do not walk the unlinked inode list
Message-ID: <20111212225506.GU14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.091561992@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174741.091561992@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 02, 2011 at 12:46:20PM -0500, Christoph Hellwig wrote:
> Stefan Pfetzing reported a bug where xfs_repair got stuck eating 100% CPU in
> phase3.  We track it down to a loop in the unlinked inode list, apparently
> caused by memory corruption on an iSCSI target.
> 
> I looked into tracking if we already saw a given unlinked inode, but given
> that we keep walking even for inodes where we can't find an allocation btree
> record that seems infeasible.  On the other hand these inodes had their
> final unlink and thus were dead even before the system went down.  There
> really is no point in adding them to the uncertain list and looking for
> references to them later.
> 
> So the simplest fix seems to be to simply remove the unlinked inode list
> walk and just clear it - when we rebuild the inode allocation btrees these
> will simply be marked free.
> 
> Reported-by: Stefan Pfetzing <stefan.pfetzing@1und1.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

After further consideration, this is probably fine as all the
unlinked inodes do get picked up elsewhere.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
