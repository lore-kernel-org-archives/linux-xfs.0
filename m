Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6441B95B
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751393186; cv=none; b=dc6sAa4ZN+bCGOujp5Qd+MK7P65jT1wdtQ/3pqoFj7S/JjnMyHjkAfRmI1NXHhxW1k8f9d9ZGI2oIaAJs1sf663zi9UuCsNDuAIvtRUdkW/LlIeHr06yYkO2h2yf1VIKbrqpyAQyQ/YcXpsgzVERrcMOh+JiMrVUwArWrhvp/qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751393186; c=relaxed/simple;
	bh=jWweVFSjxrwI/CSpbF0s7VEL2eY9QSZR+hb0/lxkKxg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSriW5jPXkZgSf2Kz+iRXuCF1KKPUGFai8Nj0q7HbGUDOZKqcQrXcKvMrlTkqVqnrRom2pWqbU1XH0zaE1UyuqnQFK4ZXtBqJ9WUZ6c2O+YeKRj0TUuwZZ2ZCowegmAAlaNbYcPSAIqvR67xLG/C8ImGOB0qbonI+dDMLMy55JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgSQ/IBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgSQ/IBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5931C4CEEB;
	Tue,  1 Jul 2025 18:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751393186;
	bh=jWweVFSjxrwI/CSpbF0s7VEL2eY9QSZR+hb0/lxkKxg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OgSQ/IBcamsqKdjcnTx01mxkqzStQlI6T1ouGA3uh9XZWipMfUUga/Z6Mk/Qfqr4y
	 Q+Z+zBD1bAAUzK0ms54bZ5ILFghewcIEX11StvMdkgopKVQg1bsGEayssP6S3bA8qF
	 qi436dm/7P4bCwPvjgBa1QxD1B17CP0sjjJ2S4QZ8lNHFVjtRTsn6B7Fdd8ZwNclYO
	 4Kg8ueAkVswov4ob/qqBGvkIca/Dp6mYgZWC4XrQ+N2UP0mCpDhfdCX3dzw8v1SbFD
	 6HV/+Z/DRyt+EndhQfFt8bOtXc54oE7/tFdjhDY46OB0iq09Zy1JBjphl31qYj7KS1
	 U/Xr58JaEvHKg==
Date: Tue, 01 Jul 2025 11:06:25 -0700
Subject: [PATCH 4/6] libxfs: add helpers to compute log item overhead
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: catherine.hoang@oracle.com, john.g.garry@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <175139303567.915889.16179791054549427168.stgit@frogsfrogsfrogs>
In-Reply-To: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
References: <175139303469.915889.13789913656019867003.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add selected helpers to estimate the transaction reservation required to
write various log intent and buffer items to the log.  These helpers
will be used by the online repair code for more precise estimations of
how much work can be done in a single transaction.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/defer_item.h |   14 ++++++++++++++
 libxfs/defer_item.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)


diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 93cf1eed58a382..325a6f7b2dcbce 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -39,4 +39,18 @@ struct xfs_refcount_intent;
 void xfs_refcount_defer_add(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri);
 
+/* log intent size calculations */
+
+unsigned int xfs_efi_log_space(unsigned int nr);
+unsigned int xfs_efd_log_space(unsigned int nr);
+
+unsigned int xfs_rui_log_space(unsigned int nr);
+unsigned int xfs_rud_log_space(void);
+
+unsigned int xfs_bui_log_space(unsigned int nr);
+unsigned int xfs_bud_log_space(void);
+
+unsigned int xfs_cui_log_space(unsigned int nr);
+unsigned int xfs_cud_log_space(void);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 6beefa6a439980..4530583ddabae1 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -942,3 +942,54 @@ const struct xfs_defer_op_type xfs_exchmaps_defer_type = {
 	.finish_item	= xfs_exchmaps_finish_item,
 	.cancel_item	= xfs_exchmaps_cancel_item,
 };
+
+/* log intent size calculations */
+
+static inline unsigned int
+xlog_item_space(
+	unsigned int	niovecs,
+	unsigned int	nbytes)
+{
+	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
+	return round_up(nbytes, sizeof(uint64_t));
+}
+
+unsigned int xfs_efi_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
+}
+
+unsigned int xfs_efd_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
+}
+
+unsigned int xfs_rui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
+}
+
+unsigned int xfs_rud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
+}
+
+unsigned int xfs_bui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
+}
+
+unsigned int xfs_bud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
+}
+
+unsigned int xfs_cui_log_space(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
+}
+
+unsigned int xfs_cud_log_space(void)
+{
+	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
+}

