Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD2FEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjG0WYv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjG0WYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2032F0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7030C61F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB58EC433C8;
        Thu, 27 Jul 2023 22:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496688;
        bh=wdx6l8mqpLIPLrMgNIrZiTnW79D3dWOuKHz40qhzCJA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mKCc+lUsD1sRU1mIXVVkwi/MxJLlHswCP+SmZ18E5Dcx31yWAvouxQAYH1n7diJiJ
         f1g2Ie5JhAmaJv+E3w6HEH5cHxCKgIWVVIwbVxHdRflV7Smt0F1NExTAiVMfsr2wWc
         Td10qSQzurGlnBbD+4fQZ4psrt4o4ciOO/g1jSC7aZ0PpL3jppO/4SItgjXA6/LTeB
         kXrZIsjZXDVeJ7d/JW403NeahETgQf3VLVJ7i4ogL7MbjntYlDfNZfb4jsO8n40Gtr
         6hyTDsXaSsidAHwAhlgzFSH7mgRPiYQAA74d1dQoxa0KczGmUIyeUJXjILJV2e5QQA
         ZnXYxA0BPAzLQ==
Date:   Thu, 27 Jul 2023 15:24:48 -0700
Subject: [PATCH 4/6] xfs: add debug knobs to control btree bulk load slack
 factors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623232.921279.6460456369281334556.stgit@frogsfrogsfrogs>
In-Reply-To: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some debug knobs so that we can control the leaf and node block
slack when rebuilding btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/newbt.c |   10 ++++++---
 fs/xfs/xfs_globals.c |   12 +++++++++++
 fs/xfs/xfs_sysctl.h  |    2 ++
 fs/xfs/xfs_sysfs.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index cbfe2ffada635..adbc3ec1d4167 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -49,9 +49,13 @@ xrep_newbt_estimate_slack(
 	uint64_t		free;
 	uint64_t		sz;
 
-	/* Let the btree code compute the default slack values. */
-	bload->leaf_slack = -1;
-	bload->node_slack = -1;
+	/*
+	 * The xfs_globals values are set to -1 (i.e. take the bload defaults)
+	 * unless someone has set them otherwise, so we just pull the values
+	 * here.
+	 */
+	bload->leaf_slack = xfs_globals.bload_leaf_slack;
+	bload->node_slack = xfs_globals.bload_node_slack;
 
 	if (sc->ops->type == ST_PERAG) {
 		free = sc->sa.pag->pagf_freeblks;
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 9edc1f2bc9399..f18fec0adf666 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -44,4 +44,16 @@ struct xfs_globals xfs_globals = {
 	.pwork_threads		=	-1,	/* automatic thread detection */
 	.larp			=	false,	/* log attribute replay */
 #endif
+
+	/*
+	 * Leave this many record slots empty when bulk loading btrees.  By
+	 * default we load new btree leaf blocks 75% full.
+	 */
+	.bload_leaf_slack	=	-1,
+
+	/*
+	 * Leave this many key/ptr slots empty when bulk loading btrees.  By
+	 * default we load new btree node blocks 75% full.
+	 */
+	.bload_node_slack	=	-1,
 };
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index f78ad6b10ea58..276696a07040c 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -85,6 +85,8 @@ struct xfs_globals {
 	int	pwork_threads;		/* parallel workqueue threads */
 	bool	larp;			/* log attribute replay */
 #endif
+	int	bload_leaf_slack;	/* btree bulk load leaf slack */
+	int	bload_node_slack;	/* btree bulk load node slack */
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index a3c6b15487237..4eaa0507ec287 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -253,6 +253,58 @@ larp_show(
 XFS_SYSFS_ATTR_RW(larp);
 #endif /* DEBUG */
 
+STATIC ssize_t
+bload_leaf_slack_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	xfs_globals.bload_leaf_slack = val;
+	return count;
+}
+
+STATIC ssize_t
+bload_leaf_slack_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack);
+}
+XFS_SYSFS_ATTR_RW(bload_leaf_slack);
+
+STATIC ssize_t
+bload_node_slack_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	xfs_globals.bload_node_slack = val;
+	return count;
+}
+
+STATIC ssize_t
+bload_node_slack_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack);
+}
+XFS_SYSFS_ATTR_RW(bload_node_slack);
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
@@ -262,6 +314,8 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(pwork_threads),
 	ATTR_LIST(larp),
 #endif
+	ATTR_LIST(bload_leaf_slack),
+	ATTR_LIST(bload_node_slack),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_dbg);

