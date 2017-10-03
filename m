Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbdJCSxT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 14:53:19 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 0/5] fs: replace kthread freezing with filesystem freeze/thaw
Date: Tue,  3 Oct 2017 11:53:08 -0700
Message-Id: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

At the 2015 South Korea kernel summit Jiri Kosina had pointd out the issue of
the sloppy semantics of the kthread freezer, lwn covered this pretty well [0].
In short, he explained how the original purpose of the freezer was to aid
in going to suspend to ensure no uwanted IO activity would cause filesystem
corruption. Kernel kthreads require special freezer handling though, the call
try_to_freeze() is often sprinkled at strategic places, but sometimes this is
done without set_freezable() making try_to_freeze() useless. Other helpers such
as freezable_schedule_timeout() exist, and very likely they are not used in any
consistent and proper way either all over the kernel. Dealing with these
helpers alone also does not and cannot ensure that everything that has been
spawned asynchronously from a kthread (such as timers) are stopped as well,
these are left to the kthread user implementation, and chances are pretty high
there are many bugs lurking here. There are even non-IO bounds kthreads now
using the freezer APIs, where this is not even needed!

Jiri suggested we can easily replace the complexities of the kthread freezer
by just using the existing filesystem freeze/thaw callbacks on hibernation and
suspend.

I've picked up Jiri's work given there are bugs which after inspection don't
see like real bugs, but just random IO loosely waiting to be completed and the
kernel not really being able to tell me who the culprit is. In fact even if one
plugs a fix, one ends up in another random place and its really unclear who is
to blaim for next.

For instance, to reproduce a simple suspend bug on what may at first seem to be
an XFS bug, one can issue a dd onto disk prior to suspend, and we'll get a
stall on our way to suspend, claiming the issue was the SCSI layer not being
able to quiesce the disk. This was reported on OpenSUSE and reproduced on
linux-next easily [1]. The following script can be run while we loop on
systemctl suspend and qemu system_wakeup calls to resume:

	while true; do
		dd if=/dev/zero of=crap bs=1M count=1024 &> /dev/null
	done

You end up with with a hung suspend attempt, and eventually a splat
as follows with a hunk task notification:

INFO: task kworker/u8:8:1320 blocked for more than 10 seconds.
      Tainted: G            E   4.13.0-next-20170907+ #88
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:8    D    0  1320      2 0x80000000
Workqueue: events_unbound async_run_entry_fn
Call Trace:
 __schedule+0x2ec/0x7a0
 schedule+0x36/0x80
 io_schedule+0x16/0x40
 get_request+0x278/0x780
 ? remove_wait_queue+0x70/0x70
 blk_get_request+0x9c/0x110
 scsi_execute+0x7a/0x310 [scsi_mod]
 sd_sync_cache+0xa3/0x190 [sd_mod]
 ? blk_run_queue+0x3f/0x50
 sd_suspend_common+0x7b/0x130 [sd_mod]
 ? scsi_print_result+0x270/0x270 [scsi_mod]
 sd_suspend_system+0x13/0x20 [sd_mod]
 do_scsi_suspend+0x1b/0x30 [scsi_mod]
 scsi_bus_suspend_common+0xb1/0xd0 [scsi_mod]
 ? device_for_each_child+0x69/0x90
 scsi_bus_suspend+0x15/0x20 [scsi_mod]
 dpm_run_callback+0x56/0x140
 ? scsi_bus_freeze+0x20/0x20 [scsi_mod]
 __device_suspend+0xf1/0x340
 async_suspend+0x1f/0xa0
 async_run_entry_fn+0x38/0x160
 process_one_work+0x191/0x380
 worker_thread+0x4e/0x3c0
 kthread+0x109/0x140
 ? process_one_work+0x380/0x380
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x25/0x30

Sprinkling freezer_do_not_count() on scsi_execute() *iff* we're going to
suspend is one way to fix this splat, however this just pushes the bug
elsewhere, and we keep doing this ever on. The right thing to do here is ensure
that after userpsace is frozen we also freeze all filesystem behaviour.

Its possible other symptoms have been observed elsewhere, and similar work
arounds are being devised. Perhaps this work can help put a stop gap for such
work arounds and complexities.

While this all seems trivial, well discussed, and so it should be well accepted
for us to go full swing with a replacement of the kthread freezer with
filesystem suspend / thaw -- not all filesystems have a respective freeze/thaw
call. Also in practice it would seem some thaw'ing calls need some revision.
For instance thawing with a sync call on ext4 currently issues a bio_submit(),
which in turn stalls on resume. Each call/filesystem then should be vetted
manually, as I've done for ext4 in this series.

Likewise while kthread freezing may have been designed to help with avoiding IO
on disk, its sloppy use on kthreads may now be providing buggy functionality
which *helps* somehow now. The removal of freezer helpers on kthreads which are
not IO bound should also be carefully vetted for to avoid potential
regressions.

Then we have the few areas in the kernel which may generate disk IO which do
not come from filesystems -- this was mentioned recently the the Alpine Linux
Persistence and Storage Summit [2] -- such drivers would need to get proper
suspend calls eventually.

Given all the above then I'd like to move *carefully* with the kthread freezer
replacement with filesystem freeze/thawing instead of doing it all in one shot,
as Jiri had originally intended.

Filesystmes which have been vetted to work properly can use the super block
FS_FREEZE_ON_SUSPEND flag when things are ready as a transitional flag. I hope
we can get to the point we can rely on all filesystmes supporting it, so that
once all filesystem code is vetted for, and all non-IO bound kthread callers
have been cleared of the freezer call we can just remove the
FS_FREEZE_ON_SUSPEND flag and then kill the kthread freezer completely (the
last patch in this series).

The way this would be merged then is, only the first four patches would
be considered for upstream at first. We'd then move on to do the same with
other filesystems. Then or in parallel move on to tackle vetting removal
of all disk non-IO bounds kthread freezer callers. Only once this is all
done should we consider the last patch to put final nail on the kthread
freezer coffin.

[0] https://lwn.net/Articles/662703/
[1] https://bugzilla.suse.com/show_bug.cgi?id=1043449
[2] http://alpss.at/

Thoughts? Rants?

Luis R. Rodriguez (5):
  fs: add iterate_supers_reverse()
  fs: freeze on suspend and thaw on resume
  xfs: allow fs freeze on suspend/hibernation
  ext4: add fs freezing support on suspend/hibernation
  pm: remove kernel thread freezing

 Documentation/power/freezing-of-tasks.txt |   9 ---
 drivers/xen/manage.c                      |   6 --
 fs/ext4/super.c                           |  13 ++--
 fs/super.c                                | 122 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c                        |   3 +-
 fs/xfs/xfs_trans_ail.c                    |   7 +-
 include/linux/freezer.h                   |   4 -
 include/linux/fs.h                        |  14 ++++
 kernel/power/hibernate.c                  |  10 +--
 kernel/power/power.h                      |  20 +----
 kernel/power/process.c                    |  61 ++++-----------
 kernel/power/user.c                       |   9 ---
 tools/power/pm-graph/analyze_suspend.py   |   1 -
 13 files changed, 163 insertions(+), 116 deletions(-)

-- 
2.14.0

