Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E92BE02B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501538; cv=none; b=ZPkJ4Efg5yjLyjKL/6N19xxL/sBVGa99AQ4QGsDlKd8gRkxqoXb/wS3KT+uJpwiWfPVDzFbueqd9ARmEjFQZqDOX4BdGKtBECfcnNZyPVmNM+Utz5bBItW+x7iVOZ6UKwEk1ZRJ1GMNLIiqdyT6RIIA3ShWR3iF72bZXtHDTKcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501538; c=relaxed/simple;
	bh=bCyMfaQdh5WV+6bfR8BdOwyKwlANm8s1kNdM7ABS0YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTMKFmwaSgb2dHeW8JK7EFrYxIHmRZmMaIIq5qTqTKyD83C59LTTHOISp5IuOFU9kxzJ9bhcD0fKujOhsedLIqhigTWkbqHSNANQNYsUBTbJQuSnNqARXNr8LhmIidXGOSUs3h/QT4OaIDsh5s6LI4SQdAwfFylgLOUSecMIif4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 18F85180F2E9;
	Thu, 19 Feb 2026 12:45:32 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 2/CrGrj3lmlSEAkAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Thu, 19 Feb 2026 12:45:32 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: hch@infradead.org,
	aalbersh@redhat.com,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Date: Thu, 19 Feb 2026 12:44:09 +0100
Message-ID: <20260219114405.31521-6-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219114405.31521-3-lukas@herbolt.com>
References: <20260219114405.31521-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
and so we set lsu to blocksize. But we do not check the the size if
lsunit can be bigger to fit the disk geometry.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76..1b6334e9adce 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3647,7 +3647,7 @@ check_lsunit:
 	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
 		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
 
-	if (lsu) {
+	if (cli->lsu) {
 		/* verify if lsu is a multiple block size */
 		if (lsu % cfg->blocksize != 0) {
 			fprintf(stderr,
-- 
2.53.0

From 2771375662c9edce25d7268bc71cc6db35a0d5c7 Mon Sep 17 00:00:00 2001
From: Lukas Herbolt <lukas@herbolt.com>
Date: Fri, 26 Sep 2025 12:48:39 +0200
Subject: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.

Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
and so we set lsu to blocksize. But we do not check the the size if
lsunit can be bigger to fit the disk geometry.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76..1b6334e9adce 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3647,7 +3647,7 @@ check_lsunit:
 	else if (cfg->lsectorsize > XLOG_HEADER_SIZE)
 		lsu = cfg->blocksize; /* lsunit matches filesystem block size */
 
-	if (lsu) {
+	if (cli->lsu) {
 		/* verify if lsu is a multiple block size */
 		if (lsu % cfg->blocksize != 0) {
 			fprintf(stderr,
-- 
2.53.0

