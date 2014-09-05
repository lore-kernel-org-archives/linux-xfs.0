Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CC777F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 16:24:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C0B08F8049
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 14:24:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rPvCvGQrKUvnlDCB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 05 Sep 2014 14:24:06 -0700 (PDT)
Date: Fri, 5 Sep 2014 17:24:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140905212400.GA8904@laptop.bfoster>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag>
	<20140905134810.GA3965@laptop.bfoster>
	<5409FBEA.9050708@profihost.ag>
	<20140905191815.GB8400@laptop.bfoster>
	<540A19BB.8040404@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540A19BB.8040404@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Sep 05, 2014 at 10:14:51PM +0200, Stefan Priebe wrote:
> 
> Am 05.09.2014 21:18, schrieb Brian Foster:
> ...
> 
> >On Fri, Sep 05, 2014 at 08:07:38PM +0200, Stefan Priebe wrote:
> >Interesting, that seems like a lot of free inodes. That's 1-2 million in
> >each AG that we have to look around for each time we want to allocate an
> >inode. I can't say for sure that's the source of the slowdown, but this
> >certainly looks like the kind of workload that inspired the addition of
> >the free inode btree (finobt) to more recent kernels.
> >
> >It appears that you still have quite a bit of space available in
> >general. Could you run some local tests on this filesystem to try and
> >quantify how much of this degradation manifests on sustained writes vs.
> >file creation? For example, how is throughput when writing a few GB to a
> >local test file?
> 
> Not sure if this is what you expect:
> 
> # dd if=/dev/zero of=bigfile oflag=direct,sync bs=4M count=1000
> 1000+0 records in
> 1000+0 records out
> 4194304000 bytes (4,2 GB) copied, 125,809 s, 33,3 MB/s
> 
> or without sync
> # dd if=/dev/zero of=bigfile oflag=direct bs=4M count=1000
> 1000+0 records in
> 1000+0 records out
> 4194304000 bytes (4,2 GB) copied, 32,5474 s, 129 MB/s
> 
> > How about with that same amount of data broken up
> >across a few thousand files?
> 
> This results in heavy kworker usage.
> 
> 4GB in 32kb files
> # time (mkdir test; for i in $(seq 1 1 131072); do dd if=/dev/zero
> of=test/$i bs=32k count=1 oflag=direct,sync 2>/dev/null; done)
> 
> ...
> 
> 55 min
> 

Both seem pretty slow in general. Any way you can establish a baseline
for these tests on this storage? If not, the only other suggestion I
could make is to allocate inodes until all of those freecount numbers
are accounted for and see if anything changes. That could certainly take
some time and it's not clear it will actually help.

> >Brian
> >
> >P.S., Alternatively if you wanted to grab a metadump of this filesystem
> >and compress/upload it somewhere, I'd be interested to take a look at
> >it.
> 
> I think there might be file and directory names in it. If this is the case i
> can't do it.
> 

It should enable obfuscation by default, but I would suggest to restore
it yourself and verify it meets your expectations.

Brian

> Stefan
> 
> 
> >
> >>Thanks!
> >>
> >>Stefan
> >>
> >>
> >>
> >>>Brian
> >>>
> >>>>>... as well as what your typical workflow/dataset is for this fs. It
> >>>>>seems like you have relatively small files (15TB used across 350m files
> >>>>>is around 46k per file), yes?
> >>>>
> >>>>Yes - most fo them are even smaller. And some files are > 5GB.
> >>>>
> >>>>>If so, I wonder if something like the
> >>>>>following commit introduced in 3.12 would help:
> >>>>>
> >>>>>133eeb17 xfs: don't use speculative prealloc for small files
> >>>>
> >>>>Looks interesting.
> >>>>
> >>>>Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
