Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871062;
	b=X48Wm+PHByoYsvSzabDOvjTTxQUiR/BrJfOR0uCgcCazPAF+D271q1sWYqdMbXiLNI1Z
	 KEjr81ok6ROSBfMaMAocrQYA0+LoTzuPQ+8pYvuN5eyb+/izLOdXkKUohZZvboenmPpJG
	 YJc7tyFkifqoLRUl6+XogUmWSM4S8qCJJMl/60lrWGnq69w1v7oG8wmBuL2tTPhGzmlm2
	 UoxDrPou2dPbdkxm1l9aJajKM+7za/TAwb7mNK6kNnVHFUEWxxRjFpWUpZLUG1rtGASQ6
	 WpGDN7o4m0tH3kLflab36jdn+Wep+I5Gz642gfRgiHi7u8KS+fhUFTE3LTGSCMUirIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xa8YXWSubao2SmyDNmszLJPRNT050h1USlWI7VSB7UA=;
	b=dJlB4QpeIplAnCQk6E7Y9OzQpS/QconckxiaJXaD1HbYjZu5Z2JCbVqPtNLTYRpr8Vmm
	 gGnVVEcYwKqtXTVzny8Yxh/JHx4kvu+QTd9P5XfNONBFIkYT2uHqA5+T9SBLPIK4tyCZm
	 hPy2v4QRbWPULohcM1UZZELDLBtAGXpdLuwChiDgyGARQqjxHQcgT/CT04IJSMHP9D3XT
	 6URQLhNkChBatT5QBP58+jXqsTIUesVhE21OgKrqNqWxliFolJlRotyG4QVoJuH8Q1Bku
	 ydjlququymN/rZxM/CN2cdIZdv9ivB75n6ONVqggP6DUKOoT9FHpr7dW79SABpd8CoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqolePN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDD8606A330
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mqolePN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C641F000C8;
	Mon, 16 Nov 2026 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871062;
	bh=xa8YXWSubao2SmyDNmszLJPRNT050h1USlWI7VSB7UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqolePN1Z0cgXkMa+y1sq75YCeTCufAxu9haqlIZStGWfAkY5hR7yeZEECnV6IJuS
	 pOvLkokTSXmB0KwgLIDKVRyJN0r6uiwoDSQsrZYupFHdkSpH/ptraNGq64mBS2kw0J
	 ezrXyPfQbiFefdiDxOYCF8q/zo0dDRwBF3qNXHGtSmhL8WSWAZlcb/GVcGoaPyFbfN
	 C61wX+41j3H49RqDwmhiaE4KOdQacO6GJ3g1rDNEQrw64tnVIcJNHvoZmm5bULmk9v
	 mjZEysoeLnq6iPvaEhmsJBRDlKK4dXUaFG7fdre9dXe4aO2g/KaHmZ8IdsBEiXiKSS
	 +CILO2bATkZdw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 22/59] xfs: validate the operation header flags during recovery
Date: Tue, 17 Nov 2026 10:14:39 +1100
Message-ID: <20261116231707.3625263-23-dgc@kernel.org>
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
index 2ff06d80a05b..3a052a0337c1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2732,6 +2732,27 @@ xlog_recover_validate_ophdr(
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

