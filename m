Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 01:02:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9K81uaG028143
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 01:01:57 -0700
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B66AD1998BE
	for <xfs@oss.sgi.com>; Thu, 19 Oct 2006 23:58:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id 77F4B69C
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 08:58:13 +0200 (CEST)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 20822-16 for <xfs@oss.sgi.com>;
	Fri, 20 Oct 2006 08:58:06 +0200 (CEST)
Received: from [192.168.1.98] (unknown [88.36.237.170])
	by mail.interline.it (Postfix) with ESMTP id AB65A63E
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 08:58:06 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: xfs_ncheck gives outdated and partial result
Date: Fri, 20 Oct 2006 08:58:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610200858.08718.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi All,
I'm here to ask a couple of question regarding xfs_ncheck.
I'm using xfs_db version 2.6.20

The first question is:
Is it right that I have to unmount/mount the filesystem before
using it (1), or to get the partial right (3) answer?
And why it's print only the first file name for inodes pointed
by multiple files (2)?


(1)
# mkfs.xfs /dev/hda5
meta-data=/dev/hda5              isize=256    agcount=16, agsize=152617 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=2441872, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
# mount /dev/hda5 /mnt/hda5/
# touch /mnt/hda5/a
# xfs_ncheck -i 131 /dev/hda5
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_ncheck.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
must run blockget -n first

(2)
# ln /mnt/hda5/a /mnt/hda5/b
# ls -i /mnt/hda5/
131 a  131 b
# umount /mnt/hda5
# mount /dev/hda5 /mnt/hda5
# xfs_ncheck -i 131 /dev/hda5
        131 a

(3)                                           
# ln /mnt/hda5/a /mnt/hda5/c
# xfs_ncheck -i 131 /dev/hda5
        131 a
# rm /mnt/hda5/a
# xfs_ncheck -i 131 /dev/hda5
        131 a
# umount /mnt/hda5
# mount /dev/hda5 /mnt/hda5
# xfs_ncheck -i 131 /dev/hda5
        131 b

Thanks in advance,
Daniele P.
