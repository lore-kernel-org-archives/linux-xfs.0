Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6CG2Sec037249 for <xfs@oss.sgi.com>; Mon, 12 Jul 2010 11:02:29 -0500
Date: Mon, 12 Jul 2010 12:05:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: writepage always has buffers
Message-ID: <20100712160523.GB2666@infradead.org>
References: <20100628143457.GC5473@infradead.org>
	<1278906189.7456.22.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278906189.7456.22.camel@doink>
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

On Sun, Jul 11, 2010 at 10:43:09PM -0500, Alex Elder wrote:
> On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> > These days we always have buffers thanks to ->page_mkwrite.  And we already
> > have an assert a few lines above tripping in case that was not true due to
> > a bug.
> 
> Should the ASSERT() be made stronger (i.e., BUG_ON())?
> Looks to me like we'll crash if it ever happens in a
> non-debug kernel, and a BUG() call would more directly
> tell us what the problem was...

The crash tells it quite directly as well, the ASSERT is there more as
a documentation of what we require.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
