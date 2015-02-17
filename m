Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADF1A7F55
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 09:57:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D8D130405F
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 07:57:21 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qUJQ2Gh4RK6T71bZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 07:57:19 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix quota type in quota structures when reusing quota
	file
Date: Tue, 17 Feb 2015 16:57:10 +0100
Message-Id: <1424188630-1111-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org

For filesystems without separate project quota inode field in the
superblock we just reuse project quota file for group quotas (and vice
versa) if project quota file is allocated and we need group quota file.
When we reuse the file, quota structures on disk suddenly have wrong
type stored in d_flags though. Nobody really cares about this (although
structure type reported to userspace was wrong as well) except
that after commit 14bf61ffe6ac (quota: Switch ->get_dqblk() and
->set_dqblk() to use bytes as space units) assertion in
xfs_qm_scall_getquota() started to trigger on xfs/106 test (apparently I
was testing without XFS_DEBUG so I didn't notice when submitting the
above commit).

Fix the problem by properly resetting ddq->d_flags when running quotacheck
for a quota file.

CC: stable@vger.kernel.org
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3e8186279541..dd0dcc7b76cd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -836,6 +836,11 @@ xfs_qm_reset_dqcounts(
 		 */
 		xfs_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
 			    "xfs_quotacheck");
+		/*
+		 * Reset type in case we are reusing group quota file for
+		 * project quotas or vice versa
+		 */
+		ddq->d_flags = type;
 		ddq->d_bcount = 0;
 		ddq->d_icount = 0;
 		ddq->d_rtbcount = 0;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
