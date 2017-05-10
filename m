Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752853AbdEJObx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 10:31:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB90A804EB
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E38B8854F
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/2] xfs: define bug_on_assert debug mode sysfs tunable
Date: Wed, 10 May 2017 10:31:50 -0400
Message-Id: <1494426711-6934-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
References: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In DEBUG mode, assert failures unconditionally trigger a kernel BUG.
This is useful in diagnostic situations to panic a system and
collect detailed state information at the time of a failure.

This can also cause problems in cases where DEBUG mode code is
desired but it is preferable not trigger kernel BUGs on assert
failure. For example, during development of new code or during
certain xfstests tests that intentionally cause corruption and test
the kernel for survival (but otherwise may expect to trigger assert
failures).

To provide additional flexibility, create the
<sysfs>/fs/xfs/debug/bug_on_assert tunable to configure assert
failure behavior at runtime. This tunable is only available in DEBUG
mode and is enabled by default to preserve existing default
behavior. When disabled, assert failures in DEBUG mode result in
kernel warnings.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_globals.c |  2 ++
 fs/xfs/xfs_message.c |  5 ++++-
 fs/xfs/xfs_sysctl.h  |  1 +
 fs/xfs/xfs_sysfs.c   | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 687a4b0..673adf0 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -47,4 +47,6 @@ xfs_param_t xfs_params = {
 
 struct xfs_globals xfs_globals = {
 	.log_recovery_delay	=	0,	/* no delay by default */
+	.bug_on_assert		=	true,	/* historical default in DEBUG
+						 * mode */
 };
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 11792d8..e68bd10 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -110,7 +110,10 @@ assfail(char *expr, char *file, int line)
 {
 	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
 		expr, file, line);
-	BUG();
+	if (xfs_globals.bug_on_assert)
+		BUG();
+	else
+		WARN_ON(1);
 }
 
 void
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 984a349..82afee0 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -95,6 +95,7 @@ extern xfs_param_t	xfs_params;
 
 struct xfs_globals {
 	int	log_recovery_delay;	/* log recovery delay (secs) */
+	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
 };
 extern struct xfs_globals	xfs_globals;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 80ac15f..ec6e0e2 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -146,6 +146,38 @@ struct kobj_type xfs_mp_ktype = {
 /* debug */
 
 STATIC ssize_t
+bug_on_assert_store(
+	struct kobject		*kobject,
+	const char		*buf,
+	size_t			count)
+{
+	int			ret;
+	int			val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val == 1)
+		xfs_globals.bug_on_assert = true;
+	else if (val == 0)
+		xfs_globals.bug_on_assert = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+STATIC ssize_t
+bug_on_assert_show(
+	struct kobject		*kobject,
+	char			*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
+}
+XFS_SYSFS_ATTR_RW(bug_on_assert);
+
+STATIC ssize_t
 log_recovery_delay_store(
 	struct kobject	*kobject,
 	const char	*buf,
@@ -176,6 +208,7 @@ log_recovery_delay_show(
 XFS_SYSFS_ATTR_RW(log_recovery_delay);
 
 static struct attribute *xfs_dbg_attrs[] = {
+	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
 	NULL,
 };
-- 
2.7.4

