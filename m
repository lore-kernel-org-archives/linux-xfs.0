Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NLPdAk233924 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 16:25:39 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id SqCfoHMCFxVtggX0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Jul 2012 14:25:37 -0700 (PDT)
Date: Mon, 23 Jul 2012 22:25:33 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: [MMTests] Threaded IO Performance on xfs
Message-ID: <20120723212533.GJ9222@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120629111932.GA14154@suse.de>
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
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Configuration:	global-dhp__io-threaded-xfs
Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-xfs
Benchmarks:	tiobench

Summary
=======

There have been many improvements in the sequential read/write case but
3.4 is noticably worse than 3.3 in a number of cases.

Benchmark notes
===============

mkfs was run on system startup.
mkfs parameters -f -d agcount=8
mount options inode64,delaylog,logbsize=262144,nobarrier for the most part.
        On kernels to old to support delaylog was removed. On kernels
        where it was the default, it was specified and the warning ignored.

The size parameter for tiobench was 2*RAM. This is barely sufficient for
	this particular test where the size parameter should be multiple
	times the size of memory. The running time of the benchmark is
	already excessive and this is not likely to be changed.

===========================================================
Machine:	arnold
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-xfs/arnold/comparison.html
Arch:		x86
CPUs:		1 socket, 2 threads
Model:		Pentium 4
Disk:		Single Rotary Disk
==========================================================

tiobench
--------
  This is a mixed bag. For low numbers of clients, throughput on
  sequential reads has improved.  For larger number of clients, there
  are many regressions but this is not consistent.  This could be due to
  weakness in the methodology due to both a small filesize and a small
  number of iterations.

  Random read is generally bad.

  For many kernels sequential write is good with the notable exception
  of 2.6.39 and 3.0 kernels.

  There was unexpected swapping on 3.1 and 3.2 kernels.

==========================================================
Machine:	hydra
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-xfs/hydra/comparison.html
Arch:		x86-64
CPUs:		1 socket, 4 threads
Model:		AMD Phenom II X4 940
Disk:		Single Rotary Disk
==========================================================

tiobench
--------

  Like arnold, performance for sequential read is good for low number
  of clients.

  Random read looks good.

  With the exception of 3.0 in general and single threaded writes for all
  kernels, sequential writes have generally improved.

  Random write has a number of regressions.

  Kernels 3.1 and 3.2 had unexpected swapping.

==========================================================
Machine:	sandy
Result:		http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-threaded-xfs/sandy/comparison.html
Arch:		x86-64
CPUs:		1 socket, 8 threads
Model:		Intel Core i7-2600
Disk:		Single Rotary Disk
==========================================================

tiobench
--------

  Like hydra, sequential reads were generally better for low numbers of
  clients. 3.4 is notable in that it regressed and 3.1 was also bad which
  is roughly similar to what was seen on ext3. There are differences in
  the memory sizes and therefore the filesize and it implies that there
  is not a single cause of the regression.

  Random read has generally improved except with the obvious exception of
  the single-threaded case.

  Sequential writes have generally improved but it is interesting to note
  that 3.4 is worse than 3.3 and this was also seen for ext3.

  Random write is a mixed bad but again 3.4 is worse than 3.3.

  Like the other machines, 3.1 and 3.2 saw unexpected swapping.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
