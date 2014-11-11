Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA0AE7F72
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 991A08F8049
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:46 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id gFAZXczI0yKRCSrb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:44 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] xfs: Remove unused variable in xfs_qm_scall_quotaon()
Date: Tue, 11 Nov 2014 22:04:16 +0100
Message-Id: <1415739865-2438-3-git-send-email-jack@suse.cz>
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

sbflags variable in xfs_qm_scall_quotaon() was practically unused (we
only set it to constant at one place and used it elsewhere). Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 80f2d77d929a..5e4944973587 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -315,7 +315,6 @@ xfs_qm_scall_quotaon(
 {
 	int		error;
 	uint		qf;
-	__int64_t	sbflags;
 
 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 	/*
@@ -323,8 +322,6 @@ xfs_qm_scall_quotaon(
 	 */
 	flags &= ~(XFS_ALL_QUOTA_ACCT);
 
-	sbflags = 0;
-
 	if (flags == 0) {
 		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
 			__func__, mp->m_qflags);
@@ -371,11 +368,10 @@ xfs_qm_scall_quotaon(
 	/*
 	 * There's nothing to change if it's the same.
 	 */
-	if ((qf & flags) == flags && sbflags == 0)
+	if ((qf & flags) == flags)
 		return -EEXIST;
-	sbflags |= XFS_SB_QFLAGS;
 
-	if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
+	if ((error = xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)))
 		return error;
 	/*
 	 * If we aren't trying to switch on quota enforcement, we are done.
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
