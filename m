Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n18MhReY199252
	for <linux-xfs@oss.sgi.com>; Sun, 8 Feb 2009 16:43:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7F6AFBA60
	for <linux-xfs@oss.sgi.com>; Sun,  8 Feb 2009 14:42:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Oiuh3CmZiR1BgJVT for
	<linux-xfs@oss.sgi.com>; Sun, 08 Feb 2009 14:42:50 -0800 (PST)
Date: Sun, 8 Feb 2009 17:42:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090208224249.GA11931@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1234132752.12370.0.camel@champagne.cantina>
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Feb 08, 2009 at 11:39:12PM +0100, Alessandro Bono wrote:
> On Sun, 2009-02-08 at 17:28 -0500, Christoph Hellwig wrote:
> > On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> > > Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> > > here ]------------
> > > Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> > > fs/buffer.c:470!
> > 
> > Per
> > http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=blob;f=fs/buffer.c;h=665d446b25bc034241ef54c3c6b1d239c0ccf0f9;hb=d5b562330ec766292a3ac54ae5e0673610bd5b3d
> > 
> > line 470 in fs/buffer.c of 2.6.28.4 has a comment and no actual code.
> > 
> > What additional patches do you have applied?
> > 
> 
> vanilla kernel
> no additional patches at all

Well, the 2.6.28.4 clearly doesn't have a bug there.  Can you
attach the fs/buffer.c you built the kernel from?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
