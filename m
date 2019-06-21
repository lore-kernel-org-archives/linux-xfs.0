Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfFUX1P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jun 2019 19:27:15 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] quota: honor quote type in Q_XGETQSTAT[V] calls
Message-ID: <0b96d49c-3c0b-eb71-dd87-750a6a48f1ef@redhat.com>
Date: Fri, 21 Jun 2019 18:27:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Bob Peterson <rpeterso@redhat.com>

The code in quota_getstate and quota_getstatev is strange; it
says the returned fs_quota_stat[v] structure has room for only
one type of time limits, so fills it in with the first enabled
quota, even though every quotactl command must have a type sent
in by the user.

Instead of just picking the first enabled quota, fill in the
reply with the timers for the quota type that was actually
requested.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I guess this is a change in behavior, but it goes from a rather
unexpected and unpredictable behavior to something more expected,
so I hope it's ok.

I'm working on breaking out xfs quota timers by type as well
(they are separate on disk, but not in memory) so I'll work
up an xfstest to go with this...

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index fd5dd806f1b9..cb13fb76dbee 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -331,9 +331,9 @@ static int quota_state_to_flags(struct qc_state *state)
 	return flags;
 }
 
-static int quota_getstate(struct super_block *sb, struct fs_quota_stat *fqs)
+static int quota_getstate(struct super_block *sb, int type,
+			  struct fs_quota_stat *fqs)
 {
-	int type;
 	struct qc_state state;
 	int ret;
 
@@ -349,14 +349,7 @@ static int quota_getstate(struct super_block *sb, struct fs_quota_stat *fqs)
 	if (!fqs->qs_flags)
 		return -ENOSYS;
 	fqs->qs_incoredqs = state.s_incoredqs;
-	/*
-	 * GETXSTATE quotactl has space for just one set of time limits so
-	 * report them for the first enabled quota type
-	 */
-	for (type = 0; type < MAXQUOTAS; type++)
-		if (state.s_state[type].flags & QCI_ACCT_ENABLED)
-			break;
-	BUG_ON(type == MAXQUOTAS);
+
 	fqs->qs_btimelimit = state.s_state[type].spc_timelimit;
 	fqs->qs_itimelimit = state.s_state[type].ino_timelimit;
 	fqs->qs_rtbtimelimit = state.s_state[type].rt_spc_timelimit;
@@ -391,22 +384,22 @@ static int quota_getstate(struct super_block *sb, struct fs_quota_stat *fqs)
 	return 0;
 }
 
-static int quota_getxstate(struct super_block *sb, void __user *addr)
+static int quota_getxstate(struct super_block *sb, int type, void __user *addr)
 {
 	struct fs_quota_stat fqs;
 	int ret;
 
 	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
-	ret = quota_getstate(sb, &fqs);
+	ret = quota_getstate(sb, type, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
 }
 
-static int quota_getstatev(struct super_block *sb, struct fs_quota_statv *fqs)
+static int quota_getstatev(struct super_block *sb, int type,
+			   struct fs_quota_statv *fqs)
 {
-	int type;
 	struct qc_state state;
 	int ret;
 
@@ -422,14 +415,7 @@ static int quota_getstatev(struct super_block *sb, struct fs_quota_statv *fqs)
 	if (!fqs->qs_flags)
 		return -ENOSYS;
 	fqs->qs_incoredqs = state.s_incoredqs;
-	/*
-	 * GETXSTATV quotactl has space for just one set of time limits so
-	 * report them for the first enabled quota type
-	 */
-	for (type = 0; type < MAXQUOTAS; type++)
-		if (state.s_state[type].flags & QCI_ACCT_ENABLED)
-			break;
-	BUG_ON(type == MAXQUOTAS);
+
 	fqs->qs_btimelimit = state.s_state[type].spc_timelimit;
 	fqs->qs_itimelimit = state.s_state[type].ino_timelimit;
 	fqs->qs_rtbtimelimit = state.s_state[type].rt_spc_timelimit;
@@ -455,7 +441,7 @@ static int quota_getstatev(struct super_block *sb, struct fs_quota_statv *fqs)
 	return 0;
 }
 
-static int quota_getxstatev(struct super_block *sb, void __user *addr)
+static int quota_getxstatev(struct super_block *sb, int type, void __user *addr)
 {
 	struct fs_quota_statv fqs;
 	int ret;
@@ -474,7 +460,7 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	default:
 		return -EINVAL;
 	}
-	ret = quota_getstatev(sb, &fqs);
+	ret = quota_getstatev(sb, type, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
@@ -744,9 +730,9 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	case Q_XQUOTARM:
 		return quota_rmxquota(sb, addr);
 	case Q_XGETQSTAT:
-		return quota_getxstate(sb, addr);
+		return quota_getxstate(sb, type, addr);
 	case Q_XGETQSTATV:
-		return quota_getxstatev(sb, addr);
+		return quota_getxstatev(sb, type, addr);
 	case Q_XSETQLIM:
 		return quota_setxquota(sb, type, id, addr);
 	case Q_XGETQUOTA:
