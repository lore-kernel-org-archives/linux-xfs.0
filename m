Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 987EC7F4E
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 14:36:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C4708F8049
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:36:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id F7dRK5C1ptFKlLfZ for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 12:36:31 -0800 (PST)
Message-ID: <54B03BCC.7040207@sandeen.net>
Date: Fri, 09 Jan 2015 14:36:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
In-Reply-To: <20150109182310.GA2785@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/9/15 12:23 PM, Tejun Heo wrote:
> Hello, Eric.
> 
> On Fri, Jan 09, 2015 at 12:12:04PM -0600, Eric Sandeen wrote:
>> I had a case reported where a system under high stress
>> got deadlocked.  A btree split was handed off to the xfs
>> allocation workqueue, and it is holding the xfs_ilock
>> exclusively.  However, other xfs_end_io workers are
>> not running, because they are waiting for that lock.
>> As a result, the xfs allocation workqueue never gets
>> run, and everything grinds to a halt.
> 
> I'm having a difficult time following the exact deadlock.  Can you
> please elaborate in more detail?

Sure, sorry.  This is cut & paste from a bug, so hopefully not too disjoint.

And, FWIW, this is a RHEL7 kernel, so not most recent upstream.  I could
possibly ask the reporter to retest upstream; sadly they are using
proprietary tests.

There are many stuck threads; the oldest is this:

crash> bt 39292
PID: 39292  TASK: c000000038240000  CPU: 27  COMMAND: "aio-stress"
 #0 [c00000003ad02a40] __switch_to at c0000000000164d8
 #1 [c00000003ad02c10] __switch_to at c0000000000164d8
 #2 [c00000003ad02c70] __schedule at c000000000900200
 #3 [c00000003ad02ec0] schedule_timeout at c0000000008fd018
 #4 [c00000003ad02fc0] wait_for_completion at c000000000900e08
 #5 [c00000003ad03040] xfs_btree_split at d000000005c58ec0 [xfs]
 #6 [c00000003ad03100] xfs_btree_make_block_unfull at d000000005c5bd5c [xfs]
 #7 [c00000003ad03190] xfs_btree_insrec at d000000005c5c214 [xfs]
 #8 [c00000003ad03290] xfs_btree_insert at d000000005c5c51c [xfs]
 #9 [c00000003ad03320] xfs_bmap_add_extent_hole_real at d000000005c4a630 [xfs]
#10 [c00000003ad033d0] xfs_bmapi_write at d000000005c51f08 [xfs]
#11 [c00000003ad03570] xfs_iomap_write_direct at d000000005c268fc [xfs]
#12 [c00000003ad03660] __xfs_get_blocks at d000000005c0b2b8 [xfs]
#13 [c00000003ad03710] do_direct_IO at c00000000033f6c4
#14 [c00000003ad03830] __blockdev_direct_IO at c000000000341428
#15 [c00000003ad03a20] xfs_vm_direct_IO at d000000005c09d18 [xfs]
#16 [c00000003ad03af0] generic_file_direct_write at c00000000021d1c0
#17 [c00000003ad03ba0] xfs_file_dio_aio_write at d000000005cb3154 [xfs]
#18 [c00000003ad03c40] xfs_file_aio_write at d000000005c1beb0 [xfs]
#19 [c00000003ad03cc0] do_io_submit at c000000000359c00

And the xfsalloc / btree split worker is not on any active task.
Digging further, it's on a queue, but not started.

The work queue which contains it is this:

crash> list -H 0xc000000001cd7b18 -o work_struct.entry -s work_struct
c0000006182ceed8
struct work_struct {
  data = {
    counter = -4611686018397073147
  }, 
  entry = {
    next = 0xc0000006182c31f8, 
    prev = 0xc000000001cd7b18
  }, 
  func = 0xd000000005c0b570 <xfs_end_io>
}
c0000006182c31f0
struct work_struct {
  data = {
    counter = -4611686018397073147
  }, 
  entry = {
    next = 0xc0000006182c0750, 
    prev = 0xc0000006182ceee0
  }, 
  func = 0xd000000005c0b570 <xfs_end_io>
}
c0000006182c0748
struct work_struct {
  data = {
    counter = -4611686018397073147
  }, 
  entry = {
    next = 0xc00000003ad030a8, 
    prev = 0xc0000006182c31f8
  }, 
  func = 0xd000000005c0b570 <xfs_end_io>
}
c00000003ad030a0
struct work_struct {
  data = {
    counter = -4611686018397087739
  }, 
  entry = {
    next = 0xc0000006182c5e08, 
    prev = 0xc0000006182c0750
  }, 
  func = 0xd000000005c58ef0 <xfs_btree_split_worker>
}

