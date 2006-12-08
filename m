Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 18:57:00 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB82upaG008648
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 18:56:52 -0800
Subject: Re: [PATCH] libattr 2.4.32 arm eabi system call calling convention
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200612071807.55023.agruen@suse.de>
References: <20061130025459.GA23869@xi.wantstofly.org>
	 <20061130092853.GB1534@infradead.org>  <200612071807.55023.agruen@suse.de>
Content-Type: text/plain
Date: Fri, 08 Dec 2006 13:55:53 +1100
Message-Id: <1165546553.30459.71.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>, Lennert Buytenhek <buytenh@wantstofly.org>, xfs@oss.sgi.com, linux-arm@lists.arm.linux.org.uk

On Thu, 2006-12-07 at 18:07 -0800, Andreas Gruenbacher wrote:
> Hello,

Hi Andreas,

> On Thursday 30 November 2006 01:28, Christoph Hellwig wrote:
> > On Thu, Nov 30, 2006 at 03:54:59AM +0100, Lennert Buytenhek wrote:
> > > When building for EABI, a different system call calling convention is
> > > used where system calls are numbered starting from zero, not 0x900000
> > > as in the old ABI.  This was causing 'ls -al' with an ls binary that
> > > was built with xattr support to SIGILL.
> >
> > Please just rip out the direct syscalls.  The days glibc provices all
> > the xattr syscalls in sys/xattr.h, and libattr should just forward to
> > those.
> 
> Yes, makes sense these days. Thanks for paying attention, Christoph.
> 
> Tim, who from the SGI side is taking care of the acl and attr packages in the 
> xfs-cmds repository these days? Would you be doing this change, or are you 
> waiting for a patch?

Tim's on holiday atm.  I'll cook up a patch (I have another attr patch
from someone I need to get merged too), and get someone to check it in.

> PS. I hope we'll meet at linux.conf.au this January in Sydney, or in Melbourne 
> some days later :-)

I'll see you there too (I'm looking forward to your LCA talk ;)

cheers.

-- 
Nathan
