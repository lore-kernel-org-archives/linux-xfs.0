Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E9A57F54
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 17:02:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B12A4AC002
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:02:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4DOOY4E2uPnYD84f for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 15:02:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: inode counter needs to use __percpu_counter_compare
Date: Wed,  6 May 2015 08:01:39 +1000
Message-Id: <1430863299-9341-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1430863299-9341-1-git-send-email-david@fromorbit.com>
References: <1430863299-9341-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Because the counter uses a custom batch size, the comparison
function needs to be aware of that batch size otherwise the
comparison does not work correctly. This leads to ASSERT failures
on generic/027 like this:

 XFS: Assertion failed: 0, file: fs/xfs/xfs_mount.c, line: 1099
 ------------[ cut here ]------------
....
 Call Trace:
  [<ffffffff81522a39>] xfs_mod_icount+0x99/0xc0
  [<ffffffff815285cb>] xfs_trans_unreserve_and_mod_sb+0x28b/0x5b0
  [<ffffffff8152f941>] xfs_log_commit_cil+0x321/0x580
  [<ffffffff81528e17>] xfs_trans_commit+0xb7/0x260
  [<ffffffff81503d4d>] xfs_bmap_finish+0xcd/0x1b0
  [<ffffffff8151da41>] xfs_inactive_ifree+0x1e1/0x250
  [<ffffffff8151dbe0>] xfs_inactive+0x130/0x200
  [<ffffffff81523a21>] xfs_fs_evict_inode+0x91/0xf0
  [<ffffffff811f3958>] evict+0xb8/0x190
  [<ffffffff811f433b>] iput+0x18b/0x1f0
  [<ffffffff811e8853>] do_unlinkat+0x1f3/0x320
  [<ffffffff811d548a>] ? filp_close+0x5a/0x80
  [<ffffffff811e999b>] SyS_unlinkat+0x1b/0x40
  [<ffffffff81e0892e>] system_call_fastpath+0x12/0x71

This is a regression introduced by commit 501ab32 ("xfs: use generic
percpu counters for inode counter").

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02f827f..900f8ce 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1106,8 +1106,9 @@ xfs_mod_icount(
 	int64_t			delta)
 {
 	/* deltas are +/-64, hence the large batch size of 128. */
-	__percpu_counter_add(&mp->m_icount, delta, 128);
-	if (percpu_counter_compare(&mp->m_icount, 0) < 0) {
+#define _ICOUNT_BATCH	128
+	__percpu_counter_add(&mp->m_icount, delta, _ICOUNT_BATCH);
+	if (__percpu_counter_compare(&mp->m_icount, 0, _ICOUNT_BATCH) < 0) {
 		ASSERT(0);
 		percpu_counter_add(&mp->m_icount, -delta);
 		return -EINVAL;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
