Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OMQPVu107584 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 17:26:25 -0500
Received: from erebus.totalmanaged.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA39131F1D2
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 15:26:52 -0700 (PDT)
Received: from erebus.totalmanaged.com (erebus.totalmanaged.com
	[208.83.104.194]) by cuda.sgi.com with ESMTP id
	fBDv4gql4K4VxutJ for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2009 15:26:52 -0700 (PDT)
From: Michael Moody <michael@gsc.cc>
Date: Wed, 24 Jun 2009 15:26:47 -0700
Subject: RE: mkfs.xfs created filesystem larger than underlying device
Message-ID: <98D6DBD179F61A46AF5C064829A832A0185042D264@erebus.totalmanaged.com>
References: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>
	<4A42A7B7.3040403@sandeen.net>
In-Reply-To: <4A42A7B7.3040403@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

It still looks wrong:

[root@filer5 /]# xfs_info /mnt/Volume1/
meta-data=/dev/Volume1-Rep-Store/Volume1-Replicated isize=256    agcount=32, agsize=146716768 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=4694936576, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@filer5 /]# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3             92460904   1631680  86056716   2% /
/dev/sda1               101086     14393     81474  16% /boot
tmpfs                  4089196         0   4089196   0% /dev/shm
/dev/mapper/Volume1--Rep--Store-Volume1--Replicated
                     18779615232      1056 18779614176   1% /mnt/Volume1

[root@filer5 /]# cat /proc/partitions
major minor  #blocks  name

   8     0   97653504 sda
   8     1     104391 sda1
   8     2    2096482 sda2
   8     3   95450197 sda3
   8    16 18945308928 sdb
 253     0 4294967296 dm-0
 253     1 4294967296 dm-1
 253     2 4294967296 dm-2
 253     3 4294967296 dm-3
 253     4 1610612736 dm-4
 147     0 4294836188 drbd0
 147     1 4294836188 drbd1
 147     2 4294836188 drbd2
 147     3 4294836188 drbd3
 147     4 1610563548 drbd4
 253     5 18779746304 dm-5

Michael S. Moody
Sr. Systems Engineer
Global Systems Consulting

Direct: (650) 265-4154
Web: http://www.GlobalSystemsConsulting.com

Engineering Support: support@gsc.cc
Billing Support: billing@gsc.cc
Customer Support Portal:  http://my.gsc.cc

NOTICE - This message contains privileged and confidential information intended only for the use of the addressee named above. If you are not the intended recipient of this message, you are hereby notified that you must not disseminate, copy or take any action in reliance on it. If you have received this message in error, please immediately notify Global Systems Consulting, its subsidiaries or associates. Any views expressed in this message are those of the individual sender, except where the sender specifically states them to be the view of Global Systems Consulting, its subsidiaries and associates.


-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net]
Sent: Wednesday, June 24, 2009 4:25 PM
To: Michael Moody
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs created filesystem larger than underlying device

Michael Moody wrote:
> Hello all.
>
>
>
> I recently created an XFS filesystem on an x86_64 CentOS 5.3 system. I
> used all tools in the repository:
>
>
>
> Xfsprogs-2.9.4-1
>
> Kernel 2.6.18-128.1.10.el5.centos.plus
>
>
>
> It is a somewhat complex configuration of:
>
>
>
> Areca RAID card with 16 1.5TB drives in a RAID 6 with 1 hotspare (100GB
> volume was created for the OS, the rest was one large volume of ~19TB)
>
> I used pvcreate /dev/sdb to create a physical volume for LVM on the 19TB
> volume.
>
> I then used vgcreate to create a volume group of 17.64TB
>
> I used lvcreate to create 5 logical volumes, 4x4TB, and 1x1.5TB
>
> On top of those logical volumes is drbd (/dev/drbd0-/dev/drbd4)
>
> On top of the drbd volumes, I created a volume group of 17.50TB
> (/dev/drbd0-/dev/drbd4)
>
> I created a logical volume of 17.49TB, upon which was created an xfs
> filesystem with no options (mkfs.xfs mkfs.xfs
> /dev/Volume1-Rep-Store/Volume1-Replicated -L Replicated)
>
> The resulting filesystem is larger than the underlying logical volume:
>
> --- Logical volume ---
>
>   LV Name                /dev/Volume1-Rep-Store/Volume1-Replicated
>   VG Name                Volume1-Rep-Store
>   LV UUID                fB0q3f-80Kq-yFuy-NjKl-pmlW-jeiX-uEruWC
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                17.49 TB
>   Current LE             4584899
>   Segments               5
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     256
>   Block device           253:5
>
> /dev/mapper/Volume1--Rep--Store-Volume1--Replicated
>
>                        18T  411M   18T   1% /mnt/Volume1
>
> Why is this, and how can I fix it?

I'm guessing that this is df rounding up.  Try df w/o -h, to see how
many 1k blocks you have and compare that to the size.

If it still looks wrong, can you include xfs_info output for
/mnt/Volume1 as well as the contents of /proc/partitions on your system?

I'd wager a beer that nothing is wrong, but that if something is wrong,
it's not xfs ;)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
