Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9417417BD2
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871344; cv=none; b=nXR7Exmw6yktE+TWHFQON5jc1ymF46Poba67UHBUhcTA2tAvYCsIAbXMg5JnR4F+m4OjPOzy1A/VMGwYLDsNMHxlPzIMlC3kpw2qA3rVHciMlyOcMPeNKi9nv6HF+GIBaBsKCmICuhxhRS7w9EnNsvE91iatDgQQ2Vc8GcyzVpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871344; c=relaxed/simple;
	bh=l8bxO/pOP/zux/EhcxsKgYUbmR3NpKUcsCrB9t1IquM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4mFeHM7sVmb0jV8f5P84SGNnE/U1UCdsERDWFGdmo7WPGMb+8ZDtV00voIyzS7dCKICQgez0Qt4LkgUmA1peCE4hfD6rUp9tvA+9bQOeShtUc81ucbQmBb6RZKFvGWxczY9Sz6W2K4ejoYiyu8Hx3EV0hRTn5H/ngxTkN+ETA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSb59Rve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSb59Rve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B21F00893;
	Tue, 13 Oct 2026 06:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871343;
	bh=QpWKNSth4lSaFKRvsJf2+YCVsHFv3JekafjMpC/3yHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSb59Rve2LmQ3ky+kn3sxNzQ1+iBY/e48ncEP3linQsMg7Vks+9/iE2ZAPjIRhfMK
	 whd26zyMwvJqXaakOYJOE9p2aU/EdYQkzc3h3C3HQnA7lGbxcUNoTxFctkX/x8XD3x
	 wTx4TxzcNKZrT09rHlhPOeS3MGiJZf+INCIEJ8WGwxKo48ebFzmE/5t4op7n8ZNv0K
	 Y2M+oDHYanjLRySp/VvJZo+gLhdyoaKIluIF2QvSnZSboRa4Vt+57e5RAivX27zOYf
	 JWYGj0QXe/2fnC9ZtCoaaQgsW8Ja/55Cb9unLS2nWNS10GrXkj1EmcV0hmUS/f73PY
	 ieHfOwNX9SqIA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 11/48] xfs: validate the operation header padding during recovery
Date: Tue, 13 Oct 2026 17:01:01 +1100
Message-ID: <20261013060204.3138690-12-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The operation header padding field is always written as zero, so a non-zero
value in a recovered ophdr is a reliable indication of corruption that
recovery currently ignores.

Reject a non-zero padding field during ophdr validation.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4a5c8830b781..b7719041085c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2712,6 +2712,13 @@ xlog_recover_validate_ophdr(
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
+	/* The padding is always written as zero. */
+	if (ohead->oh_res2 != 0) {
+		xfs_warn(log->l_mp, "%s: bad padding 0x%x",
+			__func__, ohead->oh_res2);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	return ohead;
 }
 
-- 
2.55.0

