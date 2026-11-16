Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871059;
	b=qz+tCkxyHetDEb2BiY3RknOkw3HMu08EtPHW1is6OqPwEmPKRrTDmNHpGb6t87nbSV/N
	 44NerP0Uy04jzBTMa59ksmRdvlW4zGHCq3+NFNopl1ahEaRojrQeuxGGyNCHzkdM8iCHm
	 vO4b3UmkVHDEF/os2meYJHPYFeDl0Rni6r6Jro9lKEVOAZ3r3aVCr7gbvPvjxCJOtpItp
	 1phrxSqEgHnewctkvrOgxRxzAm3udkCFZXKaT7TyVGd4qcBZe+S3YORnyoNYw/cjIyyxY
	 yalXsVdw4LOBHuF5oGdvyj3OScNbCPsWdCIb4geV1VUik/AlG7Lgxd7yJBFnn1KqelA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mazSNjCfw686tXqvfx26YdyuCNKRBb6uibxL52nKbQg=;
	b=fVz/pT2aLvT3Q6RfCXV5tXjqV/5nDncdzmvcK7WIU3neCQXqBltytkNFtA/3B4+yxPSP
	 jAptj7tEpPAeCdg2OW1bHDeLW8tYEhVj0iMOGRwW2OkRAdy/MddjYEM7EB7dyydOwH86y
	 wentwKmdgFCKzRhw7WEvBAIZLWK0noK5rDpGYnIOYd7v5671OavW+4cOK2lWKp+belTqV
	 0EQBMnwmOR0oD9swiQwiLTOxJkyEtsdr6YQaGaDZGrD93jtZAMY5o+qJK3DJXHXFujAGP
	 xBCBLrf3wtn6e57eCctDKeltQ1MBHwW1siBH2ZZ96M8VRpBWAmzEX+np9GnZWvXRajw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kc1VgjQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC57E606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kc1VgjQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B191F000C5;
	Mon, 16 Nov 2026 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871058;
	bh=mazSNjCfw686tXqvfx26YdyuCNKRBb6uibxL52nKbQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kc1VgjQ/HY1JvW7zh8Ms5HUyx/ObWPUwiAdfwVHy25PPhf9z3SiK+r4LVeUdFHZaj
	 wWXf680HbTgWzMy21UMLxd6dsg8YLlHskb/nAhXPiHdHH7/H1xY09ctSlPcXHba4RV
	 8O2S2Jm/WwEh1sb7ocZ8DkbTAPZkvvq9gbySjqy4QdjDigdtzMstCj72HKFpBOZYPN
	 KE6DXZN8FZLn2yfoatyJK91yQPM9/awfE0fh+1WRdnJ3HSaR4hb625vFsaG9o4yYqY
	 MN2VNWED91lgkW1vIP0STfEjmYOGcu5RCCUCUp/RSxlflXYGr1R947FUbhUPhowXAp
	 hks+iKBpwwd0Q==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 19/59] xfs: factor out xlog_recover_validate_ophdr()
Date: Tue, 17 Nov 2026 10:14:36 +1100
Message-ID: <20261116231707.3625263-20-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor the existing operation header checks out of
xlog_recover_process_ophdr() into a dedicated helper to centralise ophdr
validation. Later patches add validation of the remaining ophdr fields here.
The ASSERT(0) and WARN_ON(1) are dropped as they add nothing over the logged
message and returned error, and they fire on expected corrupt input.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 55 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4f05b5130bdd..a5fa7d2676cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2651,39 +2651,56 @@ xlog_recover_ophdr_to_trans(
 	return NULL;
 }
 
+/*
+ * Validate an operation header decoded from the journal before it is used to
+ * drive transaction recovery. The ophdr and its data region come straight from
+ * the on-disk log and cannot be trusted, so check the fields for known values
+ * and obvious corruption here, in one place, before anything acts on them.
+ */
 STATIC int
-xlog_recover_process_ophdr(
+xlog_recover_validate_ophdr(
 	struct xlog		*log,
-	struct hlist_head	rhash[],
-	struct xlog_rec_header	*rhead,
 	struct xlog_op_header	*ohead,
 	char			*dp,
-	char			*end,
-	int			pass,
-	struct list_head	*buffer_list)
+	char			*end)
 {
-	struct xlog_recover	*trans;
-	unsigned int		len;
-	int			error;
+	unsigned int		len = be32_to_cpu(ohead->oh_len);
+
+	/* Check the ophdr contains all the data it is supposed to contain. */
+	if (dp + len > end) {
+		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
+		return -EFSCORRUPTED;
+	}
 
 	/* Do we understand who wrote this op? */
 	if (ohead->oh_clientid != XFS_TRANSACTION &&
 	    ohead->oh_clientid != XFS_LOG) {
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
-		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 
-	/*
-	 * Check the ophdr contains all the data it is supposed to contain.
-	 */
-	len = be32_to_cpu(ohead->oh_len);
-	if (dp + len > end) {
-		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
-		WARN_ON(1);
-		return -EFSCORRUPTED;
-	}
+	return 0;
+}
+
+STATIC int
+xlog_recover_process_ophdr(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead,
+	char			*dp,
+	char			*end,
+	int			pass,
+	struct list_head	*buffer_list)
+{
+	struct xlog_recover	*trans;
+	unsigned int		len = be32_to_cpu(ohead->oh_len);
+	int			error;
+
+	error = xlog_recover_validate_ophdr(log, ohead, dp, end);
+	if (error)
+		return error;
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
 	if (!trans) {
-- 
2.55.0

