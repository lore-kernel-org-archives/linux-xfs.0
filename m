Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeFAFZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jun 2018 01:25:41 -0400
Date: Thu, 31 May 2018 22:25:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4 V2] Remove a few macros
Message-ID: <20180601052539.GA23957@infradead.org>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
 <b5e4681b-8198-82fc-e4da-bfbad08cf32d@sandeen.net>
 <20180531171909.cedwobpqlaf2h5ly@odin.usersys.redhat.com>
 <20180531231153.GO10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531231153.GO10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, Jun 01, 2018 at 09:11:53AM +1000, Dave Chinner wrote:
> 
> What was there to argue? Christoph wants us to rely on undocumented,
> compiler specific behaviour(*),

It is not undocumented.  Sections like this have been part of the
gcc manual for at least 25 years:

https://gcc.gnu.org/onlinedocs/gcc/Pointer-Arith.html

> I want it the pointer arithmetic to
> be explicitly correct with a cast.
> 
> Maintainer's choice, really.
> 
> Cheers,
> 
> Dave.
> 
> (*) It's been repeatedly demonstrated that the gcc developers don't
> care if they break code that relies on undefined behaviour in the C
> standard.

But this behavior is not undefined.  It is explicitly defined for gcc,
with other compilers (LLVM, icc) following that specification.
