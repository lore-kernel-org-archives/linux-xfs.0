Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A026429E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:38:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85C21304039
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:38:32 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	eWOQz4b69P9z0v1J (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 14:38:31 -0800 (PST)
Received: by mail-ob0-f172.google.com with SMTP id gq1so2638444obb.17
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:38:30 -0800 (PST)
Message-ID: <528A96DC.30205@gmail.com>
Date: Mon, 18 Nov 2013 17:38:20 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/11] xfs: introduce the free inode btree
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
	<52894685.8080603@gmail.com>
In-Reply-To: <52894685.8080603@gmail.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 11/17/2013 05:43 PM, Michael L. Semon wrote:
> On 11/13/2013 09:36 AM, Brian Foster wrote:
>> Hi all,
>>
>> The free inode btree adds a new inode btree to XFS with the intent to
>> track only inode chunks with at least one free inode. Patches 1-3 add
>> the necessary support for the new XFS_BTNUM_FINOBT type and introduce a
>> read-only v5 superblock flag. Patch 4 updates the transaction
>> reservations for inode allocation operations to account for the finobt.
>> Patches 5-9 add support to manage the finobt on inode chunk allocation,
>> inode allocation, inode free (and chunk deletion) and growfs. Patch 10
>> adds support to report finobt status in the fs geometry. Patch 11 adds
>> the feature bit to the associated mask. Thoughts, reviews, flames
>> appreciated.
>>
>> Brian

This is more data, but it doesn't seem to be noise.  No reply is needed, 
though.  I'm only guessing that finobt has a role in this day.  It looks 
like something quota got everything started...

I think I got through 4k blocksize testing OK.  However, disaster loomed 
after I switched to a 2k block size (again ~2.2-GB md RAID-0 partitions):

root@plbearer:/var/lib/xfstests# MKFS_OPTIONS='-m crc=1 -m finobt=1 -b log=11' ./check -g auto
[  203.967784] XFS (md127): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  203.967784] Use of these features in this kernel is at your own risk!
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 plbearer 3.12.0+
MKFS_OPTIONS  -- -f -m crc=1 -m finobt=1 -b log=11 /dev/md126
MOUNT_OPTIONS -- /dev/md126 /mnt/xfstests-scratch

# This run started in sequence with generic/001.

generic/231 1074s ...[ 7434.717194] BUG: unable to handle kernel paging request at dd3fc000
[ 7434.717315] IP: [<c13dd9b4>] memcpy+0x14/0x24
[ 7434.717315] *pde = 1fbf0067 *pte = 1d3fc060 
[ 7434.717315] Oops: 0000 [#1] DEBUG_PAGEALLOC

Entering kdb (current=0xde8ae4f0, pid 27666) Oops: (null)
due to oops @ 0xc13dd9b4
CPU: 0 PID: 27666 Comm: xfs_quota Not tainted 3.12.0+ #2
Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
task: de8ae4f0 ti: dd01c000 task.ti: dd01c000
EIP: 0060:[<c13dd9b4>] EFLAGS: 00010206 CPU: 0
EIP is at memcpy+0x14/0x24
EAX: d88e1868 EBX: 0000005c ECX: 00000001 EDX: dd3fbfa8
ESI: dd3fc000 EDI: d88e18c0 EBP: dd01de38 ESP: dd01de2c
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
CR0: 8005003b CR2: dd3fc000 CR3: 1eb43000 CR4: 000007d0
Stack:
 d88e185c 00000000 d88e1868 dd01de50 c12aa415 d88e1840 dd3fbf60 de71b8f0
 00000000 dd01deb4 c12aad31 c0098d00 dd01de90 00000084 d9008540 dd01decc
 00253b60 de635634 de635600 da71d000 00000084 de71ba00 d88e1840 de635600
Call Trace:
 [<c12aa415>] xlog_cil_lv_item_format+0x45/0x68
 [<c12aad31>] xfs_log_commit_cil+0x452/0x4e7
 [<c1253408>] xfs_trans_commit+0xac/0x230
 [<c12b5ef5>] xfs_qm_log_quotaoff_end+0x60/0x7b
 [<c12b7206>] xfs_qm_scall_quotaoff+0x120/0x48a
 [<c12bbfde>] ? xfs_fs_get_xstatev+0x27/0x27
 [<c12bc09e>] xfs_fs_set_xstate+0xc0/0xe1
 [<c1130639>] SyS_quotactl+0x4cd/0x564
 [<c10e68cb>] ? SyS_stat64+0x34/0x3a
 [<c162dcfb>] ? restore_all+0xf/0xf
 [<c1025910>] ? vmalloc_sync_all+0x133/0x133
 [<c1062418>] ? trace_hardirqs_on_caller+0xe6/0x1aa
 [<c162e53f>] sysenter_do_call+0x12/0x36
Code: 00 74 0c 8b 43 54 2b 43 50 88 43 4e 5b 5d c3 e8 a8 fc ff ff eb ed 90 55 89 e5 57 56 53 3e 8d 74 26 00 89 cb c1 e9 02 89 c7 89 d6 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 55 89 e5 57 53

This is not the disaster, only a test that did not complete.  After a 
successful reboot, I tried to run generic/231 again, only to have my 
non-finobt v5/CRC XFS / filesystem bark at me:

root@plbearer:/var/lib/xfstests# MKFS_OPTIONS='-m crc=1 -m finobt=1 -b log=11' ./check generic/231

[  392.914511] XFS (md127): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  392.914511] Use of these features in this kernel is at your own risk!
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 plbearer 3.12.0+
MKFS_OPTIONS  -- -f -m crc=1 -m finobt=1 -b log=11 /dev/md126
MOUNT_OPTIONS -- /dev/md126 /mnt/xfstests-scratch

