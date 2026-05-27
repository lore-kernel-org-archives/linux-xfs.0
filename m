Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFF8171CD;
	Wed, 27 May 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779856323; cv=none; b=c5vRuQdZovGCCwsmYoRZdv+fZUWyV0tQU2tzlyG3yxjt+bZB+k3fxB6Bdtd2yQha3xwFjUgXucffDbESL5fZrpt0gCg36ApEpVj6Z9zTc5xFwoGK2YTtxbLM8oCODTvQYRnK9hCcMt1xEAuYanfrw0o85armcuJwCZO6mamD5tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779856323; c=relaxed/simple;
	bh=EocBaTWqXBohSE+y9DwN/ROZfEnKngy9IorQ5LoPwd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LjpjiVFiLAq/5OuxwSCNmW2xq9rWmEal4l7ph9CMyXOSxISXhU37b+EwrzacdLZgz4LvplEICp+igbKTImYskId83YXjVnRv1VFGdbHeLqCH/YLvepFr/9w3ao3k/xtiiIpbGb0zqPFenWcT2wVZvoFuOR4xq3YQ4LeOb+w1mw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kZoqGWLq; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kZoqGWLq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779856306;
	bh=92Sch1yjFkLvY6+W7n39d6u7r5eDGJGs1gjZiTZ7+/E=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=kZoqGWLqVlruVczFNCiTrk7omMpznYUt1lDixw0/VXI7IYOx5KzA8AlqOx+dFINcS
	 pzH4DCH6WquXmJkHmTognu8F+7GTeZZgsO8//ptjnj46Ufhg99CasYQ3E6NDaAX6za
	 MQJVIiXkLbLI1RY9Qz9jWf5Qub+izJ5zH+Q7oxCk=
X-QQ-mid: zesmtpgz6t1779856301t8458dc35
X-QQ-Originating-IP: 4Lsd2+N8zQl0XeOxMcuLKSkVsFHJtsX2ibKOMJN8cIw=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 12:31:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14917825408524474035
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v3 1/2] xfs: fix error returns in CoW fork repair
Date: Wed, 27 May 2026 12:31:33 +0800
Message-Id: <20260527043134.1550710-2-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260527043134.1550710-1-gaoyingjie@uniontech.com>
References: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: M0wYV6TTeeWi/GF4l+szP9tzPVEiiq7mVTZs79VUVvC92HxcbAhNPzJF
	NYTj20Ny1jaVpkdOxjO0cTduqMRq/egvowUiJG3WydwEMx8O0pM4rTxCwIMnp51hl7b0X//
	RZn6MrY42+H87oretxafbotUk4LAfVkInSJDGVXeLE5EOX2EsDgLk9FDwmjapQsgDLNJ7E+
	PqouQJlAgoBQljhRx/r31HN8aLvSur3s+5eZHL0uN5JLS3yrNBY29NSAoiNy3ltNo6/kOY/
	2NLb4EhpBlxWu3hJcPYXEaDgsIzCT37Ak1jSVmLUmKnu4LgNUnaxVjag2ywWwAjLG4fPHjS
	etCDqM6vMSOLEQ2IpJtXJC2gKRXdtnfFY6g3UJh+kUd6n3P0gE0bWz7iX9PH2C0Q1ZCb+Q2
	IQQVb+MbQBaTEiOTkFW/gDFu2WjXI5q3hDbgjqnsOeR/D6UVebxxc/W6ETomSNCKM1MG51j
	CdQcsbCnhywv3Z+ftNt4Qa3Df3gNVLKy5V4LMBAFdYOipnwxhqs+lPyRwLieBVi8YyyUCUu
	ixpq/Mm72AyOIPYZ62JQrByG1Mv5WZTqiQclSDgpLYuOawGorJfAdWN/pUv1DajZpSt3sqc
	AN8Gxt1xywBtNuYDDI1RULG3c327OMDJRly5MpI0JmBLV/Y5cbYkIxChGHJjuDGdMhw9klP
	HOO8nPaBY+YQGuXC/nvSvmgr05YbfNpBGDmHE1cmhEk4W3r7GE4ZxA/zvxuA2MS2NxJ17T8
	3NYrWj6W1eDP4T4bFPn0JhgQ0tJ0A2eW2pphCQBotGLIajPuZt7u57RkyGE0lJNJkhT94h6
	mED/n8eAPL/jDyhDhch6atnYNjEJvoMVH9lRPip34b2YrtvnfDtvLdonDSRg7SLiyZ7GvQg
	0j1IGM3XgyI0xnEU33E37hENxfhAd5gNhO2J0a6d+9wOiJ1Af8+gFpzd4upJdBgEp5JvoNC
	CJ5cSB5BuoKxJMXlBOCQOJo8W8UqAU3otqr5sp2v7+M4ZeQR6He0UnH8bVaEB7ZtdIaFRRD
	6s0rm226jKUbnhh53PAepHtbwDlqTSFzs0XTCz7XWpLFgQqCJF
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

xrep_cow_find_bad() returns success after the cleanup labels even if
AG setup, btree queries, or bitmap updates failed. This can make
repair continue with an incomplete bad-file-offset bitmap instead of
stopping at the original error.

The force-rebuild path has a related cleanup problem. If
xrep_cow_mark_file_range() fails, the function returns directly and
skips the scrub AG context and perag cleanup.

Let the force-rebuild path fall through to the existing cleanup code
and return the saved error after cleanup.

Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/scrub/cow_repair.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index bffc4666ce60..a6ff09ace43d 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -300,18 +300,15 @@ xrep_cow_find_bad(
 	 * on the debugging knob, replace everything in the CoW fork.
 	 */
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			return error;
-	}
 
 out_sa:
 	xchk_ag_free(sc, &sc->sa);
 out_pag:
 	xfs_perag_put(pag);
-	return 0;
+	return error;
 }
 
 /*
-- 
2.20.1

