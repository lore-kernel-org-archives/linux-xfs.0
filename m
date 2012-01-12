Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CJU75F014699 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 13:30:07 -0600
Message-ID: <4F0F34BE.2040001@sgi.com>
Date: Thu, 12 Jan 2012 13:30:06 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/12] repair: do not walk the unlinked inode list
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.091561992@bombadil.infradead.org>
In-Reply-To: <20111202174741.091561992@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
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


Makes sense to me.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
