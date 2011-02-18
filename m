Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IJrAh6234541 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 13:53:10 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4111812A6B0B
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:55:50 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DpBxnGcVrwdSgHai
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:55:50 -0800 (PST)
Message-ID: <4D5ECEC5.2020701@hardwarefreak.com>
Date: Fri, 18 Feb 2011 13:55:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: External log size limitations
References: <4D5C1D77.1060000@spinpro.com> <20110217003233.GH13052@dastard>
	<4D5E8FAD.9080802@spinpro.com>
In-Reply-To: <4D5E8FAD.9080802@spinpro.com>
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
To: Andrew Klaassen <ak@spinpro.com>
Cc: xfs@oss.sgi.com

Andrew Klaassen put forth on 2/18/2011 9:26 AM:

> A couple of hundred nodes on a renderfarm doing mostly compositing with
> some 3D.  It's about 80/20 read/write.  On the current system that we're
> thinking of converting - an Exastore version 3 system - browsing the
> filesystem becomes ridiculously slow when write loads become moderate,
> which is why snappier metadata operations are attractive to us.

I'm not familiar with Exanet, only that it was an Israeli company that
went belly up in late '09 early '10.  Was the hardware provided by them?
 Is it totally proprietary, or are you able to wipe the OS and install a
fresh copy of your preferred Linux distro and a recent kernel?

> One thing I'm worried about, though, is moving from the Exastore's 64K
> block size to the 4K Linux blocksize limitation.  My quick calculation
> says that that's going to reduce our throughput under random load (which
> is what a renderfarm becomes with a couple of hundred nodes) from about
> 200MB/s to about 13MB/s with our 56x7200rpm disks.  It's too bad those
> large blocksize patches from a couple of years back didn't go through to
> make this worry moot.

I'm not sure which block size you're referring to here.  Are you
referring to the kernel page size or the filesystem block size?  AFAIK,
the default Linux kernel page size is still 8 KiB although there has
been talk for some time WRT changing it to 4 KiB, but IIRC some are
hesitant due to stack overruns with the 4 KiB page size.  Regardless,
the kernel page size isn't a factor WRT to throughput to disk.

If you're referring to the latter, XFS has a block size configurable per
filesystem from 512 bytes to 64 KiB, with 4 KiB being the default.  Make
your XFS filesystems with "-b size=65536" and you should be good to go.

Are those 56 drives configured as a single large RAID stripe?  RAID 10
or RAID 6?  Or are they split up into multiple smaller arrays?  Hardware
or software RAID?  I ask as it will allow us to give you the exact
mkfs.xfs command line you need to make your XFS filesystem(s) for
optimum performance.

> Is there a rule-of-thumb to convert number of files being written to log
> write rates?  We push a lot of data through, but most of the files are a
> few megabytes in size instead of a few kilobytes.

They're actually kind of independent of one another.  For instance, 'rm
-rf' on a 50k file directory structure won't touch a single file, only
metadata.  So you have zero files being written but 50k log write
transactions (which delaylog will coalesce into fewer larger actual disk
writes).  Typically, the data being written into the log is only a
fraction of the size of the files themselves, especially in your case
where most files are > 1MB in size, so the log bandwidth required for
"normal" file write operations is pretty low.  If you're nervous about
it, simply install a small (40 GB) fast SSD in the server and put one
external journal log on it for each filesystem.  That'll give you about
40-50k random 4k IOPS throughput for the journal logs.  Combined with
delaylog I think this would thoroughly eliminate any metadata
performance issues.

> I assume that if we packed the server with 128GB of RAM we wouldn't have
> to worry about that as much.  But... short of that, would you have a
> rule of thumb for log size to memory size?  Could I expect reasonable
> performance with a 2GB log and 32GB in the server?  With 12GB in the
> server?

The key to metadata performance isn't as much the size of log device but
the throughput.  If you have huge write cache on your hardware RAID
controllers and are using internal logs, or if you use a local SSD for
external logs, I would think you don't need the logs to be really huge,
as you're able to push the tail very fast, especially in the case of a
locally attached (SATA) SSD.  Write cache on a big SAN array may be very
fast, but you typically have a an FC switch hop or two to traverse,
increasing latency.  Latency with a locally attached SSD is about as low
as you can get, barring use of a ramdisk, which no sane person would
ever use for a filesystem journal.

> I'm excited about the delaylog and other improvements I'm seeing
> entering the kernel, but I'm worried about stability.  There seem to
> have been a lot of bugfix patches and panic reports since 2.6.35 for XFS
> to go along with the performance improvements, which makes me tempted to
> stick to 2.6.34 until the dust settles and the kinks are worked out.  If
> I put the new XFS code on the server, will it stay up for a year or more
> without any panics or crashes?

You're asking for a guarantee that no one can give you, or would dare
to.  And this would have little to do with confidence in XFS, but the
sheer complexity of the Linux kernel, and not knowing exactly what
hardware you have.  There could be a device driver bug in a newer kernel
that might panic your system.  There's no way for us to know that kind
of thing, so, no guarantees. :(

WRT XFS, there were a number of patches up to 2.6.35.11 which address
the problems you mention above, but none in 2.6.36.4 or 2.6.37.1, all of
which are the currently available kernels at kernel.org.  So, given that
the patches have slowed down dramatically recently and the bugs have
been squashed, WRT XFS, I think you should feel confident installing
2.6.37.1.

And, as always, install it on a test rig first and pound the daylights
out of it first with a test based on your actual real workload.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
