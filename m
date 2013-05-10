Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 835C529DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 21:00:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19C7CAC013
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 19:00:26 -0700 (PDT)
Received: from mail-gh0-f177.google.com (mail-gh0-f177.google.com
	[209.85.160.177]) by cuda.sgi.com with ESMTP id
	DSVUVVLIi44SO2Ey (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 19:00:24 -0700 (PDT)
Received: by mail-gh0-f177.google.com with SMTP id f20so799095ghb.8
	for <xfs@oss.sgi.com>; Thu, 09 May 2013 19:00:24 -0700 (PDT)
Message-ID: <518C54AA.7070908@gmail.com>
Date: Thu, 09 May 2013 22:00:10 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
	<20130509072045.GO24635@dastard>
In-Reply-To: <20130509072045.GO24635@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/09/2013 03:20 AM, Dave Chinner wrote:
> On Thu, May 09, 2013 at 01:16:46PM +1000, Dave Chinner wrote:
>> On Wed, May 08, 2013 at 10:24:25PM -0400, Michael L. Semon wrote:
>>> Hi!  I'm trying to come up with a series of ramblings that may or
>>> may not be useful in a mailing-list context, with the idea that one
>>> bug report might be good, the next might be me thinking aloud with
>>> data in hand because I know something's wrong but can't put my
>>> finger on it.  An ex-girlfriend saw the movie "Rain Man" years ago
>>> pointed to the screen and said, "Do you see that guy?  That's you!"
>>> If only I could be so smart...or act as well as Dustin Hoffman.  The
>>> noisy thinking is there, just not the brilliant insights...
>>>
>>> This report is to pass on a kernel lock detector message that might
>>> be reproducible under a certain family of tests.  generic/230 may
>>> not be at fault, it's just where the detector went off.
>>
>> No, there's definitely a bug there. Thanks for the report, Michael.
>> Try the patch below.
>
> Actaully, there's a bug in the error handling in that version - it
> fails to unlock the quotaoff lock properly on failure. The version
> below fixes that problem.
>
> Cheers,
>
> Dave.

OK, I'll try this version as well.  The first version seemed to work 
just fine.

The rest of the letter has been shortened from a more detailed review to 
a casual one with a scripted run of xfstests at the end.  If nothing 
else, it shows a) a dir3 function in a stack trace on a non-CRC 
filesystem, b) loggen might need to be installed in the `make install` 
version of xfstests, c) your previous-run-times feature has been 
restored, and d) a pwrite64 "file too large" may or may not be there 
because J. Liu's bitness patches are doing their jobs.

Good luck!

Michael

Original review (reduced):

As far as logical testing goes, your fix works well.  Without your 
patch, I got the original lockdep message, and the situation was 
replicated by issuing a `du -sx /` while xfstests xfs/054 was running. 
With your patch, all seems well for things that mention quotas.

The lock detector went off once more, but that was after attempting to 
merge a 2013-05-08 kernel git with xfs-oss/master of the same vintage, 
then apply my normal patches and your original quota lockdep fix.

Hardware change:  Because `git commit` caused XFS to emit the message 
"XFS: possible memory allocation deadlock in xfs_buf_allocate_memory 
(mode:0x250)" a few times, RAM was increased to 256 MB.  The merge was 
reworked by restoring the git from a backup tarball and doing the 
merge-and-patch session again.

Script started on Thu May  9 16:00:28 2013
cu -t -l /dev/ttyu0 -s 115200
Connected
# Note: lm256 is a local group
root@oldsvrhw:/var/lib/xfstests# ./check -xfs -g lm256
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 oldsvrhw 3.9.0+
MKFS_OPTIONS  -- -f -llogdev=/dev/sda7 -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- -ologdev=/dev/sda7 /dev/sdb6 /mnt/xfstests-scratch

xfs/003 1s ... 2s
xfs/004 8s ... 8s
xfs/008 5s ... 5s
xfs/009 8s ... 7s
xfs/012 16s ... 13s
xfs/016 76s ... 62s
xfs/017	 [failed, exit status 1] - output mismatch (see 
/var/lib/xfstests/results/xfs/017.out.bad)
     --- tests/xfs/017.out	2013-05-09 05:24:30.996641679 -0400
     +++ /var/lib/xfstests/results/xfs/017.out.bad	2013-05-09 
