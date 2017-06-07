Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:58420 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751252AbdFGDiL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 23:38:11 -0400
Date: Wed, 7 Jun 2017 11:04:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: Work around deallocated stack frame reference gcc bug on
 sparc.
Message-ID: <20170607030429.GA29532@gondor.apana.org.au>
References: <20170602.112854.571030442583332811.davem@davemloft.net>
 <20170606.150408.1629203951871477326.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606.150408.1629203951871477326.davem@davemloft.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Miller <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, matorola@gmail.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 03:04:08PM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 02 Jun 2017 11:28:54 -0400 (EDT)
> 
> > 
> > On sparc, if we have an alloca() like situation, as is the case with
> > SHASH_DESC_ON_STACK(), we can end up referencing deallocated stack
> > memory.  The result can be that the value is clobbered if a trap
> > or interrupt arrives at just the right instruction.
> > 
> > It only occurs if the function ends returning a value from that
> > alloca() area and that value can be placed into the return value
> > register using a single instruction.
> > 
> > For example, in lib/libcrc32c.c:crc32c() we end up with a return
> > sequence like:
> > 
> >         return  %i7+8
> >          lduw   [%o5+16], %o0   ! MEM[(u32 *)__shash_desc.1_10 + 16B],
> > 
> > %o5 holds the base of the on-stack area allocated for the shash
> > descriptor.  But the return released the stack frame and the
> > register window.
> > 
> > So if an intererupt arrives between 'return' and 'lduw', then
> > the value read at %o5+16 can be corrupted.
> > 
> > Add a data compiler barrier to work around this problem.  This is
> > exactly what the gcc fix will end up doing as well, and it absolutely
> > should not change the code generated for other cpus (unless gcc
> > on them has the same bug :-)
> > 
> > With crucial insight from Eric Sandeen.
> > 
> > Reported-by: Anatoly Pugachev <matorola@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Herbert, please take a look at this and push via your crypto tree
> and submit to -stable if you don't have any objections.

Sure I'll push it today.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
