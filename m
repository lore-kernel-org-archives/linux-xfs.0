Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 16:14:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5TNDqj1031804
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:13:53 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B588D6F159
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:14:54 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id KrpGqnWRHCba23gW for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 16:14:54 -0700 (PDT)
Subject: Re: rfc: kill ino64 mount option
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <20080628152303.GA22484@lst.de>
References: <20080627153928.GA31384@lst.de>
	 <20080628000914.GE29319@disturbed>  <20080628152303.GA22484@lst.de>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 09:13:34 +1000
Message-Id: <1214781214.4609.1.camel@verge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, 2008-06-28 at 17:23 +0200, Christoph Hellwig wrote:
> On Sat, Jun 28, 2008 at 10:09:14AM +1000, Dave Chinner wrote:
> > On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
> > > Does anyone have objections to kill the ino64 mount option?  It's purely
> > > a debug tool to force inode numbers outside of the range representable
> > > in 32bits and is quite invasive for something that could easily be
> > > debugged by just having a large enough filesystem..
> > 
> > It's the "large enough fs" that is the problem. XFSQA uses
> > small partitions for the most part, and this allows testing
> > of 64 bit inode numbers with a standard qa config.
> 
> Well, it allows showing 64bit inode numbers to userspace.  All XFS
> internal codepathes are still using the smaller inode numbers and we
> only add a fixed offset to them just before the inode number is returned
> to userspace.

I'd vote for removing it - I've used it in the past, and it didn't do
what I wanted (its not really useful for XFS testing) and the confusion
it causes with inode64 is not worth it.

cheers.

--
Nathan
