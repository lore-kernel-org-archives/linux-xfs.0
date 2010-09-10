Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8AKKxFt163519 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 15:20:59 -0500
Subject: Re: [PATCH] xfs: remove the ->kill_root btree operation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100907233407.GA17728@infradead.org>
References: <20100907233407.GA17728@infradead.org>
Date: Fri, 10 Sep 2010 15:20:47 -0500
Message-ID: <1284150047.2468.16.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2010-09-07 at 19:34 -0400, Christoph Hellwig wrote:
> The implementation os ->kill_root only differ by either simply zeroing
> out the now unused buffer in the btree cursor in the inode allocation
> btree or using xfs_btree_setbuf in the allocation btree.
> 
> Initially both of them used xfs_btree_setbuf, but the use in the ialloc
> btree was removed early on because it interacted badly with xfs_trans_binval.
> 
> In addition to zeroing out the buffer in the cursor xfs_btree_setbuf updates
> the bc_ra array in the btree cursor, and calls xfs_trans_brelse on the
> buffer previous occupying the slot.
> 
> The bc_ra update should be done for the alloc btree updated too, although
> the lack of it does not cause serious problems.  The xfs_trans_brelse
> call on the other hand is effectively a no-op in the end - it keeps
> decrementing the bli_recur refcount until it hits zero, and then just
> skips out because the buffer will always be dirty at this point.  So
> removing it for the allocation btree is just fine.
> 
> So unify the code and move it to xfs_btree.c.  While we're at it also
> replace the call to xfs_btree_setbuf with a NULL bp argument in
> xfs_btree_del_cursor with a direct call to xfs_trans_brelse given
> that the cursor is beeing freed just after this and the state updates
> are superflous.  After this xfs_btree_setbuf is only used with a non-NULL
> bp argument and can thus be simplified.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