[  396.616456] XFS (md126): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  396.616456] Use of these features in this kernel is at your own risk!
[  398.271753] XFS (md127): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  398.271753] Use of these features in this kernel is at your own risk!
generic/231 1074s ...[  403.133309] XFS (md126): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  403.133309] Use of these features in this kernel is at your own risk!
[  620.702535] XFS (md126): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
[  620.702535] Use of these features in this kernel is at your own risk!
[  621.430480] dc8ff000: 41 42 33 42 00 00 01 45 ff ff ff ff ff ff ff ff  AB3B...E........
[  621.438646] dc8ff010: 00 00 00 00 00 00 00 08 00 00 00 61 00 01 1c 77  ...........a...w
[  621.446751] dc8ff020: dd 91 0c 6a 2e c4 49 3a ac a9 79 89 72 a4 a9 ce  ...j..I:..y.r...
[  621.454856] dc8ff030: 00 00 00 00 fb b2 9e 73 00 00 04 ff 00 00 00 01  .......s........
[  621.462964] XFS (sdb3): Internal error xfs_allocbt_read_verify at line 362 of file fs/xfs/xfs_alloc_btree.c.  Caller 0xc1237c47
[  621.474781] XFS (sdb3): Corruption detected. Unmount and run xfs_repair
[  621.482296] XFS (sdb3): metadata I/O error: block 0x8 ("xfs_trans_read_buf_map") error 117 numblks 8
[  621.522828] XFS (sdb3): Corruption of in-memory data detected.  Shutting down filesystem
[  621.531070] XFS (sdb3): Please umount the filesystem and rectify the problem(s)
./check: line 145: /usr/bin/awk: Input/output error
./check: line 145: date: command not found
./check: line 461: /tmp/965.rawout: Input/output error
./check: line 462: /usr/bin/rm: Input/output error
 [failed, exit status 1] - no qualified output
