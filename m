Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F11EE7F3F
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 12:05:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC98B8F8040
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:05:22 -0700 (PDT)
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id PKjEIh7BJHWQqnTK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:05:18 -0700 (PDT)
Received: by mail-we0-f181.google.com with SMTP id k48so8698380wev.26
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 10:05:17 -0700 (PDT)
Received: from minas-tirith.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id ge8sm45952177wib.4.2014.08.11.10.05.15
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 11 Aug 2014 10:05:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id A2FC4185A7D
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 19:05:13 +0200 (CEST)
Date: Mon, 11 Aug 2014 19:05:00 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
In-Reply-To: <alpine.LSU.2.11.1408111657160.7326@minas-tirith.valinor>
Message-ID: <alpine.LSU.2.11.1408111843150.7326@minas-tirith.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<20140811144359.GA10217@laptop.bfoster>
	<alpine.LSU.2.11.1408111657160.7326@minas-tirith.valinor>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463779071-664183082-1407776713=:7326"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463779071-664183082-1407776713=:7326
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256



El 2014-08-11 a las 16:58 +0200, Carlos E. R. escribió:

> Ok, will do.
>
> I will create a backup of my partition, with xfsdump, after attempting
> repair of the partition, and reboot, and see (without the reformat cycle).
>
> At this instant I'm doing a full dd of the partition, just in case it
> becomes useful.

linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # xfs_repair -V
xfs_repair version 3.1.11

It is a live system, so I acan't update it. If I boot from the main 
system, that has a more modern xfs_repair, systemd will attempt mount and 
automated repair, and we will not get any logs.

linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # xfs_repair -v /dev/sdd5
Phase 1 - find and verify superblock...
         - block cache size set to 753952 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 65662 tail block 65607
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 #


linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # mount -v /dev/sdd5 mnt/
mount: /dev/sdd5 mounted on /run/media/linux/d_storage/xfs_disaster_home/20140811/mnt.
linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # umount mnt
linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 #

dmesg:

[10266.034290] XFS (sdd5): Mounting Filesystem
[10266.073739] XFS (sdd5): Starting recovery (logdev: internal)
[10266.690325] XFS (sdd5): Ending recovery (logdev: internal)
linux@linux:~>

dmesg --ctime

[Mon Aug 11 16:47:12 2014] XFS (sdd5): Mounting Filesystem
[Mon Aug 11 16:47:12 2014] XFS (sdd5): Starting recovery (logdev: internal)
[Mon Aug 11 16:47:12 2014] XFS (sdd5): Ending recovery (logdev: internal)
linux@linux:~>



linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 # xfs_repair -v /dev/sdd5
Phase 1 - find and verify superblock...
         - block cache size set to 753952 entries
Phase 2 - using internal log
         - zero log...
zero_log: head block 65700 tail block 65700
         - scan filesystem freespace and inode maps...
block (1,12608397-12608397) multiply claimed by cnt space tree, state - 2
agf_freeblks 27745492, counted 27745496 in ag 1
sb_fdblocks 115565042, counted 115565046
         - found root inode chunk
Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 2
         - agno = 1
         - agno = 3
         - agno = 0
Phase 5 - rebuild AG headers and trees...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - reset superblock...
Phase 6 - check inode connectivity...
         - resetting contents of realtime bitmap and summary inodes
         - traversing filesystem ...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

         XFS_REPAIR Summary    Mon Aug 11 16:48:08 2014

Phase		Start		End		Duration
Phase 1:	08/11 16:47:49	08/11 16:47:49 
Phase 2:	08/11 16:47:49	08/11 16:47:52	3 seconds
Phase 3:	08/11 16:47:52	08/11 16:48:07	15 seconds
Phase 4:	08/11 16:48:07	08/11 16:48:07 
Phase 5:	08/11 16:48:07	08/11 16:48:07 
Phase 6:	08/11 16:48:07	08/11 16:48:07 
Phase 7:	08/11 16:48:07	08/11 16:48:07

Total run time: 18 seconds
done
linux:/run/media/linux/d_storage/xfs_disaster_home/20140811 #


I don't understand all it says, but aparently it does not detect any 
problem.

dmesg doesn't have any more entries.


Now I'm going to create an xfsdump of it, and reboot, without rebuilding. 
Then I'll upload the metadata to google drive.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlPo98kACgkQja8UbcUWM1y78wD+MznL/4Ht53XAOw+CN/4ThhqQ
P4cN85akyVugU+T6zusA/313Z3PHezJe2oUTx1dFpQpV8Lf+LSgtlHVZ0M4xL+sz
=/iid
-----END PGP SIGNATURE-----
---1463779071-664183082-1407776713=:7326
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463779071-664183082-1407776713=:7326--
