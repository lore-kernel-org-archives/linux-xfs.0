Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 18:04:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P144TE014772
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:04:04 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C52933C87C0
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:05:26 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171]) by cuda.sgi.com with ESMTP id WfOCcTrGqGhMTusv for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:05:26 -0700 (PDT)
Date: Mon, 25 Aug 2008 03:05:24 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: agi unlinked bucket
In-Reply-To: <20080825003929.GN5706@disturbed>
Message-ID: <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de>
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de> <20080825003929.GN5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 25 Aug 2008, Dave Chinner wrote:
> If you do a mount then unmount then rerun xfs-check, does it go
> away?

Did that a few times already, and the fs is getting mounted during boot 
anyway, but xfs_check still complains:

--------------------------------------
# xfs_check /dev/mapper/md3 2>&1 | tee fsck_md3.log
agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
link count mismatch for inode 128 (name ?), nlink 335, counted 336
link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
# mount /mnt/md3
# dmesg | tail -2
  XFS mounting filesystem dm-3
  Ending clean XFS mount for filesystem: dm-3
# grep xfs /proc/mounts
/dev/mapper/md3 /mnt/md3 xfs ro,nosuid,nodev,noexec,nobarrier,noquota 0 0
--------------------------------------


The fs is ~138 GB in size. I shall run a backup and then just let 
xfs_repair have its way. I just thought you guys might have an idea what 
these messages are about and why mounting the fs (Thanks, Dave) does not 
seem to care.

Christian.

PS: Oh, I have:

#  zgrep _XFS /proc/config.gz
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set

# cat /proc/fs/xfs/stat
extent_alloc 49861 4503856 59412 3630353
abt 330869 3104741 117011 112751
blk_map 20948849 4520363 70729 4520363 70691 25570632 0
bmbt 9891 55289 3082 3852
dir 4844751 1337704 1509503 1036737
trans 0 3382656 12629
ig 3587165 210696 9 3376469 0 3299999 339798
log 342228 21840599 37111 18208 431
push_ail 3395311 0 22899 221180 5029793 934 97749 0 109 308
xstrat 13215 0
rw 953959 114144832
attr 105442 0 187 0
icluster 3519204 185118 2636028
vnodes 2 3379149 0 5676810 3379147 3379147 3379147 0
buf 18315811 8423133 9892813 4805 5035453 0 0 12242072 247641
xpc 18295668736 18285136116 146158324151
debug 0

-- 
BOFH excuse #452:

Somebody ran the operating system through a spelling checker.
