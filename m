Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAGB3DbG122839 for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 05:03:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48E3F1D980EE
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:03:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nelqFc2HyBrdL7uW for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:03:33 -0800 (PST)
Date: Mon, 16 Nov 2009 06:03:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: remove xfs_buf_get / xfs_buf_read
Message-ID: <20091116110331.GA19835@infradead.org>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.411213050@bombadil.infradead.org>
	<20091116031512.GC9467@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091116031512.GC9467@discord.disaster>
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

On Mon, Nov 16, 2009 at 02:15:12PM +1100, Dave Chinner wrote:
> On Sat, Nov 14, 2009 at 11:17:19AM -0500, Christoph Hellwig wrote:
> > The two interfaces are highl confusing as they do have a flags argument
> > which gets ignored and replaced with default flags.  Switch the few remaining
> > callers to use xfs_buf_get_flags and xfs_buf_read_flags instead and remove
> > these wrappers.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Personally I would have dropped the *_flags from the function names
> as well (so everything calls xfs_buf_get() or xfs_buf_read()) but
> it doesn't really matter....

Maybe.  The issue would be if we forward-port some code that expects it
can pass random crap in the flags field will get different behaviour
now.  Then again it'll blow up fast enough to notice..

> > +				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
> > +				BTOBB(mp->m_sb.sb_blocksize), XBF_LOCK | XBF_MAPPED);
> 
> That looks wider than 80 columns. Same for the other conversions,
> too.

I'll fix it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
