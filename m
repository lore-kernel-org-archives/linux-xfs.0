Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FEbMP8192923 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 09:37:22 -0500
Received: from ppsw-31.csi.cam.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81B8E1E67CBA
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:38:11 -0700 (PDT)
Received: from ppsw-31.csi.cam.ac.uk (ppsw-31.csi.cam.ac.uk [131.111.8.131])
	by cuda.sgi.com with ESMTP id hMZ8FjRuk0aKZiBH for
	<xfs@oss.sgi.com>; Wed, 15 Sep 2010 07:38:11 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:39032
	helo=mail.lmb.internal)
	by ppsw-31.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.137]:25)
	with esmtp id 1Ovt7i-0001eA-Ku (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Wed, 15 Sep 2010 15:38:10 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1Ovt7i-0004wZ-CS
	for xfs@oss.sgi.com; Wed, 15 Sep 2010 15:38:10 +0100
Message-ID: <4C90DA52.8090507@mrc-lmb.cam.ac.uk>
Date: Wed, 15 Sep 2010 15:38:10 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: no space left on device with 662G free
References: <4C90D080.5090004@mrc-lmb.cam.ac.uk>
	<1284561000.2452.1.camel@doink>
In-Reply-To: <1284561000.2452.1.camel@doink>
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
Cc: xfs@oss.sgi.com

Alex Elder wrote:
> Please send the output of this command:
> 
>     xfs_info /dev/mapper/vg--storage-lv--data
> 
> I'm pretty sure you've run out of inodes.

# xfs_info /dev/mapper/vg--storage-lv--data
meta-data=/dev/mapper/vg--storage-lv--data isize=256    agcount=4,
agsize=134217728 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=536870912, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


Cheers, Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
