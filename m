Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 18:28:40 -0800 (PST)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB82SUaG005584
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 18:28:31 -0800
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH] libattr 2.4.32 arm eabi system call calling convention
Date: Thu, 7 Dec 2006 18:07:54 -0800
References: <20061130025459.GA23869@xi.wantstofly.org> <20061130092853.GB1534@infradead.org>
In-Reply-To: <20061130092853.GB1534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200612071807.55023.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lennert Buytenhek <buytenh@wantstofly.org>, xfs@oss.sgi.com, linux-arm@lists.arm.linux.org.uk

Hello,

On Thursday 30 November 2006 01:28, Christoph Hellwig wrote:
> On Thu, Nov 30, 2006 at 03:54:59AM +0100, Lennert Buytenhek wrote:
> > When building for EABI, a different system call calling convention is
> > used where system calls are numbered starting from zero, not 0x900000
> > as in the old ABI.  This was causing 'ls -al' with an ls binary that
> > was built with xattr support to SIGILL.
>
> Please just rip out the direct syscalls.  The days glibc provices all
> the xattr syscalls in sys/xattr.h, and libattr should just forward to
> those.

Yes, makes sense these days. Thanks for paying attention, Christoph.

Tim, who from the SGI side is taking care of the acl and attr packages in the 
xfs-cmds repository these days? Would you be doing this change, or are you 
waiting for a patch?

Thanks,
Andreas

PS. I hope we'll meet at linux.conf.au this January in Sydney, or in Melbourne 
some days later :-)
