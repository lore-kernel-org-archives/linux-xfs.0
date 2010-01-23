Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0N4cfZI165473 for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 22:38:41 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52A2E185C36
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 20:39:42 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id IGfv1D4Azgv2DqVr for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2010 20:39:42 -0800 (PST)
Message-ID: <4B5A7D8E.3090001@sandeen.net>
Date: Fri, 22 Jan 2010 22:39:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Assistance needed mounting XFS version 1 filesystem
References: <f4da9efd1001220748i140ec49jddbb7098dddf4960@mail.gmail.com>
In-Reply-To: <f4da9efd1001220748i140ec49jddbb7098dddf4960@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: nerovid@gmail.com
Cc: xfs@oss.sgi.com

Jordan wrote:
> Hello,
> I have been trying to mount an old Maxoptix optical drive with
> XFS-formatted media for a week now without success.  From what I can
> tell, the media were formatted using XFS version 1, support for which
> was removed from the Linux kernel a few years back.
> 
> Here is the output of fdisk -l:
> Disk /dev/sda (SGI disk label): 64 heads, 32 sectors, 1096 cylinders
> Units = cylinders of 2048 * 512 bytes
> 
> ----- partitions -----
> Pt#     Device  Info     Start       End   Sectors  Id  System
>  1:  /dev/sda1  boot         2       986   2018340   a  SGI xfs
>  2:  /dev/sda2  swap       987      1096    224490   3  SGI raw
>  9:  /dev/sda3               0         1      2100   0  SGI volhdr
> 11:  /dev/sda4               0      1096   2244930   6  SGI volume
> ----- Bootinfo -----
> Bootfile: /unix
> ----- Directory Entries -----
>  0: sgilabel   sector    2 size     512
> 
> When I try to mount the /dev/sda1 partition, I get the following error:
> 
> # mount -t xfs /dev/sda1 /optical
> mount: block device /dev/sda1 is write-protected, mounting read-only
> mount: /dev/sda1: can't read superblock
> 
> # dmesg | tail
> Current sda: sense key Data Protect
> Additional sense: Write protected
> end_request: I/O error, dev sda, sector 1017642

Seems like this might be a real IO error... it's within the size
of sda1 (from above), and also within the filesystem geometry
(from db output below)

Maybe you can try creating a dd_rescue image of the fs, and mount that?

-Eric

> xfs_force_shutdown(sda1,0x1) called from line 353 of file
> fs/xfs/xfs_rw.c.  Return address = 0x44ff9bfa
> Filesystem "sda1": I/O Error Detected.  Shutting down filesystem: sda1
> Please umount the filesystem, and rectify the problem(s)
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0xf7dfe
>  ("xlog_bwrite") error 5 buf count 131072
> XFS: failed to locate log tail
> XFS: log mount/recovery failed
> XFS: log mount failed
> 
> xfs_check comes back with no errors.
> 
> # xfs_db /dev/sda1
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 252292
> rblocks = 0
> rextents = 0
> uuid = d4bc0c01-b21d-1001-866b-0800690a794d
> logstart = 131076
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 16
> agblocks = 31537
> agcount = 8
> rbmblocks = 0
> logblocks = 1000
> versionnum = 0x1
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 15
> rextslog = 0
> inprogress = 0
> imax_pct = 25
> icount = 704
> ifree = 322
> fdblocks = 122918
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 0
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
> xfs_db>
> 
> My running kernel is 2.6.5-1.358 on Fedora Core 2.  I went with an old
> distribution to try to find a kernel that still has XFS version 1
> support built in.
> 
> Any help or advice you could provide would be great.
> 
> Jordan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
