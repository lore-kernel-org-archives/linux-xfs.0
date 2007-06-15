Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 09:04:49 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FG4jWt001110
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 09:04:46 -0700
Received: from localhost (dslb-084-056-065-071.pools.arcor-ip.net [84.56.65.71])
	by mail.lichtvoll.de (Postfix) with ESMTP id 5A2015AD57
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 18:04:45 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: xfs_fsr - problem with open files possible?
Date: Fri, 15 Jun 2007 18:04:42 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151804.43067.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi!

I ran xfs_fsr on my laptops some time ago, for example on my partition 
which holds /home. This seemed to work quite well:

---------------------------------------------------------------------
shambala:~> xfs_db -c frag -f /dev/sda2
actual 777855, ideal 737681, fragmentation factor 5.16%
shambala:~> xfs_fsr /dev/sda2
/home start inode=0
shambala:~> xfs_db -c frag -f /dev/sda2
actual 744809, ideal 737681, fragmentation factor 0.96%
shambala:~> xfs_fsr /dev/sda2
/home start inode=0
shambala:~> xfs_db -c frag -f /dev/sda2
actual 744809, ideal 737681, fragmentation factor 0.96%
---------------------------------------------------------------------

As discussed before here there is a limit in what xfs_fsr can do and it 
didn't come below 0.96% fragmentation even though the partition has 
several GB of free space.

As I restarted KMail after fragmenting it however told me about some 
broken indexes. KMail stores index for folders in files. It was able to 
restore the indexes.

I can not pinpoint this problem to the defragmentation with xfs_fsr, but 
it seemed more than a coincidence to me that it happened directly after I 
restarted KMail after the defragmentation.

KMail was running while the fragmentation was taking place and well it 
likely had some index files opened. At least it does now that I am 
writing that mail:

---------------------------------------------------------------------
shambala:~> lsof +D /home/martin/Mail
COMMAND  PID   USER   FD   TYPE DEVICE   SIZE      NODE NAME
kontact 2787 martin  mem    REG    8,2 280837 
223046853 /home/martin/Mail/.Lichtvoll.directory/.KDE.index
kontact 2787 martin  mem    REG    8,2     33 
119177542 /home/martin/Mail/.templates.index
kontact 2787 martin  mem    REG    8,2     33 
120665290 /home/martin/Mail/.drafts.index
kontact 2787 martin   18u   REG    8,2 280837 
223046853 /home/martin/Mail/.Lichtvoll.directory/.KDE.index
kontact 2787 martin   19u   REG    8,2     33 
120665290 /home/martin/Mail/.drafts.index
kontact 2787 martin   20u   REG    8,2     33 
119177542 /home/martin/Mail/.templates.index
---------------------------------------------------------------------

Could data loss happen when running xfs_fsr on files that are opened by an 
application?

I did not came across any other corrupted files except a Mercurial 
repository. I can not pinpoint this problem to XFS at all and have no 
idea how and when it got corrupted. At least in my backup from some weeks 
ago the repository has been okay. Unfortunately I do not know anymore 
whether I made a commit to that repository while xfs_fsr was running or 
not. But I think I didn't.

The filesystem itself was okay after fragmentation, I checked it via 
xfs_check!

I can try to reproduce the problem. Would be handy tough to have an 
xfs_fsr that can be limited only to operate on a certain directory and 
its files and sub directories. This way I could create a new mailfolder, 
copy some mails in there, have it opened so that KMail accesses the index 
file and let xfs_fsr only run on this mailfolder.

I can also open a bug report, but I first wanted to ask here.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
