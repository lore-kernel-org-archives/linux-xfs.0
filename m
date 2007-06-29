Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 17:17:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T0GutL030526
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 17:16:58 -0700
Date: Fri, 29 Jun 2007 10:16:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
Message-ID: <20070629001648.GD31489@sgi.com>
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Illes <S.Illes@westminster.ac.uk>
Cc: xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
> Hi,
> 
> I am using XFS on my laptop, I have realized that nobarrier mount options  
> sometimes slows down deleting large number of small files, like the kernel  
> source tree. I made four tests, deleting the kernel source right after  
> unpack and after reboot, with both barrier and nobarrier options:
> 
> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2

FWIW, I bet these mount options have something to do with the
issue.

Here's the disk I'm testing against - 36GB 10krpm u160 SCSI:

<5>[   25.427907] sd 0:0:2:0: [sdb] 71687372 512-byte hardware sectors (36704 MB)
<5>[   25.440393] sd 0:0:2:0: [sdb] Write Protect is off
<7>[   25.441276] sd 0:0:2:0: [sdb] Mode Sense: ab 00 10 08
<5>[   25.442662] sd 0:0:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
<6>[   25.446992]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9

Note - read cache is enabled, write cache is disabled, so barriers
cause a FUA only.  i.e. the only bubble in the I/O pipeline that
barriers cause are in teh elevator and the scsi command queue.

The disk is capable of about 30MB/s on the inner edge.

Mount options are default (so logbsize=32k,logbufs=8), mkfs
options are default, 4GB partition on inner (slow) edge of disk.
Kernel is 2.6.22-rc4 with all debug and tracing options turned on
on ia64.

For this config, I see:

		barrier		nobarrier
hot cache	22s		14s
cold cache 	21s		20s

In this case, barriers have little impact on cold cache behaviour,
and the difference on the hot cache behaviour will probably be
because of FUA being used on barrier writes (i.e. no combining
of sequential log I/Os in the elevator).

The difference in I/O behaviour b/t hot cache and cold cache during
the rm -rf  is that there are zero read I/Os on a hot cache and
50-100 read I/Os per second on a cold cache which is easily
within the capability of this drive.

After turning on the write cache with:

# sdparm -s WCE -S /dev/sdb
# reboot

[   25.717942] sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA

I get:
					barrier		nobarrier
logbsize=32k,logbufs=8: hot cache	24s		11s
logbsize=32k,logbufs=8: cold cache 	33s		16s
logbsize=256k,logbufs=8: hot cache	10s		10s
logbsize=256k,logbufs=8: cold cache 	16s		16s
logbsize=256k,logbufs=2: hot cache	11s		9s
logbsize=256k,logbufs=2: cold cache 	17s		13s

Out of the box, barriers are 50% slower with WCE=1 than with WCE=0
on the cold cache test, but are almost as fast with larger
log buffer size (i.e. less barrier writes being issued).

Worth noting is that at 10-11s runtime, the disk is bandwidth
bound (i.e. we're doing 30MB/s), so that's the fastest time
rm -rf will do on this filesystem.

So, clearly we have differing performance depending on
mount options and at best barriers give equal performance.

I just ran the same tests on an x86_64 box with 7.2krpm 500GB SATA
disks with WCE (2.6.18 kernel) using a 30GB partition on the outer
edge:

					barrier		nobarrier
logbsize=32k,logbufs=8: hot cache	29s		29s
logbsize=32k,logbufs=8: cold cache 	33s		30s
logbsize=256k,logbufs=8: hot cache	8s		8s
logbsize=256k,logbufs=8: cold cache 	11s		11s
logbsize=256k,logbufs=2: hot cache	8s		8s
logbsize=256k,logbufs=2: cold cache 	11s		11s

Barriers make little to zero difference here.

> Can anyone explain this?

Right now I'm unable to reproduce your results even on 2.6.18 so I
suspect a drive level issue here.

Can I suggest that you try the same tests with write caching turned
off on the drive(s)? (hdparm -W 0 <dev>, IIRC).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
