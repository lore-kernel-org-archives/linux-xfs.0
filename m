Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AAnIej046543
	for <linux-xfs@oss.sgi.com>; Tue, 10 Feb 2009 04:49:19 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22B221B85C14
	for <linux-xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:48:41 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	9P6e1cQni8WsStDF for <linux-xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 02:48:41 -0800 (PST)
Date: Tue, 10 Feb 2009 21:43:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090210104304.GP8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090209075308.GA7360@infradead.org>
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
Cc: linux-xfs <linux-xfs@oss.sgi.com>, Alessandro Bono <alessandro.bono@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > sure, attached
> 
> That would be a missing PagePrivate bit in page_buffers() called from
> end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> which requires the page not having PG_writeback set which must be
> set until end_buffer_async_write is done.  Very strange, and all this
> is generic code without xfs involvement.  Did this happen once
> or can you reproduce it?

Hmmmm - i wonder if this has anything to do with the writeback fixes
that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
plain 2.6.28) and see if you can reproduce the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
