Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17HUOoI247219 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 11:30:24 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id A4Woipac9xDCrk0x for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 09:30:22 -0800 (PST)
Date: Tue, 7 Feb 2012 17:30:20 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120207173020.GA7381@nsrc.org>
References: <20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org> <20120203115434.GA649@nsrc.org>
	<4F2C38BE.2010002@hardwarefreak.com> <20120203221015.GA2675@nsrc.org>
	<4F2D016C.9020406@hardwarefreak.com> <20120204112436.GA3167@nsrc.org>
	<4F2D2953.2020906@hardwarefreak.com> <20120204200417.GA3362@nsrc.org>
	<4F2D98A9.4090709@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2D98A9.4090709@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 04, 2012 at 03:44:25PM -0500, Joe Landman wrote:
> >Sure it can. A gluster volume consists of "bricks". Each brick is served by
> >a glusterd process listening on a different TCP port. Those bricks can be on
> >the same server or on different servers.
> 
> I seem to remember that the Gluster folks abandoned this model
> (using their code versus MD raid) on single servers due to
> performance issues.  We did play with this a few times, and the
> performance wasn't that good.  Basically limited by single disk
> seek/write speed.

It does appear to scale up, although not as linearly as I'd like.

Here are some performance stats [1][2].
#p = number of concurrent client processes; files read first in sequence
and then randomly.

With a 12-brick distributed replicated volume (6 bricks each on 2 servers),
the servers connected by 10GE and the gluster volume mounted locally on one
of the servers:

 #p  files/sec  dd_args
  1      95.77  bs=1024k 
  1      24.42  bs=1024k [random]
  2     126.03  bs=1024k 
  2      43.53  bs=1024k [random]
  5     284.35  bs=1024k 
  5      82.23  bs=1024k [random]
 10     280.75  bs=1024k 
 10     146.47  bs=1024k [random]
 20     316.31  bs=1024k 
 20     209.67  bs=1024k [random]
 30     381.11  bs=1024k 
 30     241.55  bs=1024k [random]

With a 12-drive md raid10 "far" array, exported as a single brick and
accessed using glusterfs over 10GE:

 #p  files/sec  dd_args
  1     114.60  bs=1024k 
  1      38.58  bs=1024k [random]
  2     169.88  bs=1024k 
  2      70.68  bs=1024k [random]
  5     181.94  bs=1024k 
  5     141.74  bs=1024k [random]
 10     250.96  bs=1024k 
 10     209.76  bs=1024k [random]
 20     315.51  bs=1024k 
 20     277.99  bs=1024k [random]
 30     343.84  bs=1024k 
 30     316.24  bs=1024k [random]

This is a rather unfair comparison because the RAID10 "far" configuration
allows it to find all data on the first half of each drive, reducing the
seek times and giving faster read throughput.  Unsurprisingly, it wins on
all the random reads.

For sequential reads with 5+ concurrent clients, the gluster distribution
wins (because of the locality of files to their directory)

In the limiting case, because the filesystems are independent you can read
off them separately and concurrently:

# for i in /brick{1..6}; do find $i | time cpio -o >/dev/null & done

This completed in 127 seconds for the entire corpus of 100,352 files (65GB
of data), i.e.  790 files/sec or 513MB/sec.  If your main use case was to be
able to copy or process all the files at once, this would win hands-down.

In fact, since the data is duplicated, we can read half the directories
from each disk in the pair.

root@storage1:~# for i in /brick{1..6}; do find $i | egrep '/[0-9]{4}[02468]/' | time cpio -o >/dev/null & done
root@storage2:~# for i in /brick{1..6}; do find $i | egrep '/[0-9]{4}[13579]/' | time cpio -o >/dev/null & done

This read the whole corpus in 69 seconds: i.e. 1454 files/sec or 945MB/s. 
Clearly you have to jump through some hoops to get this, but actually
reading through all the files (in any order) is an important use case for
us.

Maybe the RAID10 array could score better if I used a really big stripe size
- I'm using 1MB at the moment.

Regards,

Brian.

[1] Test script shown at
http://gluster.org/pipermail/gluster-users/2012-February/009585.html

[2] Tuned by:
gluster volume set <volname> performance.io-thread-count 32
and with the patch at
http://gluster.org/pipermail/gluster-users/2012-February/009590.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
