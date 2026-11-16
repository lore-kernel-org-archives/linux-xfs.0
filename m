Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871063;
	b=rRad7rrhhjrABtJtcGEz8QFKS/OzzZsGIXnRkxrCgq7DRI8cq8qC7epa61xKTBYNiZGt
	 VpScWgfJPG2XOz4x6HSd2HPtwoSKJ6QRWFFj6l4ZWREh4kYu3H8+9A4yv8r29jWEUurKq
	 niaRSLOhh6HdeDSPq+58PbNNVNn1m1N2jWwKlRHl6yA9e/ROCin6n43vIcmJVjUCddKSh
	 m9ZOPeoDGLU5ksa7esAYsZvZHStr+vxKSOyB1PX2DGeduWsapApRh7Qin8ZJFZcw5Tjel
	 s6A8ct8lQDEsoq5Fv0TeKd7GPl/bU2nsubs+N/xVM4L7mmfqCzQRToeGvJSKbNC7RkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WRX9U5r/jMhQQ0ltGsSj1n61T9UmhCgA66kF5TfyBaQ=;
	b=KtnuB/JRZQL0rkwIwm3o1iKfw3l6q3qs+vuBr8zUaxqErmbUgWQtiWD7OXGGXhrvQY61
	 buOPWtf3Es3RGORflzj4FUNwDNBHHYD8t8bQFT69DRlZW3ONR+kI75FBFuEWODOc1CgT2
	 X4xxgq5UeMubHJtPt8ffPouGSSrxU4rgZgvO2Ur+MalpOdECJBC4OGLrsW/aY4XC75B3v
	 nP83uOjevBkU2RftLx3Cwi7UiP8m/r3wjmgrX+nhjBghlfmuabp2AYzqXrjrsW8jfem7y
	 MdVa9qC9nbuhdb6UntT7LdtuRg2niDg6vDtHD4E2XAnilMFwZ3v50SHUVuBK6/JTJVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSd6mzWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84FF606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSd6mzWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB48B1F000C4;
	Mon, 16 Nov 2026 23:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871063;
	bh=WRX9U5r/jMhQQ0ltGsSj1n61T9UmhCgA66kF5TfyBaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSd6mzWUlsl8e64SVM8FcbN3i9bwj9nTcWOoTZ52U8O8WwDaNMBv2KjQ5NP+N6o7Y
	 16b7cYrO05jQ5Ohr0aXNHtOuVP7jaKeTksAZxPrZsUka2UKHohMA4vJAsPkjYFX3sv
	 YdV0rySZRSuY10LQtcPmnmslWGF6H0uRC4G4GdScyx/Cx+NT+guMyRR3EKnZRN7NOW
	 Zc2npM0AXmZFNHUeX/+xfQGGL1Y8fYkXA8BDUSnxfJpSwyatEZGV1pGVlekwM9j4PP
	 VW4gt9acMmpNxN22yOBB1m3rc1y587WSBUsjHpila2r+/VPjAS/eab5o41+N01k9o+
	 ZPMS4XBR3w9pw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 23/59] xfs: enforce zero length control records during recovery
Date: Tue, 17 Nov 2026 10:14:40 +1100
Message-ID: <20261116231707.3625263-24-dgc@kernel.org>
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

Start and commit records only bracket a transaction and carry no data of
their own, but recovery only asserted this for start records and did not check
it for commit records, so a corrupt non-zero length on either was accepted on
production builds.

Enforce the zero length for both in the operation header flag validation and
drop the now redundant assert.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3a052a0337c1..bb3e23c20069 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2631,8 +2631,6 @@ xlog_recover_ophdr_to_trans(
 	if (!(ohead->oh_flags & XLOG_START_TRANS))
 		return NULL;
 
-	ASSERT(be32_to_cpu(ohead->oh_len) == 0);
-
 	/*
 	 * This is a new transaction so allocate a new recovery container to
 	 * hold the recovery ops that will follow.
@@ -2739,9 +2737,19 @@ xlog_recover_validate_ophdr(
 	 * stand alone.
 	 */
 	switch (ohead->oh_flags) {
-	case 0:
 	case XLOG_START_TRANS:
 	case XLOG_COMMIT_TRANS:
+		/*
+		 * Start and commit records only bracket a transaction and carry
+		 * no data of their own.
+		 */
+		if (len != 0) {
+			xfs_warn(log->l_mp, "%s: bad control record length 0x%x",
+				__func__, len);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+		break;
+	case 0:
 	case XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_END_TRANS:
-- 
2.55.0

