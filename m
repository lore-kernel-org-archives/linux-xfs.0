Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1A547CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 04:59:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCE678F80B7
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 02:59:25 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id 2Hk7vkrK3uNGIygU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 May 2013 02:59:23 -0700 (PDT)
Received: by mail-pa0-f41.google.com with SMTP id rl6so4114384pac.0
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 02:59:23 -0700 (PDT)
MIME-Version: 1.0
From: Ole Tange <tange@binf.ku.dk>
Date: Fri, 24 May 2013 11:59:02 +0200
Message-ID: <CANU9nTnbA8WLK68X4yLFODiBZZgT4xX9U6fEmCHp+0+BMb6XQQ@mail.gmail.com>
Subject: Intermittent crashes - xfs_repair finds no errors
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I have a 50 TB file system that has crashed 4 times during the past
week. The filesystem runs on RAID, and the RAID is not complaining.
This leads me to believe it is not due to hardware error on the disks.

My guess is that the CPU has had a hiccup and that xfs somehow got
corrupted due to this. And now I cannot clean out the corruption.

Errors from syslog below.

I have tried:

# Do fsck on an overlay file so it is easy to revert if we get a nasty surprise
DEVICES=/dev/md3
parallel 'rm overlay-{/};truncate -s4000G overlay-{/}' ::: $DEVICES
parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f --show --
overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}'
::: $DEVICES
mount /dev/mapper/md3 /mnt/disk
umount /dev/mapper/md3
./xfsprogs-3.1.9/repair/xfs_repair /dev/mapper/md3
<<no serious problems reported>>
mount /dev/mapper/md3 /mnt/disk
ls /mnt/disk/lost+found
<<no files here>>
umount /mnt/disk
# Good: No nasty surprise. Dump the metadata
./xfsprogs-3.1.9/db/xfs_metadump.sh -o /dev/mapper/md3 - | pbzip2 >
xfs_dump_after_repair_3.1.9.bz2

# Cleanup the overlay file
parallel 'dmsetup remove {/}; rm overlay-{/}' ::: $DEVICES
parallel losetup -d ::: /dev/loop[0-9]*

# Do the fsck for real
mount /dev/md3 /mnt/disk
umount /dev/md3
./xfsprogs-3.1.9/repair/xfs_repair /dev/md3
<<no serious problems reported>>
mount /dev/md3 /mnt/disk
ls /mnt/disk/lost+found
<<no files here>>
umount /mnt/disk


/Ole


Dump after repair:
http://dna.ku.dk/~tange/xfs/xfs_dump_after_repair_3.1.9.bz2

# uname -a
Linux lemaitre 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
x86_64 GNU/Linux

May 13 11:43:31 lemaitre kernel: [507964.074856] XFS (md3): metadata
I/O error: block 0x18dcf8 ("xfs_trans_read_buf") error 5 buf count
4096
May 13 11:44:03 lemaitre kernel: [507996.306827] XFS (md3): metadata
I/O error: block 0x190a98 ("xfs_trans_read_buf") error 5 buf count
4096
May 13 11:44:14 lemaitre kernel: [508006.731931] XFS (md3): metadata
I/O error: block 0x1926b0 ("xfs_trans_read_buf") error 5 buf count
4096
[... filesystem still operational ...]
May 14 10:27:02 lemaitre kernel: [589775.551542] XFS (md3): metadata
I/O error: block 0x186f38 ("xfs_trans_read_buf") error 5 buf count
4096
May 14 10:27:29 lemaitre kernel: [589801.821276] XFS (md3): metadata
I/O error: block 0x18af68 ("xfs_trans_read_buf") error 5 buf count
4096
May 14 15:23:12 lemaitre kernel: [607544.768253] XFS (md3): metadata
I/O error: block 0x4aff80 ("xfs_trans_read_buf") error 5 buf count
4096
May 14 15:34:34 lemaitre kernel: [608227.324389] XFS (md3): metadata
I/O error: block 0x6563e8 ("xfs_trans_read_buf") error 5 buf count
4096
May 14 21:33:11 lemaitre kernel: [629744.136229] XFS (md3): metadata
I/O error: block 0x130a07a4a0 ("xfs_trans_read_buf") error 5 buf count
4096
May 14 21:33:11 lemaitre kernel: [629744.136324] XFS (md3):
xfs_do_force_shutdown(0x1) called from line 394 of file
/build/buildd-linux-2.6_3.2.4-1~bpo60+1-amd64-Ns0wYl/linux-2.6-3.2.4/debian/build/source_amd64_none/fs/xfs/xfs_trans_buf.c.
 Return address = 0xffffffffa049aead
