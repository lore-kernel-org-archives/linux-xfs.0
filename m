Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ON4c9K109333 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 18:04:38 -0500
Received: from erebus.totalmanaged.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEF8131EC9C
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:05:04 -0700 (PDT)
Received: from erebus.totalmanaged.com (mx01.totalmanaged.com
	[208.83.104.194]) by cuda.sgi.com with ESMTP id
	wmP7D5ntYEU0eYwf for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2009 16:05:04 -0700 (PDT)
From: Michael Moody <michael@gsc.cc>
Date: Wed, 24 Jun 2009 16:05:00 -0700
Subject: RE: mkfs.xfs created filesystem larger than underlying device
Message-ID: <98D6DBD179F61A46AF5C064829A832A0185042D267@erebus.totalmanaged.com>
References: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>
	<4A42A7B7.3040403@sandeen.net>
	<98D6DBD179F61A46AF5C064829A832A0185042D264@erebus.totalmanaged.com>
	<4A42B087.5050205@sandeen.net>
In-Reply-To: <4A42B087.5050205@sandeen.net>
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

Are there still known issues with NFS and XFS? I'm performing the same test against a jfs formatted filesystem (exported via NFS), and so far, no issues. This is the latest centosplus kernel. Are there mount options which could cause XFS to have corruption?

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
Sent: Wednesday, June 24, 2009 5:03 PM
To: Michael Moody
Cc: xfs@oss.sgi.com
Subject: Re: mkfs.xfs created filesystem larger than underlying device

Michael Moody wrote:
> It still looks wrong:
>
> [root@filer5 /]# xfs_info /mnt/Volume1/
> meta-data=/dev/Volume1-Rep-Store/Volume1-Replicated isize=256    agcount=32, agsize=146716768 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=4694936576, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

4694936576*4096 = 19230460215296

> [root@filer5 /]# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
...
> /dev/mapper/Volume1--Rep--Store-Volume1--Replicated
>                      18779615232      1056 18779614176   1% /mnt/Volume1

18779615232*1024 = 19230325997568

> [root@filer5 /]# cat /proc/partitions
> major minor  #blocks  name
>
...
>  253     5 18779746304 dm-5

18779746304*1024 = 19230460215296

so in bytes,

xfs_info says:          19230460215296
/proc/partitions says:  19230460215296 (same as above)
df says:                19230325997568 (a little smaller, but ok)

So, I don't see a problem here.

<later....>

> I experienced significant corruption. I had only about 3 files on the
> XFS filesystem, which was then exported via nfs. I ran nfs_stress.sh
> against it, and my files ended up corrupt, and the machine locked up.
> Ideas?

No, not really, not on a kernel this old, and without details about what
was corrupt, what xfs_repair said, what dmesg said, what sysrq-t said, etc.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
