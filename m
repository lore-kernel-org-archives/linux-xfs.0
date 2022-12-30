Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A72C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiLaAbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiLaAbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AC513DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A4361D4E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25894C433F0;
        Sat, 31 Dec 2022 00:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446669;
        bh=CSeQacM9ejZy8MUbqWG4oiVtB+zAZKmEtM338S6p7bs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z5POvMS/le8tpMxKupO4fSSkogHCD0PUz3+Lp4Y/jCprnQkUcJbS/wIiocRixqT52
         ixOc4hPNck3P68zr3OibAqahDTT8rhrZNQBR/BhoiJA6cZu8rQVExAXm16zng0H6gi
         tDhOcH4YDIw8IUEcHIVo1hkLfFrj3YmCc5F4ETi+i0/9uUTqrvkXuHEg3+/rmoxDF2
         kBbJA+0uWl7bfuJaTmdE7dsvzAPdE1pQy+ZGz346DxZo8PvYDyUo9RuGYStEtNTJ+9
         BMqZzwbfM+47TS2oXRTfLc/ANds5pNFPLhmMrPeglI0dwKjU0Q747flhXn5Kpd+Zqj
         Blylp/qDMTQIw==
Subject: [PATCH 1/4] libfrog: enhance ptvar to support initializer functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870444.716640.9510831594966072132.stgit@magnolia>
In-Reply-To: <167243870430.716640.15368107413813691968.stgit@magnolia>
References: <167243870430.716640.15368107413813691968.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Modify the per-thread variable code to support passing in an initializer
function that will set up each thread's variable space when it is
claimed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/ptvar.c     |    9 ++++++++-
 libfrog/ptvar.h     |    4 +++-
 scrub/counter.c     |    2 +-
 scrub/descr.c       |    2 +-
 scrub/phase7.c      |    2 +-
 scrub/read_verify.c |    2 +-
 6 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index 7ac8c541862..9d5ae6bc8e3 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -26,6 +26,7 @@
 struct ptvar {
 	pthread_key_t	key;
 	pthread_mutex_t	lock;
+	ptvar_init_fn	init_fn;
 	size_t		nr_used;
 	size_t		nr_counters;
 	size_t		data_size;
@@ -38,6 +39,7 @@ int
 ptvar_alloc(
 	size_t		nr,
 	size_t		size,
+	ptvar_init_fn	init_fn,
 	struct ptvar	**pptv)
 {
 	struct ptvar	*ptv;
@@ -58,6 +60,7 @@ ptvar_alloc(
 	ptv->data_size = size;
 	ptv->nr_counters = nr;
 	ptv->nr_used = 0;
+	ptv->init_fn = init_fn;
 	memset(ptv->data, 0, nr * size);
 	ret = -pthread_mutex_init(&ptv->lock, NULL);
 	if (ret)
@@ -98,11 +101,15 @@ ptvar_get(
 	if (!p) {
 		pthread_mutex_lock(&ptv->lock);
 		assert(ptv->nr_used < ptv->nr_counters);
-		p = &ptv->data[(ptv->nr_used++) * ptv->data_size];
+		p = &ptv->data[ptv->nr_used * ptv->data_size];
 		ret = -pthread_setspecific(ptv->key, p);
 		if (ret)
 			goto out_unlock;
+		ptv->nr_used++;
 		pthread_mutex_unlock(&ptv->lock);
+
+		if (ptv->init_fn)
+			ptv->init_fn(p);
 	}
 	*retp = 0;
 	return p;
diff --git a/libfrog/ptvar.h b/libfrog/ptvar.h
index b7d02d6269e..e4a181ffe76 100644
--- a/libfrog/ptvar.h
+++ b/libfrog/ptvar.h
@@ -8,7 +8,9 @@
 
 struct ptvar;
 
-int ptvar_alloc(size_t nr, size_t size, struct ptvar **pptv);
+typedef void (*ptvar_init_fn)(void *data);
+int ptvar_alloc(size_t nr, size_t size, ptvar_init_fn init_fn,
+		struct ptvar **pptv);
 void ptvar_free(struct ptvar *ptv);
 void *ptvar_get(struct ptvar *ptv, int *ret);
 
diff --git a/scrub/counter.c b/scrub/counter.c
index 6d91eb6e015..174f480f882 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -38,7 +38,7 @@ ptcounter_alloc(
 	p = malloc(sizeof(struct ptcounter));
 	if (!p)
 		return errno;
-	ret = -ptvar_alloc(nr, sizeof(uint64_t), &p->var);
+	ret = -ptvar_alloc(nr, sizeof(uint64_t), NULL, &p->var);
 	if (ret) {
 		free(p);
 		return ret;
diff --git a/scrub/descr.c b/scrub/descr.c
index e694d01d7b7..152d9150621 100644
--- a/scrub/descr.c
+++ b/scrub/descr.c
@@ -89,7 +89,7 @@ descr_init_phase(
 	int			ret;
 
 	assert(descr_ptvar == NULL);
-	ret = -ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
+	ret = -ptvar_alloc(nr_threads, DESCR_BUFSZ, NULL, &descr_ptvar);
 	if (ret)
 		str_liberror(ctx, ret, _("creating description buffer"));
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 75d0ee0fb02..f3ab1c9d8f6 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -136,7 +136,7 @@ phase7_func(
 	}
 
 	error = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
-			&ptvar);
+			NULL, &ptvar);
 	if (error) {
 		str_liberror(ctx, error, _("setting up block counter"));
 		return error;
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index be30f2688f9..19f74fae722 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -120,7 +120,7 @@ read_verify_pool_alloc(
 	rvp->disk = disk;
 	rvp->ioerr_fn = ioerr_fn;
 	ret = -ptvar_alloc(submitter_threads, sizeof(struct read_verify),
-			&rvp->rvstate);
+			NULL, &rvp->rvstate);
 	if (ret)
 		goto out_counter;
 	ret = -workqueue_create(&rvp->wq, (struct xfs_mount *)rvp,

