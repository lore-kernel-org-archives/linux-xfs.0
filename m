Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16232 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751079AbdKNECp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2017 23:02:45 -0500
Date: Tue, 14 Nov 2017 15:02:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171114040232.GZ4094@dastard>
References: <20171113103139.GA18936@yu-chen.sh.intel.com>
 <20171113225216.GJ5858@dastard>
 <20171114033959.GB23219@yu-chen.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114033959.GB23219@yu-chen.sh.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yu Chen <yu.c.chen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, Hou Tao <houtao1@huawei.com>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 14, 2017 at 11:39:59AM +0800, Yu Chen wrote:
> Hi Dave,
> On Tue, Nov 14, 2017 at 09:52:16AM +1100, Dave Chinner wrote:
> > On Mon, Nov 13, 2017 at 06:31:39PM +0800, Yu Chen wrote:
> > > Hi all,
> > > Currently we are running hibernation stress test on a server
> > > and unfortunately after 48 rounds of cycling, it fails at a
> > > early stage that, the xfs task refuses to be frozen by the system:
> > > 
> > > [ 1934.221653] PM: Syncing filesystems ...
> > > [ 1934.661517] PM: done.
> > > [ 1934.664067] Freezing user space processes ... (elapsed 0.003 seconds) done.
> > > [ 1934.675251] OOM killer disabled.
> > > [ 1934.724317] PM: Preallocating image memory... done (allocated 6906555 pages)
> > > [ 1954.666378] PM: Allocated 27626220 kbytes in 19.93 seconds (1386.16 MB/s)
> > > [ 1954.673939] Freezing remaining freezable tasks ...
> > > [ 1974.681089] Freezing of tasks failed after 20.001 seconds (1 tasks refusing to freeze, wq_busy=0):
> > > [ 1974.691169] xfsaild/dm-1    D    0  1362      2 0x00000080
> > > [ 1974.697283] Call Trace:
> > > [ 1974.700014]  __schedule+0x3be/0x830
> > > [ 1974.703898]  schedule+0x36/0x80
> > > [ 1974.707440]  _xfs_log_force+0x143/0x280 [xfs]
> > > [ 1974.712295]  ? schedule_timeout+0x16b/0x350
> > > [ 1974.716953]  ? wake_up_q+0x80/0x80
> > > [ 1974.720752]  ? xfsaild+0x16f/0x770 [xfs]
> > > [ 1974.725134]  xfs_log_force+0x2c/0x80 [xfs]
> > > [ 1974.729707]  xfsaild+0x16f/0x770 [xfs]
> > > [ 1974.733885]  kthread+0x109/0x140
> > > [ 1974.737480]  ? kthread+0x109/0x140
> > > [ 1974.741271]  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> > > [ 1974.747284]  ? kthread_park+0x60/0x60
> > > [ 1974.751354]  ret_from_fork+0x25/0x30
> > > [ 1974.755366] Restarting kernel threads ... done.
> > > [ 1978.259907] OOM killer enabled.
> > > [ 1978.263405] Restarting tasks ... done.
> > > 
> > > The reason for this failure might be that,
> > > while the kernel thread xfsaild/dm-1 is waiting for
> > > xfs-buf/dm-1 to wake it up, however the latter
> > > has already been frozen, thus xfsaild/dm-1 never
> > > has a chance to be woken up and get froze. (Although
> > > the xfsaild/dm-1 remains in TASK_UNINTERRUPTIBLE, which
> > > is quite similar to 'frozen'.)
> > 
> > Should be fixed by this commit in the for-next branch:
> > 
> > 0bd89676c4fe xfs: check kthread_should_stop() after the setting of task state
> > 
> > That should get merged into 4.15 with the next merge...
> >
> I did not quite catch why above commit would fix the issue here,
> according to
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=0bd89676c4fed53b003025bc4a5200861ac5d8ef
> it tries to address a race condition between umount and xfsaild on
> checking the kthread_should_stop() in order not to make
> xfsaild falling asleep indefinitely.

Argh, got my threads slightly crossed there.

> But in our case, the xfsaild is waiting for the xfs-buf to wake
> it up, and is nothing related to the kthread_should_stop() checking
> here, did I miss something?

Similar symptoms - the symptom that was fixed by the commit I
mentioned was the xfsaild getting stuck in sleeping forever and so
never seeing the KTHREAD_STOP bit - it was a "set bit vs wakeup"
race caused by the fact that we didn't reset the state of the
task correctly after wakeup.

You said:

>> (Although the xfsaild/dm-1 remains in TASK_UNINTERRUPTIBLE, which
>> is quite similar to 'frozen'.)

So from a quick look, it seemed like a similar race condition. I
missed the *un* part of the task state, though.
TASK_UNINTERRUPTIBLE implies waiting for IO completion, which is
what _xfs_log_force() is doing.

SO, follow the other branch of the discussion: hibernation needs to
freeze filesystems so they can quiesce gracefully before the kernel
starts shutting down the infrastructure the filesystem relies on...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
