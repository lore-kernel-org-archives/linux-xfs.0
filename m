Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBNLka76006856 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 15:46:36 -0600
Date: Fri, 23 Dec 2011 15:47:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2 v2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111223214703.GW29840@sgi.com>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111220200841.GA2788@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111220200841.GA2788@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hey Christoph,

On Tue, Dec 20, 2011 at 03:08:41PM -0500, Christoph Hellwig wrote:
> Since Linux 2.6.36 the writeback code has introduces various measures for
> live lock prevention during sync().  Unfortunately some of these are
> actively harmful for the XFS model, where the inode gets marked dirty for
> metadata from the data I/O handler.
> 
> The older_than_this checks that are now more strictly enforced since
> 
>     writeback: avoid livelocking WB_SYNC_ALL writeback
> 
> by only calling into __writeback_inodes_sb and thus only sampling the

Do you mean __writeback_inodes_wb, or perhaps writeback_sb_inodes?

So far I'm not seeing the connection with the commit you've referenced
above, which seems to be related to nr_to_write.  It looks like you're
referring to older fs/fs-writeback.c..

This one seems like it might be relevant:

commit 7624ee7
mm: avoid resetting wb_start after each writeback round

Anyway.. in the 3.2-rcX code it appears that older_than_this is only set
at the start of wb_writeback (excluding for_kupdate being set)...

> current cut off time once.  But on a slow enough devices the previous
> asynchronous sync pass might not have fully completed yet, and thus XFS
> might mark metadata dirty only after that sampling of the cut off time for
> the blocking pass already happened. 

Are you referring to sync_filesystem() calling
__sync_filesystem(sb, 0)
and then
__sync_filesystem(sb, 1 /* wait */)?

Ah... and with that I think I understand what you're after here:  After
__sync_filesystem calls sync_inodes_sb and waits for completion... which
will dirty more inodes in completion handlers... you have the
opportunity to clean up those dirty inodes in .sync_fs.  If that's what
you intend:  I'd say this looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

Mark also reviewed this.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

THanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
