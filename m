Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KEI3FL076647 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 09:18:03 -0500
Received: from pyrimidin.rz.uni-konstanz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 644E71953190
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 07:19:15 -0700 (PDT)
Received: from pyrimidin.rz.uni-konstanz.de (pyrimidin.rz.uni-konstanz.de
	[134.34.240.46]) by cuda.sgi.com with ESMTP id bYtlpLhOVYQdtZXG
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 07:19:15 -0700 (PDT)
in-reply-to: 20101019014245.GN29677@dastard
From: "Markus Roth" <Markus.Roth@uni-konstanz.de>
message-id: <626d-4cbefa80-3-30be62c0@160346662>
subject: Re: Performance degeneration issues
date: Wed, 20 Oct 2010 16:19:14 +0200
MIME-Version: 1.0
Reply-To: Markus Roth <Markus.Roth@uni-konstanz.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hello once more,
 
Am Dienstag 19 Oktober 2010 03:42 CEST, Dave Chinner <david@fromorbit.com> schrieb: 

> Also, what's the output of of 'xfs_info <mntpt>'?

here's one
meta-data=/dev/sda3              isize=256    agcount=16, agsize=2949182 blks
         =                       sectsz=512   attr=0
data     =                       bsize=2048   blocks=47186912, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=2048   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

and another 
meta-data=/dev/sdb1              isize=256    agcount=16, agsize=2621355 blks
         =                       sectsz=512   attr=0
data     =                       bsize=2048   blocks=41941680, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=2048   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Please excuse my forgetting to post the requested information.
Used blocks differ because of different states in work process.

What I've also noticed is that compared to ext3, file-descriptors 
get closed quite slowly (although that might also be a VMWare issue
as the one server running on pure hardware currently is testing ext3). 

Greetings,
   Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
