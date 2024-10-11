Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA74A2D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609375; cv=none; b=UeQx0ahnlkm49GlNNIXuvMjr5L9tGTj+s32J8fzeZp9FvuNtEgD8OqkfRHaYysK1a516W5s5hC1xZ5kpZ5oXs+Dw+gf3Kh1CSOSjGc/DKHu1Ynpjt9OmregiGuiY3Nb2Iu4afzGingKxpH4RWRsssVtj8jkFrGcaXQzufLVGLfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609375; c=relaxed/simple;
	bh=a5Cgect2+Drs7mHck8UNEVV6z3l7vNCM2zY7oGGOTho=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRNab+2KBiPdTZm4kdAIUZce4hTcKOE7DD9LjAD7RqkeHbvKuA/bkwSDUP6DIKgdRtH66Vqmx5pD8QI+2Fs5yWNDol0qk7jXQlemISmxrDfUJk7HkcoY4+KpWSoSRFbQbxsiGzGLV237ty7Bj1RG6M33V1ODm+eghhYIwwJ65mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uwr8dbfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uwr8dbfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EC8C4CEC5;
	Fri, 11 Oct 2024 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609375;
	bh=a5Cgect2+Drs7mHck8UNEVV6z3l7vNCM2zY7oGGOTho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uwr8dbfptP6vZLpAIAzfB7NJgeXCd/m5BKNfUFCL8Epk2fX9UtYPnvKJaFZOAlLAe
	 MDe3pqCVsNhuKK0yDasXRqCey2qKcSPSSJ8NXGmsXeqWjaxkpBXgd4VXoQ9VoUe3r7
	 ZI6luF3T0rLfb1dHCeq2ZgdH2MkcOtbl/qhwqnouSn9e9Vf3dKfEhsEmQt7NQgUr5j
	 qeaLMHBk3O2tL4KF0fOyfu2fHOxWvDiL1fvR6cXmcB6fvZqI5pq86hh1tif2RfDKTA
	 WSC4wRVgbpAiZ60PoftzYJ2gT4YZA0WBKRKwyNdaUGkn9N//5BRuqpVhpmHUn6n71o
	 bkkLtuwD7msZA==
Date: Thu, 10 Oct 2024 18:16:15 -0700
Subject: [PATCH 08/38] xfs_db: show the metadata root directory when dumping
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654099.4183231.5070655775862456.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Show the metadirino field when appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)


diff --git a/db/sb.c b/db/sb.c
index b47477631af824..2c5f4882c894f5 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,6 +50,30 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
+/*
+ * Counts superblock fields that only exist when the metadata directory feature
+ * is enabled.
+ */
+static int
+metadirfld_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 1 : 0;
+}
+
+/*
+ * Counts superblock fields that do not exist when the metadata directory
+ * feature is enabled.
+ */
+static int
+premetadirfld_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 0 : 1;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -99,7 +123,9 @@ const field_t	sb_flds[] = {
 	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
 	{ "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)),
-		C1, 0, TYP_NONE },
+		premetadirfld_count, FLD_COUNT, TYP_NONE },
+	{ "metadirpad", FLDT_UINT32X, OI(OFF(metadirpad)), metadirfld_count,
+		FLD_COUNT, TYP_NONE },
 	{ "features_compat", FLDT_UINT32X, OI(OFF(features_compat)),
 		C1, 0, TYP_NONE },
 	{ "features_ro_compat", FLDT_UINT32X, OI(OFF(features_ro_compat)),
@@ -113,6 +139,8 @@ const field_t	sb_flds[] = {
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
+	{ "metadirino", FLDT_INO, OI(OFF(metadirino)), metadirfld_count,
+	  FLD_COUNT, TYP_INODE },
 	{ NULL }
 };
 

