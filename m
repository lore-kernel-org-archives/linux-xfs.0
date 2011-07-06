Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p666b2Qp087902 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 01:37:02 -0500
Date: Wed, 6 Jul 2011 02:37:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/27] xfs: re-enable non-blocking behaviour in
	xfs_map_blocks
Message-ID: <20110706063700.GA4508@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094602.465074143@bombadil.infradead.org>
	<1309905319.1950.48.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309905319.1950.48.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 05:35:19PM -0500, Alex Elder wrote:
> On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > The non-blockig behaviour in xfs_map_blocks currently is conditional on
> > having both the WB_SYNC_NONE sync_mode and the nonblocking flag set.
> > The latter used to be used by both pdflush, kswapd and a few other places
> > in older kernels, but has been fading out starting with the introduction
> > of the per-bdi flusher threads.
> > 
> > Enable the non-blocking behaviour for all WB_SYNC_NONE calls to get back
> > the behaviour we want.
> 
> The subject line should refer to xfs_vm_writepage()
> (not xfs_map_blocks()).  Unless I hear otherwise I
> will plan to change that for you.

Well, the actual xfs_ilock_nowait call is in xfs_map_blocks, the logic
controlling it in xfs_vm_writepage, so either one is fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
