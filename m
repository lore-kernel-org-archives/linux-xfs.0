Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:65337 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729109AbfCYAKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Mar 2019 20:10:49 -0400
Date: Mon, 25 Mar 2019 11:10:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Message-ID: <20190325001044.GA23020@dastard>
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Sun, Mar 24, 2019 at 08:18:10PM +0200, Amir Goldstein wrote:
> Hi All,
> 
> Christoph's re-factoring to xfs_ilock() brought up this question,
> but AFAICS, current behavior seems to have always been that
> way for xfs (?).
> 
> Since commit 6552321831dc ("xfs: remove i_iolock and use
> i_rwsem in the VFS inode instead"), xfs_file_buffered_aio_read()
> is the only call sites I know of to call generic_file_read_iter() with
> i_rwsem read side held.

That did not change the locking behaviour of XFS at all.

> This lock is killing performance of multi-threaded buffered
> read/write mixed workload on the same file [1].
> Attached output of bcc tools [2] script xfsdist and ext4dist
> for latency distribution on the same mixed read/write workload.

In future, can you just paste the text in line, rather than attach
it as base64 encoded attechments? They are kinda hard to quote.

ext4 read :

....
    4 -> 7          : 2610
....
 2048 -> 4095       : 232
 4096 -> 8191       : 632
 8192 -> 16383      : 925
16384 -> 32767      : 408
....

ext4 write:

    4 -> 7          : 16732
    8 -> 15         : 81712
   16 -> 31         : 121450
   32 -> 63         : 29638

So about 4500 read IOPS, of which >50% are cache hits.
And ~250,000 write iops, all in less than 64 microseconds so
straight into cache. So we are looking at a ~50:1 write to read
ratio here.

XFS read:

         0 -> 1          : 8
         2 -> 3          : 21
         4 -> 7          : 17
 ....
      8192 -> 16383      : 4
     16384 -> 32767      : 8
     32768 -> 65535      : 17
     65536 -> 131071     : 55
    131072 -> 262143     : 41
    262144 -> 524287     : 104
    524288 -> 1048575    : 101
   1048576 -> 2097151    : 34
 ....

XFS Write:
         4 -> 7          : 10087
         8 -> 15         : 34815
        16 -> 31         : 32446
        32 -> 63         : 3888
        64 -> 127        : 155
 ....
 	<snip long tail>

Which shows ~400 read ops (almost no cache hits) and ~80,000 write
ops with a long latency tail. It's a roughly a 200:1 write to read
ratio.

I'm guessing what we are seeing here is a rwsem starvation problem.
The only reason a read would get delayed for mor ethan a few hundred
microseconds is ifthere are a continual stream of write holders
starving pending reads.

I don't recall it being this bad historically but rwsems have been
severely performance optimised for various corner cases over the
past few years and it is extremely likely that behaviour has
changed.  Definitely needs looking at, but rwsems are so fragile
these days (highly dependent on memory ordering that nobody seems to
be able to get right) and impossible to validate as correct that we
might just end up having to live with it.

FWIW, What kernel did you test this on?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> Compared to ext4, avg. read latency on RAID of spindles
> can be two orders of magnitude higher (>100ms).
> I can provide more performance numbers if needed with fio,
> but they won't surprise anyone considering the extra lock.
> 
> This workload simulates a performance issue we are seeing
> on deployed systems. There are other ways for us to work
> around the issue, not using xfs on those systems would be
> one way, but I wanted to figure out the reason for this
> behavior first.

The workload is 8 threads doing random 8k random reads and
8 threads doing random writes to a single 5GB file?

I'd be interested in seeing if a fio workload using 16 randrw
threads demonstrate the same latency profile (i.e. threads aren't
exclusively read- or write- only), or is profile coming about
specifically because you have dedicated write-only threads that will
continually bash on the IO locks and hence starve readers?

> My question is, is the purpose of this lock syncing
> dio/buffered io?

That's one part of it. The other is POSIX atomic write semantics.

https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html

"I/O is intended to be atomic to ordinary files and pipes and FIFOs.
Atomic means that all the bytes from a single operation that started
out together end up together, without interleaving from other I/O
operations."

i.e. that independent read()s should see a write() as a single
atomic change. hence if you do a read() concurrently with a write(),
the read should either run to completion before the write, or the
write run to completion before the read().

XFS is the only linux filesystem that provides this behaviour.

ext4 and other filesytsems tha thave no buffered read side locking
provide serialisation at page level, which means an 8kB read racing
with a 8kB write can return 4k from the new write and 4k from the
yet-to-be-written part of the file. IOWs, the buffered read gets
torn.

> If so, was making this behavior optional via mount option
> ever considered for xfs?
> Am I the first one who is asking about this specific workload
> on xfs (Couldn't found anything on Google), or is this a known
> issue/trade off/design choice of xfs?

It's an original design feature of XFS. See this 1996 usenix paper
on XFS, section 6.2 - Performing File I/O , "Using Multiple
Processes":

"Currently, when using direct I/O and multiple writers, we
place the burden of serializing writes to the same
region of the file on the application. This differs from
traditional Unix file I/O where file writes are atomic
with respect to other file accesses, and it is one of the
main reasons why we do not yet support multiple
writers using traditional Unix file I/O."

i.e. XFS was designed with the intent that buffered writes are
atomic w.r.t. to all other file accesses. That's not to say we can't
change it, just that it has always been different to what linux
native filesystems do. And depending on which set of application
developers you talk to, you'll get different answers as to whether
they want write()s to be atomic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
