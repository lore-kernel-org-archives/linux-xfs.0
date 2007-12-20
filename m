Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 16:01:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBK01Zwv000939
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 16:01:38 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4498B78841
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 16:01:47 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id KKvotXyp1oZVz0el for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 16:01:47 -0800 (PST)
Date: Wed, 19 Dec 2007 18:01:44 -0600
Subject: mount prob: "log inconsistent or not a log"
Message-ID: <20071220000144.GQ19770@msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: Jonathan.Detert@msoe.edu
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I have an xfs filesystem that had been mounted and functioning for
several months.

An event (see [1] below) occurred which left me unable to mount the
file system.

The host o.s. is linux 2.6.20 (ubuntu server is the distribution).
Here's what I get:
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
root@quartz:/mnt # mount -t xfs -o defaults,_netdev /dev/sdb /usr/local/vms
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

root@quartz:/mnt #
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Note that it is an iscsi disk device (hence the '_netdev' mount option).
I tried the mount with and without the _netdev option.

This is what /var/log/messages has to say about the mount attempt:
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS mounting filesystem sdb
Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: Log inconsistent or not a log (last==0, first!=1)
Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: empty log check failed
Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: log mount/recovery failed: error 22
Dec 19 17:42:30 quartz kernel: [ 9701.960000] XFS: log mount failed
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

xfs_check is no help; it segfaults:
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
root@quartz:/mnt # xfs_check /dev/sdb
cache_node_purge: refcount was 1, not zero (node=0x80c2610)
xfs_check: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x80c4808)
xfs_check: cannot read realtime bitmap inode (22)
Segmentation fault
root@quartz:/mnt # 
-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

I tried to xfs_repair the file system.  xfs_repair returned without
noticable errors, and then I could mount the fs.  However, the fs was
basically empty - it just had a lost+found dir, with a subdir named
'128'.  This hierarchy repeated itself for several levels.  I stopped
looking after about the 4th level.

The fs is on an iscsi SAN.  I have daily snapshots of the SAN volume,
going back several days.  However, after connecting to the most recent
snapshot, I have the same problem - the same errors when trying to mount
the fs or xfs_check the fs.  I haven't tried to xfs_repair the
snapshotted fs, because I don't want the same thing to happen to the
snapshot.

Lastly, I don't know if this is significant or not, so I'll mention that
the iscsi disk device never had a partition table on it.  I just used
the raw disk device (e.g. /dev/sdb as opposed to /dev/sdb1, etc).

Any idea what to do?

Thanks

[1] the server 'quartz' lost its iscsi connection while the xfs file
system was in use.  After restoring the iscsi connection, quartz still
could not read the xfs file system.  I rebooted quartz, and attempted to
manually mount /dev/sdb, and got the error messages shown above.
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
Linus Torvalds once found a segmentation fault in the universe.
