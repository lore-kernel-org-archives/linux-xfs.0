Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CE42652B7
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895876; cv=none; b=sphxxsQMFdzfv5Ki/lF3uQUBZch19Nvh0wT5l+uxTUROfV/U8ZO59jr4f1SxRCd3cFfhJiCUEUSCYlTWBNWEyTZj2NHNk2l9LeV/r+dm8sfavU4lhi18TSGhqyQCevJZ0JhxfKI/IZXOx/UY20vI44tDw5psqAcY2HV+gtstD28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895876; c=relaxed/simple;
	bh=DeNAQ6t02ikEz3EkXAncletCe8DvOsz+XOjRZi12yiw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBhN09wfF9Zyc9IC9ipNlkp4I4zhuLXqjvvq3PfBjGF3kjQcEszQg9uLyojjiEyvEdFZkb7G4Oiw71gajCup+CxeCRcpwwibVirYh5sI+AwPlInOGhTe51KALpk9Fx52YxMPPwulzZclglWqknIPbZgmm+QazgHv0FN1TYUWjU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nm8my24a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nm8my24a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9EEC19425;
	Thu, 19 Mar 2026 04:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895876;
	bh=DeNAQ6t02ikEz3EkXAncletCe8DvOsz+XOjRZi12yiw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nm8my24a/8mbvm9TflnOpXWnbME6mZNmfV1a8KpsA46VRerFE6GPB7X89jXXfYxHD
	 AMp+exk44rdBPLgSwii/0X7v7avXwORD0eG39euA10SuENxcAtoeUoXRKLgqkNa3WW
	 Eg0ncbKAT/vsWhhta2QVLS8ix1xL7R1h0fmMi2XVn2Lw8IrmfQ9hkv1Idza9m0aPlJ
	 NUJOwPIKAKb4/Px4KiL+CtSaJEZtXgnbat3VTogBqhLdoH7l2K8IU+K16kvJ7GWiE7
	 c+swHtlonefms34xnCXIP/iPbr67kRXabdU1G1Pv+0Zx09y7pfHTykrd/PHCndj/s/
	 ChbWFIk/wJErg==
Date: Wed, 18 Mar 2026 21:51:16 -0700
Subject: [PATCH 22/22] xfs_scrub: allow overrides of the media verification IO
 limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow power users to override the media verification IO size limits via
magic environment variables.  For the background service, this can be
done via:

[Service]
Environment=XFS_SCRUB_VERIFY_MAX_SIZE=128M

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/README-env-vars.txt |    3 ++
 scrub/read_verify.c     |   62 +++++++++++++++++++++++++++++++++++++++--------
 scrub/xfs_scrub.c       |    3 ++
 3 files changed, 57 insertions(+), 11 deletions(-)


diff --git a/doc/README-env-vars.txt b/doc/README-env-vars.txt
index 6862dcad71e217..03faf0882f1ae0 100644
--- a/doc/README-env-vars.txt
+++ b/doc/README-env-vars.txt
@@ -23,3 +23,6 @@ XFS_SCRUB_THREADS            -- start exactly this number of threads
 Available even in non-debug mode:
 SERVICE_MODE                 -- compress all error codes to 1 for LSB
                                 service action compliance
+XFS_SCRUB_VERIFY_MAX_SIZE    -- maximum size of media verification requests
+XFS_SCRUB_VERIFY_BATCH_LOCALITY -- coalesce sparse areas of up to this size
+                                   to batch verification requests
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 01f9134799384f..19024ddc711dd2 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -38,10 +38,29 @@
 #define RVP_BG_IO_MAX_SIZE		KILOBYTES(256)
 
 /* What's the real maximum IO size? */
