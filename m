Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAIHWeHu025124 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 11:32:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D75F1B27824
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 09:32:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tipXdgV4ZTBZ4hfa for
	<xfs@oss.sgi.com>; Tue, 18 Nov 2008 09:32:40 -0800 (PST)
Date: Tue, 18 Nov 2008 08:53:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: assertion failed in xfs_reclaim_inodes_ag()
Message-ID: <20081118135356.GA21792@infradead.org>
References: <49221D83.6030406@sgi.com> <20081118133844.GA17894@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081118133844.GA17894@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 18, 2008 at 08:38:44AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 18, 2008 at 12:42:27PM +1100, Lachlan McIlroy wrote:
> > Hit this while running stress tests.  Looks like an inode is tagged with
> > XFS_ICI_RECLAIM_TAG but not XFS_IRECLAIMABLE|XFS_IRECLAIM.  I can't see
> > how that can happen.
> 
> Looks it's xfs_iget_cache_hit when the inode is marked XFS_IRECLAIMABLE,
> in that case we first clear XFS_IRECLAIMABLE and then call
> __xfs_inode_clear_reclaim_tag, and all that under
> read_lock(&pag->pag_ici_lock) only, so no protection against the assert
> in xfs_reclaim_inodes_ag.

And the easiest fix is to just remove the assert, xfs_reclaim_inode does
the right thing (bail out) if XFS_IRECLAIMABLE is not set, and it does
so with the correct locks.  The more complicated fix would be to take
the pag_ici_lock in write more from the very beginning in
xfs_reclaim_inodes_ag, and open-code a variant of xfs_reclaim_inode
there.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
