Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB4A3AFB14
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590088; cv=none; b=uGPA/MCo4erDw7KdJltuiS4zOD0ra+bf7gdQKH1N8A8wKniWrdE3a20dHNC9t5Z/UG4vu1gW8VnBAnkdfhknBDs4pJx1GSqjCmnAgVuHD5pJqj+6UQ3mdjQ1awdozesVbtnGjY6A+/2p0hV7MvDZCyeGhmsHthwPjj9CklWWd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590088; c=relaxed/simple;
	bh=P2kqdtN0fUsRTGkC2H1tTCuY5iQqvFAjkWm0/iK49oA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tX2VHD28J7VFL/tQJCGlo820EzMeI1RqLZjS+FbR70FoN82a3fpsZeCGjTCUDxvpQ5V4HRJ2Yhw06tB/FpSMuUKZSASYjy8D0Pc2+fYR5vbIo51/UGCa9BPzdIVZuUnzJCjm64W3WA7bG7SqllnEPLmMOJvfIzKVCWNMoUXNwgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2khn8Fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2khn8Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF53B1F000E9;
	Thu,  9 Jul 2026 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783590087;
	bh=SwpU6ftr9KJQYVIo+T0w5AUtcVmNhaB5Ur+es0c264I=;
	h=From:To:Cc:Subject:Date;
	b=T2khn8Fe8prpM+EB4UZOO14dv1dNTP1z228rSfSemBnC67qagkjRREbdIC1kd+wg4
	 qKfMtt4OSCrbm3S0RA/apAQQ1+ySx6hCyryU2pQbwMqDUjARSX3pLKdPa4vllRkGEH
	 i2diq808hacjPgwumBphvKU9Vot1JKqKvZ7FULldrKs1GmRSiJRt0SYPRFJNgJp9K7
	 Ns/wjpeRxdm0o1C5wnXGfYHSfeSSYpNbjuQaZSGuKuikvhAS/fnMbk8fm4HvHLl7dw
	 ouB3K0O78e6e+32Qv2F9xNYTPPA+uFa8mxvpF/3hH7CDUZwgKwepzoy6egT4n11Ojg
	 hmCK4p2Q/t1Cw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] xfs: fix null pointer dereference in tracepoint
Date: Thu,  9 Jul 2026 11:41:16 +0200
Message-ID: <20260709094116.2025306-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If dfp is not NULL we exit early here, when dfp is NULL it's allocated
in xfs_defer_alloc() but not assigned. The tracepoint tries to
dereference members of dfp struct.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index c6909716b041..89501e8bd2f8 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -878,7 +878,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
+	dfp = xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
-- 
2.54.0