...

so that's our stuck split worker, behind xfs_end_io's.

if we look at the oldest stuck aio-stress task waiting for the work item to complete, there is an inode in its stack frames:

crash> xfs_inode c0000000b1dca800

and we find that it has an i_lock held, with waiters:

  i_lock = {
    mr_lock = {
      count = -8589934591, 
      wait_lock = {
        raw_lock = {
          slock = 0
        }
      }, 
      wait_list = {
        next = 0xc00000005a003a20, 
        prev = 0xc00000003f483a20
      }
    }
  }, 

If we ask crash about those waiters, we see they are other kworker threads:

crash> kmem 0xc00000005a003a20
...
    PID: 50959
COMMAND: "kworker/27:2"
...
crash> kmem 0xc00000003f483a20
...
    PID: 29528
COMMAND: "kworker/27:10"
...

and pid 50959 is indeed the 2nd-to-last listed uninterruptable sleep pid.

crash> bt 50959
...
 #3 [c00000005a003a00] rwsem_down_write_failed at c000000000903224
 #4 [c00000005a003a90] down_write at c0000000008ff68c
 #5 [c00000005a003ac0] xfs_ilock at d000000005c78ea8 [xfs]
 #6 [c00000005a003b00] xfs_iomap_write_unwritten at d000000005c272dc [xfs]
 #7 [c00000005a003c20] xfs_end_io at d000000005c0b680 [xfs]
 #8 [c00000005a003c50] process_one_work at c0000000000ecadc

doing bt -FF on that yields:

 #5 [c00000005a003ac0] xfs_ilock at d000000005c78ea8 [xfs]
    c00000005a003ac0: [c00000005a003b00:kmalloc-16384] [c0000005e6fb2000:kmalloc-2048] 
    c00000005a003ad0: xfs_ilock+232    xfs_table_header+19848 
    c00000005a003ae0: 0000000000000000 0000000000006970 
    c00000005a003af0: 0000000000000008 [c0000000b1dca800:xfs_inode]

which is the same inode, c0000000b1dca800

The oldest stuck aio-stress process is (again) down this path:

crash> bt 39292
PID: 39292  TASK: c000000038240000  CPU: 27  COMMAND: "aio-stress"
...
 #4 [c00000003ad02fc0] wait_for_completion at c000000000900e08
 #5 [c00000003ad03040] xfs_btree_split at d000000005c58ec0 [xfs]
 #6 [c00000003ad03100] xfs_btree_make_block_unfull at d000000005c5bd5c [xfs]
 #7 [c00000003ad03190] xfs_btree_insrec at d000000005c5c214 [xfs]
 #8 [c00000003ad03290] xfs_btree_insert at d000000005c5c51c [xfs]
 #9 [c00000003ad03320] xfs_bmap_add_extent_hole_real at d000000005c4a630 [xfs]
#10 [c00000003ad033d0] xfs_bmapi_write at d000000005c51f08 [xfs]
#11 [c00000003ad03570] xfs_iomap_write_direct at d000000005c268fc [xfs]
#12 [c00000003ad03660] __xfs_get_blocks at d000000005c0b2b8 [xfs]
#13 [c00000003ad03710] do_direct_IO at c00000000033f6c4
#14 [c00000003ad03830] __blockdev_direct_IO at c000000000341428

and xfs_iomap_write_direct() takes the ilock exclusively.

        xfs_ilock(ip, XFS_ILOCK_EXCL);

before calling xfs_bmapi_write(), so it must be the holder.  Until this work item runs, everything else working on this inode is stuck, but it's not getting run, behind other items waiting for the lock it holds.

-Eric

>> To be honest, it's not clear to me how the workqueue
>> subsystem manages this sort of thing.  But in testing,
>> making the allocation workqueue high priority so that
>> it gets added to the front of the pending work list,
>> resolves the problem.  We did similar things for
>> the xfs-log workqueues, for similar reasons.
> 
> Ummm, this feel pretty voodoo.  In practice, it'd change the order of
> things being executed and may make certain deadlocks unlikely enough,
> but I don't think this can be a proper fix.
> 
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index e5bdca9..9c549e1 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -874,7 +874,7 @@ xfs_init_mount_workqueues(
>>  		goto out_destroy_log;
>>  
>>  	mp->m_alloc_workqueue = alloc_workqueue("xfs-alloc/%s",
>> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
>> +		       WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);
> 
> And this at least deserves way more explanation.
> 
>>  	if (!mp->m_alloc_workqueue)
>>  		goto out_destroy_eofblocks;
>>  
>>
> 
> Thanks.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
