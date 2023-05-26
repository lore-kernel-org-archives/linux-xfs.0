Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7E2C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjEZBrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjEZBrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546318D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51AA364868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E3C433EF;
        Fri, 26 May 2023 01:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065666;
        bh=6Z6Tex5GuzZB/AK4ZVJSk4S4b+KDWqsF7Nv5FXKyP/4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bcLkj6eNzRH4T2G2sH0OIx4TeGAi8EBnfl6Xhm8aqbcZVyK82jEzzn03Purnk5AbQ
         6znvxewIrvM6vIUEqwGeJzOh5uZcMRJmDUgIPFWmoLQ2+6lBhd6eKg93UQI6pJp9Tw
         ba+Va3NNpj7oJgw+OwWkZdPnEHabRXfs2KbcNy+Mf18opA9PY+1mOkaYsE06SM97Cw
         Za6pwFnXcVqmfuybxL/rX9VaEN97q6YRLZuLuMaXpvrgUZkKbQ5ZeTNzglw0UbxoeF
         h8wDwz1qFVfJmPrlMTlbQsiK/KYq5vEWRnoUWNi7zAMQhN9AqENlbu0iHNxcZenMwG
         mmkOps558hGYQ==
Date:   Thu, 25 May 2023 18:47:46 -0700
Subject: [PATCH 1/4] libfrog: enhance ptvar to support initializer functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072765.3744428.13292568255598716550.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
References: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
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
index 20d15365514..ed12cc42856 100644
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
index 77d5378ec3f..88ca5d95a78 100644
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
index 6476ba0cc92..ad9cba92bfd 100644
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
index e950efdc4e2..131b9d9f7d4 100644
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

