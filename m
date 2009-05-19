Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4JEBQXj047818 for <xfs@oss.sgi.com>; Tue, 19 May 2009 09:11:26 -0500
Received: from concorde.pha.jhu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9476C296F49
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 07:11:36 -0700 (PDT)
Received: from concorde.pha.jhu.edu (concorde.pha.jhu.edu [128.220.143.18]) by
	cuda.sgi.com with ESMTP id ALxFjz3KImEACiVW for
	<xfs@oss.sgi.com>; Tue, 19 May 2009 07:11:36 -0700 (PDT)
Received: from [128.220.233.109] (cue.pha.jhu.edu [128.220.233.109])
	(authenticated bits=0)
	by concorde.pha.jhu.edu (8.13.1/8.13.1) with ESMTP id n4JEBXTu014659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 10:11:34 -0400
Message-ID: <4A12BE15.3080908@pha.jhu.edu>
Date: Tue, 19 May 2009 10:11:33 -0400
From: Josh Greenberg <josh@pha.jhu.edu>
MIME-Version: 1.0
Subject: question on agcount and agsize
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
To: xfs@oss.sgi.com

I've just installed xfs for the first time and I'm trying to put an xfs 
file system on a large disk. When I just tried with no arguments, it 
told me that the agsize was too large and the maximum is 268435455 
blocks. I wasn't familiar with allocation groups at all so I researched 
this a little bit. I found out what an allocation group is but there 
aren't many recommendations on agcount other than "don't make it too 
big" because it slows the disk down as it gets full. However, after 
playing with the numbers, I found that the lowest number it will accept 
for agcount is 44. I now have a file system with the following structure:

meta-data=/dev/md0       isize=256    agcount=44, agsize=266361205 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=11719892992, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


I have two questions:
1. Does the agcount have to be a power of 2? Almost every example of 
agcount I've seen online has been a power of 2 (2, 4, 8, 16, and 32). I 
originally tried an agcount of 64 which worked but then tried to size it 
down so it wasn't too large. Will this cause problems later.
2. Is 44 too large? Will I experience a slow down as the disk fills? 
I've seen people recommend that you not go over agcount=32 and even 
someone who said not to exceed agcount=8. What are the long term 
ramifications of this?

Thanks,

Josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
