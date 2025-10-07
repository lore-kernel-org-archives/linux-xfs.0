Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0784FF9D6
	for <linux-xfs@vger.kernel.org>; Tue,  7 Oct 2025 07:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759821394; cv=none; b=an8lAVfbq3efpslF5u0QvZM4Qrdx9uQVkRCri86qVVYaj6VT1aqsyj9xNrOzSmdg4LAxCi+JBYS5V/PrqgMuWFs9C+xbcUcFDuX7AAqJLYzY1CmN22ZVB07siL4FQ2UIS/eRv3qyqg+FNtwKgXOolhppR+PjHcuiJVJtGngSWaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759821394; c=relaxed/simple;
	bh=5/G0OaLijYnRg4rK4mEwmV0MNHghme9dGJZQGO2+4eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM/jpmr5AtxoDour0yNg9YjbwRwglsMHlNygXCU4rDyWTv2sBCGx3C9B4W5GI7+pO0J+ZeR+llqjRHlwmePFrMuPAuGr89gLmejDjMtU5CoEfNpZuSxwvnlvFqGZYtbDziADrUZjIH/QmFDTVV9LkYSCygW5orrHY06zTWo0Bi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id C79E3180F2C9;
	Tue, 07 Oct 2025 09:16:19 +0200 (CEST)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id FLEsKkO+5GgkeAoAKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 07 Oct 2025 09:16:19 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH v2] mkfs.xfs fix sunit size on 512e and 4kN disks.
Date: Tue,  7 Oct 2025 09:13:00 +0200
Message-ID: <20251007071259.51015-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aN9_ZfFEdDCuSTJW@infradead.org>
References: <aN9_ZfFEdDCuSTJW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> and should be done in a prep patch
Not sure if I got it right, but sending v2

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
v2: rework check lsu only if LSU comes from CLI

---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8cd4ccd7..3aecacd3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3644,7 +3644,7 @@ check_lsunit:
 	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
 		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
 
-	if (lsu) {
+	if (cli->lsu) {
 		/* verify if lsu is a multiple block size */
 		if (lsu % cfg->blocksize != 0) {
 			fprintf(stderr,
-- 
2.51.0

