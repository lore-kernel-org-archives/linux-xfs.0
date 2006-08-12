Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Aug 2006 10:36:30 -0700 (PDT)
Received: from mail.automatix.de (www.automatix.de [213.131.230.237])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7CHaEDW021053
	for <linux-xfs@oss.sgi.com>; Sat, 12 Aug 2006 10:36:15 -0700
Received: from uucp by mail.automatix.de with local-bsmtp (Exim 3.36 #1)
	id 1GBoYk-00034D-00
	for linux-xfs@oss.sgi.com; Sat, 12 Aug 2006 10:09:30 +0200
Received: from pc2.s.automatix.de ([192.168.11.12])
	by s.automatix.de with esmtp (Exim 3.36 #1)
	id 1GBoML-0006In-00
	for linux-xfs@oss.sgi.com; Sat, 12 Aug 2006 09:56:41 +0200
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: juergen.sauer@automatix.de
Subject: Bug in xfsrestore or NFS+XFS Filesystem on NFS Server ? Can anyone confirm ?
Date: Sat, 12 Aug 2006 09:56:47 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200608120956.47466.juergen.sauer@automatix.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi!
Job to do: filesytem tranfer fom one raid to another / backup a server of 
about 1TB data and restore.

This Senario:
Server: Ubuntu 6.06 LTS + own xfs-fixed kernel 2.6.17.7
Backup: Ubuntu 6.06 LTS + own xfs-fixed kernel 2.6.17.7
Network 1Gbit Copper

xfsdumped server like this:
1. logged into the backup system 
1a. dumped the XFS Filesystem like that: 
> ssh server "xfsdump -l 0 -F -L transfer -M server_backup" - /dev/sdb1" >  /backup//backup/server_sdb1_xfsdump
Worked fine. Rsult was: 
-rw-rw-r-- 1 root root 568776542496 2006-08-10 15:16 /backup/backup-server_sdb1_xfsdump

But the ssh transfer has got an big overhead off cpu (comression, evcryption), so the dump
was not fast as expected, it took about 2 days.
So I decided to drop the overhead and to use a NFS link on the restore side.

2. Now I exchanged the old Hardware Raid on the server and started from Knoppix V5.01
(see: http://ftp.freenet.de/pub/ftp.uni-kl.de/pub/linux/knoppix/KNOPPIX_V5.0.1CD-2006-06-01-DE.iso
http://ftp.freenet.de/pub/ftp.uni-kl.de/pub/linux/knoppix/KNOPPIX_V5.0.1CD-2006-06-01-EN.iso)
Knoppix Booted using "knoppix 2"

2a. created anf formated partitions, sda1, sda2 (sda2 for swap, 4 GN or so. aktivated swap);
mounted the fresh XFS partiton to /mnt
2b. made NFS link to Backup server up (started portmap and mounted the backup:/backup/)

2c. started xfsrestore like that
xfsrestore -f /backup/backup-server_sda1_xfsdump /mnt/ 

After about a few hours xfsrestore quitted with a failure:  "Too much open files", Abort
The restore Process failed after ca. 66G of 500G.
OK, I raised the Kernel Openfile MAX, echo 524288 > /proc/sys/fs/file-max
and tried again.
xfsrestore -f /backup/backup-server_sda1_xfsdump /mnt/ 
Same error at same place.
Version was:  xfsrestore: version 2.2.36 (dump format 3.0)

Can s.o. confirm this ?

A working around was to use the much slower ssh pipe construct:
2d.
root@Knoppix[~]# ssh backup "dd if=/backup/backup-server_sda1_xfsdump bs=10M" | xfsrestore - /mnt/

This works.

Since that the last restore works, I think there is a bug in xfsrestore or xfs/nfs in the kernel 2.6.17.
Backupserver, Server, Knoppix are bugfixed 2.6.17(.7). Restoring the dump via nfs failed due "too much open files".

Does xfsrestore opens really 512k files ? I do not belive that. 
So It could a problem in Kernel  or NFS Stack be the problem.

Can any one confirm this behavior ? (to make it better next time)

Greetings from Northern Germany
	Jürgen Sauer

-- 
Jürgen Sauer - AutomatiX GmbH, +49-4209-4699, jojo@automatix.de
Das Linux Systemhaus - Service - Support - Server - Lösungen
http://www.automatix.de OpenOffice erhalten Sie hier kostenfrei 
http://de.openoffice.org/
