Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7CMj2CS177279 for <xfs@OSS.SGI.com>; Sun, 12 Aug 2012 17:45:02 -0500
Received: from sabi.co.UK (rm-pr-sg-07.server.shotgunsoftware.com
	[74.50.53.135]) by cuda.sgi.com with ESMTP id 2SJMWees6o7Gibro
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@OSS.SGI.com>; Sun, 12 Aug 2012 15:45:00 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1T0grY-0000WJ-Hk
	for <xfs@OSS.SGI.com>; Sun, 12 Aug 2012 23:41:59 +0100
Resent-Message-ID: <20520.12624.397768.450417@tree.ty.sabi.co.UK>
Resent-To: xfs@oss.sgi.com
Subject: Re: howto keep xfs directory searches fast for a long time
Date: Sun, 12 Aug 2012 20:05:42 +0100
MIME-Version: 1.0
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Message-ID: <20519.65183.983097.950473@tree.ty.sabi.co.UK>
References: <6344220.LKveJofnHA@saturn>
In-Reply-To: <6344220.LKveJofnHA@saturn>
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

> I need a VMware VM that has 8TB storage. As I can at max
> create a 2TB disk, I need to add 4 disks, and use lvm to
> concat these. All is on top of a RAID5 or RAID6 store.

Ah the usual goal of a single large storage pool for cheap.

> The workload will be storage of mostly large media files (5TB
> mkv Video + 1TB mp3), plus backup of normal documents (1TB
> .odt,.doc,.pdf etc).

Probably 2-3MB per MP3 thus 300-500k MP3, 1-2MB per document.
For videos hard to guess how long, but picking an arbitrary
number with 100MB videos it would be around 50,000 files.

Overall 1 million files, still within plausibility.

> The server should be able to find files quickly, transfer speed
> is not important. There won't be many deletes to media files,
> mostly uploads and searching for files. Only when it grows
> full, old files will be removed. But normal documents will be
> rsynced (used as backup destination) regularly.

> I will set vm.vfs_cache_pressure = 10, this helps at least
> keeping inodes cached when they were read once.

That may be a workaround (see below) in your specific case to
the default answer to this question:

> - What is the best setup to get high speed on directory
>   searches? Find, ls, du, etc. should be quick.

None. If you are thinking inode-accessing searches, it just won't
work fast on large filetrees over long stroking.

  Note: in way of principle 'find' and 'ls' won't access inodes,
  as the could be just about names, but most uses of 'find' and
  'ls' do access inode fields. 'du' obviously does, and so does
  'rsync' which you intend to use for backups.

Especially as most filesystems, including XFS (in at least some
versions and configurations) aim to keep metadata (directories,
inodes) close to file data rather than each other, because that
is what typical workloads are supposed to required.

Perhaps you could change the intended storage layer to favour
clustering of metadata, however difficult it is to get
filesystems to go against the grain of their usual design.

> - Should I use inode64 or not?

That's a very difficult question, as 'inode64' has two different
effects:

* Allows inodes to be stored in the first 1TiB (with 512B
  sectors) of the filetree space.
* Distributes directories across AGs, and attempts to put
  *data* in the same AG as the directory they are linked from.
    http://www.spinics.net/lists/xfs/msg11429.html
    http://www.spinics.net/lists/xfs/msg11455.html

In your case perhaps it is best not to distribute directories
across AGs, and to keep all inodes in the first 1TiB. But it is a
very difficult tradeoff as you may run out of space for inodes in
the first 1TiB, even if you don't have that many inodes.

> - If that's an 8 disk RAID-6, should I mkfs.xfs with 6*4 AGs?
>   Or what would be a good start, or wouldn't it matter at all?

Difficult to say ahead of time. RAID6 can be a very bad choice
for metadata intensive accesses, but only for updating the
metadata, and it seems that there won't a lot of that in your
case.

> And as it'll be mostly big media files, should I use
> sunit/swidth set to 64KB/6*64KB, does that make sense?

Whatever the size of files, 'sw' should be the size of the RMW
block of the blockdevice containing the filesystem, and 'su'
should be the size of contiguous data on each member blockdevice.
What is a difficult question is the best '--chunksize' for the
RAID set, and that depends a lot on how multithreaded and random
is the workload.

> I'm asking because I had such a VM setup once, and while it
> was fairly quick in the beginning, over time it felt much
> slower on traversing directories, very seek bound.

The definition of a database is something like "a set of data
whose working set cannot be cached in memory". If you want to
store a database consider using a DBMS. But perhaps your
(meta)data set can be cached in memory, see below.

It may be worthile to consider a few large directories as in XFS
they are implemented as fairly decent trees, for random access,
but large directories don't work so well for linear scans (inode
enumeration issues), especially with apps that are not careful.

Also depending on filesystem used and parameters, things gets
slower with time the more space is used in a partition, because
most filesystems tend to allocate clumpedly and starting with the
low address blocks on the outer tracks, thus implicitly short
striking the block device at the beginning.

> That xfs was only 80% filled, so shouldn't have had a
> fragmentation problem.

Perhaps 80% is not enough for fragmentation of file contents,
but it can be a big issue for keeping metadata together.

> And I know nothing to fix that apart from backup/restore, so
> maybe there's something to prevent that?

No. Even backup/restore may not be good enough once the filetree
block device has filled up and accesses often need long strokes.

Filesystems are designed for "average" performance on "average"
workloads more than peak performance on custom workloads, no
matter the committment to denial of so many posters to this list.
In your case you are trying to bend over a filesystem aimed at
high parallel throughput over large sequential streams into doing
low latency access to widely scattered small metadata...

Given your requirements it might be better for you do have a
filesystem that clusters all metadata together and far away from
the data it described, as you 1M inodes might take all together
around 1GiB of space.

Or you could implement a pre-service phase where all inodes are
scanned at system startup (I think it would be best with 'du'),
and then to ensure that they get rarely written back to storage
(which by default XFS rarely does as in effect it defaults to
'relatime').

For example on my laptop I have two filetrees with around 700,000
inodes, and with 4GiB of RAM when I 'rsync' either of them for
backups further passes cause almost no disk IO, because that many
inodes do get cached. These are some lines from 'slabtop' after
such an 'rsync':

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
665193 665193 100%    0.94K  39129       17    626064K xfs_inode
601377 601377 100%    0.19K  28637       21    114548K dentry

This is cheating, because it uses the in-memory inode and dentry
caches as a DBMS, but in your case you might get away with cheating.

Setting 'vm/vfs_cache_pressure=0' might even be a sensible option
as the number of inodes in your situation has an upper bound
which is likely to be below maximum RAM you can give to your
server.

Finally I am rather perplexed when a VM and SAN is used in a
situation performance, and in particular where low latency disk
and network access is important. VMs perform well for CPU bound
loads, not so well for network loads, and even less for IO loads,
and even less when latency matters more than throughput.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
