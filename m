Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96CxcKH018986 for <xfs@OSS.SGI.com>; Thu, 6 Oct 2011 07:59:39 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id 3NERNFKguYrCT23K for
	<xfs@OSS.SGI.com>; Sat, 14 Jan 2012 17:15:05 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by april.london.02.net (8.5.140)
	id 4F0E3BDD000CCD37 for xfs@OSS.SGI.com; Sun, 15 Jan 2012 01:15:03 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RmEgQ-0001yB-72
	for <xfs@OSS.SGI.com>; Sun, 15 Jan 2012 01:14:54 +0000
MIME-Version: 1.0
Message-ID: <20242.10382.19330.275280@tree.ty.sabi.co.UK>
Date: Sun, 15 Jan 2012 01:14:54 +0000
Subject: Re: Optimal XFS formatting options?
In-Reply-To: <33140169.post@talk.nabble.com>
References: <33140169.post@talk.nabble.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> Hi, I have a 4.9 TB iSCSI LUN on a RAID 6 array with twelve 2
> TB SATA disks (4.9T is only one of the logical volumes). It
> will contain several million files of various sizes, but 80%
> of them will be less than 50 MB.  I'm a novice at best and I
> usually just use the default #mkfs.xfs /dev/sdx1

The default :-) advice in this list and in the XFS FAQ is that
in any recent edition of the XFS tools and XFS code in the
kernel the defaults are usually best, unless you have a special
situation, for example if the kernel cannot get storage geometry
from the storage layer.

Also, "several million" in a about 5,000,000MB filesystem
indicates an average file size of 1MB. That's not too small,
fortunately. Anyhow consider how long it will take to 'fsck' all
that if it gets damaged, or the extra load to backup the whole
filetree if backups scan the tree (e.g. RYNC based).

> This is server will be write heavy for about 8 hours a night,
> but every morning there are many reads to the disk.  There is
> rarely a time where it will be write heavy and read heavy at
> the same time.  Are there other XFS format options that I
> could use to optimize performance? Any input is greatly
> appreciated. Thank you.

As usual, the first note is that in general RAID6 is a bad idea,
with RMW and reliability (especially during rebuild) issues, but
salesmen and management usually love it because it embodies a
promise of something for nothing (let's say that the parity RAID
industry is the Wall Street of storage system :->).

To mitigate problems In general if you are doing a lot of
writing it is very important that the filesystem try to align to
address/length of the full RAID stripe, but this should be
automatic if the relevant geometry is reported to the Linux
kernel. Otherwise thee are many previous messages in this list
about that, and the FAQ etc.

Things that you might want to double check in case they matter
for you, as to not-'mkfs' options:

  * XFS has several limitations on 32b kernels. Just make sure
    you have a 64b kernel.

  * Make really sure your partitions (or LUNs if unpartitioned)
    are aligned, certainly to a multiple of stripe size, ideally
    to something larg, at least like 1MiB.

  * Recent (let's say at least 2.6.32 or EL57) kernels and
    editions of XFS tools and partitioning tools (if you use
    any) are very improved. The newer usually the better.

  * Usually just in case explicitly specify at 'mount' (not
    'mkfs') time the 'inode64' option; and the 'barrier' option
    unless you really know better (and pray hard that your
    storage layer supports it). The 'delaylog' option or its
    opposite are also something to look carefully into.

  * Check carefully whether your app is compatible with the
    'noatime' and 'nodiratime' options and enable them if
    possible, "just in case" :-).

  * Look very attentively at the kernel page cache flusher
    parameters to make it run more often (tom prevent the
    accumulation of very large gulps of unwritten data) but not
    too often (to give a chance to the delayed allocator).

As to proper 'mkfs' you may want to look into:

  * Explicitly set the sector size because most storage layers
    lie. In general if possible you should set it to 4096, just
    in case :-). This also allegedly extends the range where
    inodes can be stored if you cannot specify 'inode64' at
    mount time.

  * If you have a critically high rate of metadata work (like
    file creation/deletion, and it seems your case overnight)
    you may want to ensure that your log is not only aligned,
    but perhaps on a separate device, and/or you have a host
    adapter with a large battery backed cache. Logs are small,
    so it should be easy either way.

  * Depending on the degree of multihtreading of your
    application you may want more/less AGs, but usually on a
    4.9TB filetree there will be plenty.

  * You may want larger inodes than the default if you have lots
    of ACLs or your files are written slowly and thus have many
    extents. They are recommended also for small files but I
    cannot remember whether XFS really stores small files or
    directories into the inode (I remember that directories of
    less than 8 entries are stored in the inode, but I don't
    know whether depends on its size).

Run first 'mfs.fs -N ....' so it will print out which
parameters it will use without actually doing anything.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
