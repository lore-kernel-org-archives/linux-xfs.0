Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6C61854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309709; cv=none; b=iCkVJJ1MHDpci46X0WE14zOy8SKqne4mRQDl/BFWc9aKn4+7FDtn98c1SIpmYbCRluotq2cxnHk9KeSRZhRqrvtB89qWuqnhm8a0yNF6gXujYuFW2Jlpily/cMZ+dU6DpdAqholGivFUPky6prEOSAOfcI3eH2vop/HLQSW/+9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309709; c=relaxed/simple;
	bh=x3MG6+QNI5V/KjrHr2x69TH02ac4NPYo1jU7NAn4Vtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rjJG//r33tD8yLmTdUh0SFH8lmFt9bMaQifyqTbt1kfvYs3ONFfECHLW1/I1AmKt+WbxxBO5R8n/s8i3Eo4NXsPqFGdB3ggY5fSWK4dVd+jlpjl8gqblVoQBs9dC7xHr1DpL0rqNKB1dXbUQPeYddFTwcEpEfrDDY6l6FNDDgoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnJv9Gmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnJv9Gmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B399C32786;
	Tue, 30 Jul 2024 03:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309709;
	bh=x3MG6+QNI5V/KjrHr2x69TH02ac4NPYo1jU7NAn4Vtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GnJv9Gmbdaxr23ebC0IeLsjyH9bM0V/K/DaT2tPR7o3vrxxbc5VW5bqLcSrc9fyf6
	 a6KHZMhXZYpkKUFWir2dmbcaOV6EtTKEyTEBoXisZnz5ETii86H9KM2oh1vHvuUnrc
	 GHJBhS3fqd5Akh0tCuf8zZXCOdRZremv98YbTZP7f5coy7MfmgmwecKEdRQtOr2dyV
	 VPgdQ3V75R9PbWq17Ddo+qeOcTcbyRI5BkTKftJgPq2r6S0yUFkm920EUSolc8DMwp
	 pYIn/NGYpIvu0emOvfO9JEnvB1MSi5q9Hbs8qUymcl+2Bv0Fkpw2Y6+CO7x4jtGTRX
	 kJLN34mzeltxg==
Date: Mon, 29 Jul 2024 20:21:48 -0700
Subject: [PATCH 1/3] libfrog: define a self_healing filesystem property
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsproperties.c |   38 ++++++++++++++++++++++++++++++++++++++
 libfrog/fsproperties.h |   13 +++++++++++++
 2 files changed, 51 insertions(+)


diff --git a/libfrog/fsproperties.c b/libfrog/fsproperties.c
index c317d15c1de0..4ccd0edd8453 100644
--- a/libfrog/fsproperties.c
+++ b/libfrog/fsproperties.c
@@ -29,11 +29,49 @@ __fsprops_lookup(
 #define fsprops_lookup(values, value) \
 	__fsprops_lookup((values), ARRAY_SIZE(values), (value))
 
+/* Self-healing fs property */
+
+static const char *fsprop_self_healing_values[] = {
+	[FSPROP_SELFHEAL_UNSET]		= NULL,
+	[FSPROP_SELFHEAL_NONE]		= "none",
+	[FSPROP_SELFHEAL_CHECK]		= "check",
+	[FSPROP_SELFHEAL_OPTIMIZE]	= "optimize",
+	[FSPROP_SELFHEAL_REPAIR]	= "repair",
+};
+
+/* Convert the self_healing property enum to a string. */
+const char *
+fsprop_write_self_healing(
+	enum fsprop_self_healing	x)
+{
+	if (x <= FSPROP_SELFHEAL_UNSET ||
+	    x >= ARRAY_SIZE(fsprop_self_healing_values))
+		return NULL;
+	return fsprop_self_healing_values[x];
+}
+
+/*
+ * Turn a self_healing value string into an enumerated value, or _UNSET if it's
+ * not recognized.
+ */
+enum fsprop_self_healing
+fsprop_read_self_healing(
+	const char	*value)
+{
+	int ret = fsprops_lookup(fsprop_self_healing_values, value);
+	if (ret < 0)
+		return FSPROP_SELFHEAL_UNSET;
+	return ret;
+}
+
 /* Return true if a fs property name=value tuple is allowed. */
 bool
 fsprop_validate(
 	const char	*name,
 	const char	*value)
 {
+	if (!strcmp(name, FSPROP_SELF_HEALING_NAME))
+		return fsprops_lookup(fsprop_self_healing_values, value) >= 0;
+
 	return true;
 }
diff --git a/libfrog/fsproperties.h b/libfrog/fsproperties.h
index 6dee8259a437..7004d339715a 100644
--- a/libfrog/fsproperties.h
+++ b/libfrog/fsproperties.h
@@ -47,4 +47,17 @@ bool fsprop_validate(const char *name, const char *value);
 
 /* Specific Filesystem Properties */
 
+#define FSPROP_SELF_HEALING_NAME	"self_healing"
+
+enum fsprop_self_healing {
+	FSPROP_SELFHEAL_UNSET = 0,	/* do not set property */
+	FSPROP_SELFHEAL_NONE,		/* no background scrubs */
+	FSPROP_SELFHEAL_CHECK,		/* allow only background checking */
+	FSPROP_SELFHEAL_OPTIMIZE,	/* allow background optimization */
+	FSPROP_SELFHEAL_REPAIR,		/* allow background repair & optimization */
+};
+
+const char *fsprop_write_self_healing(enum fsprop_self_healing x);
+enum fsprop_self_healing fsprop_read_self_healing(const char *value);
+
 #endif /* __LIBFROG_FSPROPERTIES_H__ */

