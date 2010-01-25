Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PKdIhb074689 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 14:39:18 -0600
Date: Mon, 25 Jan 2010 15:40:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100125204021.GA6191@infradead.org>
References: <20100122185419.63ae6430@harpe.intellique.com>
	<20100122183848.GB28561@sgi.com>
	<20100125150410.GA25699@infradead.org>
	<20100125202839.GA28087@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125202839.GA28087@sgi.com>
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
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 25, 2010 at 02:28:39PM -0600, bpm@sgi.com wrote:
> The original tests were done with the wsync mount option.  I'm not
> really sure that it was necessary.  Test case was "tar -xvf
> ImageMagick.tar".  'fdatasync' represents whether the export option
> controlling usage of write_inode_now vs fsync was set.

Ok.  Btw, you need to call ->fsync with fdatasync = 0 for NFS as it
also wants to catch non-data changes to the inode.  Doesn't matter
for XFS as we currently always force a full fsync, but I'm going to
change that soon.

> internal log, no wsync, no fdatasync
> 2m48.632s       2m59.676s       2m42.450s
> 
> internal log, wsync, no fdatasync
> 3m1.320s        3m10.961s       2m53.560s
> 
> internal log, wsync, fdatasync
> 1m40.191s       1m38.780s       1m35.758s

The wsync case always still includes either the ->fsync or write_inode
call, right?  If we use wsync we shouldn't need either in theory as
the transactions already commit synchronously.

Anyway, given the massive improvements of ->fsync vs write_inode you
really should post that patch to the NFS list for discussion ASAP.


> > But all this affects metadata performance, and only for sync exports,
> > while the OP does a simple dd which is streaming data I/O and uses the
> > (extremly unsafe) async export operation that disables the write_inode
> > calls.
> 
> Right.  This might not apply to Emmanuel's problem.  I've been wondering
> if a recent change to not hold the inode mutex over the sync helps in
> the streaming io case.  Any idea?

It should help a bit.  I'm not sure it can cause that much of a
difference for such a simple single-threaded workload.  Emmanuel, is
there any chance you could try the latest 2.6.32-stable kernel or even
2.6.33-rc as those changes are included there?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
