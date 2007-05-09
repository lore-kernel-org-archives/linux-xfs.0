Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 05:06:03 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49C5wfB021602
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 05:05:59 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49C5vv6004481
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 08:05:57 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49C5vn6531388
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 08:05:57 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49C5vNd025124
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 08:05:57 -0400
Date: Wed, 9 May 2007 17:35:59 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070509120559.GA19430@amitarora.in.ibm.com>
References: <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <17978.47502.786970.196554@cargo.ozlabs.ibm.com> <20070509101507.GA26056@in.ibm.com> <17985.42884.971318.859402@cargo.ozlabs.ibm.com> <20070509111011.GA21619@in.ibm.com> <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Paul Mackerras <paulus@samba.org>
Cc: suparna@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Wed, May 09, 2007 at 09:37:22PM +1000, Paul Mackerras wrote:
> Suparna Bhattacharya writes:
> 
> > > Of course the interface used by an application program would have the
> > > fd first.  Glibc can do the translation.
> > 
> > I think that was understood.
> 
> OK, then what does it matter what the glibc/kernel interface is, as
> long as it works?
> 
> It's only a minor point; the order of arguments can vary between
> architectures if necessary, but it's nicer if they don't have to.
> 32-bit powerpc will need to have the two int arguments adjacent in
> order to avoid using more than 6 argument registers at the user/kernel
> boundary, and s390 will need to avoid having a 64-bit argument last
> (if I understand it correctly).

You are right to say that. But, it may not be _that_ a minor point,
especially for the arch which is getting affected. It has
other implications like what Heiko noticed in his post below:
http://lkml.org/lkml/2007/4/27/377
 - implications like modifying glibc and *trace utilities for a particular
arch.

--
Regards,
Amit Arora
