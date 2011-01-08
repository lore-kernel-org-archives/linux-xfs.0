Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p083vMoT168101 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 21:57:23 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0CC223FB4E
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 19:59:32 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	ydhxEAow5QjFEsRj for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 19:59:32 -0800 (PST)
Received: by gxk10 with SMTP id 10so9237724gxk.26
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 19:59:32 -0800 (PST)
Message-ID: <4D27E11F.4030607@philkarn.net>
Date: Fri, 07 Jan 2011 19:59:27 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: realtime partition support?
References: <4D2724E0.9020801@philkarn.net> <20110108021728.GA28803@dastard>
In-Reply-To: <20110108021728.GA28803@dastard>
Reply-To: karn@ka9q.net
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
To: Dave Chinner <david@fromorbit.com>
Cc: karn@ka9q.net, xfs@oss.sgi.com

On 1/7/11 6:17 PM, Dave Chinner wrote:

> Experimental, implemented in linux and mostly just works, but is
> largely untested and not really recommended for any sort of
> production use.

Thanks.

>> Throughput on large files would be almost as fast as if everything were
>> on the SSD.
> 
> Not at all. The data is still written to the rotating disk, so
> the presence of the SSD won't change throughput rates at all.

My point is that the big win of the SSD comes from its lack of
rotational and seek latency. They really shine on random small reads. On
large sequential reads and writes, modern rotating disks can shovel data
almost as quickly as an SSD once the head is in the right place and the
data has started flowing. But it can't get there until it has walked the
directory tree, read the inode for the file in question and finally
seeked to the file's first extent. If all that meta information resided
on SSD, the conventional drive could get to that first extent that much
more quickly.

Yeah, the SSD is typically still faster than a rotating drive on
sequential reads -- but only by a factor of 2:1, not dozens or hundreds
of times. On sequential writes, many rotating drives are actually faster
than many SSDs.

> I'd also expect it to be be much, much slower than just using the
> rotating disk for the standard data device - the SSD will make no
> difference as metadata IO is not the limiting factor.

No? I'm having a very hard time getting XFS on rotating SATA drives to
come close to Reiser or ext4 when extracting a large tarball (e.g., the
Linux source tree) or when doing rm -rf. I've improved it by playing
with logbsize and logbufs but Reiser is still much faster, especially at
rm -rf. The only way I've managed to get XFS close is by essentially
disabling journaling altogether, which I don't want to do. I've tried
building XFS with an external journal and giving it a loopback device
connected to a file in /tmp. Then it's plenty fast. But unsafe.

As I understand it, the problem is all that seeking to the internal
journal. I'd like to try putting the journal on a SSD partition but I
can't figure out how to do that with an existing XFS file system without
rebuilding it.

Turning off the write barrier also speeds things up considerably, but
that also makes me nervous. My system doesn't have a RAID controller
with a nonvolatile cache but it is plugged into a UPS (actually a large
solar power system with a battery bank) so unexpected loss of power is
unlikely. Can I safely turn off the barrier?

If I correctly understand how drive write caching works, then even a
kernel panic shouldn't keep data that's already been sent to the drive
from being written out to the media. Only a power failure could do that,
or possibly the host resetting the drive. After a kernel panic the BIOS
will eventually reset all the hardware, but that won't happen for some
time after a kernel panic.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
