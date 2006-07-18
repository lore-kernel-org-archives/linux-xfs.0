Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 14:33:54 -0700 (PDT)
Received: from smtp107.sbc.mail.mud.yahoo.com (smtp107.sbc.mail.mud.yahoo.com [68.142.198.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6ILXaDW006481
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 14:33:39 -0700
Date: Tue, 18 Jul 2006 14:33:04 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: file system defragmentation
Message-ID: <20060718213304.GA27287@tuatara.stupidest.org>
References: <4f52331f050826001612f8e323@mail.gmail.com> <20050826101131.GA24544@ii.uib.no> <4f52331f0508260848782f240a@mail.gmail.com> <43128F82.4010004@tlinx.org> <4312913F.6040205@coremetrics.com> <43311567.3060208@tlinx.org> <5356806.post@talk.nabble.com> <20060717141917.GY2114946@melbourne.sgi.com> <5374022.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374022.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Cosmo Nova <cs_mcc98@hotmail.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Jul 18, 2006 at 12:59:39AM -0700, Cosmo Nova wrote:

> Hi, can I summarize by saying that, XFS still partition the volume
> into different allocation groups, but there is NO locking.

the allocator has per-AG locks

> Two files may write in the same allocation group and introduce
> fragments?

i'm not sure what you mean, but any number of files can be writing to
a single AG at once, the degree of fragmentation you will see depends
on the IO patterns and where there are writing

in the case of writing multiple large files in parallel in the same
directory the blocks do tend to interleave

> What is the maximum and typical number of allocation groups please?
> I can't find the numbers in the source code...

It's a 32-bit value, I'm not sure how practical very large values are
though.

> And for the buffer, Is preallocation the same as delayed allocation?

No, preallocation allocates space a head of time on disk so that later
when it's written the allocation process is simpler (or not needed)
and ideally also to reduce fragmentation by doing as much allocation
as possible at once.

Delayed allocation is simply the idea of doing the allocation as late
as possible so when you do have to flush the data to disk you can try
to make better decisions about where to place the blocks.

> If a file space allocation is delayed, what is the upper bound of
> the delayed size?

It depends on the platform and how often data is flushed from the OS.
