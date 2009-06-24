Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5OMXD4t107809 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 17:33:14 -0500
Received: from erebus.totalmanaged.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41F4631EE14
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 15:33:41 -0700 (PDT)
Received: from erebus.totalmanaged.com (erebus.totalmanaged.com
	[208.83.104.194]) by cuda.sgi.com with ESMTP id
	2rdvuyQ3BYYyYa7W for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2009 15:33:41 -0700 (PDT)
From: Michael Moody <michael@gsc.cc>
Date: Wed, 24 Jun 2009 15:33:38 -0700
Subject: RE: mkfs.xfs created filesystem larger than underlying device
Message-ID: <98D6DBD179F61A46AF5C064829A832A0185042D265@erebus.totalmanaged.com>
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

In addition:

I experienced significant corruption. I had only about 3 files on the XFS filesystem, which was then exported via nfs. I ran nfs_stress.sh against it, and my files ended up corrupt, and the machine locked up. Ideas?

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
