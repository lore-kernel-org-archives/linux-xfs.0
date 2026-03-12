Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3673C0637;
	Thu, 12 Mar 2026 12:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773317484; cv=none; b=NVfyXtxa0U2H73HwQtudh4Beg6KglYcOeC4QXubYu8OyRNKQsJMIq43C5NsdJXklQeqcHUetI/W7AJPVvnSLcJWShuXwstDhhFcLD1vSTlqe58P9N5dTzwVNGiWfnzUl3w0puci0BksD634gOAj1Igr2GX9QJmRAPi8Zxz5h9GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773317484; c=relaxed/simple;
	bh=pYtzYzU3hcC71DMdzs1RnbTWm53HJuN8VornObBqgvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gmPmhx5CHymlo/MmGo+FHOHE54t93n+bljvRz2jIWSqLyglCWGztfKcLUrqkHx/iHZmd4f/9kjD4pOlRG8bT0jQ9IwG1inDv0f7z9xew0aJTcxq04zMqDb03oVbERW8BkLHMDlIKtJ4H9Egwcgynic/SyuU6xzAjlqfTgaVJR2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iMU/icBW; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iMU/icBW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1773317448;
	bh=JzMZ6Illm3olIQVM1CIFS+yhwDn9CKSBdZFqE/yOK9w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iMU/icBWp4mfPIWEx72fCWlpmHmuLTAYjJ8N0ea14QlQSdgQjLsuFyIDcIo3JJzg2
	 o+dd/4TlqK2KVIzFj2+pqevCiKHF1ZMxh1GI4nHJaow85D3HXs6cCAvIgcvEWmZ+9H
	 21RnOXpNt3VMSYTjnzQadQR3IIEc1Xn7Ohsh7vNE=
X-QQ-mid: esmtpsz11t1773317443t4428a848
X-QQ-Originating-IP: iv4EUvJnJXdbZKjq4oI8qP9L5SZqG0Roq7Bm9D4V+Y8=
Received: from hongao-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 12 Mar 2026 20:10:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4145597553995456810
EX-QQ-RecipientCnt: 5
From: hongao <hongao@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongao <hongao@uniontech.com>
Subject: [PATCH] xfs: scrub: unlock dquot before early return in quota scrub
Date: Thu, 12 Mar 2026 20:10:26 +0800
Message-ID: <1C42C3A2C8CD80B0+20260312121026.23660-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NhdiEwnVOUqEVnM8jLi5TYAlgz8/ATfp7a4K4+amnft+HWpPfjQFxjdT
	X7ycn2lIQyJpn2eSOhpTS94rJkwnlXC9qZrnauF6FsA+TG1iNhv6++4P+2usb4BHWLdh1Go
	kr/9tnsaSPM27HhOkpizKaeITJ4N+Vxji6gclbdFqs4cGFdMjq2HjMFzGPsQbWzniQaHl5W
	UJE7XLZ8JZ7BRMLciNjpHPpVQYAWgSp1s3dRmslvVLVRoRhLK29wXUxbyTsdqp99OXI+blL
	xI/6pXC4Mtbn+bxjr5VrLHDDUc1ToS6E0QifXCuXpcs9CZowA6Xprori90OiE42gaOukk/8
	WoojJr+yq66mzFuXSi7ReZ0RzrNy0F4W8sbuTTZzFh0HzdfDLeCDjNJzedd+EblA32UrrMj
	/bES69KBnSGjgEWUHjUvWWzRiYsjudvF9QeQZkP4oh2d5fNiwKl/Pd5sIQEm0TtScP8O003
	dpIZTkRyA8Tj/rDw0iaWyjfCAz9ffm8VTu42/EyLQ9z6KtHat3W8xCsN+ZaOzQ7zhFQgt3F
	/vOSdQYs37jZqbJG1qBQTOjoNulImY1+AfUJMrmT6L1IFZ6RgarZIz1NZaBMlylWEA6mpOw
	/w3/CFlZnY8BDpyMlQfTR2SO4PuHbtC/qZu+mRS1nSszSRFB4Bgphx/4horpLgYGVPFQlRc
	uaQcusdcnb4xF92GsaUDPiHHtqzZEcwzQjHi31+7o24VM2C2wnTcrwq4HwA9YLsOerlr1+9
	DmXbwzRpSrGFMZKj6/H7xz4HP+6PRenuggCHT/83ZvcpdLgYWd3D8hw7Lm6CkvH/wXivwmZ
	ixge9o0ccfmpRJ2qRWsgpGk7ZpVi/iV62xo1BaSv8jHE5mk7SsHgYsrLNV4pgay44HZNqZZ
	ruXt4NIcMDfbcwdj5YUHikLwe9WQGooC2BeI3PLbRySx9RqvXz2xy3OfY1vojH1rnk3D5pz
	X26V1jmjpWoC0CuyvJVqemMl9IBVXzPdeCbjHJi36WVLqAI51T88mJMzdP/oqoIELTOqqYL
	pQI6nzktTTpMce/FMg
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

xchk_quota_item can return early after calling xchk_fblock_process_error.
When that helper returns false, the function returned immediately without
dropping dq->q_qlock, which can leave the dquot lock held and risk lock
leaks or deadlocks in later quota operations.

Fix this by unlocking dq->q_qlock before the early return.

Signed-off-by: hongao <hongao@uniontech.com>

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 1d25bd5b892e..222812fe202c 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -171,8 +171,10 @@ xchk_quota_item(
 
 	error = xchk_quota_item_bmap(sc, dq, offset);
 	xchk_iunlock(sc, XFS_ILOCK_SHARED);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error)) {
+		mutex_unlock(&dq->q_qlock);
 		return error;
+	}
 
 	/*
 	 * Warn if the hard limits are larger than the fs.
-- 
2.51.0

