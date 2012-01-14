Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96A8Jul012946 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 05:08:19 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ln7Yd5brkDIiWnEE
	for <xfs@oss.sgi.com>; Sat, 14 Jan 2012 14:23:46 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 90C756C0B9
	for <xfs@oss.sgi.com>; Sat, 14 Jan 2012 16:23:45 -0600 (CST)
Message-ID: <4F12006F.8080805@hardwarefreak.com>
Date: Sat, 14 Jan 2012 16:23:43 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Optimal XFS formatting options?
References: <33140169.post@talk.nabble.com>
In-Reply-To: <33140169.post@talk.nabble.com>
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
To: xfs@oss.sgi.com

On 1/14/2012 11:44 AM, MikeJeezy wrote:
> 
> Hi, I have a 4.9 TB iSCSI LUN on a RAID 6 array with twelve 2 TB SATA disks
> (4.9T is only one of the logical volumes). It will contain several million
> files of various sizes, but 80% of them will be less than 50 MB.  I'm a
> novice at best and I usually just use the default #mkfs.xfs /dev/sdx1
> 
> This is server will be write heavy for about 8 hours a night, but every
> morning there are many reads to the disk.  There is rarely a time where it
> will be write heavy and read heavy at the same time.  Are there other XFS
> format options that I could use to optimize performance?

    sunit=value

This is used to specify the stripe unit for a RAID device or a logical
volume. The value has to be specified in 512-byte block units. Use the
su suboption to specify the stripe unit size in bytes. This suboption
ensures that data allocations will be stripe unit aligned when the
current end of file is being extended and the file size is larger than
512KiB. Also inode allocations and the internal log will be stripe unit
aligned.

    su=value

This is an alternative to using sunit. The su suboption is used to
specify the stripe unit for a RAID device or a striped logical volume.
The value has to be specified in bytes, (usually using the m or g
suffixes). This value must be a multiple of the filesystem block size.

    swidth=value

This is used to specify the stripe width for a RAID device or a striped
logical volume. The value has to be specified in 512-byte block units.
Use the sw suboption to specify the stripe width size in bytes. This
suboption is required if -d sunit has been specified and it has to be a
multiple of the -d sunit suboption.

    sw=value

suboption is an alternative to using swidth. The sw suboption is used to
specify the stripe width for a RAID device or striped logical volume.
The value is expressed as a multiplier of the stripe unit, usually the
same as the number of stripe members in the logical volume
configuration, or data disks in a RAID device.


Using su and sw is often easier due to less conversions.

With a 12 drive RAID6 array your stripe width, or sw, is 10.  You will
need to consult the array controller admin interface and documentation
to discover the su value if you don't already know it.  Different
vendors call this parameter by different names.  It could be "chunk
size" or "strip size" or other.  Some/many vendors don't specify this
value at all, giving you only static pre-defined total stripe size
options for the array, such as 64KB, 128KB, 1MB, etc, only in power of 2
values.  In this case if you have 64KB stripe size and divide by 10
drives in the stripe you end up with a non filesystem block size
multiple:  6553.6 bytes.  This presents serious problems for alignment.
 In this case you must dig deep to find out exactly how your vendor
controller handles this situation when your effective RAID spindle count
is not a power of 2.

So let's assume your vendor does the smart thing and allows you
flexibility in specifying per drive strip size.  Assume for example the
stripe unit (strip, chunk) of the array is 64KB, there are 10 stripe
spindles (12-2=10), and the local device name of the LUN is /dev/sdb.
To create an aligned XFS filesystem on this you would use something like:

$ mkfs.xfs -d su=64k sw=10 /dev/sdb

When using vendor array hardware that only allows one to define what XFS
calls swidth, it is best to use a power of 2 stripe spindle count to get
proper alignment.  If you use a non power of 2 stripe spindle count the
vendor firmware will either round down or round up to create the stripe
unit size, and this formula is often not documented.

With such vendor hardware, for a RAID6 array you would want to have 6,
10, or 18 total drives in the array, giving you 4, 8, or 16 stripe
spindles.  Alternatively, you need to know exactly how the firmware
rounds up or down to arrive at the strip block size (sunit).

If you find yourself in such a situation, and are unable to determine
the strip size the array firmware is using, you may be better off using
the mkfs.xfs defaults, vs guessing and ending up with unaligned writes.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
