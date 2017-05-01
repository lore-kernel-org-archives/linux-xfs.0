Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2999562AbdEAGKu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 02:10:50 -0400
Subject: Re: xlog_write: reservation ran out
From: Ming Lin <mlin@kernel.org>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
Message-ID: <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
Date: Sun, 30 Apr 2017 23:10:15 -0700
MIME-Version: 1.0
In-Reply-To: <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>


On 4/28/2017 1:56 PM, Ming Lin wrote:
> I'm new to xfs code.
> 
> Search  XFS_TRANS_INACTIVE and the usage is like below,
> 
> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> 
> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);
> 
> seems tr_remove is not related.
> I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.

Now things are a little bit more clear. I tried below debug patch.
The t_decrease[] array was used to track where the space was used.

 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_log.c               | 23 ++++++++++++++++++++---
 fs/xfs/xfs_log_cil.c           |  8 ++++++++
 fs/xfs/xfs_log_priv.h          |  3 +++
 fs/xfs/xfs_super.c             |  1 +
 5 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 1b754cb..4087c39 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -788,7 +788,7 @@ xfs_trans_resv_calc(
 	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

-	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
+	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp) * 2;
 	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

@@ -821,7 +821,7 @@ xfs_trans_resv_calc(
 	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
 	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

-	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
+	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp) * 2;
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3dfa2db..d2da8a7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -832,6 +832,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			/* remove inited flag, and account for space used */
 			tic->t_flags = 0;
 			tic->t_curr_res -= sizeof(magic);
+			tic->t_decrease[0] = sizeof(magic);
 			error = xlog_write(log, &vec, tic, &lsn,
 					   NULL, XLOG_UNMOUNT_TRANS);
 			/*
@@ -2067,7 +2068,13 @@ xlog_print_tic_res(

 	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
 		"xlog_write: reservation ran out. Need to up reservation");
-	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+	for (i = 0; i < RES_DECREASE_NUM; i++) {
+		xfs_warn(mp, "t_decrease[%d] = %d\n", i, ticket->t_decrease[i]);
+	}
+	dump_stack();
+
+	if (ticket->t_curr_res < 0)
+		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 }

 /*
@@ -2210,6 +2217,7 @@ xlog_write_setup_copy(

 	/* account for new log op header */
 	ticket->t_curr_res -= sizeof(struct xlog_op_header);
+	ticket->t_decrease[1] = sizeof(struct xlog_op_header);
 	ticket->t_res_num_ophdrs++;

 	return sizeof(struct xlog_op_header);
@@ -2330,19 +2338,27 @@ xlog_write(
 	 * We only need to take into account start records and
 	 * split regions in this function.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED)
+	if (ticket->t_flags & XLOG_TIC_INITED) {
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+		ticket->t_decrease[2] = sizeof(xlog_op_header_t);
+	}

 	/*
 	 * Commit record headers need to be accounted for. These
 	 * come in as separate writes so are easy to detect.
 	 */
-	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+		ticket->t_decrease[3] = sizeof(xlog_op_header_t);
+	}

 	if (ticket->t_curr_res < 0)
 		xlog_print_tic_res(log->l_mp, ticket);

+	if (ticket->t_trans_type == XFS_TRANS_INACTIVE &&
+			(ticket->t_unit_res - ticket->t_curr_res > ticket->t_unit_res / 2))
+		xlog_print_tic_res(log->l_mp, ticket);
+
 	index = 0;
 	lv = log_vector;
 	vecp = lv->lv_iovecp;
