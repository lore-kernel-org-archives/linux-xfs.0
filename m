Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 16:31:56 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47NVnfB016106
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 16:31:52 -0700
Date: Mon, 7 May 2007 16:31:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-Id: <20070507163135.cf455103.akpm@linux-foundation.org>
In-Reply-To: <20070507231442.GA29907@thunk.org>
References: <20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426181332.GD7209@amitarora.in.ibm.com>
	<20070503213133.d1559f52.akpm@linux-foundation.org>
	<20070507113753.GA5439@schatzie.adilger.int>
	<20070507135825.f8545a65.akpm@linux-foundation.org>
	<20070507222103.GJ8181@schatzie.adilger.int>
	<20070507153856.d56a5133.akpm@linux-foundation.org>
	<20070507231442.GA29907@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Theodore Tso <tytso@mit.edu>
Cc: Andreas Dilger <adilger@clusterfs.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, 7 May 2007 19:14:42 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, May 07, 2007 at 03:38:56PM -0700, Andrew Morton wrote:
> > > Actually, this is a non-issue.  The reason that it is handled for extent-only
> > > is that this is the only way to allocate space in the filesystem without
> > > doing the explicit zeroing.  For other filesystems (including ext3 and
> > > ext4 with block-mapped files) the filesystem should return an error (e.g.
> > > -EOPNOTSUPP) and glibc will do manual zero-filling of the file in userspace.
> > 
> > It can be a bit suboptimal from the layout POV.  The reservations code will
> > largely save us here, but kernel support might make it a bit better.
> 
> Actually, the reservations code won't matter, since glibc will fall
> back to its current behavior, which is it will do the preallocation by
> explicitly writing zeros to the file.

No!  Reservations code is *critical* here.  Without reservations, we get
disastrously-bad layout if two processes were running a large fallocate()
at the same time.  (This is an SMP-only problem, btw: on UP the timeslice
lengths save us).

My point is that even though reservations save us, we could do even-better
in-kernel.

But then, a smart application would bypass the glibc() fallocate()
implementation and would tune the reservation window size and would use
direct-IO or sync_file_range()+fadvise(FADV_DONTNEED).

> This wlil result in the same
> layout as if we had done the persistent preallocation, but of course
> it will mean the posix_fallocate() could potentially take a long time
> if you're a PVR and you're reserving a gig or two for a two hour movie
> at high quality.  That seems suboptimal, granted, and ideally the
> application should be warned about this before it calls
> posix_fallocate().  On the other hand, it's what happens today, all
> the time, so applications won't be too badly surprised.

A PVR implementor would take all this over and would do it themselves, for
sure.

> If we think applications programmers badly need to know in advance if
> posix_fallocate() will be fast or slow, probably the right thing is to
> define a new fpathconf() configuration option so they can query to see
> whether a particular file will support a fast posix_fallocate().  I'm
> not 100% convinced such complexity is really needed, but I'm willing
> to be convinced....  what do folks think?
> 

An application could do sys_fallocate(one-byte) to work out whether it's
supported in-kernel, I guess.
