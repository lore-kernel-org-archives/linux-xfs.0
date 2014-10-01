Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC9E57F5A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:23:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89850304070
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:23:18 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 13HYKZJtAregUHvu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 08:23:16 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0F439AD35
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:23:15 +0000 (UTC)
Date: Wed, 1 Oct 2014 17:23:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Test xfs/287 failure
Message-ID: <20141001152314.GH17405@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
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
To: xfs@oss.sgi.com


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  so after installing latest xfsdump (just pulled git repo at oss.sgi.com),
I'm getting failure in test xfs/287. The failure is:
xfs/287 2s ... 2s
_check_xfs_filesystem: filesystem on /dev/vdb2 is inconsistent (r) (see
/var/lib/xfstests/results//xfs/287.full)

And the 287.full has:
...
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
directory flags set on non-directory inode 133
directory flags set on non-directory inode 134
directory flags set on non-directory inode 133
would fix bad flags.
directory flags set on non-directory inode 134
would fix bad flags.
...

Complete file is attached. I'm using also the latest xfsprogs from git and
kernel 3.17.0-rc5 (plus couple of my patches but these should have no
influence).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="287.full"

meta-data=/dev/vdb2              isize=256    agcount=4, agsize=12800 blks
         =                       sectsz=512   attr=2, projid32bit=0
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=51200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=853, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
MOUNT_OPTIONS =  -o pquota
Setting up project 1234 (path /mnt-scratch/pquota/16bit)...
Processed 1 (/etc/projects and cmdline) paths for project 1234 with recursion depth infinite (-1).
xfs_quota: cannot set project on /mnt-scratch/pquota/32bit: Invalid argument
Setting up project 2123456789 (path /mnt-scratch/pquota/32bit)...
Processed 1 (/etc/projects and cmdline) paths for project 2123456789 with recursion depth infinite (-1).
writing all SBs
versionnum [0xb4e4+0x8a] = V4,NLINK,QUOTA,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
MOUNT_OPTIONS = -o pquota -o pquota
Setting up project 2123456789 (path /mnt-scratch/pquota/32bit)...
Processed 1 (/etc/projects and cmdline) paths for project 2123456789 with recursion depth infinite (-1).
/sbin/xfsdump: using file dump (drive_simple) strategy
/sbin/xfsdump: version 3.1.4 (dump format 3.0) - type ^C for status and control
/sbin/xfsdump: saving project quota information for: /mnt-scratch
/sbin/xfsdump: level 0 dump of kvm0:/mnt-scratch
/sbin/xfsdump: dump date: Wed Oct  1 13:48:40 2014
/sbin/xfsdump: session id: 318309cb-194a-4668-befa-a3a76c343a23
/sbin/xfsdump: session label: "label"
/sbin/xfsdump: ino map phase 1: constructing initial dump list
/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/sbin/xfsdump: ino map construction complete
/sbin/xfsdump: estimated dump size: 22080 bytes
/sbin/xfsdump: /var/lib/xfsdump/inventory created
/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/sbin/xfsdump: dumping ino map
/sbin/xfsdump: dumping directories
/sbin/xfsdump: dumping non-directory files
/sbin/xfsdump: ending media file
/sbin/xfsdump: media file size 22280 bytes
/sbin/xfsdump: dump size (non-dir files) : 0 bytes
/sbin/xfsdump: dump complete: 1 seconds elapsed
/sbin/xfsdump: Dump Summary:
/sbin/xfsdump:   stream 0 /tmp/28900.dump OK (success)
/sbin/xfsdump: Dump Status: SUCCESS
/sbin/xfsrestore: using file dump (drive_simple) strategy
/sbin/xfsrestore: version 3.1.4 (dump format 3.0) - type ^C for status and control
/sbin/xfsrestore: searching media for dump
/sbin/xfsrestore: examining media file 0
/sbin/xfsrestore: dump description: 
/sbin/xfsrestore: hostname: kvm0
/sbin/xfsrestore: mount point: /mnt-scratch
/sbin/xfsrestore: volume: /dev/vdb2
/sbin/xfsrestore: session time: Wed Oct  1 13:48:40 2014
/sbin/xfsrestore: level: 0
/sbin/xfsrestore: session label: "label"
/sbin/xfsrestore: media label: "media"
/sbin/xfsrestore: file system id: 22b25481-c3cc-40a8-aeae-ecfbf0698d57
/sbin/xfsrestore: session id: 318309cb-194a-4668-befa-a3a76c343a23
/sbin/xfsrestore: media id: 1cdf4371-50d9-4e9a-9484-5ae31c38f40b
/sbin/xfsrestore: using online session inventory
/sbin/xfsrestore: searching media for directory dump
/sbin/xfsrestore: reading directories
/sbin/xfsrestore: 2 directories and 4 entries processed
/sbin/xfsrestore: directory post-processing
/sbin/xfsrestore: restoring non-directory files
/sbin/xfsrestore: project quota information written to '/mnt-scratch/restore/xfsdump_quotas_proj'
/sbin/xfsrestore: use 'xfs_quota' to restore quotas
/sbin/xfsrestore: restore complete: 0 seconds elapsed
/sbin/xfsrestore: Restore Summary:
/sbin/xfsrestore:   stream 0 /tmp/28900.dump OK (success)
/sbin/xfsrestore: Restore Status: SUCCESS
Setting up project 2123456789 (path /mnt-scratch/restore/pquota/32bitv2)...
Processed 1 (/etc/projects and cmdline) paths for project 2123456789 with recursion depth infinite (-1).
_check_xfs_filesystem: filesystem on /dev/vdb2 is inconsistent
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
directory flags set on non-directory inode 133
directory flags set on non-directory inode 134
directory flags set on non-directory inode 133
would fix bad flags.
directory flags set on non-directory inode 134
would fix bad flags.
        - agno = 1
        - agno = 2
        - agno = 3
directory flags set on non-directory inode 786561
directory flags set on non-directory inode 786562
directory flags set on non-directory inode 786563
directory flags set on non-directory inode 786561
would fix bad flags.
directory flags set on non-directory inode 786562
would fix bad flags.
directory flags set on non-directory inode 786563
would fix bad flags.
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
directory flags set on non-directory inode 133
would fix bad flags.
directory flags set on non-directory inode 134
would fix bad flags.
        - agno = 1
        - agno = 2
        - agno = 3
directory flags set on non-directory inode 786561
would fix bad flags.
directory flags set on non-directory inode 786562
would fix bad flags.
directory flags set on non-directory inode 786563
would fix bad flags.
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output
*** mount output ***
/dev/vda on / type ext3 (rw,relatime,errors=continue,user_xattr,acl,barrier=1,data=ordered)
proc on /proc type proc (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,mode=1777)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620,ptmxmode=000)
/dev/vdb1 on /mnt type xfs (rw)
*** end mount output

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--/04w6evG8XlLl3ft--