May 14 21:33:12 lemaitre kernel: [629745.203860] XFS (md3): I/O Error
Detected. Shutting down filesystem
May 14 21:33:12 lemaitre kernel: [629745.203914] XFS (md3): Please
umount the filesystem and rectify the problem(s)
May 14 21:33:31 lemaitre kernel: [629763.936215] XFS (md3):
xfs_log_force: error 5 returned.
May 14 21:34:01 lemaitre kernel: [629794.016047] XFS (md3):
xfs_log_force: error 5 returned.
May 14 21:34:31 lemaitre kernel: [629824.096189] XFS (md3):
xfs_log_force: error 5 returned.

Filesystem offline here. Fsck run and remounted.

May 15 15:31:53 lemaitre kernel: [694466.016078] XFS (md3):
xfs_log_force: error 5 returned.
May 15 15:31:54 lemaitre kernel: [694467.551968] XFS (md3):
xfs_log_force: error 5 returned.
May 15 15:31:54 lemaitre kernel: [694467.551978] XFS (md3):
xfs_do_force_shutdown(0x1) called from line 1033 of file
/build/buildd-linux-2.6_3.2.4
-1~bpo60+1-amd64-Ns0wYl/linux-2.6-3.2.4/debian/build/source_amd64_none/fs/xfs/xfs_buf.c.
 Return address = 0xffffffffa0453fc3
May 15 15:32:18 lemaitre kernel: [694490.937571] XFS (md3):
xfs_log_force: error 5 returned.
May 15 15:32:18 lemaitre kernel: [694490.939155] XFS (md3):
xfs_log_force: error 5 returned.
May 15 15:39:02 lemaitre kernel: [694895.438967] device-mapper:
uevent: version 1.0.3

Filesystem offline here. Fsck run and remounted.


May 15 15:58:18 lemaitre kernel: [696050.756430] XFS (md3): Mounting Filesystem
May 15 15:58:18 lemaitre kernel: [696051.044107] XFS (md3): Starting
recovery (logdev: internal)
May 15 15:58:19 lemaitre kernel: [696052.068526] XFS (md3): Ending
recovery (logdev: internal)
May 15 16:06:52 lemaitre kernel: [696564.817562] XFS (md3): Mounting Filesystem
May 15 16:06:52 lemaitre kernel: [696565.459025] XFS (md3): Ending clean mount
May 15 16:07:00 lemaitre kernel: [696573.319085] XFS (md3): Mounting Filesystem
May 15 16:07:00 lemaitre kernel: [696573.500547] XFS (md3): Ending clean mount
May 15 16:13:41 lemaitre kernel: [696974.019574] NFSD: Using
/var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 15 16:13:41 lemaitre kernel: [696974.028698] NFSD: starting
90-second grace period
May 15 20:28:12 lemaitre kernel: [712245.349494] XFS (md3): metadata
I/O error: block 0x338eb0 ("xfs_trans_read_buf") error 5 buf count
4096
May 15 20:29:43 lemaitre kernel: [712335.934214] XFS (md3): metadata
I/O error: block 0x17bb08 ("xfs_trans_read_buf") error 5 buf count
4096
May 15 20:30:27 lemaitre kernel: [712380.590518] XFS (md3): metadata
I/O error: block 0x52f5b0 ("xfs_trans_read_buf") error 5 buf count
4096
May 15 20:30:51 lemaitre kernel: [712404.002788] XFS (md3): metadata
I/O error: block 0x50a8a0 ("xfs_trans_read_buf") error 5 buf count
4096
May 15 20:42:27 lemaitre kernel: [713100.456611] XFS (md3): metadata
I/O error: block 0x1f7a30 ("xfs_trans_read_buf") error 5 buf count
4096

