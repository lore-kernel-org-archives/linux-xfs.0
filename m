Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A89D47FAD
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 21:33:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7E968304070
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 19:33:27 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CJmcEVJFnD8oJFoo
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 19:33:26 -0800 (PST)
Message-ID: <5306C90B.1000904@hardwarefreak.com>
Date: Thu, 20 Feb 2014 21:33:31 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>
	<52EB3B96.7000103@hardwarefreak.com>	<1391202273-sup-9265@al.wesleyan.edu>	<52ED61C9.8060504@hardwarefreak.com>	<20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu>	<20140203214128.GR13997@dastard>
	<52F09E36.8050606@hardwarefreak.com>	<1392748390-sup-1943@al.wesleyan.edu>	<5303E7AC.50903@hardwarefreak.com>
	<20140220183125.29149.64880@al.wesleyan.edu>
In-Reply-To: <20140220183125.29149.64880@al.wesleyan.edu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs@oss.sgi.com

On 2/20/2014 12:31 PM, C. Morgan Hamill wrote:
> Quoting Stan Hoeppner (2014-02-18 18:07:24)
>> Create each LV starting on a stripe boundary.  There will be some
>> unallocated space between LVs.  Use the mkfs.xfs -d size= option to
>> create your filesystems inside of each LV such that the filesystem total
>> size is evenly divisible by the stripe width.  This results in an
>> additional small amount of unallocated space within, and at the end of,
>> each LV.
> 
> Of course, this occurred to me just after sending the message... ;)

That's the right way to do that, but you really don't want to do this
with LVM.  It's just a mess.  You can easily do this with a single XFS
filesystem and a concatenation, with none of these alignment and sizing
headaches.  Read on.

...
> 8 * 128k = 1024k
> 1024k * 4 = 4096k
> 
> Which leaves me with 5 disks unused.  I might be able to live with that
> if it makes things work better.  Sounds like I won't have to.

Forget all of this.  Forget RAID60.  I think you'd be best served by a
concatenation.

You have a RAID chassis with 15 drives and two 15 drive JBODs daisy
chained to it, all 4TB drives, correct?  Your original setup was 1 spare
and one 14 drive RAID6 array per chassis, 12 data spindles.  Correct?
Stick with that.

Export each RAID6 as a distinct LUN to the host.  Make an mdadm --linear
array of the 3 RAID6 LUNs, devices.  Then format the md linear device,
e.g. /dev/md0 using the geometry of a single RAID6 array.  We want to
make sure each allocation group is wholly contained within a RAID6
array.  You have 48TB per array and 3 arrays, 144TB total.  1TB=1000^4
and XFS deals with TebiBytes, or 1024^4.  Max agsize is 1TiB.  So to get
exactly 48 AGs per array, 144 total AGs, we'd format with

# mkfs.xfs -d su=128k,sw=12,agcount=144

The --linear array, or generically concatenation, stitches the RAID6
arrays together end-to-end.  Here the filesystem starts at LBA0 on the
first array and ends on the last LBA of the 3rd array, hence "linear".
XFS performs all operations at the AG level.  Since each AG sits atop
only one RAID6, the filesystem alignment geometry is that of a single
RAID6.  Any individual write will peak at ~1.2GB/s.  Since you're
limited by the network to 100MB/s throughput this shouldn't be an issue.

Using an md linear array you can easily expand in the future without all
the LVM headaches, by simply adding another identical RAID6 array to the
linear array (see mdadm grow) and then growing the filesystem with
xfs_growfs.  In doing so, you will want to add the new chassis before
the filesystem reaches ~70% capacity.  If you let it grow past that
point, most of your new writes may go to only the new RAID6 where the
bulk of your large free space extents now exist.  This will create an IO
hotspot on the new chassis, while the original 3 will see fewer writes.

Also, don't forget to mount with the "inode64" option in fstab.

...
> A limitation of the software in question is that placing multiple
> archive paths onto a single filesystem is a bit ugly: the software does
> not let you specifiy a maximum size for the archive paths, and so will
> think all of them are the size of the filesystem.  This isn't an issue
> in isolation, but we need to make use of a data-balancing feature the
> software has, which will not work if we place multiple archive paths on
> a single filesystem.  It's a stupid issue to have, but it is what it is.

So the problem is capacity reported to the backup application.  Easy to
address, see below.

...
> Yes, this is what I *want* to do.  There's a limit to the number of
> store points, but it's large, so this would work fine if not for the
> multiple-stores-on-one-filesystem issue.  Which is frustrating.

...
> The *only* reason for LVM in the middle is to allow some flexibility of
> sizing without dealing with the annoyances of the partition table.
> I want to intentionally under-provision to start with because we are
> using a small corner of this storage for a separate purpose but do not
> know precisely how much yet.  LVM lets me leave, say, 10TB empty, until
> I know exactly how big things are going to be.

XFS has had filesystem quotas for exactly this purpose, for almost as
long as it has existed, well over 15 years.  There are 3 types of
quotas: user, group, and project.  You must enable quotas with a mount
option.  You manipulate quotas with the xfs_quota command.  See

man xfs_quota
man mount

Project quotas are set on a directory tree level.  Set a soft and hard
project quota on a directory and the available space reported to any
process writing into it or its subdirectories is that of the project
quota, not the actual filesystem free space.  The quota can be increased
or decreased at will using xfs_quota.  That solves your "sizing" problem
rather elegantly.


Now, when using a concatenation, md linear array, to reap the rewards of
parallelism the requirement is that the application creates lots of
directories with a fairly even spread of file IO.  In this case, to get
all 3 RAID6 arrays into play, that requires creation and use of at
minimum 97 directories.  Most backup applications make tons of
directories so you should be golden here.

> It's a pile of little annoyances, but so it goes with these kinds of things.
> 
> It sounds like the little empty spots method will be fine though.

No empty spaces required.  No LVM required.  XFS atop an md linear array
with project quotas should solve all of your problems.

> Thanks, yet again, for all your help.

You're welcome Morgan.  I hope this helps steer you towards what I think
is a much better architecture for your needs.

Dave and I both initially said RAID60 was an ok way to go, but the more
I think this through, considering ease of expansion, using a single
filesystem and project quotas, it's hard to beat the concat setup.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