./check: line 527: expr: command not found
./check: line 533: expr: command not found
./common/rc: line 849: /usr/bin/awk: Input/output error
./common/rc: line 849: sed: command not found
./common/rc: line 774: /usr/bin/awk: Input/output error
./common/rc: line 1532: grep: command not found
./common/rc: line 1532: tee: command not found
_check_xfs_filesystem: filesystem on /dev/md127 has dirty log (see /var/lib/xfstests/results//generic/231.full)
./common/rc: line 1537: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1538: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1539: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1540: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1550: /tmp/965.fs_check: Input/output error
./common/rc: line 1564: /tmp/965.repair: Input/output error
_check_xfs_filesystem: filesystem on /dev/md127 is inconsistent (r) (see /var/lib/xfstests/results//generic/231.full)
./common/rc: line 1569: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1570: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1571: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1571: /usr/bin/cat: Input/output error
./common/rc: line 1572: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1576: /usr/bin/rm: Input/output error
./common/rc: line 1580: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1581: /var/lib/xfstests/results//generic/231.full: Input/output error
./common/rc: line 1582: /var/lib/xfstests/results//generic/231.full: Input/output error
./check: line 320: /var/lib/xfstests/results//check.log: Input/output error
./check: line 321: /var/lib/xfstests/results//check.log: Input/output error
./check: line 322: /var/lib/xfstests/results//check.log: Input/output error
./check: line 322: fmt: command not found
./check: line 323: /var/lib/xfstests/results//check.log: Input/output error
./check: line 325: [: too many arguments
./check: line 336: [: too many arguments
Passed all  tests
./check: line 344: /var/lib/xfstests/results//check.log: Input/output error
./check: line 349: /usr/bin/rm: Input/output error
./check: line 350: /usr/bin/rm: Input/output error
root@plbearer:/var/lib/xfstests# ls
-bash: /bin/ls: Input/output error

There was a trace in my logs that was probably from the same event but had 
more detail:

Nov 18 08:14:53 plbearer kernel: [  621.127588] XFS (md126): Quotacheck needed: Please wait.
Nov 18 08:14:54 plbearer kernel: [  621.210188] XFS (md126): Quotacheck: Done.
Nov 18 08:14:54 plbearer kernel: [  621.210188] XFS (md126): Quotacheck: Done.
Nov 18 08:14:54 plbearer [  621.430480] dc8ff000: 41 42 33 42 00 00 01 45 ff ff ff ff ff ff ff ff  AB3B...E........ 
Nov 18 08:14:54 plbearer [  621.438646] dc8ff010: 00 00 00 00 00 00 00 08 00 00 00 61 00 01 1c 77  ...........a...w 
Nov 18 08:14:54 plbearer [  621.446751] dc8ff020: dd 91 0c 6a 2e c4 49 3a ac a9 79 89 72 a4 a9 ce  ...j..I:..y.r... 
Nov 18 08:14:54 plbearer [  621.454856] dc8ff030: 00 00 00 00 fb b2 9e 73 00 00 04 ff 00 00 00 01  .......s........ 
Nov 18 08:14:54 plbearer [  621.462964] XFS (sdb3): Internal error xfs_allocbt_read_verify at line 362 of file fs/xfs/xfs_alloc_btree.c.  Caller 0xc1237c47 
Nov 18 08:14:54 plbearer [  621.474781] XFS (sdb3): Corruption detected. Unmount and run xfs_repair 
Nov 18 08:14:54 plbearer [  621.482296] XFS (sdb3): metadata I/O error: block 0x8 ("xfs_trans_read_buf_map") error 117 numblks 8 
Nov 18 08:14:54 plbearer kernel: [  621.491567] XFS (sdb3): xfs_do_force_shutdown(0x8) called from line 138 of file fs/xfs/xfs_bmap_util.c.  Return address = 0xc1232e5d
Nov 18 08:14:54 plbearer kernel: [  621.491567] XFS (sdb3): xfs_do_force_shutdown(0x8) called from line 138 of file fs/xfs/xfs_bmap_util.c.  Return address = 0xc1232e5d
Nov 18 08:14:54 plbearer [  621.522828] XFS (sdb3): Corruption of in-memory data detected.  Shutting down filesystem 
Nov 18 08:14:54 plbearer [  621.531070] XFS (sdb3): Please umount the filesystem and rectify the problem(s) 

After an unsuccessful attempt to reboot to that / partition, I rebooted to 
an alternate (JFS) / setup.  Note that write caches are off on this PC, so 
it was a surprise that the log recovery did not complete for the v5 XFS / 
partition.  xfs_repair was run, and the following mount was fine on what 
was probably a non-finobt kernel:

root@plbearer:~# xfs_repair -L /dev/sdb3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
xfs_agf_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
xfs_allocbt_read_verify: XFS_CORRUPTION_ERROR
sb_ifree 1842, counted 1817
sb_fdblocks 513939, counted 513840
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
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

The v5 XFS / was xfsdump'ed without issue.  No harm, no foul.  But it does 
mean I'll have to take a step back from finobt for the moment, taking the 
time to re-bisect my AIO issues so I can file another bug report about them.

Thanks for reading!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
