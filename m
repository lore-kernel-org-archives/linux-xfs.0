Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ON24Md109174 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 18:02:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04D739867DF
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:11:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id cAA3NswIKCiF6w5y for
	<xfs@oss.sgi.com>; Wed, 24 Jun 2009 16:11:00 -0700 (PDT)
Message-ID: <4A42B087.5050205@sandeen.net>
Date: Wed, 24 Jun 2009 18:02:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs created filesystem larger than underlying device
References: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>	<4A42A7B7.3040403@sandeen.net>
	<98D6DBD179F61A46AF5C064829A832A0185042D264@erebus.totalmanaged.com>
In-Reply-To: <98D6DBD179F61A46AF5C064829A832A0185042D264@erebus.totalmanaged.com>
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
To: Michael Moody <michael@gsc.cc>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

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

xfs_info says:		19230460215296
/proc/partitions says:	19230460215296 (same as above)
df says:		19230325997568 (a little smaller, but ok)

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
