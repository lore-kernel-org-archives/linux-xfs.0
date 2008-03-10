Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Mar 2008 05:39:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ACd7Rc026328
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 05:39:08 -0700
Received: from gw02.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EB7E120254E
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 05:39:37 -0700 (PDT)
Received: from gw02.mail.saunalahti.fi (gw02.mail.saunalahti.fi [195.197.172.116]) by cuda.sgi.com with ESMTP id jCt1spQVFwn0AXWC for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 05:39:37 -0700 (PDT)
Received: from uunet198.aac.fi (uunet198.aac.fi [193.64.61.198])
	by gw02.mail.saunalahti.fi (Postfix) with ESMTP id AA80F139F59
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2008 14:39:04 +0200 (EET)
Message-ID: <47D52BE5.6010706@iki.fi>
Date: Mon, 10 Mar 2008 14:39:01 +0200
From: Erkki Lintunen <erkki.lintunen@iki.fi>
Reply-To: erkki.lintunen@iki.fi
MIME-Version: 1.0
Subject: an occational trouble with xfs file system which xfs_repair 2.7.14
 has been able to fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

can you help me a bit with my troublesome ~700GB xfs filesystem?

The file system has had several dir trees since it was created somewhere 
2004-2005. It has been written to daily since it was created. It has 
been expanded few times with xfs_growfs. It has experienced the same 
symptom already 2-4 times.

The symptom is that one of the dir trees gets locked about once a year. 
It is always the same tree. I can't remember when or what happened when 
the symptom was first experienced. I guess the system had run on 
2.6.17.x kernel once in its lifetime, but xfs_repair ought to fix the 
dir lock problem, at least the latest, doesn't it.

The filesystem is used for backups with rsync, cp -al and rm -fr 
commands in a script. When the trouble begins cp -al command starts to 
take several hours and hundreds of megs memory. rm -fr of a subtree also 
takes considerably longer than rm a subtree in another bigger tree in 
the same filesystem, but the rm commands have always finnished, which 
the cp -al commands haven't. Most of the time the cp -al process has D 
status.

I have mananged to repair the file system with xfs_repair 2.7.14, but 
not with 2.6.20, which comes in Debian Sarge. Now I tried latest 
xfs_repair and it didn't fix the problem - at least on the first run 
without any options.

For example latest backup had to be interrupted and time command showed 
following:

real    1342m7.316s
user    1m4.152s
sys     14m5.109s

I have xfs_metadump of the filesystem right after the interrup. Its size 
is 3.9G uncompressed and 1.6G compressed with bzip2 -9. Now I ran 
xfs_repair 2.7.14 on the file system and wait one day before I'll see 
whether it was capable to fix the problem this time as well.

What else information I could provide in addition to those requested in FAQ?

plastic:~# grep backup-volA /etc/fstab
/dev/vg00/backup-volA   /site/backup-volA       xfs     defaults 
0       1


plastic:~# df -ml /backup/volA/.
Filesystem           1M-blocks      Used Available Use% Mounted on
/site/backup-volA       692688    647328     45361  94% /backup/volA


plastic:~# ./xfs_repair -V
xfs_repair version 2.9.7
plastic:~# /usr/local/sbin/xfs_repair -V
xfs_repair version 2.7.14
plastic:~# /sbin/xfs_repair -V
xfs_repair version 2.6.20


plastic:~# dmesg |tail -n 3
Filesystem "dm-0": Disabling barriers, not supported by the underlying 
device
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0


plastic:~# uname -a
Linux plastic 2.6.24.2-i686-net #1 SMP Tue Feb 12 17:42:16 EET 2008 i686 
GNU/Linux


plastic:~# xfs_info /site/backup-volA
meta-data=/site/backup-volA      isize=256    agcount=39, agsize=4559936 
blks
          =                       sectsz=512
data     =                       bsize=4096   blocks=177360896, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


# diff between output of xfs_repair 2.9.7 (screenlog.0) and
# xfs_repair 2.7.14 (screenlog.1)
--- screenlog.0	2008-03-10 10:32:13.000000000 +0200
+++ screenlog.1	2008-03-10 14:04:00.000000000 +0200
@@ -1,3 +1,9 @@
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - agno = 0
          - agno = 1
          - agno = 2
          - agno = 3
@@ -39,6 +45,9 @@
          - process newly discovered inodes...
  Phase 4 - check for duplicate blocks...
          - setting up duplicate extent list...
+        - clear lost+found (if it exists) ...
+        - clearing existing "lost+found" inode
+        - marking entry "lost+found" to be deleted
          - check for inodes claiming duplicate blocks...
          - agno = 0
          - agno = 1
@@ -83,103 +92,13 @@
          - reset superblock...
  Phase 6 - check inode connectivity...
          - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
+        - ensuring existence of lost+found directory
+        - traversing filesystem starting at / ...
+rebuilding directory inode 128
+        - traversal finished ...
+        - traversing all unattached subtrees ...
+        - traversals finished ...
+        - moving disconnected inodes to lost+found ...
  Phase 7 - verify and correct link counts...

Best regards,
Erkki
