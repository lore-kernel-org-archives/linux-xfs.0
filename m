Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B04DB7F51
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 04:09:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D150AC001
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 02:09:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id whtWDSQNY79wT7kS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 02:09:10 -0800 (PST)
Date: Wed, 27 Nov 2013 02:09:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131127100906.GA19740@infradead.org>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131127064351.GN10323@ZenIV.linux.org.uk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 27, 2013 at 06:43:51AM +0000, Al Viro wrote:
> On Tue, Nov 26, 2013 at 06:12:53AM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 26, 2013 at 01:11:34PM +0000, Al Viro wrote:
> > > .config, please - all I'm seeing on mine is a bloody awful leak somewhere
> > > in VM that I'd been hunting for last week, so the damn thing gets OOMed
> > > halfway through xfstests run ;-/
> 
> > #
> > # Automatically generated file; DO NOT EDIT.
> > # Linux/x86 3.12.0-hubcap2 Kernel Configuration
> [snip]
> 
> Could you post the output of your xfstests run?  FWIW, with your .config
> I'm seeing the same leak (shut down by turning spinlock debugging off,
> it's split page table locks that end up leaking when they are separately
> allocated) *and* xfs/253 seems to be sitting there indefinitely once
> we get to it - about 100% system time, no blocked processes, xfs_db running
> all the time for hours.  No oopsen on halt with that sucker skipped *or*
> interrupted halfway through.

Might be that your xfsprogs is old enough that it has a bug that test
wants to verify is fixed.

> Setup is kvm on 3.3GHz amd64 6-core, with 4Gb given to guest (after having
> one too many OOMs on leaks).  virtio disk, with raw image sitting in a file
> on host, xfstests from current git, squeeze/amd64 userland on guest.
> Reasonably fast host disks (not that the sucker had been IO-bound, anyway).
> Tried both with UP and 4-way SMP guest, same picture on both...

I'm running on my laptop with a Dual Core 2.5Ghz i5, on preallocated
raw files on XFS on an older Intel SSD. Qemu command line:

kvm \
	-m 2048 \
	-smp 4 \
	-kernel arch/x86/boot/bzImage \
	-append "root=/dev/vda console=tty0
	console=ttyS0,115200n8" \
	-nographic \
	-drive if=virtio,file=/work/images/debian.qcow2,cache=none,serial="test1234" \
	-drive if=virtio,file=/work/images/test.img,cache=none,aio=native \
	-drive if=virtio,file=/work/images/scratch.img,cache=none,aio=native


It's probably enough to run
./check with -g quick to reproduce it, too - let me verify that which
I'd have to do to catch the output anyway.

Also if you want to look me into something else feel free - it's very
reproducable here.  Wish I could be more help here, but with all the
RCU and micro optimizations in the path lookup code I can't claim to
really understand it anymore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
