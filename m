Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 583487CC5
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5A34AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:26 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CQjdRXkVHizAMKIN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:25 -0700 (PDT)
Subject: [PATCH 004/119] xfs: enable buffer deadlock postmortem diagnosis
	via ftrace
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:18:18 -0700
Message-ID: <146612629822.12839.7938642541078923297.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Create a second buf_trylock tracepoint so that we can distinguish
between a successful and a failed trylock.  With this piece, we can
use a script to look at the ftrace output to detect buffer deadlocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c   |    3 ++-
 fs/xfs/xfs_trace.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index efa2a73..2333db7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -947,7 +947,8 @@ xfs_buf_trylock(
 	if (locked)
 		XB_SET_OWNER(bp);
 
-	trace_xfs_buf_trylock(bp, _RET_IP_);
+	locked ? trace_xfs_buf_trylock(bp, _RET_IP_) :
+		 trace_xfs_buf_trylock_fail(bp, _RET_IP_);
 	return locked;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ea94ee0..68f27f7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -354,6 +354,7 @@ DEFINE_BUF_EVENT(xfs_buf_submit_wait);
 DEFINE_BUF_EVENT(xfs_buf_bawrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
+DEFINE_BUF_EVENT(xfs_buf_trylock_fail);
 DEFINE_BUF_EVENT(xfs_buf_trylock);
 DEFINE_BUF_EVENT(xfs_buf_unlock);
 DEFINE_BUF_EVENT(xfs_buf_iowait);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
