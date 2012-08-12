Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7CJZRCS158853 for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 14:35:27 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mM11A216F7N5fGRq
	for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 12:35:26 -0700 (PDT)
Message-ID: <5028057F.3090007@hardwarefreak.com>
Date: Sun, 12 Aug 2012 14:35:27 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: howto keep xfs directory searches fast for a long time
References: <6344220.LKveJofnHA@saturn>
In-Reply-To: <6344220.LKveJofnHA@saturn>
Reply-To: stan@hardwarefreak.com
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/12/2012 4:14 AM, Michael Monnerie wrote:
> I need a VMware VM that has 8TB storage. As I can at max create a 2TB 
> disk, I need to add 4 disks, and use lvm to concat these. All is on top 
> of a RAID5 or RAID6 store.

So the problem here is max vmdk size?  Just use an RDM.  IIRC there's no
size restriction on RDMs.  And, using an RDM will avoid any alignment
issues that you may likely get when sticking XFS atop LVM atop a thin
disk file atop VMFS atop parity RAID.  With RDM you get XFS directly
atop the storage LUN.  This can be achieved with either an FC/iSCSI SAN
LUN or with a LUN exported/exposed from a hardware RAID controller.

> The workload will be storage of mostly large media files (5TB mkv Video 
> + 1TB mp3), plus backup of normal documents (1TB .odt,.doc,.pdf etc). 
> The server should be able to find files quickly, transfer speed is not 
> important. There won't be many deletes to media files, mostly uploads 
> and searching for files. Only when it grows full, old files will be 
> removed. But normal documents will be rsynced (used as backup 
> destination) regularly.
> I will set vm.vfs_cache_pressure = 10, this helps at least keeping 
> inodes cached when they were read once.
> 
> - What is the best setup to get high speed on directory searches? Find, 
> ls, du, etc. should be quick.

How many directory entries are we talking about?  Directory searching is
seek latency sensitive, so the spindle speed of the disks and read-ahead
cache of the controller may likely play as large, or larger, a role than
XFS parms.

> - Should I use inode64 or not?

Given your mixed large media and normal "office" file rsync workloads,
it's difficult to predict.  I would think inode64 would slow down
searching a bit due to extra seek latency accessing directory trees.

This is a VM environment, thus this guest and its XFS filesystem will be
competing for seeks with other VMs/workloads.  So anything that
decreases head seeks in XFS is a good thing.

> - If that's an 8 disk RAID-6, should I mkfs.xfs with 6*4 AGs? Or what 
> would be a good start, or wouldn't it matter at all?

Thus, I'd think the fewer AGs the better, as in as few as you can get
away with, especially if most of this VM's workload is large media files.

> And as it'll be mostly big media files, should I use sunit/swidth set to 
> 64KB/6*64KB, does that make sense?

If you can use an RDM on your existing storage array, match su/sw to
what's there.  If you can't and must add 4 disks, simply attach them to
your RAID controller, create a new RAID5 array.  Given large media
files, I'd probably use a strip of 256KB, times 3 spindles = 768KB
stripe.  But this will depend on your RAID controller.  Strip size may
be irrelevant to a degree with some BBWC controllers.

> I'm asking because I had such a VM setup once, and while it was fairly 
> quick in the beginning, over time it felt much slower on traversing 
> directories, very seek bound. 

This suggests directory fragmentation.

> That xfs was only 80% filled, so shouldn't 
> have had a fragmentation problem. And I know nothing to fix that apart 
> from backup/restore, so maybe there's something to prevent that?

The files may not have been badly fragmented, but even at only 80% full,
if the FS got over 90% full and/or saw many deletes over its lifespan,
you could have had a decent amount of both directory and free space
fragmentation.  Depends on how it aged.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
