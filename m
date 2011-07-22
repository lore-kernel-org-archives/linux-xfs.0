Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M6xNiI069718 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 01:59:23 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 931631BD647A
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 23:59:21 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	skEXtWtY4TmBQrKF for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 23:59:21 -0700 (PDT)
Received: by iyf40 with SMTP id 40so1696952iyf.26
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 23:59:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
References: <CADDb1s3X5PANPrrz=GRZZyKmSK1=xiBQ8+zz3WNTW6xN=c80PQ@mail.gmail.com>
	<CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
Date: Fri, 22 Jul 2011 12:29:21 +0530
Message-ID: <CADDb1s2rcEvik3Tb4zooq93A6BSP+W9K87VdJEWLN9iHY1StMQ@mail.gmail.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Analysis of the logs using xfs_logprint =96 shows issues seems related
with the journaling and the data writeback.
Data for the file is being written first but the journal is not
consistent with that information.
Last committed transaction from the logs shows that =96 19492251 free
blocks are there in the allocation group. While the file which was
being written at the time of reset had =91255 blocks=92
___________________________________________________________________________=
_________
Allocation group length =3D 19492366
Free blocks =3D 19492251
Difference =3D 115 blocks (i.e., only 115 blocks from this allocation
group are used)
___________________________________________________________________________=
__________
----------------------------------------------------------------------------
Oper (472): tid: 92ae5cd0  len: 0  clientid: TRANS  flags: START
----------------------------------------------------------------------------
Oper (473): tid: 92ae5cd0  len: 16  clientid: TRANS  flags: none
TRAN:    type: DIOSTRAT       tid: 0       num_items: 4
----------------------------------------------------------------------------
Oper (474): tid: 92ae5cd0  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x84  flags: 0x5   dsize: 16
        blkno: 64  len: 16  boff: 1024
Oper (475): tid: 92ae5cd0  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100644 version 2 format 2
nlink 1 uid 0 gid 0
atime 0xc mtime 0xc ctime 0xc
size 0x65400 nblocks 0x67 extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x5
Oper (476): tid: 92ae5cd0  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (477): tid: 92ae5cd0  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1 (0x1)  len: 1  bmap size: 1  flags: 0x0
Oper (478): tid: 92ae5cd0  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF
ver: 1  seq#: 0  len: 19492366
root BNO: 1  CNT: 2
level BNO: 1  CNT: 1
1st: 0  last: 3  cnt: 4  freeblks: 19492251  longest: 19492251
----------------------------------------------------------------------------
Oper (479): tid: 92ae5cd0  len: 28  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 16 (0x10)  len: 8  bmap size: 2  flags: 0x0
Oper (480): tid: 92ae5cd0  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (481): tid: 92ae5cd0  len: 28  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 8 (0x8)  len: 8  bmap size: 2  flags: 0x0
Oper (482): tid: 92ae5cd0  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (483): tid: 92ae5cd0  len: 0  clientid: TRANS  flags: COMMIT
__________________________________________________________________________

After running repair on this disk after the issue is observed:
File size which was written =3D 1044480 bytes =3D 255 blocks

# xfs_repair -L /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
data fork in ino 132 claims free block 115
data fork in ino 132 claims free block 116
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
Done

# mount /dev/sdb1 /media/b
XFS mounting filesystem sda1

# ls =96l /media/b
-rwxr-xr-x    1 root     0                0 Jan  1 00:00 test_code
-rw-r--r--    1 root     0          1044480 Jan  1 00:00 direct_io_file_0

Please let me know if the observations are wrong. Also, this seems
very debatable issue =96 but is there any fix for this?

Thanks & Regards,
Amit Sahrawat


