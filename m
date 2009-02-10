Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AArsBu046812
	for <linux-xfs@oss.sgi.com>; Tue, 10 Feb 2009 04:53:55 -0600
Received: from mail-bw0-f168.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBEE2103473
	for <linux-xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:53:17 -0800 (PST)
Received: from mail-bw0-f168.google.com (mail-bw0-f168.google.com
	[209.85.218.168]) by cuda.sgi.com with ESMTP id
	B9AW5HEqOvtS0H6n for <linux-xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 02:53:17 -0800 (PST)
Received: by bwz12 with SMTP id 12so2643066bwz.20
	for <linux-xfs@oss.sgi.com>; Tue, 10 Feb 2009 02:53:16 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090210104304.GP8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed>
Date: Tue, 10 Feb 2009 11:53:14 +0100
Message-Id: <1234263194.7462.8.camel@champagne.cantina>
Mime-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2009-02-10 at 21:43 +1100, Dave Chinner wrote:
> On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> > On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > > sure, attached
> > 
> > That would be a missing PagePrivate bit in page_buffers() called from
> > end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> > which requires the page not having PG_writeback set which must be
> > set until end_buffer_async_write is done.  Very strange, and all this
> > is generic code without xfs involvement.  Did this happen once
> > or can you reproduce it?
> 
> Hmmmm - i wonder if this has anything to do with the writeback fixes
> that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
> plain 2.6.28) and see if you can reproduce the problem?

no problem 
I'll try with 2.6.28.1 a full rsync (circa 210G)
maybe I can do this today


> 
> Cheers,
> 
> Dave.
-- 
---
Cordiali Saluti
Alessandro Bono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
