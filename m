Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OI3cQG061051 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:03:38 -0600
Date: Tue, 24 Jan 2012 13:03:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfs: make i_flags an unsigned long
Message-ID: <20120124180336.GE23671@infradead.org>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.348628833@bombadil.infradead.org>
	<20120113190716.GA6271@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120113190716.GA6271@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 13, 2012 at 01:07:16PM -0600, Ben Myers wrote:
> On Thu, Dec 08, 2011 at 10:58:00AM -0500, Christoph Hellwig wrote:
> > To be used for bit wakeup i_flags needs to be an unsigned long or we'll
> > run into trouble on big endian systems.  Beause of the 1-byte i_update
> 					   Because
> > field right after it this actually causes a fairly large size increase
> > on its own (4 or 8 bytes), but that increase will be more than offset
> > by the next two patches.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good to me.  But I could go for a thorough explanation of 'trouble
> on big endian systems'.

If we use the bitops that expect to operate on a 64-bit value on a
32-bit value on big endian we'll actually use the 32-bit longword next
to it, not the one we intended for the first half of the bits.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
