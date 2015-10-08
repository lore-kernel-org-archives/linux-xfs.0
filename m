Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93E397F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 03:23:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20755AC00F
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 01:23:13 -0700 (PDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	Pa6CQlwA85bIqm29 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Oct 2015 01:23:11 -0700 (PDT)
Received: by wicfx3 with SMTP id fx3so13916339wic.0
	for <xfs@oss.sgi.com>; Thu, 08 Oct 2015 01:23:10 -0700 (PDT)
Date: Thu, 8 Oct 2015 11:23:07 +0300
From: Gleb Natapov <gleb@scylladb.com>
Subject: Re: Question about non asynchronous aio calls.
Message-ID: <20151008082307.GE11716@scylladb.com>
References: <20151007141833.GB11716@scylladb.com>
	<56152B0F.2040809@sandeen.net>
	<20151007150833.GB30191@bfoster.bfoster>
	<56153685.3040401@sandeen.net> <561560B2.1080902@scylladb.com>
	<20151008042831.GU27164@dastard> <5615FD76.1090309@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5615FD76.1090309@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Oct 08, 2015 at 08:21:58AM +0300, Avi Kivity wrote:
> >>>I fixed something similar in ext4 at the time, FWIW.
> >>Makes sense.
> >>
> >>Is there a way to relax this for reads?
> >The above mostly only applies to writes. Reads don't modify data so
> >racing unaligned reads against other reads won't given unexpected
> >results and so aren't serialised.
> >
> >i.e. serialisation will only occur when:
> >	- unaligned write IO will serialise until sub-block zeroing
> >	  is complete.
> >	- write IO extending EOF will serialis until post-EOF
> >	  zeroing is complete
> 
> 
> By "complete" here, do you mean that a call to truncate() returned, or that
> its results reached the disk an unknown time later?
> 
I think Brian already answered that one with:

  There are no such pitfalls as far as I'm aware. The entire AIO
  submission synchronization sequence triggers off an in-memory i_size
  check in xfs_file_aio_write_checks(). The in-memory i_size is updated in
  the truncate path (xfs_setattr_size()) via truncate_setsize(), so at
  that point the new size should be visible to subsequent AIO writers.

> i could, immediately after truncating the file, extend it to a very large
> size, and truncate it back just before the final fsync/close sequence.  This
> has downsides from the viewpoint of user support (why is the file so large
> after a crash, what happens with backups) but is better than nothing.
> 
> >	- cached pages are found on the inode (i.e. mixing
> >	  buffered/mmap access with direct IO).
> 
> We don't do that.
> 
> >	- truncate/extent manipulation syscall is run
> 
> Actually, we do call fallocate() ahead of io_submit() (in a worker thread,
> in non-overlapping ranges) to optimize file layout and also in the belief
> that it would reduce the amount of blocking io_submit() does.
> 
> Should we serialize the fallocate() calls vs. io_submit() (on the same
> file)?  Were those fallocates a good idea in the first place?
> 
> >All other DIO will be issued and run concurrently, reads and writes.
> >
> >Realistically, if you are care about performance (which obviously
> >you are) then you do not do unaligned IO, and you try hard to
> >minimise operations that extend the file...
> 
> On SSDs, if you care about performance you avoid random writes, which cause
> write amplification.  So you do have to extend the file, unless you know its
> size in advance, which we don't.
> 
> Also, does "extend the file" here mean just the size, or extent allocation
> as well?
> 
> A final point is discoverability.  There is no way to discover safe
> alignment for reads and writes, and which operations block io_submit(),
> except by asking here, which cannot be done at runtime.  Interfaces that
> provide a way to query these attributes are very important to us.
As Brian pointed statfs() can be use to get f_bsize which is defined as
"optimal transfer block size".

--
			Gleb.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
