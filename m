Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NIC2mJ054213 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 13:12:02 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA18412030BA
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 11:28:33 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id J88MpTousFifgnVn
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 11:28:33 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P9iae-0000Cz-5n
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 19:13:12 +0100
MIME-Version: 1.0
Message-ID: <19651.9652.631329.903552@tree.ty.sabi.co.uk>
Date: Sat, 23 Oct 2010 19:13:08 +0100
Subject: Re: Best filesystems ?
In-Reply-To: <Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
	<20101021020009.GG12506@dastard>
	<19648.27859.799400.168394@tree.ty.sabi.co.uk>
	<Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
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

[ ... ]

>> But the ig deal here is that's not something that a filesystem
>> targeted at high bandwidth multistreaming loads should be
>> optimized for, at least by default.

> Has someone documented (recently, and correctly) what
> filesystems (XFS, ext3, ext4, reiser, JFS, VFAT etc.) are best
> for what tasks (mailboxes, database, general computing, video
> streaming etc.) ?

That's impossible. In part because it would take a lot of work,
but mostly because file system performance is so anisotropic with
storage and application profiles, and there are too many variables.
File systems also have somewhat different features. I have written
some impressions on what matters here:

  http://www.sabi.co.uk/blog/0804apr.html#080415

The basic performance metric for a file systems used to be which
percent of the native performance of a hard disk it could deliver
to a single process, but currently most file systems are at 90%
or higher for most of that.

My current impressions are:

* Reiser3 is nice with the right parameters for the few cases
  where there is a significant number of small files on a small
  storage system accessed by a single process.

* 'ext2' is nice for small freshly loaded filesystems with not
  too big files, and for MS-Windows compatibility.

* 'ext3' is good for widespread compatibility and for somewhat
  "average", small or middling filesystems up to 2TB.

* 'ext4' is good for inplace upgradeability from 'ext3', and some
  more scalability and features, but I can't see any real reason
  why it was developed but offering an in-place upgrade path to RH
  customers, given that JFS and XFS were there are fairly mature
  already. I think it has a bit more scalability and performance
  than 'ext3' (especially better internal parallelism).

* JFS is good for almost everything, including largish filesystems
  on somewhat largish systems with lots of processes accessing
  lots of files, and works equally well on 32b and 64b, is very
  stable, and has a couple of nice features. Its major downside is
  less care than XFS for barriers. I think that it can support
  well filesystems up to 10-15TB, and perhaps beyond. It should
  have been made the default for Linux for at least a decade
  instead of 'ext3'.

* XFS is like JFS, and with somewhat higher scalability both as to
  sizes and as to higher internal parallelism in the of multiple
  processes accessing the same file, and has a couple of nice
  features (mostly barrier support, but also small blocks and large
  inodes). Its major limitation are internal complexity and should
  only be used on 64b systems. It can support single filesystems
  larger than 10-15TB, but that's stretching things.

* Lustre works well as a network parallel large file streaming
  filesystem. It is however somewhat unstable and great care has to
  be taken in integration testing because of that.

I currently think that JFS, XFS and Lustre cover more or less all
common workloads. I occasionally use 'ext2' or NTFS for data
exchange between Linux and MS-Windows.

There are some other interesting ones:

* UDF could be a very decent small-average sized file systems,
  especially for interchange, but also general purpose use.
  Implementations are a bit lacking.

* OCFS2 used in non cluster mode works well, and has pretty decent
  performance, and can be used in shared-storage mode too, but it
  seems still a bit too unstable.

* NILFS2 seems just the right thing for SSD based file systems,
  and with a collector could be a general purpose file systems.

* GlusterFS seems quite interesting for the distributed case.

Reiser4 also looked fairly good, but it has been sort of succeeded
by BTRFS (whose author used to work on Reiser4), but BTRFS seems
like a non entirely justified successor to 'ext4', but it has also
a few nice extra features builtin that I am not sure really need to
be built in ( have the same feeling for ZFS).

Then there are traditional file systems which also have some
special interest, like OpenAFS or GFS2.

The major current issue with all of these is 'fsck' times and lack
of scalability to single-pool filesystems larger than several TB,
but doing that well is still a research issue (which hasn't stopped
happy-go-lucky people from creating much larger filesystems,
usually with XFS, "because you can", but good luck to them).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
