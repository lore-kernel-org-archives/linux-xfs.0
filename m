Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC329E7F150
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjI0AQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjI0AOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:14:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7CD1BDD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:33:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA006C433C8;
        Tue, 26 Sep 2023 23:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771208;
        bh=3gJq//hJG+ZlxplrFhUGZ5h+Y56FYfWNyBmMESDc1JE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LUs4mtO+Js31qtldc8mHE9khOsZzODUISz05w7lfkMfjezf0WZKi6Edd3Skha5xjo
         EWW7CdelIFS96cKlEgF/QnE+K8r5yhncyGJOciwNmdSDC7P2wauu9AJqlTZQQEsFHx
         JSt8plDg8gDtAGMjjv+UnSJqqUkKiq+DyOQ7QYPn32+XpCfrYtKkpJs30tb2pKXXZo
         tBEedirfSBQOw4VoronkantyOLFc0YjMhI4gtUDQUr5y1eQikG9jCEmR8tyTUAzz+2
         vZNh0aMLuSoFKrksMR36ES//x9atcxlEiy/o5yZXKIsr4jq9yFvANG6PxLhox+P/3M
         4PfYwInJI1WDQ==
Date:   Tue, 26 Sep 2023 16:33:28 -0700
Subject: [PATCH 2/4] xfs: add debug knobs to control btree bulk load slack
 factors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059605.3313134.15019333471378453170.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059572.3313134.3407643746555317156.stgit@frogsfrogsfrogs>
References: <169577059572.3313134.3407643746555317156.stgit@frogsfrogsfrogs>
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
index 2932fd317ab23..2c388c647d37f 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -47,9 +47,13 @@ xrep_newbt_estimate_slack(
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

