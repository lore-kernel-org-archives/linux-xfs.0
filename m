Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2T2kPDn199998
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 21:46:25 -0500
Received: from mx3.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A8BC2385ACE
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 19:49:35 -0700 (PDT)
Received: from mx3.twosigma.com (mx3.twosigma.com [208.77.213.34]) by
	cuda.sgi.com with SMTP id H2Ij6G0jdk1PZqoH for
	<linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 19:49:35 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Mon, 28 Mar 2011 22:49:33 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B534F@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<20110329015137.GD3008@dastard>
In-Reply-To: <20110329015137.GD3008@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

> As it is, the question I'd really like answered is how a machine with
> 48GB RAM can possibly be short of memory when running mmap() on a
> 16GB file.  The error that XFS is throwing indicates that the
> machine cannot allocate a single page of memory, so where has all
> your memory gone, and why hasn't the OOM killer been let off the
> leash?  What is consuming the other 32GB of RAM or preventing it
> from being allocated? 
Here's meminfo while a test was deadlocking.  As you can see, we certainly aren't running out of RAM.
# cat /proc/meminfo 
MemTotal:       49551548 kB
MemFree:        44139876 kB
Buffers:            5324 kB
Cached:          4970552 kB
SwapCached:            0 kB
Active:            52772 kB
Inactive:        4960624 kB
Active(anon):      37864 kB
Inactive(anon):        0 kB
Active(file):      14908 kB
Inactive(file):  4960624 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:           4914084 kB
Writeback:             0 kB
AnonPages:         37636 kB
Mapped:          4925460 kB
Shmem:               280 kB
Slab:             223212 kB
SReclaimable:     176280 kB
SUnreclaim:        46932 kB
KernelStack:        3968 kB
PageTables:        35228 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    47073968 kB
Committed_AS:      86556 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      380892 kB
VmallocChunk:   34331773836 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        2048 kB
DirectMap2M:     2086912 kB
DirectMap1G:    48234496 kB


> Perhaps the output of xfs_bmap -vvp <file> after a successful vs
deadlocked run would be instructive....

I will try to get this tomorrow.

Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
