Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871104;
	b=P3N2AKpR8dqK7AjndhdZhVy2dMLURAH0BXYhC2D9QJDvLaR5jQrG4phy2kUxRCkfCZmH
	 0tkXLclZWL92PoAX5kx0Kc2RodUc+gjK8JoM6aV0SBYFG92Y7v+0gkDXYIl6wfNHPr02z
	 cDr6H4lZYIw6lO913Zzaqpu5ulwuNKBmlGqwtnWjFo9SIxMt/Mx5xBjkQDRtPJ1k8uy9M
	 AhRFCoJu+RUZTKOiEPEPTuEungurxm8FiqBioZdCbbgNrM3vv9IXXOqmf82b45G3R4sg+
	 ogRbPT7ULsCoW14xcOkRY6liXdxaiHc3a/ny+UvxedNqQJf2UYk3/UDg+mkZCzZ7FaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1SDYqian/FW93+AnoAO856xTAyiPK590M6Mlw6hu+m4=;
	b=kLFPerygkHNzSeMh8ZthMu9ySAy4HrTShhD6zNr+h7gOjrS1cAwFYPvJ7ABvR6dUc+9r
	 wgTQaHXyGSpIpNg2XobFb+gmW8A1cu3Zq1iJrOK7USqtr+5qTPN03j9WCHzepPtJ17d23
	 WN23f+OBPVgkCUSCSC0KbRoVAx7n7B6MXObv7TQti6Um1HkKsglU2QgBRml/8rQFJkguX
	 k/1eEFTYhfu+0+Fgoij0EJgwARPyaLtgqADWnTiR7h3vBFH+Hj7GqJuwk0UI06d5Jio64
	 9AcDQisu7ms/JBpYixt8L7FM57r5DsakS564v3AMGzhoAtilKNwlZTrnnR6xIM72Ylg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjmjFJVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83807606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjmjFJVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C30F1F000CD;
	Mon, 16 Nov 2026 23:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871104;
	bh=1SDYqian/FW93+AnoAO856xTAyiPK590M6Mlw6hu+m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjmjFJVNqUOjV0bYVFr+SrduGOgnqKR+KQV7ByGARAmig8pW5UUXiQtqXvods5VwE
	 1AykLGFJIyGgenVzD9x88jwVqQ9LtBoKKPdc714XO4sH1F58h1a5HX5Xl0qh5YkOYe
	 nltQJUclVmsdh+mK9JpFsPgQLRI7g17wXgW0LmDOFy93O4sirRy/nb8+LZXLV9YNUc
	 5Yc6vS9SNa/v00EqzlUth+ivdyWyW1+jHO1wsoUleNt6FA6pAf3SNGrZ6KwO6AovH5
	 J/ia7EkSCg5mXk2EF2rIm2DWvTH+E0WfDHmJuk1isXZenqoCApX8MaoPl+KhvHn+NP
	 yLLfF5svSaCGQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 54/59] xfs: validate buffer item region count during recovery
Date: Tue, 17 Nov 2026 10:15:11 +1100
Message-ID: <20261116231707.3625263-55-dgc@kernel.org>
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

Validate the number of regions in a buffer log item as it is decoded from the
journal. A cancelled buffer logs only its format header, so the valid range
spans the whole range a log item can hold.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 383d0e87ef6a..3742099de2eb 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1211,8 +1211,25 @@ xlog_recover_buf_commit_pass2(
 	return 0;
 }
 
+/*
+ * A buffer item is a format header region followed by a region for each dirty
+ * range of the buffer. However, a cancelled buffer only logs a format header,
+ * hence the valid region count range spans the entire range a log item can
+ * legally have.
+ */
+static int
+xlog_recover_buf_nregions(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	if (nregions < 1 || nregions > XLOG_MAX_REGIONS_IN_ITEM)
+		return -EFSCORRUPTED;
+	return nregions;
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
+	.validate_nregions	= xlog_recover_buf_nregions,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
-- 
2.55.0

