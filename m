Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 01:39:41 -0800 (PST)
Received: from xi.wantstofly.org (alephnull.demon.nl [83.160.184.112])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAU9dWaG022944
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 01:39:34 -0800
Date: Thu, 30 Nov 2006 10:38:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] libattr 2.4.32 arm eabi system call calling convention
Message-ID: <20061130093842.GB24108@xi.wantstofly.org>
References: <20061130025459.GA23869@xi.wantstofly.org> <20061130092853.GB1534@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061130092853.GB1534@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: agruen@suse.de, xfs@oss.sgi.com, linux-arm@lists.arm.linux.org.uk

On Thu, Nov 30, 2006 at 09:28:53AM +0000, Christoph Hellwig wrote:

> > When building for EABI, a different system call calling convention is
> > used where system calls are numbered starting from zero, not 0x900000
> > as in the old ABI.  This was causing 'ls -al' with an ls binary that
> > was built with xattr support to SIGILL.
> 
> Please just rip out the direct syscalls.  The days glibc provices all
> the xattr syscalls in sys/xattr.h, and libattr should just forward to
> those.

Sounds like the better option to me as well.  (Would have saved me
a bunch of work, too.)
