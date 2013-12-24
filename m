Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F34C07F9C
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 06:48:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E08178F8040
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 04:48:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id sp0YZvjjzYFEfuWA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Dec 2013 04:48:25 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBOCmNAS021331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:24 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmMbL028944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:23 GMT
Received: from ubhmt104.oracle.com (ubhmt104.oracle.com [156.151.24.9])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmMUv011029 for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:22 GMT
Message-ID: <52B98292.5040002@oracle.com>
Date: Tue, 24 Dec 2013 20:48:18 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs: wake up cil->xc_commit_wait while removing ctx from
	cil->xc_committing
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

I can easily to hit a hang up while running fsstress and shutting down
XFS on SSD via the tests below:

for ((i=0;i<10;i++))
do
    echo "[$i] Fire up..."
    mount /dev/sda7 /xfs
    fsstress -d /xfs -n 1000 -p 100 >/dev/null 2>&1 &
    sleep 10
    godown /xfs
    wait
    killall -q fsstress
    umount /xfs
    echo "[$i] Done...."
    echo
done

which yielding a backtrace as below:

[  246.268987] INFO: task fsstress:3347 blocked for more than 120 seconds.
[  246.268992]       Tainted: PF          O 3.13.0-rc2+ #4
[  246.268994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.268996] fsstress        D ffff88026f254440     0  3347   3284
<snip>
[  246.269013] Call Trace:
[  246.269022]  [<ffffffff816f3829>] schedule+0x29/0x70
[  246.269054]  [<ffffffffa0c4546b>] xlog_cil_force_lsn+0x1cb/0x220 [xfs]
[  246.269059]  [<ffffffff81097210>] ? wake_up_state+0x20/0x20
[  246.269064]  [<ffffffff811e9110>] ? do_fsync+0x80/0x80
[  246.269087]  [<ffffffffa0c43881>] _xfs_log_force+0x61/0x270 [xfs]
[  246.269091]  [<ffffffff8128b490>] ? jbd2_log_wait_commit+0x110/0x180
[  246.269095]  [<ffffffff810a83f0>] ? prepare_to_wait_event+0x100/0x100
[  246.269098]  [<ffffffff811e9110>] ? do_fsync+0x80/0x80
[  246.269120]  [<ffffffffa0c43ab6>] xfs_log_force+0x26/0x80 [xfs]
[  246.269139]  [<ffffffffa0bea31d>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
[  246.269143]  [<ffffffff811e9130>] sync_fs_one_sb+0x20/0x30
[  246.269147]  [<ffffffff811bd5d2>] iterate_supers+0xb2/0x110
[  246.269150]  [<ffffffff811e9262>] sys_sync+0x62/0xa0
[  246.269156]  [<ffffffff816ffd6d>] system_call_fastpath+0x1a/0x1f
[  266.335154] XFS (sda7): xfs_log_force: error 5 returned.
[  296.400515] XFS (sda7): xfs_log_force: error 5 returned.

In xlog_cil_force_lsn(), if the task finds a previous sequence still in
committing, it need to wait until all those previously sequence commits
to complete, i.e, blocked on cil->xc_commit_wait wait queue.  In normal
situations, the ctx with a previous sequence will eventually commit and
wake up tasks on cil->xc_commit_wait after getting a vaild commit_lsn
(see xlog_cil_push()).  However, if something wrong during commit, e.g,
XLOG_STATE_IOERROR is detected, it will be aborted and the ctx will be
just removed from the cil->xc_committing list but we did not wake up
the waiting tasks in this case.  Hence, there is a race condition will
happen as below:

	Task1                    Task2

                	list_add(&ctx->committing, &cil->xc_committing);

xlog_wait(&cil->xc_commit_wait..)
schedule()...

                	Aborting!! list_del(&ctx->committing);
                	wake_up_all(&cil->xc_commit_wait); <-- MISSING!

As a result, we should handle this situation in xlog_cil_committed().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_cil.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5eb51fc..8c7e9c7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -406,6 +406,8 @@ xlog_cil_committed(
 
 	spin_lock(&ctx->cil->xc_push_lock);
 	list_del(&ctx->committing);
+	if (abort)
+		wake_up_all(&ctx->cil->xc_commit_wait);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
 	xlog_cil_free_logvec(ctx->lv_chain);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