16:03:25.185045262 -0400
     @@ -3,8 +3,6 @@
      *** test
          *** test 0
          *** test 1
     -    *** test 2
     -    *** test 3
     -    *** test 4
     -*** done
      ...
      (Run 'diff -u tests/xfs/017.out 
/var/lib/xfstests/results/xfs/017.out.bad' to see the entire diff)
xfs/019	 8s
xfs/021 8s ... 7s
xfs/022	 [not run] No dump tape specified
xfs/023	 [not run] No dump tape specified
xfs/024	 [not run] No dump tape specified
xfs/025	 [not run] No dump tape specified
xfs/026	 22s
xfs/027 22s ... 22s
xfs/028	 31s
xfs/029	 11s
xfs/030	 65s
xfs/031 102s ... 99s
xfs/033	 49s
xfs/034 9s ... 9s
xfs/035	 [not run] No dump tape specified
xfs/036	 [not run] No dump tape specified
xfs/037	 [not run] No dump tape specified
xfs/038	 [not run] No dump tape specified
xfs/039	 [not run] No dump tape specified
xfs/040	 [not run] Can't run srcdiff without KWORKAREA set
xfs/041	 121s
xfs/042	 163s
xfs/043	 [not run] No dump tape specified
xfs/044	 [failed, exit status 1] - output mismatch (see 
/var/lib/xfstests/results/xfs/044.out.bad)
     --- tests/xfs/044.out	2013-05-09 05:24:32.493415709 -0400
     +++ /var/lib/xfstests/results/xfs/044.out.bad	2013-05-09 
16:16:33.963173264 -0400
     @@ -16,51 +16,18 @@
          *** mount (expect success)
          *** umount
      *** zero log
     -*** loggen
     -   *** zero block (1BB) x 100
     +./tests/xfs/044: line 138: /var/lib/xfstests/src/loggen: No such 
file or directory
          *** mount (expect success)
      ...
      (Run 'diff -u tests/xfs/044.out 
/var/lib/xfstests/results/xfs/044.out.bad' to see the entire diff)
xfs/045	 11s
xfs/046 20s ... 19s
xfs/047	 31s
xfs/048 2s ... 1s
xfs/049	 [not run] External device testing in progress, skipped this test
xfs/050	 49s
xfs/052 7s ... 8s
xfs/054 31s ... 28s
xfs/055	 [not run] No dump tape specified
xfs/056	 19s
xfs/057	 [not run] Place holder for IRIX test 057
xfs/058	 [not run] Place holder for IRIX test 058
xfs/059 32s ... 31s
xfs/060 31s ... 30s
xfs/061	 20s
xfs/063 21s ... 21s
xfs/064 77s ... 75s
xfs/065 53s ... 51s
xfs/066	 8s
xfs/067	 12s
xfs/071	 - output mismatch (see /var/lib/xfstests/results/xfs/071.out.bad)
     --- tests/xfs/071.out	2013-05-09 05:24:33.373478835 -0400
     +++ /var/lib/xfstests/results/xfs/071.out.bad	2013-05-09 
16:25:07.474096862 -0400
     @@ -40,14 +40,14 @@


      Writing 512 bytes, offset is +0 (direct=false)
     -wrote 512/512 bytes at offset <OFFSET>
     +pwrite64: File too large
      Reading 512 bytes (direct=false)
     -read 512/512 bytes at offset <OFFSET>
      ...
      (Run 'diff -u tests/xfs/071.out 
/var/lib/xfstests/results/xfs/071.out.bad' to see the entire diff)
xfs/072 8s ... 7s
xfs/073	 [not run] Cannot xfs_copy with external devices
xfs/078	^CRan: xfs/003 xfs/004 xfs/008 xfs/009 xfs/012 xfs/016 xfs/017 
xfs/019 xfs/021 xfs/026 xfs/027 xfs/028 xfs/029 xfs/030 xfs/031 xfs/033 
xfs/034 xfs/041 xfs/042 xfs/044 xfs/045 xfs/046 xfs/047 xfs/048 xfs/050 
xfs/052 xfs/054 xfs/056 xfs/059 xfs/060 xfs/061 xfs/063 xfs/064 xfs/065 
xfs/066 xfs/067 xfs/071 xfs/072
Not run: xfs/022 xfs/023 xfs/024 xfs/025 xfs/035 xfs/036 xfs/037 xfs/038 
xfs/039 xfs/040 xfs/043 xfs/049 xfs/055 xfs/057 xfs/058 xfs/073
Failures: xfs/017 xfs/044 xfs/071
Failed 3 of 38 tests
root@oldsvrhw:/var/lib/xfstests# ./check -xfs -g lm256
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/i686 oldsvrhw 3.9.0+
MKFS_OPTIONS  -- -f -llogdev=/dev/sda7 -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- -ologdev=/dev/sda7 /dev/sdb6 /mnt/xfstests-scratch

xfs/003 2s ... 1s
xfs/004 8s ... 8s
xfs/008 5s ... 5s
xfs/009 7s ... 8s
xfs/012 13s ...[ 1851.323902]
[ 1851.325479] =================================
[ 1851.326551] [ INFO: inconsistent lock state ]
[ 1851.326551] 3.9.0+ #1 Not tainted
[ 1851.326551] ---------------------------------
[ 1851.326551] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
[ 1851.326551] kswapd0/18 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1851.326551]  (&(&ip->i_lock)->mr_lock){++++-+}, at: [<c11dcabf>] 
xfs_ilock+0x10f/0x190
[ 1851.326551] {RECLAIM_FS-ON-R} state was registered at:
[ 1851.326551]   [<c105e10a>] mark_held_locks+0x8a/0xf0
[ 1851.326551]   [<c105e69c>] lockdep_trace_alloc+0x5c/0xa0
[ 1851.326551]   [<c109c52c>] __alloc_pages_nodemask+0x7c/0x670
[ 1851.326551]   [<c10bfd8e>] new_slab+0x6e/0x2a0
[ 1851.326551]   [<c14083a9>] __slab_alloc.isra.59.constprop.67+0x1d3/0x40a
[ 1851.326551]   [<c10c12cd>] __kmalloc+0x10d/0x180
[ 1851.326551]   [<c1199b56>] kmem_alloc+0x56/0xd0
[ 1851.326551]   [<c1199be1>] kmem_zalloc+0x11/0xd0
[ 1851.326551]   [<c11c666e>] xfs_dabuf_map.isra.2.constprop.5+0x22e/0x520
[ 1851.326551]   [<c11c7064>] xfs_da_read_buf+0x54/0x280
[ 1851.326551]   [<c11cf2e3>] xfs_dir3_leaf_read.constprop.6+0x43/0x90
[ 1851.326551]   [<c11d1d75>] xfs_dir2_leaf_lookup_int+0x45/0x350
[ 1851.326551]   [<c11d20b0>] xfs_dir2_leaf_lookup+0x30/0x150
[ 1851.326551]   [<c11ca75f>] xfs_dir_lookup+0x13f/0x160
[ 1851.326551]   [<c1196d20>] xfs_lookup+0x50/0x120
[ 1851.326551]   [<c118fcc8>] xfs_vn_lookup+0x48/0x80
[ 1851.326551]   [<c10cc92e>] lookup_real+0x1e/0x50
[ 1851.326551]   [<c10d00fa>] do_last.isra.46+0x74a/0xb90
[ 1851.326551]   [<c10d05db>] path_openat.isra.47+0x9b/0x3e0
[ 1851.326551]   [<c10d0951>] do_filp_open+0x31/0x80
[ 1851.326551]   [<c10c9665>] open_exec+0x45/0x110
[ 1851.326551]   [<c10ca96a>] do_execve_common+0x1da/0x550
[ 1851.326551]   [<c10caddf>] sys_execve+0x2f/0x50
[ 1851.326551]   [<c140e1ff>] sysenter_do_call+0x12/0x36
[ 1851.326551] irq event stamp: 789831
[ 1851.326551] hardirqs last  enabled at (789831): [<c109e4fa>] 
clear_page_dirty_for_io+0xaa/0xe0
[ 1851.326551] hardirqs last disabled at (789830): [<c109e4d4>] 
clear_page_dirty_for_io+0x84/0xe0
[ 1851.326551] softirqs last  enabled at (789776): [<c102a90e>] 
__do_softirq+0x12e/0x1f0
[ 1851.326551] softirqs last disabled at (789769): [<c102ab1d>] 
irq_exit+0x6d/0x80
[ 1851.326551]
[ 1851.326551] other info that might help us debug this:
[ 1851.326551]  Possible unsafe locking scenario:
[ 1851.326551]
[ 1851.326551]        CPU0
[ 1851.326551]        ----
[ 1851.326551]   lock(&(&ip->i_lock)->mr_lock);
[ 1851.326551]   <Interrupt>
[ 1851.326551]     lock(&(&ip->i_lock)->mr_lock);
[ 1851.326551]
[ 1851.326551]  *** DEADLOCK ***
[ 1851.326551]
[ 1851.326551] 1 lock held by kswapd0/18:
[ 1851.326551]  #0:  (sb_internal){.+.+.?}, at: [<c11f1aa6>] 
xfs_trans_alloc+0x26/0x50
[ 1851.326551]
[ 1851.326551] stack backtrace:
[ 1851.326551] Pid: 18, comm: kswapd0 Not tainted 3.9.0+ #1
[ 1851.326551] Call Trace:
[ 1851.326551]  [<c1407048>] print_usage_bug+0x1dc/0x1e6
[ 1851.326551]  [<c105d5d0>] ? print_shortest_lock_dependencies+0x1b0/0x1b0
[ 1851.326551]  [<c105e05b>] mark_lock+0x26b/0x290
[ 1851.326551]  [<c105ff3f>] __lock_acquire+0x64f/0x1690
[ 1851.326551]  [<c1199e66>] ? kmem_zone_alloc+0x56/0xd0
[ 1851.326551]  [<c1190321>] ? xfs_vn_mknod+0x151/0x170
[ 1851.326551]  [<c11f3a3d>] ? xlog_space_left+0x2d/0xf0
[ 1851.326551]  [<c11f3a3d>] ? xlog_space_left+0x2d/0xf0
[ 1851.326551]  [<c1061580>] lock_acquire+0x80/0x100
[ 1851.326551]  [<c11dcabf>] ? xfs_ilock+0x10f/0x190
[ 1851.326551]  [<c1047184>] down_write_nested+0x54/0xa0
[ 1851.326551]  [<c11dcabf>] ? xfs_ilock+0x10f/0x190
[ 1851.326551]  [<c11dcabf>] xfs_ilock+0x10f/0x190
[ 1851.326551]  [<c118f212>] xfs_iomap_write_allocate+0x232/0x400
[ 1851.326551]  [<c105cce8>] ? lock_release_holdtime.part.27+0x88/0xe0
[ 1851.326551]  [<c11dcc4b>] ? xfs_ilock_nowait+0xbb/0x1e0
[ 1851.326551]  [<c1046f8b>] ? up_read+0x1b/0x30
[ 1851.326551]  [<c11dce1b>] ? xfs_iunlock+0xab/0x170
[ 1851.326551]  [<c117c948>] xfs_map_blocks+0x388/0x420
[ 1851.326551]  [<c117da45>] xfs_vm_writepage+0x355/0x6e0
[ 1851.326551]  [<c1050655>] ? sched_clock_cpu+0xa5/0x100
[ 1851.326551]  [<c105e30e>] ? trace_hardirqs_off_caller+0x1e/0xa0
[ 1851.326551]  [<c10a4567>] shrink_page_list+0x4c7/0x680
[ 1851.326551]  [<c10a4ba1>] shrink_inactive_list+0x181/0x2d0
[ 1851.326551]  [<c10a4e6a>] shrink_lruvec+0x17a/0x3b0
[ 1851.326551]  [<c1046f8b>] ? up_read+0x1b/0x30
[ 1851.326551]  [<c10a3901>] ? shrink_slab+0x1e1/0x2f0
[ 1851.326551]  [<c10a5a2e>] kswapd+0x30e/0x680
[ 1851.326551]  [<c10a5720>] ? try_to_free_pages+0x680/0x680
[ 1851.326551]  [<c10424d5>] kthread+0xa5/0xb0
[ 1851.326551]  [<c105cd1c>] ? lock_release_holdtime.part.27+0xbc/0xe0
[ 1851.326551]  [<c140e177>] ret_from_kernel_thread+0x1b/0x28
[ 1851.326551]  [<c1042430>] ? __kthread_parkme+0x70/0x70
  14s
[ 1859.123845] XFS (sdb5): Mounting Filesystem
[ 1859.439419] XFS (sdb5): Ending clean mount
xfs/016 62s ...[ 1862.733835] XFS (sdb6): Mounting Filesystem
[ 1863.049345] XFS (sdb6): Ending clean mount
[ 1866.823293] XFS (sdb6): Mounting Filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
