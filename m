Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Apr 2007 10:47:15 -0700 (PDT)
Received: from mtagate1.de.ibm.com (mtagate1.de.ibm.com [195.212.29.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3RHl5fB018972
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 10:47:06 -0700
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l3RHl15a130500
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 17:47:01 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3RHl1944079788
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 19:47:01 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3RHl02S018720
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 19:47:01 +0200
Date: Fri, 27 Apr 2007 19:46:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070427174613.GA8228@osiris.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com> <20070427144327.GC22949@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070427144327.GC22949@lazybastard.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Fri, Apr 27, 2007 at 04:43:28PM +0200, Jörn Engel wrote:
> On Fri, 27 April 2007 14:10:03 +0200, Heiko Carstens wrote:
> > 
> > After long discussions where at least two possible implementations
> > were suggested that would work on _all_ architectures you chose one
> > which doesn't and causes extra effort.
> 
> I believe the long discussion also showed that every possible
> implementation has drawbacks.  To me this one appeared to be the best of
> many bad choices.

If one insists to have fd at first argument, what is wrong with having
u32 arguments only? It's not that this syscall comes even close to
what can be considered performance critical...

> Is this implementation worse than we thought?

It adds userspace overhead for one architecture. Every *trace and
*libc needs special handling on s390 for this syscall. I would
prefer to avoid this.
