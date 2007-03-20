Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Mar 2007 07:51:55 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2KEpj6p030549
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 07:51:48 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id 68DBADDA
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 15:23:44 +0100 (CET)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 11358-24 for <xfs@oss.sgi.com>;
	Tue, 20 Mar 2007 15:23:14 +0100 (CET)
From: "Daniele P." <daniele@interline.it>
Subject: xfsrepair memory consumption
Date: Tue, 20 Mar 2007 15:32:05 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703201532.06076.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,
I'm just asking if any work has been done/is in progress to improve
xfs_repair memory consumption.
I know that xfs tools use a lot of memory but IIRC someone wrote on this
mailing list that s/he'll work on this issue.
But now I see that the memory requirements are increasing instead of
lowering.

I discovered this because running xfs_repair 2.6.20-1 on a 300GB file
system fills up the entire memory on a debian sarge (256MB Mem/256MB
swap) and eventually the process is killed

....
Phase 6 - check inode connectivity...
- resetting contents of realtime bitmap and summary inodes
- ensuring existence of lost+found directory
- traversing filesystem starting at / ...
Killed

Next I tried a self compiled xfsprogs 2.8.18-1 from cvs but things get
worse.
So I increased the memory to 512MB, and made sure not to use the multi
thread but still no luck:

....
Phase 3 - for each AG...
- scan and clear agi unlinked lists...
- process known inodes and perform inode discovery...
- agno = 0
- agno = 1
- agno = 2
Killed

Finally using the *old* version 2.6.20-1 with 512MB of memory xfs_repair
finished with success, but using near all the available memory.

More info:

enceladus:~# xfs_info /dev/sdb1
meta-data=/media/iomega300       isize=256    agcount=16, agsize=4578901 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=73262416, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
enceladus:~# df /dev/sdb1
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1            292918592 164698268 128220324  57% /media/300
enceladus:~# df -i /dev/sdb1
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb1            293049664 6511481 286538183    3% /media/300

Thanks in Advance,
Daniele P.
