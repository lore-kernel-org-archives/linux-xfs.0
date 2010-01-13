Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DAnRsb145995 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 04:49:27 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 061EA12484ED
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 02:50:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Pq8ClJXPWJDczpKg for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 02:50:21 -0800 (PST)
Date: Wed, 13 Jan 2010 21:50:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: allocsize mount option
Message-ID: <20100113105018.GP17483@discord.disaster>
References: <348821.11898.qm@web76206.mail.sg1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <348821.11898.qm@web76206.mail.sg1.yahoo.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jan 13, 2010 at 05:42:16PM +0800, Gim Leong Chin wrote:
> Hi,
> =

> =

> The application is ANSYS, which writes 128 GB files.=A0 The existing
> computer with SUSE Linux Enterprise Desktop 11 which is used for
> running ANSYS, has two software RAID 0 devices made up of five 1
> TB drives.=A0 The /home partition is 4.5 T, and it is now 4 TB
> full.=A0 I see a fragmentation > 19%.

XFS will start to fragment when the filesystem gets beyond 85%
full - it seems that you are very close to that threshold.

That being said, if you've pulled the figure of 19% from the xfs_db
measure of fragmentation, that doesn't mean the filesystem is badly
fragmented, it just means that that there are 19% more fragments
than the ideal. In 4TB of data with 1GB sized files, that would mean
there are 4800 extents (average length ~800MB, which is excellent)
instead of the perfect 4000 extents (@1GB each). Hence you can see
how misleading this "19% fragmentation" number can be on an extent
based filesystem...

> I have just set up a new computer with 16 WD Cavair Black 1 TB
> drives connected to an Areca 1680ix-16 RAID with 4 GB cache.=A0 14
> of these drives are in RAID 6 with 128 kB stripes.  The OS is also
> SLED 11.  The system has 16 GB memory, and AMD Phenom II X4 965
> CPU.
> =

> I have done tests writing 100 30 MB files and 1 GB, 10 GB and 20
> GB files, with single instance and multiple instances.
> =

> There is a big difference in writing speed when=A0writing 20 GB
> files when using allocsize=3D1g and not using the option.  That is
> without the inode64 option, which gives further speed gains.

> I use dd for writing the 1 GB, 10 GB and 20 GB files.
> =

> mkfs.xfs -f -b size=3D4k -d agcount=3D32,su=3D128k,sw=3D12 -i size=3D256,=
align=3D1,attr=3D2 -l version=3D2,su=3D128k,lazy-count=3D1 -n version=3D2 -=
s size=3D512 -L /data /dev/sdb1
> =

> =

> defaults,nobarrier,usrquota,grpquota,noatime,nodiratime,allocsize=3D1g,lo=
gbufs=3D8,logbsize=3D256k,largeio,swalloc
> =

> The start of the partition has been set to LBA 3072 using GPT Fdisk to al=
ign the stripes.

This all looks good - it certainly seems that you have done your
research. ;) The only thing I'd do differently is that if you have
only one partition on the drives, I wouldn't even put a partition on it.

> The dd command is:
> =

> chingl@tsunami:/data/test/t2> dd if=3D/dev/zero of=3Dbigfile20GB bs=3D107=
3741824 count=3D20

I'd significantly reduce the size of that buffer - too large a
buffer can slow down IO due to the memory it consumes and TLB misses
it causes. I'd typically use something like:

$ dd if=3D/dev/zero of=3Dbigfile bs=3D1024k count=3D20k

Which does 20,000 writes of 1MB each and ensures the dd process
doesn't consume over a GB of RAM.

> Single instance of 20 GB dd repeats were 214, 221, 123 MB/s with
> allocsize=3D1g, compared to 94, 126 MB/s without.

This seems rather low for a buffered write on hardware that can
clearly go faster. SLED11 is based on 2.6.27, right? I suspect that
many of the buffered writeback issues that have been fixed since
2.6.30 are present in the SLED11 kernel, and if that is the case I
can see why the allocsize mount option makes such a big
difference.

It might be worth checking how well direct IO writes run to take
buffered writeback issues out ofthe equation. In that case, I'd use
stripe width multiple sized buffers like:

$ dd if=3D/dev/zero of=3Dbigfile bs=3D3072k count=3D7k oflag=3Ddirect

I'd suggest that you might need to look at increasing the maximum IO
size for the block device (/sys/block/sdb/queue/max_sectors_kb),
maybe the request queue depth as well to get larger IOs to be pushed
to the raid controller. if you can, at least get it to the stripe
width of 1536k....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
