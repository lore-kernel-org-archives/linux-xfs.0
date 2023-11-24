Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BF33DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvGVYYPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8875BC433C8;
	Fri, 24 Nov 2023 23:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869755;
	bh=3gJq//hJG+ZlxplrFhUGZ5h+Y56FYfWNyBmMESDc1JE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FvGVYYPyy4GC1DaHiHvhnVkb6n9wiSrt1ipHk+R760ta7u5MtIe/RYbhQTvzzmwR5
	 1Hq62mWaX3oiN58eXEqObrmrJhoEM/1KqqTH5HtG1I1ps+rT2sesSKNdX1Fjjpd9WE
	 O3iNrLhqNaHiLXzfEtZ1oxWrfkIH4BM2Z/R68z1hjKcnmQCpkgeNo/P1ZJ915eO/+R
	 98+iX7wDQcCvOruuOMtZx1ZMJyrP6OAcnjRxZ79vllqTxRyzr8uShq0i7Jp4Xa3Jo1
	 H3p8NcyR9T/qbkZeoJHaHXDdUvlYyTRr+KT1Oln/D+Noh3GDY9RRbZ/O/NQXetgCZe
	 Gw5k+VLbQOm9Q==
Date: Fri, 24 Nov 2023 15:49:15 -0800
Subject: [PATCH 2/4] xfs: add debug knobs to control btree bulk load slack
 factors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

