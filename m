Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM0LWCp028155 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 18:21:33 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7EC4269235
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:21:31 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	YlSXOQGKEyXzDuzi for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 16:21:31 -0800 (PST)
Received: by iaen33 with SMTP id n33so9311756iae.26
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:21:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
References: <CAF3hT9B8-ou-4RhfCkfFWTwwB_tb7nWSP-5pgP3G6oTE+1gAvA@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:21:30 -0800
Message-ID: <CAF3hT9AurrVi7xosauVmhQcsbqJgLsxkNYm6dWDNCpB+GR69=w@mail.gmail.com>
Subject: Re: EFSCORRUPTED on mount?
From: Gregory Farnum <gregory.farnum@dreamhost.com>
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
Cc: bpm@sgi.com

I lied a little bit =97 turns out an admin restarted the node with
reboot -fn. But I've been assured this shouldn't have been able to
corrupt the filesystem, so troubleshooting continues.

On Mon, Nov 21, 2011 at 2:13 PM, Ben Myers <bpm@sgi.com> wrote:
> Hey Greg,
>
> It might be useful if you can provide an xfs_metadump of the filesystem.
>
> xfs_metadump /dev/foo - | bzip2 > /tmp/foo.bz2
Sure. I posted it at ceph.newdream.net/sdg1.bz2
Thanks!

On Mon, Nov 21, 2011 at 1:52 PM, Emmanuel Florac <eflorac@intellique.com> w=
rote:
> xfs_check is mostly useless nowadays, use "xfs_repair -n" instead. At
> this stage, there's probably not much you can do but an "xfs_repair -L"
> to zero the log. Hope for the better.

oot@cephstore6358:~# xfs_repair -n /dev/sdg1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
block (1,7800040-7800040) multiply claimed by cnt space tree, state - 2
agf_freeblks 80672443, counted 80672410 in ag 1
sb_icount 64, counted 251840
sb_ifree 61, counted 66
sb_fdblocks 462898325, counted 358494731
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
data fork in ino 9434 claims free block 141395214
data fork in ino 9770 claims free block 142474809
data fork in ino 10212 claims free block 142638961
data fork in ino 11173 claims free block 142644317
data fork in ino 14117 claims free block 142411949
        - agno =3D 1
data fork in ino 2147485225 claims free block 142644284
data fork in ino 2147485241 claims free block 142465951
data fork in ino 2147486073 claims free block 142459130
data fork in ino 2147496267 claims free block 142411931
data fork in ino 2147497106 claims free block 142426585
data fork in ino 2147497824 claims free block 141402019
data fork in ino 2147502462 claims free block 142638996
data fork in ino 2150562849 claims free block 141404091
data fork in ino 2150562852 claims free block 141397795
data fork in ino 2150564343 claims free block 142644220
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
        - agno =3D 3
entry "inc\uosdmap.8818__0_A69FF397" at block 2 offset 2376 in
directory inode 2147484449 references free inode 2262318364
        would clear inode number in entry at offset 2376...
entry "inc\uosdmap.8817__0_A69FF2C7" at block 2 offset 2216 in
directory inode 377265 references free inode 2685370
        would clear inode number in entry at offset 2216...
entry "osdmap.8818__0_0A3E6C28" at block 2 offset 2056 in directory
inode 621643 references free inode 2685371
        would clear inode number in entry at offset 2056...
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "inc\uosdmap.8817__0_A69FF2C7" in directory inode 377265 points
to free inode 2685370, would junk entry
bad hash table for directory inode 377265 (no data entry): would rebuild
entry "osdmap.8818__0_0A3E6C28" in directory inode 621643 points to
free inode 2685371, would junk entry
bad hash table for directory inode 621643 (no data entry): would rebuild
bad hash table for directory inode 2147484441 (no leaf entry): would rebuild
entry "inc\uosdmap.8818__0_A69FF397" in directory inode 2147484449
points to free inode 2262318364, would junk entry
leaf block 8388608 for directory inode 2147484449 bad tail
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
would have reset inode 2685369 nlinks from 1 to 2
would have reset inode 2262318317 nlinks from 1 to 2
No modify flag set, skipping filesystem flush and exiting.

root@cephstore6358:~# xfs_repair /dev/sdg1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

root@cephstore6358:~# mount /dev/sdg1 /mnt/osd.17
2011 Nov 21 16:18:19 cephstore6358 [ 9989.033072] XFS: Internal error
XFS_WANT_CORRUPTED_GOTO at line 1664 of file fs/xfs/xfs_alloc.c.
Caller 0xffffffff811d6b71
2011 Nov 21 16:18:19 cephstore6358 [ 9989.033075]
2011 Nov 21 16:18:19 cephstore6358 [ 9989.053128] XFS (sdg1): Internal
error xfs_trans_cancel at line 1928 of file fs/xfs/xfs_trans.c.
Caller 0xffffffff811fa463
2011 Nov 21 16:18:19 cephstore6358 [ 9989.053130]
2011 Nov 21 16:18:19 cephstore6358 [ 9989.053215] XFS (sdg1):
Corruption of in-memory data detected.  Shutting down filesystem
2011 Nov 21 16:18:19 cephstore6358 [ 9989.053218] XFS (sdg1): Please
umount the filesystem and rectify the problem(s)
2011 Nov 21 16:18:19 cephstore6358 [ 9989.053226] XFS (sdg1): Failed
to recover EFIs
mount: Structure needs cleaning

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
