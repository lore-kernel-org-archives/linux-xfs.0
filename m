Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9B233939
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695910; cv=none; b=l1mEImYg7elpCdNx7uI478BiUw87tLxHgN5zVHFLYvtLRfM4TNu2e7rQCrvzjxFsTeO+XyT9XMgbTdkatEvSqnjPD6//VWIGhnpAwWXCtXNk6sU8yIJu2WaFYSVzWDYJ4kqvTe11Noe1fjxKPllIybC/MbT+3HG2GbRYLDAh4uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695910; c=relaxed/simple;
	bh=7reF2eDOfCAkH3eOPp6UqVU8r8Vxr717Crvt3VkK7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzH6YOqXa611akntBaT/yMJMwxkeJOF7rT7+IPFw4WeOiZ8YSxDyicr94j8looNYUu46B0B7fuYlGYxoC/HF8ZFh95Yse9X99vqjxVp7CM8W+4DRSibqswabROqvQj/Vm2lu3kk4PTzXhvfGfGGLT+hxCGayncptXdwgKoS2U5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 8F43B180F2FB;
	Mon, 25 May 2026 09:58:24 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA:T4
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:24 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 3/5] xfsprogs: mkfs.xfs add auto|autodetect value for -d/l/r concurrency
Date: Mon, 25 May 2026 09:57:50 +0200
Message-ID: <20260525075752.4159504-4-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525075752.4159504-1-lukas@herbolt.com>
References: <20260525075752.4159504-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add autodetect|auto value for concurrency option to restore the current
default behavior concurrency detection on SSDs.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bff7d078901c..cb9c528021d6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1838,9 +1838,12 @@ set_data_concurrency(
 	/*
 	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
 	 * If this cannot be determined, fall back to the default AG geometry.
+	 * "auto" or "autodetect" means auto-detect based on storage type.
 	 */
 	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
+	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
+		optnum = -1;
 	else
 		optnum = getnum(value, opts, subopt);
 
@@ -1986,9 +1989,12 @@ set_log_concurrency(
 	/*
 	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
 	 * this cannot be determined, fall back to the default computation.
+	 * "auto" or "autodetect" means auto-detect based on storage type.
 	 */
 	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
+	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
+		optnum = -1;
 	else
 		optnum = getnum(value, opts, subopt);
 
@@ -2206,10 +2212,13 @@ set_rtvol_concurrency(
 	/*
 	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
 	 * If this cannot be determined, fall back to the default rtgroup
-	 * geometry.
+	 * geometry. * "auto" or "autodetect" means auto-detect based on
+	 * storage type.
 	 */
 	if (!value || !strcmp(value, "nr_cpus"))
 		optnum = 1;
+	else if (!strcmp(value, "auto") || !strcmp(value, "autodetect"))
+		optnum = -1;
 	else
 		optnum = getnum(value, opts, subopt);
 
-- 
2.54.0

