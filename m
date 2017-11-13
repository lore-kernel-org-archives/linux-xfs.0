Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:7650 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752388AbdKMK3I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 05:29:08 -0500
Date: Mon, 13 Nov 2017 18:31:39 +0800
From: Yu Chen <yu.c.chen@intel.com>
Subject: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171113103139.GA18936@yu-chen.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yu Chen <yu.c.chen@intel.com>, Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, linux-pm@vger.kernel.org, inux-kernel@vger.kernel.org

Hi all,
Currently we are running hibernation stress test on a server
and unfortunately after 48 rounds of cycling, it fails at a
early stage that, the xfs task refuses to be frozen by the system:

[ 1934.221653] PM: Syncing filesystems ...
[ 1934.661517] PM: done.
[ 1934.664067] Freezing user space processes ... (elapsed 0.003 seconds) done.
[ 1934.675251] OOM killer disabled.
[ 1934.724317] PM: Preallocating image memory... done (allocated 6906555 pages)
[ 1954.666378] PM: Allocated 27626220 kbytes in 19.93 seconds (1386.16 MB/s)
[ 1954.673939] Freezing remaining freezable tasks ...
[ 1974.681089] Freezing of tasks failed after 20.001 seconds (1 tasks refusing to freeze, wq_busy=0):
[ 1974.691169] xfsaild/dm-1    D    0  1362      2 0x00000080
[ 1974.697283] Call Trace:
[ 1974.700014]  __schedule+0x3be/0x830
[ 1974.703898]  schedule+0x36/0x80
[ 1974.707440]  _xfs_log_force+0x143/0x280 [xfs]
[ 1974.712295]  ? schedule_timeout+0x16b/0x350
[ 1974.716953]  ? wake_up_q+0x80/0x80
[ 1974.720752]  ? xfsaild+0x16f/0x770 [xfs]
[ 1974.725134]  xfs_log_force+0x2c/0x80 [xfs]
[ 1974.729707]  xfsaild+0x16f/0x770 [xfs]
[ 1974.733885]  kthread+0x109/0x140
[ 1974.737480]  ? kthread+0x109/0x140
[ 1974.741271]  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[ 1974.747284]  ? kthread_park+0x60/0x60
[ 1974.751354]  ret_from_fork+0x25/0x30
[ 1974.755366] Restarting kernel threads ... done.
[ 1978.259907] OOM killer enabled.
[ 1978.263405] Restarting tasks ... done.

The reason for this failure might be that,
while the kernel thread xfsaild/dm-1 is waiting for
xfs-buf/dm-1 to wake it up, however the latter
has already been frozen, thus xfsaild/dm-1 never
has a chance to be woken up and get froze. (Although
the xfsaild/dm-1 remains in TASK_UNINTERRUPTIBLE, which
is quite similar to 'frozen'.)

Possible scenario:

xfsaild/dm-1:
xfsaild_push ->xfs_log_force->_xfs_log_force->
xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);


xfs-buf/dm-1
xfs_buf_ioend_work->xfs_buf_ioend->xlog_iodone->
xlog_state_done_syncing->xlog_state_do_callback->
wake_up_all(&iclog->ic_force_wait);


The xfs-buf/dm-1 should be freezed according to
commit 8018ec083c72 ("xfs: mark all internal workqueues
as freezable"), thus a easier way might be have to revert
commit 18f1df4e00ce ("xfs: Make xfsaild freezeable
again") for now, after this reverting the xfsaild/dm-1
becomes non-freezable again, thus pm does not see this
thread - unless we find a graceful way to treat xfsaild/dm-1
as 'frozen' if it is waiting for an already 'frozen' task,
or if the filesystem freeze is added in.

Any comments would be much appreciated.

Thanks,
	Yu

