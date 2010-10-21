Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LGcioM030455 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 11:38:46 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 530C91E80E82
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 09:39:57 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 55AujbmZE48TAEL3
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 09:39:57 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8yBD-0008GY-9W
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 17:39:51 +0100
MIME-Version: 1.0
Message-ID: <19648.27859.799400.168394@tree.ty.sabi.co.uk>
Date: Thu, 21 Oct 2010 17:39:47 +0100
Subject: Re: avoid mbox file fragmentation
In-Reply-To: <20101021020009.GG12506@dastard>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
	<20101021020009.GG12506@dastard>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>


>> However, I am a fan of having *default* physical
>> preallocation, because as a rule one can trade off space for
>> speed nowadays, and padding files with "future growth" tails
>> is fairly cheap, and one could modify the filesystem code or
>> 'fsck' to reclaim unused space in "future grown" tails.

> When writing lots of small files (e.g. unpacking a kernel
> tarball),

But the ig deal here is that's not something that a filesystem
targeted at high bandwidth multistreaming loads should be
optimized for, at least by default.

  While a number of people writing to this mailing list try to
  use XFS as a small records DBMS, we read their silly posts
  here precisely because it's a stupid idea and thus it works
  badly for them, and so they complain. All the guys who use XFS
  mostly for the workloads it is good for don't complain, so we
  don't read about them here that much.

There is simply no way to optimize for both workloads, because
they require completely different strategies.

  BTW, '.a' files exist precisely because "many small files" was
  considered a bad idea for '.o' files; I wish that the original
  UNIX guys had used '.a' files much more widely, at the very
  least for '.h' files and 'man' pages and configuration files.
  One of the several details that the BTL guys missed (apart
  from 'creat' I mean :->).

> leaving space at the file tail due to preallocation (that will
> never get used)

It will get used, e.g. by 'fsck' or the filesystem itself (let's
call it 'grey' space, and say that it will be reclaimed either
periodically or after all free space has been exahusted).

The overall issue here when you use the future tense "will
never" is that you can only have by default _adaptive_
strategies, and you need _predictive_ ones to handle well
completely different workloads.

That is predictive at the kernel level (and then good luck
making good guesses, even if in some useful simple cases it is
possible) or at the app level (and then userspace sucks, but at
least it's their fault).

> means that the file data is now sparse on disk instead of
> packed into adjacent blocks.

But even in your case of lots of small files without "tails",
that doesn't work either, because you get lots of little files
that are not quite guaranteed to be contiguous ot each other,
and anyhow if the tails are not large, then even with tails the
files can be "nearly" (most on the same track) contiguous.

> The result? Instead of the elevate merging adjacent file data
> IOs into a large IO, they all get issued individually,

Modern IO subsystems do scatter/gather and mailboxing quite
well, even SATA/SAS nowadays almost does the matter.

> and the seek count for IO goes way up.

Not necessarily -- because many/most files end up together on
the same track/cylinder they would have ended up without tails.

Anyhow for the "many small records DBMS" case, 

> Not truncating away the specualtive prealocation beyond EOF
> will cause this,

It will cause some space diffusion, but again you cannot do both
multistreaming high bandwidth and singlestreaming lots of small
files well, and a filesystem should not do the latter anyhow.

And even so, if for example the userspace hints to the file
system that sa file is very unlikely to be modified or appended
to (which is the default for most apps, and could be inferred
for example by no 'w' permissions or other details), the
filesystem need not put tails on it. Even heuristics based on
how many writes (and their interval) and/or seeks have occurred
can be used to asses the need for tails.

But again for the types of workloads XFS targets, one can do the
brute force approach defaulting to tails, and it does not cost
anywhere like this:

> too, and that slows down such workloads by an order of
> magnitude....

That sounds way too much. First consider that if a file is less
than 2KiB in size it will have an "internal" tail (in a 4KiB)
block much longer than itself already, and that's already a very
bad idea for small files, as it makes for many more IOPs and IO
bus bandwidth than needed, never mind the cache and RAM space.

  And if you are targeting things like that workload, the
  greatest improvement is just reducing the block size.
  If you do please scale accordingly the following numbers.

Then suppose that each nearly 4KiB file will have a 4KiB tail;
this simply reduce the density of space by a factor of around 2x
(makes a bad situation only 2x worse :->).

In other words leaving (for a while) "tails" on small files
behave somewhat similarly (but much better than) doubling block
size to 8KiB, which is not a catastrophe (the catastrophe has
already happened when default block sizes became 4KiB).

Unless you really want to argue that switching from 4KiB to 8KiB
blocks is really going to cost 10x in performance.

What I mean tails don't *have* to be done stupidly; sure there
are a number of really dumb things in Linux IO (from swap space
prefetching to "plugging"), but a few things seem to have been
designed with some forethought, so one does not need to assume
that they would be necessarily implemented that badly (and no, I
don't have time, as usual, so I stay on my "armchair").

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
