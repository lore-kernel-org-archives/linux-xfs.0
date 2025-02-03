Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30B2AD27
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738573470; cv=none; b=cV77BfIvY3qKQSYtaDp4QTEWKJok9zobaHXBMwccrgJm9I9Y7UFJZ/lCnoSIEf8dwTF+DPj38HEyYnHGAHu8JOR+DRfn1JwJw9Ju/eyFEPlpXoOtFa4UI/Z6K6qBfcITH6kOtdMPHNhCxQrl00bpj4GRyBiNHnKHwxB63vYdHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738573470; c=relaxed/simple;
	bh=pAUPCbEs3cZzfEoN2JmK3Z5lmziiHE6LDI4qOfyUwZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOVbtYuUQRP0B7xgf7sQSxGhI9R+TT39Wf8w8EdygPKO06LybCbEPq0t0kr/AwkZG1XPl1Pkcs0ojiHOTtXhUKIgqC5fRUmb0c4JXd+3kWbyUd3Pc+aD1ZIJfj6wNwZFX1A/XqNzoKSp1Cbn5Fpdpw3v3YhnnVzfsKEtRlD3fJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 60528180F24D;
	Mon,  3 Feb 2025 09:56:55 +0100 (CET)
Received: from trufa.intra.herbolt.com.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id mEG9EdWEoGdxJQEAKEJqOA:T2
	(envelope-from <lukas@herbolt.com>); Mon, 03 Feb 2025 09:56:55 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
Date: Mon,  3 Feb 2025 09:55:13 +0100
Message-ID: <20250203085513.79335-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250203085513.79335-1-lukas@herbolt.com>
References: <20250203085513.79335-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If there is corrutpion on the filesystem andxfs_repair
fails to repair it. The last resort of getting the data
is to use norecovery,ro mount. But if the NEEDSREPAIR is
set the filesystem cannot be mounted. The flag must be
cleared out manually using xfs_db, to get access to what
left over of the corrupted fs.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 fs/xfs/xfs_super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 394fdf3bb535..c2566dcc4f88 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
 #endif
 	}
 
-	/* Filesystem claims it needs repair, so refuse the mount. */
-	if (xfs_has_needsrepair(mp)) {
+	/*
+	 * Filesystem claims it needs repair, so refuse the mount unless
+	 * norecovery is also specified, in which case the filesystem can
+	 * be mounted with no risk of further damage.
+	 */
+	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
 		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
 		error = -EFSCORRUPTED;
 		goto out_free_sb;
-- 
2.48.1

