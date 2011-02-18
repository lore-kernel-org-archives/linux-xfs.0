Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IKSRNg236137 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 14:28:27 -0600
Received: from homer.spinpro.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65CC62E9F17
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:31:07 -0800 (PST)
Received: from homer.spinpro.com (mail.spinpro.com [206.223.182.178]) by
	cuda.sgi.com with ESMTP id DUtD2ZqPcwY92WKP for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 12:31:07 -0800 (PST)
Message-ID: <4D5ED70B.7030504@spinpro.com>
Date: Fri, 18 Feb 2011 15:31:07 -0500
From: Andrew Klaassen <ak@spinpro.com>
MIME-Version: 1.0
Subject: Re: External log size limitations
References: <4D5C1D77.1060000@spinpro.com> <20110217003233.GH13052@dastard>
	<4D5E8FAD.9080802@spinpro.com> <4D5ECEC5.2020701@hardwarefreak.com>
In-Reply-To: <4D5ECEC5.2020701@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Stan Hoeppner wrote:
> I'm not familiar with Exanet, only that it was an Israeli company that
> went belly up in late '09 early '10.  Was the hardware provided by them?
> Is it totally proprietary, or are you able to wipe the OS and install a
> fresh copy of your preferred Linux distro and a recent kernel?

It's IBM and LSI gear, so I'm crossing my fingers that a Linux install 
will be relatively painless.

> I'm not sure which block size you're referring to here.  Are you
> referring to the kernel page size or the filesystem block size?  AFAIK,
> the default Linux kernel page size is still 8 KiB although there has
> been talk for some time WRT changing it to 4 KiB, but IIRC some are
> hesitant due to stack overruns with the 4 KiB page size.  Regardless,
> the kernel page size isn't a factor WRT to throughput to disk.
> If you're referring to the latter, XFS has a block size configurable per
> filesystem from 512 bytes to 64 KiB, with 4 KiB being the default.  Make
> your XFS filesystems with "-b size=65536" and you should be good to go.

I thought that the filesystem block size was still limited to the kernel 
page size, which is 4K on x86 systems.

http://oss.sgi.com/projects/xfs/

"The maximum filesystem block size is the page size of the kernel, which 
is 4K on x86 architecture."

Is this no longer true?  It would be awesome news if it wasn't.

My quick calculations were based on worst-case random read, which is 
what we were seeing with the Exastore.  They had a 64K blocksize * 48 
disks * 70 seeks per second = 215 MB/s, which is exactly what we were 
seeing under load.  Under heavy random load, I'm worried that XFS has to 
either thrash the disks with 4K reads and writes ~or~ introduce 
unnecessary latency by doing read-combining and write-combining and/or 
predictive elevator hanky-panky.

> Are those 56 drives configured as a single large RAID stripe?  RAID 10
> or RAID 6?  Or are they split up into multiple smaller arrays?  Hardware
> or software RAID?  I ask as it will allow us to give you the exact
> mkfs.xfs command line you need to make your XFS filesystem(s) for
> optimum performance.

I miscounted; it's 48 drives split into 6 hardware RAID-5 arrays.

> They're actually kind of independent of one another.  For instance, 'rm
> -rf' on a 50k file directory structure won't touch a single file, only
> metadata.  So you have zero files being written but 50k log write
> transactions (which delaylog will coalesce into fewer larger actual disk
> writes).  Typically, the data being written into the log is only a
> fraction of the size of the files themselves, especially in your case
> where most files are > 1MB in size, so the log bandwidth required for
> "normal" file write operations is pretty low.  If you're nervous about
> it, simply install a small (40 GB) fast SSD in the server and put one
> external journal log on it for each filesystem.  That'll give you about
> 40-50k random 4k IOPS throughput for the journal logs.  Combined with
> delaylog I think this would thoroughly eliminate any metadata
> performance issues.

Is there a way to monitor log operations to find out how much is being 
used at a given time?

> The key to metadata performance isn't as much the size of log device but
> the throughput.  If you have huge write cache on your hardware RAID
> controllers and are using internal logs, or if you use a local SSD for
> external logs, I would think you don't need the logs to be really huge,
> as you're able to push the tail very fast, especially in the case of a
> locally attached (SATA) SSD.  Write cache on a big SAN array may be very
> fast, but you typically have a an FC switch hop or two to traverse,
> increasing latency.  Latency with a locally attached SSD is about as low
> as you can get, barring use of a ramdisk, which no sane person would
> ever use for a filesystem journal.

All the metadata eventually has to be written to the main array, so 
doesn't that ultimately become the limiting factor on metadata 
throughput under sustained load?

> You're asking for a guarantee that no one can give you, or would dare
> to.  And this would have little to do with confidence in XFS, but the
> sheer complexity of the Linux kernel, and not knowing exactly what
> hardware you have.  There could be a device driver bug in a newer kernel
> that might panic your system.  There's no way for us to know that kind
> of thing, so, no guarantees. :(

Fair enough.  Since I get yelled at if the server goes down, I'm drawn 
to proven-track-record kernels as much as possible.  (Well, okay... not 
quite back to 2.4-proven-track-record kernels...)

> WRT XFS, there were a number of patches up to 2.6.35.11 which address
> the problems you mention above, but none in 2.6.36.4 or 2.6.37.1, all of
> which are the currently available kernels at kernel.org.  So, given that
> the patches have slowed down dramatically recently and the bugs have
> been squashed, WRT XFS, I think you should feel confident installing
> 2.6.37.1.
> 
> And, as always, install it on a test rig first and pound the daylights
> out of it first with a test based on your actual real workload.

Ayup...

Andrew



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