@@ -2917,6 +2933,7 @@ restart:
 	 */
 	if (log_offset == 0) {
 		ticket->t_curr_res -= log->l_iclog_hsize;
+		ticket->t_decrease[4] = log->l_iclog_hsize;
 		xlog_tic_add_region(ticket,
 				    log->l_iclog_hsize,
 				    XLOG_REG_TYPE_LRHEADER);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 23014f9..9d965d6 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -334,6 +334,7 @@ xlog_cil_insert_items(
 	if (ctx->ticket->t_curr_res == 0) {
 		ctx->ticket->t_curr_res = ctx->ticket->t_unit_res;
 		tp->t_ticket->t_curr_res -= ctx->ticket->t_unit_res;
+		tp->t_ticket->t_decrease[5] = ctx->ticket->t_unit_res;
 	}

 	/* do we need space for more log record headers? */
@@ -348,9 +349,11 @@ xlog_cil_insert_items(
 		ctx->ticket->t_unit_res += hdrs;
 		ctx->ticket->t_curr_res += hdrs;
 		tp->t_ticket->t_curr_res -= hdrs;
+		tp->t_ticket->t_decrease[6] = hdrs;
 		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
 	tp->t_ticket->t_curr_res -= len;
+	tp->t_ticket->t_decrease[7] = len;
 	ctx->space_used += len;

 	spin_unlock(&cil->xc_cil_lock);
@@ -586,6 +589,7 @@ xlog_cil_push(
 	lhdr.i_len = sizeof(xfs_trans_header_t);
 	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
 	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
+	tic->t_decrease[8] = lhdr.i_len + sizeof(xlog_op_header_t);

 	lvhdr.lv_niovecs = 1;
 	lvhdr.lv_iovecp = &lhdr;
@@ -797,6 +801,10 @@ xfs_log_commit_cil(
 	if (tp->t_ticket->t_curr_res < 0)
 		xlog_print_tic_res(mp, tp->t_ticket);

+	if (tp->t_ticket->t_trans_type == XFS_TRANS_INACTIVE &&
+			(tp->t_ticket->t_unit_res - tp->t_ticket->t_curr_res > tp->t_ticket->t_unit_res / 2))
+		xlog_print_tic_res(mp, tp->t_ticket);
+
 	tp->t_commit_lsn = cil->xc_ctx->sequence;
 	if (commit_lsn)
 		*commit_lsn = tp->t_commit_lsn;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index db7cbde..359ebdb 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -163,6 +163,8 @@ typedef struct xlog_res {
 	uint	r_type;	/* region's transaction type	:4 */
 } xlog_res_t;

+#define RES_DECREASE_NUM 10
+
 typedef struct xlog_ticket {
 	struct list_head   t_queue;	 /* reserve/write queue */
 	struct task_struct *t_task;	 /* task that owns this ticket */
@@ -170,6 +172,7 @@ typedef struct xlog_ticket {
 	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
 	int		   t_curr_res;	 /* current reservation in bytes : 4  */
 	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
+	int		   t_decrease[RES_DECREASE_NUM];
 	char		   t_ocnt;	 /* original count		 : 1  */
 	char		   t_cnt;	 /* current count		 : 1  */
 	char		   t_clientid;	 /* who does this belong to;	 : 1  */


And then I got below debug info,

[42497.026294] XFS (nvme7n1p1): xlog_write: reservation summary:
  trans type  = INACTIVE (3)
  unit res    = 166048 bytes
  current res = 53444 bytes
  total reg   = 0 bytes (o/flow = 0 bytes)
  ophdrs      = 0 (ophdr space = 0 bytes)
  ophdr + reg = 0 bytes
  num regions = 0
[42497.061742] XFS (nvme7n1p1): xlog_write: reservation ran out. Need to up reservation
[42497.069865] XFS (nvme7n1p1): t_decrease[0] = 0

[42497.076160] XFS (nvme7n1p1): t_decrease[1] = 0

[42497.082450] XFS (nvme7n1p1): t_decrease[2] = 0

[42497.088734] XFS (nvme7n1p1): t_decrease[3] = 0

[42497.095003] XFS (nvme7n1p1): t_decrease[4] = 0

[42497.101341] XFS (nvme7n1p1): t_decrease[5] = 0

[42497.107626] XFS (nvme7n1p1): t_decrease[6] = 2096

[42497.114187] XFS (nvme7n1p1): t_decrease[7] = 110508

[42497.120915] XFS (nvme7n1p1): t_decrease[8] = 0

[42497.127220] XFS (nvme7n1p1): t_decrease[9] = 0

[42497.133518] CPU: 25 PID: 28408 Comm: tp_fstore_op Tainted: G
[42497.145703] Hardware name: Huawei RH2288H V3/BC11HGSA0, BIOS 3.50 11/23/2016
[42497.152987]  000000000000000a 00000000ca382f91 ffff881ef681bc48 ffffffff816372cc
[42497.160876]  ffff881ef681bca8 ffffffffa06a474f ffff880300000000 ffff880900000000
[42497.168711]  ffff880700000000 0000000000000000 ffff880900000000 ffff881f00000000
[42497.176568] Call Trace:
[42497.179210]  [<ffffffff816372cc>] dump_stack+0x19/0x1b
[42497.184578]  [<ffffffffa06a474f>] xlog_print_tic_res+0x11f/0x160 [xfs]
[42497.191356]  [<ffffffffa06a6d72>] xfs_log_commit_cil+0x4d2/0x530 [xfs]
[42497.198116]  [<ffffffffa06a0f24>] xfs_trans_commit+0x134/0x270 [xfs]
[42497.204682]  [<ffffffffa0696e7b>] xfs_inactive_ifree+0x1eb/0x250 [xfs]
[42497.211435]  [<ffffffffa0696f6d>] xfs_inactive+0x8d/0x130 [xfs]
[42497.217570]  [<ffffffffa069c2c6>] xfs_fs_evict_inode+0xa6/0xe0 [xfs]
[42497.224097]  [<ffffffff811fc0c7>] evict+0xa7/0x170
[42497.229080]  [<ffffffff811fc9ab>] iput+0x18b/0x1f0
[42497.234081]  [<ffffffff811f12de>] do_unlinkat+0x1ae/0x2b0
[42497.239679]  [<ffffffff811e5a5e>] ? SYSC_newstat+0x3e/0x60
[42497.245370]  [<ffffffff811f22e6>] SyS_unlink+0x16/0x20
[42497.250738]  [<ffffffff816479c9>] system_call_fastpath+0x16/0x1b


As you saw from above log, it is related to the "ifree" transaction.
And most reservation space was used in "t_decrease[7] = 110508", which was recorded
in line 356 below.

 277 static void
 278 xlog_cil_insert_items(
 279         struct xlog             *log,
 280         struct xfs_trans        *tp)
 281 {

....

 340         /* do we need space for more log record headers? */
 341         iclog_space = log->l_iclog_size - log->l_iclog_hsize;
 342         if (len > 0 && (ctx->space_used / iclog_space !=
 343                                 (ctx->space_used + len) / iclog_space)) {
 344                 int hdrs;
 345
 346                 hdrs = (len + iclog_space - 1) / iclog_space;
 347                 /* need to take into account split region headers, too */
 348                 hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
 349                 ctx->ticket->t_unit_res += hdrs;
 350                 ctx->ticket->t_curr_res += hdrs;
 351                 tp->t_ticket->t_curr_res -= hdrs;
 352                 tp->t_ticket->t_decrease[6] = hdrs;
 353                 ASSERT(tp->t_ticket->t_curr_res >= len);
 354         }
 355         tp->t_ticket->t_curr_res -= len;
 356         tp->t_ticket->t_decrease[7] = len;
 357         ctx->space_used += len;
 358
 359         spin_unlock(&cil->xc_cil_lock);
 360 }

Any idea why it used so many reservation space here?

Thanks,
Ming
