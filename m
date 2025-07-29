Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8E2BE044
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820055; cv=none; b=BHQ3bdY3uNCC2vYklrn5Q+irBGO/l++DDZhQX9DuQstIzzwVEAdqlAuqA7Uznnhlm+rMxxRqNUxHW5jFTX9OR83jMzjSjQ/781uxkcKpQ6NpMnL6t9eXZ5eZ29PLtEw/BUErJoVE5HicXjTo4KPp1S3N7XsG69fQg72DI20GgHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820055; c=relaxed/simple;
	bh=cA7Km08RFy/o8JQEcg03CsgKi2ze7KSIVHBNZYZ4RFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8ZZa+Pa1H5uRyFTjKK7fTp3pDWJDhGlpTXPidmWMnbpadVuHNrop43V9qJTwpUM6rFH873cZFMyoAwJ2G/vqb354DGcHpc86psteDBIo4RdsmWD6V7axlCHbXrk1RjeTtZMHtu3e61lsDXjaoNH8hJu4aBinZpJCoKUld1c/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZZp/fY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZZp/fY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1375DC4CEEF;
	Tue, 29 Jul 2025 20:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820055;
	bh=cA7Km08RFy/o8JQEcg03CsgKi2ze7KSIVHBNZYZ4RFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZZp/fY48g3T6fC7FLkWr9iVtdJYDfPnAdLT178YVkhCpauq305Kh2LmG1/YJz1h+
	 r2id7AzPGCSxOw0BwTxSx6QJiF9Kd8wzvWYAZbahwvN51IQ4KudgJw2ZpaHHcsrfhZ
	 i71EbRLyZsWdouEKCJsOgrgsdGNBz6l2i0Huad+Ll+Ph2saS4HdU3hSbKwrjR7Gr+W
	 rVICo3XwmULJOj9ov18vBZgkenEUj8sS9Zbp3WIho3BGGSRJ06y4OvXekz8eLk2bKw
	 jdCJKZBUzFSZVFVKWHC8GI0nWdK0Q6wB0A4fqGFeJFj4vzUUh8nA8UvDxzxleVMdY5
	 YzzY9eD9CoACg==
Date: Tue, 29 Jul 2025 13:14:14 -0700
Subject: [PATCH 1/1] misc: fix reversed calloc arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175381999075.3030568.1303902231364782556.stgit@frogsfrogsfrogs>
In-Reply-To: <175381999056.3030568.12773129144419141720.stgit@frogsfrogsfrogs>
References: <175381999056.3030568.12773129144419141720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

gcc 14 complains about reversed arguments to calloc:

namei.c: In function ‘path_parse’:
namei.c:51:32: warning: ‘calloc’ sizes specified with ‘sizeof’ in the earlier argument and not in the later argument [-Wcalloc-transposed-args]
   51 |         dirpath = calloc(sizeof(*dirpath), 1);
      |                                ^
namei.c:51:32: note: earlier argument should specify number of elements, later size of each element

Fix all of these.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/namei.c          |    2 +-
 libxcmd/input.c     |    2 +-
 logprint/log_misc.c |    2 +-
 repair/phase3.c     |    2 +-
 repair/quotacheck.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 2586e0591c2357..1d9581c323cd67 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -48,7 +48,7 @@ path_parse(
 	const char	*p = path;
 	const char	*endp = path + strlen(path);
 
-	dirpath = calloc(sizeof(*dirpath), 1);
+	dirpath = calloc(1, sizeof(*dirpath));
 	if (!dirpath)
 		return NULL;
 
diff --git a/libxcmd/input.c b/libxcmd/input.c
index fa80e5abb224ee..4092d9d06382e9 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -90,7 +90,7 @@ breakline(
 {
 	int	c = 0;
 	char	*p;
-	char	**rval = calloc(sizeof(char *), 1);
+	char	**rval = calloc(1, sizeof(char *));
 
 	while (rval && (p = strsep(&input, " ")) != NULL) {
 		if (!*p)
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 144695753211aa..88679e9ee1dce6 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -140,7 +140,7 @@ xlog_print_add_to_trans(xlog_tid_t	tid,
 {
     xlog_split_item_t *item;
 
-    item	  = (xlog_split_item_t *)calloc(sizeof(xlog_split_item_t), 1);
+    item	  = (xlog_split_item_t *)calloc(1, sizeof(xlog_split_item_t));
     item->si_xtid  = tid;
     item->si_skip = skip;
     item->si_next = split_list;
diff --git a/repair/phase3.c b/repair/phase3.c
index 3a3ca22de14d26..6ec616d9b31d44 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -150,7 +150,7 @@ phase3(
 	do_log(_("        - process newly discovered inodes...\n"));
 	set_progress_msg(PROG_FMT_NEW_INODES, (uint64_t) glob_agcount);
 
-	counts = calloc(sizeof(*counts), mp->m_sb.sb_agcount);
+	counts = calloc(mp->m_sb.sb_agcount, sizeof(*counts));
 	if (!counts) {
 		do_abort(_("no memory for uncertain inode counts\n"));
 		return;
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 7953144c3f416b..df6cde2d58aec0 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -116,7 +116,7 @@ qc_rec_get(
 	pthread_mutex_lock(&dquots->lock);
 	node = avl64_find(&dquots->tree, id);
 	if (!node && can_alloc) {
-		qrec = calloc(sizeof(struct qc_rec), 1);
+		qrec = calloc(1, sizeof(struct qc_rec));
 		if (qrec) {
 			qrec->id = id;
 			node = avl64_insert(&dquots->tree, &qrec->node);

