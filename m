Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55782C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdS0WiM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A2FC433C7;
	Sun, 31 Dec 2023 22:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062656;
	bh=JGT4uiVu3VwwN5Llmw/ta+wLN/kdUn1qERbrgeQii7M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kdS0WiM8UZIFzz0geGirrat7I5dTn3YcTZWlZgN1CBodSqXb8uF3TLe9LrqwOeZy9
	 cLU96zJjtvoyErRzVQEgBzmRIH+/7/PdDqesfhO1RVo8vQxhtt3hS99nGwOYnc6qUL
	 R9sWEAOmKKtos+FQOXNs1H7Ouq9jKE5gQ2FhMRj5Aug7Yms3KI5LIkhYaGW1vFakQC
	 fRty9wRNYqw9WBZ2XeRDNpPgZhznRhVYNY1dqk9jOHGWoLFffQegmyhHxkYKJ04szE
	 aIYS4s4bFZD1MY8DsHtmWPrEgBEjdAK/BLsIS0ha06vXJ43ep6Rla4om6SZ/6eU7NQ
	 G69tdgdIvFnpg==
Date: Sun, 31 Dec 2023 14:44:15 -0800
Subject: [PATCH 1/4] libfrog: enhance ptvar to support initializer functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000237.1798235.3216092633181820932.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
References: <170405000222.1798235.1301416875511824495.stgit@frogsfrogsfrogs>
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
index 2ee357f3a76..c903454c0dc 100644
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
index cd4501f72b7..cce5ede0012 100644
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
index 29d7939549f..52348274be2 100644
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

