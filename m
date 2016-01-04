Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAC257F51
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 12:20:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC0CB8F8035
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 10:20:44 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id sGs31rhbZLgpBR15 for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 10:20:42 -0800 (PST)
Subject: [resend PATCH 3/3] writeback: fix false positive WARN in
	__mark_inode_dirty
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Jan 2016 10:20:16 -0800
Message-ID: <20160104182016.24118.33718.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org

This warning was added as a debugging aid way back in commit
500b067c5e6c "writeback: check for registered bdi in flusher add and
inode dirty" when we were switching over to per-bdi writeback.

Once the block device has been torn down it's no longer useful to
complain about unregistered bdi's.  Clear the writeback capability under
the the wb->list_lock(), so that __mark_inode_dirty has no opportunity
to race bdi_unregister() to this WARN() condition.

Alternatively we could just delete the warning...

Found this while testing block device remove from underneath an active
fs triggering traces like:

 WARNING: CPU: 6 PID: 2129 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
 bdi-block not registered
 [..]
 Call Trace:
  [<ffffffff81459f02>] dump_stack+0x44/0x62
  [<ffffffff810a1f32>] warn_slowpath_common+0x82/0xc0
  [<ffffffff810a1fcc>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff812830b1>] __mark_inode_dirty+0x261/0x350
  [<ffffffff8126d019>] generic_update_time+0x79/0xd0
  [<ffffffff8126d19d>] file_update_time+0xbd/0x110
  [<ffffffff812e4ab8>] ext4_dax_fault+0x68/0x110
  [<ffffffff811f7f3e>] __do_fault+0x4e/0xf0
  [<ffffffff811fc077>] handle_mm_fault+0x5e7/0x1b50
  [<ffffffff811fbae1>] ? handle_mm_fault+0x51/0x1b50
  [<ffffffff81068981>] __do_page_fault+0x191/0x3f0
  [<ffffffff81068caf>] trace_do_page_fault+0x4f/0x120
  [<ffffffff810630fa>] do_async_page_fault+0x1a/0xa0
  [<ffffffff819023f8>] async_page_fault+0x28/0x30

Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7340353f8aea..9ea843bca709 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -343,10 +343,17 @@ static void wb_shutdown(struct bdi_writeback *wb)
 {
 	/* Make sure nobody queues further work */
 	spin_lock_bh(&wb->work_lock);
+
 	if (!test_and_clear_bit(WB_registered, &wb->state)) {
 		spin_unlock_bh(&wb->work_lock);
 		return;
 	}
+
+	/* tell __mark_inode_dirty that writeback is no longer possible */
+	spin_lock(&wb->list_lock);
+	wb->bdi->capabilities |= BDI_CAP_NO_WRITEBACK;
+	spin_unlock(&wb->list_lock);
+
 	spin_unlock_bh(&wb->work_lock);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