On Fri, Jul 22, 2011 at 10:53 AM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> More logs for xfs_log_print and xfs_repair.
>
> Thanks & Regards,
> Amit Sahrawat
>
> On Fri, Jul 22, 2011 at 10:22 AM, Amit Sahrawat
> <amit.sahrawat83@gmail.com> wrote:
>> Dear All,
>>
>> Target : ARM
>>
>> Recently I encountered a corruption on XFS for RC-3. While the
>> DIRECT-IO for a file was in operation (Write operation) there was a
>> power reset - Only one file at a time is being written to the disk
>> using DIO.. After reboot on mounting I just tried to remove the file
>> and encountered the below mentioned corruption. =A0The hard disk is not
>> able to mount after this, only after clearing logs (xfs_repair =96L) =96
>> disk is able to mount
>> XFS mounting filesystem sda1
>> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1535 of file
>> fs/xfs/xfs_alloc.c. =A0Caller 0xc0152c04
>> Backtrace:
>> [<c0023000>] (dump_backtrace+0x0/0x110) from [<c02dd680>] (dump_stack+0x=
18/0x1c)
>> =A0r6:00000000 r5:c0152c04 r4:00000075 r3:e3ec1c88
>> [<c02dd668>] (dump_stack+0x0/0x1c) from [<c0176bd0>]
>> (xfs_error_report+0x4c/0x5c)
>> [<c0176b84>] (xfs_error_report+0x0/0x5c) from [<c01510d4>]
>> (xfs_free_ag_extent+0x400/0x600)
>> [<c0150cd4>] (xfs_free_ag_extent+0x0/0x600) from [<c0152c04>]
>> (xfs_free_extent+0x8c/0xa4)
>> [<c0152b78>] (xfs_free_extent+0x0/0xa4) from [<c015ffa8>]
>> (xfs_bmap_finish+0x108/0x194)
>> =A0r7:e3ec1e10 r6:00000000 r5:e3737870 r4:e373e000
>> [<c015fea0>] (xfs_bmap_finish+0x0/0x194) from [<c017e840>]
>> (xfs_itruncate_finish+0x1dc/0x30c)
>> [<c017e664>] (xfs_itruncate_finish+0x0/0x30c) from [<c0197dc8>]
>> (xfs_inactive+0x20c/0x40c)
>> [<c0197bbc>] (xfs_inactive+0x0/0x40c) from [<c01a3da0>]
>> (xfs_fs_clear_inode+0x50/0x60)
>> =A0r9:e3ec0000 r8:c001f128 r7:00000000 r6:e4671a80 r5:c0312454
>> r4:e4667300
>> [<c01a3d50>] (xfs_fs_clear_inode+0x0/0x60) from [<c00bdd84>]
>> (clear_inode+0x8c/0xe8)
>> =A0r4:e4667420 r3:c01a3d50
>> [<c00bdcf8>] (clear_inode+0x0/0xe8) from [<c00be584>]
>> (generic_delete_inode+0xdc/0x178)
>> =A0r4:e4667420 r3:ffffffff
>> [<c00be4a8>] (generic_delete_inode+0x0/0x178) from [<c00be640>]
>> (generic_drop_inode+0x20/0x68)
>> =A0r5:00000000 r4:e4667420
>> [<c00be620>] (generic_drop_inode+0x0/0x68) from [<c00bd368>] (iput+0x6c/=
0x7c)
>> =A0r4:e4667420 r3:c00be620
>> [<c00bd2fc>] (iput+0x0/0x7c) from [<c00b4c40>] (do_unlinkat+0xfc/0x154)
>> =A0r4:e4667420 r3:00000000
>> [<c00b4b44>] (do_unlinkat+0x0/0x154) from [<c00b4cb0>] (sys_unlink+0x18/=
0x1c)
>> =A0r7:0000000a r6:00000000 r5:00000000 r4:be90299b
>> [<c00b4c98>] (sys_unlink+0x0/0x1c) from [<c001ef80>] (ret_fast_syscall+0=
x0/0x30)
>> xfs_force_shutdown(sda1,0x8) called from line 4047 of file
>> fs/xfs/xfs_bmap.c. =A0Return address =3D 0xc015ffec
>> Filesystem "sda1": Corruption of in-memory data detected. =A0Shutting
>> down filesystem: sda1
>> Please umount the filesystem, and rectify the problem(s)
>>
>> [root@localhost amits]# xfs_repair -n /dev/sdb1
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>> =A0 =A0 =A0 =A0- scan filesystem freespace and inode maps...
>> =A0 =A0 =A0 =A0- found root inode chunk
>> Phase 3 - for each AG...
>> =A0 =A0 =A0 =A0- scan (but don't clear) agi unlinked lists...
>> =A0 =A0 =A0 =A0- process known inodes and perform inode discovery...
>> =A0 =A0 =A0 =A0- agno =3D 0
>> data fork in ino 132 claims free block 115
>> data fork in ino 132 claims free block 116
>> =A0 =A0 =A0 =A0- agno =3D 1
>> =A0 =A0 =A0 =A0- agno =3D 2
>> =A0 =A0 =A0 =A0- agno =3D 3
>> =A0 =A0 =A0 =A0- process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>> =A0 =A0 =A0 =A0- setting up duplicate extent list...
>> =A0 =A0 =A0 =A0- check for inodes claiming duplicate blocks...
>> =A0 =A0 =A0 =A0- agno =3D 0
>> =A0 =A0 =A0 =A0- agno =3D 2
>> =A0 =A0 =A0 =A0- agno =3D 1
>> =A0 =A0 =A0 =A0- agno =3D 3
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>> =A0 =A0 =A0 =A0- traversing filesystem ...
>> =A0 =A0 =A0 =A0- traversal finished ...
>> =A0 =A0 =A0 =A0- moving disconnected inodes to lost+found ...
>> Phase 7 - verify link counts...
>> No modify flag set, skipping filesystem flush and exiting.
>> [root@localhost amits]#
>>
>> Please find the logs for xfs_logprint at the time of issue attached.
>>
>> If there was really corruption which is shown at the time of deletion
>> of file then why did the XFS file-system mounted? After checking the
>> blocks request being passed as free request =96 it showed that the at
>> the time of xfs_free_ag_extent() =96 the values from the tree fetched
>> are not correct =96 for blocks to the right of current file extent (may
>> be due to corruption) =96 is there anything written to xfs logs related
>> with this? So that at the mount time this thing can be taken care.
>>
>> Please let me know in case more information is required for this.
>>
>> Thanks & Regards,
>> Amit Sahrawat
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