May 16 05:32:29 lemaitre kernel: [744902.528045] [Hardware Error]:
CPU:24       MC4_STATUS[-|CE|MiscV|-|AddrV|CECC]: 0x9d404433001c011b
May 16 05:32:29 lemaitre kernel: [744902.528141] [Hardware Error]:
 MC4_ADDR: 0x00000031acadd6fc
May 16 05:32:29 lemaitre kernel: [744902.528190] [Hardware Error]:
Northbridge Error (node 1): L3 ECC data cache error.
May 16 05:32:29 lemaitre kernel: [744902.528274] [Hardware Error]:
cache level: L3/GEN, tx: GEN, mem-tx: RD
( This CPU hiccup error may or may not be related to the xfs error )

May 16 06:31:11 lemaitre kernel: [748424.640189] XFS (md3): metadata
I/O error: block 0x10f50 ("xfs_trans_read_buf") error 5 buf count 4096
May 16 06:34:08 lemaitre kernel: [748600.981856] XFS (md3): metadata
I/O error: block 0x1abe8 ("xfs_trans_read_buf") error 5 buf count 4096
May 16 06:37:28 lemaitre kernel: [748801.549961] XFS (md3): metadata
I/O error: block 0x8d2a1a10 ("xfs_trans_read_buf") error 5 buf count
4096
May 16 06:43:40 lemaitre kernel: [749173.254919] XFS (md3): metadata
I/O error: block 0x1214d8 ("xfs_trans_read_buf") error 5 buf count
4096
[...]
May 16 12:24:38 lemaitre kernel: [769631.380902] XFS (md3): metadata
I/O error: block 0x186360 ("xfs_trans_read_buf") error 5 buf count
4096
May 16 12:24:39 lemaitre kernel: [769632.453609] XFS (md3): metadata
I/O error: block 0x1862d0 ("xfs_trans_read_buf") error 5 buf count
4096
May 16 15:26:01 lemaitre kernel: [780514.048738] idba_ud[17842]:
segfault at 0 ip 000000000040bcc6 sp 00007fff1a6ad000 error 4 in
idba_ud[400000+c7000]
May 16 17:29:29 lemaitre kernel: [787921.801014] XFS (md3): metadata
I/O error: block 0x140c507bf8 ("xfs_trans_read_buf") error 5 buf count
4096
May 16 17:29:29 lemaitre kernel: [787921.801138] XFS (md3): page
discard on page ffffea00ddeeb9d0, inode 0xa301b6, offset 0.
May 16 17:29:29 lemaitre kernel: [787921.826000] XFS: Internal error
XFS_WANT_CORRUPTED_RETURN at line 341 of file
/build/buildd-linux-2.6_3.2.4-1~bpo60+1-amd64-Ns0wYl/linux-2.6-3.2.4/debian/build/source_amd64_none/fs/xfs/xfs_alloc.c.
 Caller 0xffffffffa04679e6
May 16 17:29:29 lemaitre kernel: [787921.826005]

Filesystem offline here. Fsck run and remounted.

May 22 02:57:07 lemaitre kernel: [1253980.123621] XFS (md3): metadata
I/O error: block 0x50a0f4e10 ("xfs_trans_read_buf") error 5 buf count
4096
May 22 02:57:07 lemaitre kernel: [1253980.123741] XFS (md3): page
discard on page ffffea00a3ee6df8, inode 0xdeb24f, offset 4194304.
May 22 05:27:28 lemaitre kernel: [1263001.003821] XFS (md3): metadata
I/O error: block 0xd0cd54fe0 ("xfs_trans_read_buf") error 5 buf count
4096
May 22 05:27:28 lemaitre kernel: [1263001.003919] XFS (md3):
xfs_do_force_shutdown(0x1) called from line 394 of file
/build/buildd-linux-2.6_3.2.4-1~bpo60+1-amd64-Ns0wYl/linux-2.6-3.2.4/debian/build/source_amd64_none/fs/xfs/xfs_trans_buf.c.
 Return address = 0xffffffffa049aead
May 22 05:27:29 lemaitre kernel: [1263002.295623] XFS (md3): I/O Error
Detected. Shutting down filesystem
May 22 05:27:29 lemaitre kernel: [1263002.295679] XFS (md3): Please
umount the filesystem and rectify the problem(s)

Filesystem offline here. Fsck run and remounted.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
