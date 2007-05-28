Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 May 2007 05:54:04 -0700 (PDT)
Received: from dh.localdomain (inn.nightwish.hu [217.20.130.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4SCrxWt011034
	for <xfs@oss.sgi.com>; Mon, 28 May 2007 05:54:01 -0700
From: Pallai Roland <dap@mail.index.hu>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Mon, 28 May 2007 14:53:55 +0200
References: <200705241318.30711.dap@mail.index.hu> <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan> <20070525000547.GH85884050@sgi.com>
In-Reply-To: <20070525000547.GH85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281453.55618.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Friday 25 May 2007 02:05:47 David Chinner wrote:
> "-o ro,norecovery" will allow you to mount the filesystem and get any
> uncorrupted data off it.
>
> You still may get shutdowns if you trip across corrupted metadata in
> the filesystem, though.
This filesystem is completely dead.

hq:~# mount -o ro,norecovery /dev/loop1 /mnt/r5
May 28 13:41:50 hq kernel: Mounting filesystem "loop1" in no-recovery mode.  
Filesystem will be inconsistent.
May 28 13:41:50 hq kernel: XFS: failed to read root inode

hq:~# xfs_db /dev/loop1
xfs_db: cannot read root inode (22)
xfs_db: cannot read realtime bitmap inode (22)
Segmentation fault

hq:~# strace xfs_db /dev/loop1
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, "XFSB\0\0\20\0\0\0\0\0\6\374\253\0\0\0\0\0\0\0\0\0\0\0\0"..., 512) = 
512
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 512, 
480141901312) = 512
pread(4, "\30G$L\203\33OE \256=\207@\340\264O\"\324\2074DY\323\6"..., 8192, 
131072) = 8192
write(2, "xfs_db: cannot read root inode ("..., 36xfs_db: cannot read root 
inode (22)
) = 36
pread(4, "\30G$L\203\33OE \256=\207@\340\264O\"\324\2074DY\323\6"..., 8192, 
131072) = 8192
write(2, "xfs_db: cannot read realtime bit"..., 47xfs_db: cannot read realtime 
bitmap inode (22)
) = 47
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++


Browsing with hexdump -C, seems like a part of a PDF file is at 128Kb, on the 
place of the root inode. :(


--
 d
