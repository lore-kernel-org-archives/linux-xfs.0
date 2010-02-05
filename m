Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15BYfsZ132820 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 05:34:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C3A71B2557
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 03:35:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SEuZKHlXAe2yrfjm for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 03:35:51 -0800 (PST)
Date: Fri, 5 Feb 2010 06:35:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for-2.6.33] xfs: flush all log buffers in xlog_dealloc_log
Message-ID: <20100205113550.GA10926@infradead.org>
References: <20100201220813.GA3519@infradead.org>
	<20100203105545.GA1047@infradead.org>
	<20100204081422.GF5332@discord.disaster>
	<20100204161050.GB11206@infradead.org>
	<20100205025811.GB11483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205025811.GB11483@discord.disaster>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Feb 05, 2010 at 01:58:11PM +1100, Dave Chinner wrote:
> > and there's
> > also a very similar one from Ed Cashin <ecashin@coraid.com> in
> > mail archives from November.
> 
> Yeah, that's clearly IO completion after the call to
> xfs_unmountfs_wait(). That does a xfs_wait_buftarg() call
> which waits for all hashed buffers on the buftarg except for
> those that are XBF_FS_MANAGED - the superblock.
> 
> Looking at xfs_fs_put_super(), the superblock buffer is freed after
> xfs_unmountfs() frees the log, so if the superblock was logged
> and is undergoing IO then xfs_unmountfs_wait() would not have
> blocked on it and it could leak past the "no more IO should
> bein progress" barrier that xfs_unmountfs_wait() is supposed to
> provide.
> 
> Does this look like a plausible cause of the problem?

We just did a xfs_unmountfs_writesb before the call to
xfs_unmountfs_wait, so the superblock buffer should be a sync buffer at
that point, so something more fishy is going on here.  syncd is also
stopped before that call, so that gets rid of another possible case
of an async buffer pending.

Independent of that I think xfs_wait_buftarg waiting for the SB buffer
seems correct to me, but I fear something else is going on here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
