Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DKeAHO092705 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 15:40:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAA1314D1AC6
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 13:49:28 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id CD8e9EgiSh5NIZCn for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 13:49:28 -0700 (PDT)
Message-ID: <4C65ADC1.3010801@sandeen.net>
Date: Fri, 13 Aug 2010 15:40:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fs corruption not detected by xfs_check or _repair
References: <4C656149.6050604@nethype.de>
In-Reply-To: <4C656149.6050604@nethype.de>
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
To: Marco Maisenhelder <marco@nethype.de>
Cc: xfs@oss.sgi.com

Marco Maisenhelder wrote:
> Hi list,
> 
> I have a little bit of a problem after a catastrophic hardware failure
> (power supply went up in smoke and took half of my server with it -
> luckily only one of my raid5 disks though). My xfs data partition on my
> raid has some severe corruption that prevents me from accessing some
> files and directories on the partition. This is how the problem
> manifests itself:
> 
> *marco:/etc# ls -lrt /store/xfs_corruption/x/
> ls: cannot access /store/xfs_corruption/x/db.backup2: Invalid argument
> ls: cannot access /store/xfs_corruption/x/db.backup1: Invalid argument
> total 0
> ?????????? ? ? ? ?                ? db.backup2
> ?????????? ? ? ? ?                ? db.backup1
> 
> xfs_check does not report any errors. xfs_repair does not repair anything.
> 
> xfs_repair version 3.1.2
> xfs_check version 3.1.2
> System is Debian stable using a 2.6.26-2-amd64 kernel
> 
> *marco:/etc# xfs_info /store/
> meta-data=/dev/mapper/vgraid-rstore isize=256    agcount=48,
> agsize=11443904 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=549307392, imaxpct=25
>          =                       sunit=64     swidth=192 blks
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> There's nothing in any of the system logs that would hint to the
> filesystem being corrupt.
> 
> I have done a metadump but after looking into it found that there's
> still sensitive information in there. I would be ok sharing it with
> individual developers but I can't put that on an open mailinglist.

You might be able to xfs_mdrestore, mount that, remove all but the
offending directory, re-metadump that, and put it out there?  Just a thought,
I haven't looked in further detail at your xfs_db adventures, sorry - maybe
there's enough info there but I'm swamped in other things ATM, so will leave
it to others, I hope.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
