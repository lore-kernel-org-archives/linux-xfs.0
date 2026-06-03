Received: from mail.nppct.ru (mail.nppct.ru [195.133.245.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B30A3E16B9
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2026 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.133.245.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780519890; cv=none; b=TTZVqALWsisSvdp8gjhKrIkkAx3qmVLs4LByI6kH55cQxOB8cD058nq4T4Ol3jdnRaOtnd7uzzQ4tUsy0j6z6vW764Em/IXOe/ci1B8yApzkgePJl8K223ZFWvwfYVYxEPahIyPshTkVFghCIWsEbXaTDyRKz4lX/28SkzRPnkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780519890; c=relaxed/simple;
	bh=9khcxchl3IzPyyfhPI9Yt7yAq7wBv27v9pwnaEpqJLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gTU0AprTkmYVeFhHAoTh+kWtD4GLQ3nN/m4ipkm3bMvJHVL9UrX2EuMyRqQlnxAtzR3jqmI5IvyOezO1cO8UXJVLxEga4hKW/Yx3vocOAasGJcE5PZoekW9NVtTSV05vAwU+lN6gbB/HDFuw6Pb082yR0SXRnHL5wphhPR1Kdrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nppct.ru; spf=pass smtp.mailfrom=nppct.ru; dkim=pass (1024-bit key) header.d=nppct.ru header.i=@nppct.ru header.b=H8yf63+a; arc=none smtp.client-ip=195.133.245.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nppct.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nppct.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nppct.ru header.i=@nppct.ru header.b="H8yf63+a"
Received: from mail.nppct.ru (localhost [127.0.0.1])
	by mail.nppct.ru (Postfix) with ESMTP id 3D98C1C0F71
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jun 2026 23:42:11 +0300 (MSK)
Authentication-Results: mail.nppct.ru (amavisd-new); dkim=pass (1024-bit key)
	reason="pass (just generated, assumed good)" header.d=nppct.ru
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nppct.ru; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:to:from:from; s=dkim; t=1780519329; x=
	1781383330; bh=9khcxchl3IzPyyfhPI9Yt7yAq7wBv27v9pwnaEpqJLg=; b=H
	8yf63+aQnMcxqP7eJvLOCC/bZakO7Xw7DnLVS7c+QpHk/w6SEpLGf9K+GAHBiWtL
	azdHlk7o7aCpyW++yrs1PlctE55/iWDcCRMlAfDZYkT/2SSNP78HyGCFAyhNMV1A
	QaQadJ46M9vA5LZ/ijXqs2YAFUOoUVlXY8GJX/yfQw=
X-Virus-Scanned: Debian amavisd-new at mail.nppct.ru
Received: from mail.nppct.ru ([127.0.0.1])
	by mail.nppct.ru (mail.nppct.ru [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uDoAQQWAgd6I for <linux-xfs@vger.kernel.org>;
	Wed,  3 Jun 2026 23:42:09 +0300 (MSK)
Received: from localhost.localdomain (unknown [87.249.24.51])
	by mail.nppct.ru (Postfix) with ESMTPSA id 82C4B1C04B5;
	Wed,  3 Jun 2026 23:42:06 +0300 (MSK)
From: Alexey Nepomnyashih <sdl@nppct.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: Alexey Nepomnyashih <sdl@nppct.ru>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Allison Collins <allison.henderson@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix unreachable BIGTIME check in dquot flush validation
Date: Wed,  3 Jun 2026 20:41:47 +0000
Message-ID: <20260603204148.232530-1-sdl@nppct.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dqp->q_id == 0 check inside the XFS_DQTYPE_BIGTIME block is
unreachable because root dquots return successfully earlier. Reject root
dquots with XFS_DQTYPE_BIGTIME before that early return, preserving the
intended validation and removing the unreachable condition.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4ea1ff3b4968 ("xfs: widen ondisk quota expiration timestamps to handle y2038+")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
---
 fs/xfs/xfs_dquot.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 69e9bc588c8b..c311f61d9554 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1216,6 +1216,14 @@ xfs_qm_dqflush_check(
 	    type != XFS_DQTYPE_PROJ)
 		return __this_address;
 
+	/* bigtime flag should never be set on root dquots */
+	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
+		if (!xfs_has_bigtime(dqp->q_mount))
+			return __this_address;
+		if (dqp->q_id == 0)
+			return __this_address;
+	}
+
 	if (dqp->q_id == 0)
 		return NULL;
 
@@ -1231,14 +1239,6 @@ xfs_qm_dqflush_check(
 	    !dqp->q_rtb.timer)
 		return __this_address;
 
-	/* bigtime flag should never be set on root dquots */
-	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
-		if (!xfs_has_bigtime(dqp->q_mount))
-			return __this_address;
-		if (dqp->q_id == 0)
-			return __this_address;
-	}
-
 	return NULL;
 }
 
-- 
2.43.0

