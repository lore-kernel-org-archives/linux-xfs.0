Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13F1E29E03
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:40:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3A38AC008
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EKpE2R7CgSPhJ9VV for
	<xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:40:42 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PFefdW023072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3PFef6Q025763
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:40:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: tracepoints for xfs_iunlink() and
	xfs_iunlink_remove()
Date: Thu, 25 Apr 2013 11:41:29 -0400
Message-Id: <1366904490-46821-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
References: <1366904490-46821-1-git-send-email-bfoster@redhat.com>
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

Add tracepoints for xfs_iunlink() and xfs_iunlink_remove(). These
tracepoints are useful for debugging inode link (and unlinked list
issues).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c |    4 ++++
 fs/xfs/xfs_trace.h |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4f20165..c22f980 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1519,6 +1519,8 @@ xfs_iunlink(
 
 	mp = tp->t_mountp;
 
+	trace_xfs_iunlink(ip);
+
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
@@ -1598,6 +1600,8 @@ xfs_iunlink_remove(
 	mp = tp->t_mountp;
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 
+	trace_xfs_iunlink_remove(ip);
+
 	/*
 	 * Get the agi buffer first.  It ensures lock ordering
 	 * on the list.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aa4db33..43bd572 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -586,6 +586,8 @@ DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
 DEFINE_INODE_EVENT(xfs_evict_inode);
 DEFINE_INODE_EVENT(xfs_update_time);
+DEFINE_INODE_EVENT(xfs_iunlink);
+DEFINE_INODE_EVENT(xfs_iunlink_remove);
 
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
