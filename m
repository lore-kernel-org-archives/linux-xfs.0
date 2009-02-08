Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n18Mdrxb198988
	for <linux-xfs@oss.sgi.com>; Sun, 8 Feb 2009 16:39:54 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95B0F18F065F
	for <linux-xfs@oss.sgi.com>; Sun,  8 Feb 2009 14:39:16 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by cuda.sgi.com with ESMTP id LLfH69jl34MusO3n for
	<linux-xfs@oss.sgi.com>; Sun, 08 Feb 2009 14:39:16 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e21so1002145fga.8
	for <linux-xfs@oss.sgi.com>; Sun, 08 Feb 2009 14:39:15 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090208222859.GA2532@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
Date: Sun, 08 Feb 2009 23:39:12 +0100
Message-Id: <1234132752.12370.0.camel@champagne.cantina>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2009-02-08 at 17:28 -0500, Christoph Hellwig wrote:
> On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> > Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> > here ]------------
> > Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> > fs/buffer.c:470!
> 
> Per
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=blob;f=fs/buffer.c;h=665d446b25bc034241ef54c3c6b1d239c0ccf0f9;hb=d5b562330ec766292a3ac54ae5e0673610bd5b3d
> 
> line 470 in fs/buffer.c of 2.6.28.4 has a comment and no actual code.
> 
> What additional patches do you have applied?
> 

vanilla kernel
no additional patches at all

-- 
---
Cordiali Saluti
Alessandro Bono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
