Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KLbv3g229328 for <xfs@oss.sgi.com>; Thu, 20 May 2010 16:37:58 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ED799F9FBE
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 14:41:26 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id xE1Qb4wRWYUwtaSt for
	<xfs@oss.sgi.com>; Thu, 20 May 2010 14:41:26 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KLe5Xi008490 for <xfs@oss.sgi.com>; Thu, 20 May 2010 14:40:07 -0700
Message-ID: <4BF5AC35.7050909@tlinx.org>
Date: Thu, 20 May 2010 14:40:05 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: mkfs.xfs -n ci - error?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I'm trying to use the "-n ci" option on a volume, but get an error where it tells me
the correct syntax is "-n ci".  Am I missing something?

mkfs.xfs -i maxpct=5 -n ci -l size=32704b,lazy-count=1 -d su=64k,sw=4 -L Backup -f /dev/Space/Backup 
unknown option -n ci
Usage: mkfs.xfs
/* blocksize */         [-b log=n|size=num]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
                            (sunit=value,swidth=value|su=num,sw=num),
                            sectlog=n|sectsize=num
/* inode size */        [-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]
/* log subvol */        [-l agnum=n,internal,size=num,logdev=xxx,version=n
                            sunit=value|su=num,sectlog=n|sectsize=num,
                            lazy-count=0|1]
/* label */             [-L label (maximum 12 characters)]
/* naming */            [-n log=n|size=num,version=2|ci]
                        ^^^^                        ^^^

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