-static inline unsigned int
-rvp_io_max_size(void)
+static unsigned int
+rvp_io_max_size(
+	const struct scrub_ctx	*ctx)
 {
-	return bg_mode > 0 ? RVP_BG_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
+	static unsigned int	res;
+	char			*p;
+
+	if (res)
+		return res;
+
+	p = getenv("XFS_SCRUB_VERIFY_MAX_SIZE");
+	if (p) {
+		long long	r = cvtnum(ctx->mnt.fsgeom.blocksize,
+					   ctx->mnt.fsgeom.sectsize, p);
+
+		if (r >= ctx->mnt.fsgeom.blocksize && r <= GIGABYTES(2)) {
+			res = r;
+			return res;
+		}
+	}
+
+	res = bg_mode > 0 ? RVP_BG_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
+	return res;
 }
 
 /* Tolerate 2M holes in adjacent read verify requests. */
@@ -54,10 +73,29 @@ rvp_io_max_size(void)
 #define RVP_BG_IO_BATCH_LOCALITY	KILOBYTES(256)
 
 /* How many holes are we willing to verify to reduce IO count? */
-static inline unsigned int
-rvp_io_batch_locality(void)
+static unsigned int
+rvp_io_batch_locality(
+	const struct scrub_ctx	*ctx)
 {
-	return bg_mode > 0 ? RVP_BG_IO_BATCH_LOCALITY : RVP_IO_BATCH_LOCALITY;
+	static unsigned int	res;
+	char			*p;
+
+	if (res)
+		return res;
+
+	p = getenv("XFS_SCRUB_VERIFY_BATCH_LOCALITY");
+	if (p) {
+		long long	r = cvtnum(ctx->mnt.fsgeom.blocksize,
+					   ctx->mnt.fsgeom.sectsize, p);
+
+		if (r >= ctx->mnt.fsgeom.blocksize && r <= GIGABYTES(2)) {
+			res = r;
+			return res;
+		}
+	}
+
+	res = bg_mode > 0 ? RVP_BG_IO_BATCH_LOCALITY : RVP_IO_BATCH_LOCALITY;
+	return res;
 }
 
 struct read_verify {
@@ -112,17 +150,18 @@ read_verify_pool_alloc(
 	struct read_verify_pool		*rvp;
 	const unsigned int		verifier_threads =
 		read_verify_nproc(ctx);
+	const unsigned int		maxsize =
+		rvp_io_max_size(ctx);
 	int				ret;
 
-	if (rvp_io_max_size() % ctx->mnt.fsgeom.blocksize)
+	if (maxsize % ctx->mnt.fsgeom.blocksize)
 		return EINVAL;
 
 	rvp = calloc(1, sizeof(struct read_verify_pool));
 	if (!rvp)
 		return errno;
 
-	ret = posix_memalign((void **)&rvp->readbuf, page_size,
-			rvp_io_max_size());
+	ret = posix_memalign((void **)&rvp->readbuf, page_size, maxsize);
 	if (ret)
 		goto out_free;
 	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
@@ -351,7 +390,7 @@ read_verify(
 	if (rvp->runtime_error)
 		return;
 
-	io_max_size = rvp_io_max_size();
+	io_max_size = rvp_io_max_size(rvp->ctx);
 
 	while (rv->io_length > 0) {
 		read_error = 0;
@@ -502,7 +541,8 @@ try_read_verify_schedule_io(
 {
 	uint64_t			req_end;
 	uint64_t			rv_end;
-	const unsigned int		locality = rvp_io_batch_locality();
+	const unsigned int		locality =
+		rvp_io_batch_locality(rvp->ctx);
 
 	assert(rvp->readbuf);
 
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index aae24ec83c1c75..0faf49b862b932 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -120,6 +120,9 @@
  * Available even in non-debug mode:
  * SERVICE_MODE			-- compress all error codes to 1 for LSB
  *				   service action compliance
+ * XFS_SCRUB_VERIFY_MAX_SIZE    -- maximum size of media verification requests
+ * XFS_SCRUB_VERIFY_BATCH_LOCALITY -- coalesce sparse areas of up to this size
+ *                                    to batch verification requests
  */
 
 /* Program name; needed for libfrog error reports. */

