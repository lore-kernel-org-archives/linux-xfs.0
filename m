Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAPLnsRm009246
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 15:49:54 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF0E515F611D
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 13:49:52 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id BnT5e4nrHDVqVAIA for
	<linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 13:49:52 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.175.140.ip-pool.NEFkom.net [83.171.175.140])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E3B165ADD6
	for <linux-xfs@oss.sgi.com>; Tue, 25 Nov 2008 22:44:15 +0100 (CET)
From: Martin Steigerwald <Martin@Lichtvoll.de>
Subject: truncated files
Date: Tue, 25 Nov 2008 22:44:14 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811252244.14718.Martin@Lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-xfs@oss.sgi.com


Hi!

Today on one try to hibernate via tuxonice it machine appeared dead. I am 
not completely sure if it was. But I was in a hurry and had no time to 
try to ping or SSH it from a different machine and thus I just switched 
it off hard.

After booting again which worked fine, parts of my KDE configuration 
appeared broken. Color scheme and window position was lost. And KMail did 
not know how to sent out a mail anymore, all transports were missing.

Thus I checked my /home filesystem on /dev/sda5 this evening. It appeared 
absolutely fine with xfs_check and xfs_repair -n from xfsprogs 2.9.8 
(grml 2008.11rc).

But comparing some of the config files of KDE with the versions in my 
backup showed truncated files:

martin@shambhala:~> ls -l .kde-backup-2008-11-22/share/config/kmailrc
-rw------- 1 martin martin 247680 22. Nov 
18:29 .kde-backup-2008-11-22/share/config/kmailrc

martin@shambhala:~> ls -l .kde-broken-2008-11-25/share/config/kmailrc
-rw------- 1 martin martin 116902 25. Nov 
21:16 .kde-broken-2008-11-25/share/config/kmailrc

But no hole in it:

martin@shambhala:~> 
su -c "xfs_bmap -v .kde-broken-2008-11-25/share/config/kmailrc"
Passwort:
.kde-broken-2008-11-25/share/config/kmailrc:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET            TOTAL
   0: [0..231]:        22444768..22444999  0 (22444768..22444999)   232


Similar stuff happened on the encfs encrypted KDE user that I use for 
professional stuff - encfs is layered on top of XFS via FUSE:

shambhala:~ms> ls -l .kde-broken-2008-11-25/share/config/kdeglobals
-rw------- 1 ms teamix 4772 25. Nov 
20:35 .kde-broken-2008-11-25/share/config/kdeglobals
shambhala:~ms> ls -l .kde-backup-2008-11-22/share/config/kdeglobals
-rw------- 1 ms teamix 6621 18. Nov 
16:13 .kde-backup-2008-11-22/share/config/kdeglobals

Unfortunately I cannot check this one for holes directly as its on encfs:

shambhala:~ms> xfs_bmap -v .kde-broken-2008-11-25/share/config/kdeglobals
xfs_bmap: specified file 
[".kde-broken-2008-11-25/share/config/kdeglobals"] is not on an XFS 
filesystem

(Since encfs encrypted pathes as well and the file length may differ a 
bit, the encrypted file could be difficult to find... well maybe by 
date.)

And well my basket index was lost (http://basket.kde.org is a note taking 
application):

shambhala:~ms> 
ls -l .kde-backup-2008-11-22/share/apps/basket/baskets/baskets.xml
-rw-r--r-- 1 ms teamix 10271 18. Nov 
15:03 .kde-backup-2008-11-22/share/apps/basket/baskets/baskets.xml
shambhala:~ms> 
ls -l .kde-broken-2008-11-25/share/apps/basket/baskets/baskets.xml
-rw-r--r-- 1 ms teamix 1905 25. Nov 
13:24 .kde-broken-2008-11-25/share/apps/basket/baskets/baskets.xml



But since I found no holes in the other file and AFAIK the truncated file 
problem has long been solved - anyone has a idea, how this could have 
happened?

I fixed it by copying ~/.kde/share/config for my private user, and 
complete ~/.kde for my company user from the backup last weekend. In 
~/.kde/share/apps for the private too much has changed since the backup, 
thus for the moment I left it. I do not miss anything in there right now, 
but feel a tad bit uncomfortable that files might be truncated in there 
also and I might only find out later when I already worked with them for 
some time.

I thought that KDE maybe was writing those files at the moment. But its a 
bit wide-spread for that. And it must have happened that it wrote to 
config / app files on two user accounts. Might be the explaination, but I 
am not completely convinced.

I did not have seen a thing like this since at least a year I think.


This is with:

martin@shambhala:~> cat /proc/version
Linux version 2.6.27.7-tp42-toi-3.0-rc7a (martin@shambhala) (gcc version 
4.3.2 (Debian 4.3.2-1) ) #1 PREEMPT Mon Nov 24 11:30:39 CET 2008

I did not find anything cumbersone in /var/log/syslog... no XFS crash or 
something like this.


If no one has any idea I take this as really bad luck. Might really be 
that I turned off the machine while quite some KDE files were being 
written out. I know that some KDE applications make backups prior to 
overwriting. Maybe something could be improved in KDE applications. If 
so, I would be interested to hear and I would file bug reports with KDE.

Well actually thats my bet already. XFS appears to be fine.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
