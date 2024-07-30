Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246087464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301501; cv=none; b=ERnssu0cKJDSkRW0bDQfm62qEmhs31hmhF6E25hOF3Tl4ih81Hs4cA89rN2V68sy1jPj1vflFeSZhw0pKQ4zsNA6A+HduEi9I4qlul45JS2rxYBErVhYUHLTgcxEmzgidFKhWbrKx0YiTDzFana+G6KqtwdnnLOPOqfrA1/t424=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301501; c=relaxed/simple;
	bh=O3tavl00HoFOxMQ4iQH6EEtM1sVGBucSefOZqL4Kzg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VERzs8HGjaZPBIi2GYPnSrHp/YSizLBoBf1Z0RFLBPDBYZZyGwFP6p+gL/Pu6SHilZvzu21wHFaDyykdqvDAKOx/VikXRWm8Hf2fIqzOXl23IsP/BOInqFrJQhfjwBIP1ZscAsKc+XPUeC5BMDQpBqSW9234YYTA0r9jwjF4xpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=riMyLNJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="riMyLNJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D9C32786;
	Tue, 30 Jul 2024 01:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301501;
	bh=O3tavl00HoFOxMQ4iQH6EEtM1sVGBucSefOZqL4Kzg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=riMyLNJo0rEA9YAjY9MAX8d8T323x2GPXjqF5dRAY0/UfXVPhd2Y29iU1pl5NQLdC
	 YMeybuQo61k7+qZ+h4jGtLAfG0fNXHfJKU3/xk7CbE1I2dzDFf4VAtMJ0ez7E5GzBR
	 IgJOUrSE2vKxSAYc6/9YFj2sVa+3wXW9ihLyatLKS9ubLbnqkxKWxT+ecy2TIX8xw3
	 7hWxm0BHrPTD9vtophFcuFl7Oxu73rDu/VKVxdKm2msVHAHdITbr820FjVhXvpu7st
	 XOjptUjTq/BaYs4p3UtVrm0FAEs/ViuwHmWV7LJ1UrhiKhTUvdfM0wO2+chYunEfPO
	 DB30p4BB6AgYA==
Date: Mon, 29 Jul 2024 18:05:00 -0700
Subject: [PATCH 1/4] libfrog: enhance ptvar to support initializer functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847164.1348659.6687708357250131254.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847145.1348659.7832915816905920685.stgit@frogsfrogsfrogs>
References: <172229847145.1348659.7832915816905920685.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/ptvar.c     |    9 ++++++++-
 libfrog/ptvar.h     |    4 +++-
 scrub/counter.c     |    2 +-
 scrub/descr.c       |    2 +-
 scrub/phase7.c      |    2 +-
 scrub/read_verify.c |    2 +-
 6 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index 7ac8c5418..9d5ae6bc8 100644
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
index b7d02d626..e4a181ffe 100644
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
index 2ee357f3a..c903454c0 100644
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
index 77d5378ec..88ca5d95a 100644
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
index cd4501f72..cce5ede00 100644
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
index 29d793954..52348274b 100644
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

