Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CEE443C29
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871345; cv=none; b=RzAU/25m7K5sBAcm6+AscOKyaDXtJSM+JbMmQ1WGqgbiKJYmNE2f+M2JRo7KTjLA9N3k/g3t37cHgQqoclvAInnE7Mi5uPWBx1ML3ZoBQNqgNsM1ww2P1c6MYvTIfDvJWNARNwkAo5rt0MAy1AYcT3p6RMTRLhjE6VZgWJE3t3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871345; c=relaxed/simple;
	bh=+IZR9rOu2K0IE4gqk4CdWyvJsOV8MlPchQAOt6T12Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blinOpYG3bX0/T8nZYPvhm7T+27q4jOqPqMeWLKzy4VXnpCpbuaU3cnQLyJcVvKArNeFkVn5Dk91324+AdRRjYXfD/jCmoF6c9VZ3lJMsPmHfIFot8eLGV0M8mWSiU+fX3tGEdSGPHqpYnYbIHSJjHVVtsl0+C4fgPBQgeKup/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUcqqy1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUcqqy1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCD91F00898;
	Tue, 13 Oct 2026 06:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871344;
	bh=Ls9qrLi0MIvR3KOBXJ3+UTO00hUqVWO4Hm4ZJQbIm5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUcqqy1LBitjEcf3Pphzj5isxGHohYi7Qr3FEKV0Dth/Mzo/fj6NpJ4AygjlHvqDE
	 FpxZ1QtrlE57ccBOdvJJampbEKA3bIHDVrRhYOS2jH7ZBo6GQhFZaKM7QTIVKMrZPS
	 R76mN8HkNeugaHM1mLvspm4DemusKMWcwqDXizKu8ttIKwNhLvwyXYTMGj5XDjLmJT
	 WdDQ06zYq0hPExmq6OeMZHBeamUqKuXAtqPt/wMpIdypxB0uMEUYY52Xq/FIpgUr5J
	 K80cdvnPZSbrdTfWUipMJ+2QBDIWAx45AaWf2oAd1/WQpHFm1i1eaFbuR/suBBY6WW
	 21vDYjw0/k8BA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 12/48] xfs: validate the operation header flags during recovery
Date: Tue, 13 Oct 2026 17:01:02 +1100
Message-ID: <20261013060204.3138690-13-dgc@kernel.org>
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

Recovery acted on the operation header flags without checking them for unknown
bits or impossible combinations, so corruption in the flags could misdirect
transaction assembly rather than being detected.

Reject any oh_flags value the log writer does not produce, accepting only the
known individual flags and the valid continuation combinations.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b7719041085c..fd53b365a8a0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2719,6 +2719,27 @@ xlog_recover_validate_ophdr(
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
+	/*
+	 * Only the flag combinations the log writer actually produces are
+	 * valid. Reject unknown flags and impossible combinations. END is only
+	 * ever set together with WAS_CONT, and START, COMMIT and UNMOUNT each
+	 * stand alone.
+	 */
+	switch (ohead->oh_flags) {
+	case 0:
+	case XLOG_START_TRANS:
+	case XLOG_COMMIT_TRANS:
+	case XLOG_CONTINUE_TRANS:
+	case XLOG_WAS_CONT_TRANS | XLOG_CONTINUE_TRANS:
+	case XLOG_WAS_CONT_TRANS | XLOG_END_TRANS:
+	case XLOG_UNMOUNT_TRANS:
+		break;
+	default:
+		xfs_warn(log->l_mp, "%s: bad flags 0x%x",
+			__func__, ohead->oh_flags);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	return ohead;
 }
 
-- 
2.55.0

