Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E68FA7F37
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 15:14:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72CA6AC00A
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:14:38 -0800 (PST)
Received: from internal-smtp3.wesleyan.edu (internal-smtp3.wesleyan.edu
	[129.133.6.182]) by cuda.sgi.com with ESMTP id WDEkAAyVTU1BHNbd
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:14:36 -0800 (PST)
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <52EB3B96.7000103@hardwarefreak.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
Date: Fri, 31 Jan 2014 16:14:31 -0500
Message-Id: <1391202273-sup-9265@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

Excerpts from Stan Hoeppner's message of 2014-01-31 00:58:46 -0500:
> RAID60 is a nested RAID level just like RAID10 and RAID50.  It is a
> stripe, or RAID0, across multiple primary array types, RAID6 in this
> case.  The stripe width of each 'inner' RAID6 becomes the stripe unit of
> the 'outer' RAID0 array:
> 
> RAID6 geometry     128KB * 12 = 1536KB
> RAID0 geometry  1536KB * 3  = 4608KB
> 
> If you are creating your RAID60 array with a proprietary hardware
> RAID/SAN management utility it may not be clearly showing you the
> resulting nested geometry I've demonstrated above, which is correct for
> your RAID60.
> 
> It is possible with software RAID to continue nesting stripe upon stripe
> to build infinitely large nested arrays.  It is not practical to do so
> for many reasons, but I'll not express those here as it is out of scope
> for this discussion.  I am simply attempting to explain how nested RAID
> levels are constructed.
> 
> > So optimised for sequential IO. The time-honoured method of setting
> > up XFS for this if the workload is large files is to use a stripe
> > unit that is equal to the width of the underlying RAID6 volumes with
> > a stripe width of 3. That way XFS tries to align files to the start
> > of each RAID6 volume, and allocate in full RAID6 stripe chunks. This
> > mostly avoids RMW cycles for large files and sequential IO. i.e. su
> > = 1536k, sw = 3.

Makes perfect sense.

> As Dave demonstrates, your hardware geometry is 1536*3=4608KB.  Thus,
> when you create your logical volumes they each need to start and end on
> a 4608KB boundary, and be evenly divisible by 4608KB.  This will ensure
> that all of your logical volumes are aligned to the RAID60 geometry.
> When formatting the LVs with XFS you will use:
> 
> ~# mkfs.xfs -d su=1536k,sw=3 /dev/[lv_device_path]

Noted.

> This aligns XFS to the RAID60 geometry.  Geometry alignment must be
> maintained throughout the entire storage stack.  If a single layer is
> not aligned properly, every layer will be misaligned.  When this occurs
> performance will suffer, and could suffer tremendously.
> 
> You'll want to add "inode64" to your fstab mount options for these
> filesystems.  This has nothing to do with geometry, but how XFS
> allocates inodes and how/where files are written to AGs.  It is the
> default in very recent kernels but I don't know in which it was made so.

Yes, I was aware of this.

> LVM typically affords you much more flexibility here than your RAID/SAN
> controller.  Just be mindful that when you expand you need to keep your
> geometry, i.e. stripe width, the same.  Let's say some time in the
> future you want to expand but can only afford, or only need, one 14 disk
> chassis at the time, not another 3 for another RAID60.  Here you could
> create a single 14 drive RAID6 with stripe geometry 384KB * 12 = 4608KB.
> 
> You could then carve it up into 1-3 pieces, each aligned to the
> start/end of a 4608KB stripe and evenly divisible by 4608KB, and add
> them to one of more of your LVs/XFS filesystems.  This maintains the
> same overall stripe width geometry as the RAID60 to which all of your
> XFS filesystems are already aligned.

OK, so the upshot is is that any additions to the volume group must be
array with su*sw=4608k, and all logical volumes and filesystems must
begin and end on multiples of 4608k from the start of the block device.

As long as these things hold true, is it all right for logical
volumes/filesystems to begin on one physical device and end on another?

> If you remember only 3 words of my post, remember:
> 
> Alignment, alignment, alignment.

Yes, I am hearing you. :-)

> For a RAID60 setup such as you're describing, you'll want to use LVM,
> and you must maintain consistent geometry throughout the stack, from
> array to filesystem.  This means every physical volume you create must
> start and end on a 4608KB stripe boundary.  Every volume group you
> create must do the same.  And every logical volume must also start and
> end on a 4608KB stripe boundary.  If you don't verify each layer is
> aligned all of your XFS filesystems will likely be unaligned.  And
> again, performance will suffer, possibly horribly so.

So, basically, --dataalignment is my friend during pvcreate and
lvcreate.

Thanks so much for your and Dave's help; this has been tremendously
helpful.
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
