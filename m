Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34AB17BA3;
	Thu, 21 Aug 2025 05:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755755751; cv=none; b=TdX5KDcFQKbkbFgw2AAOmLSVjxHVQ6oICqNer96Qu2AEUjHyjeDUYJk0aF8w7nUGRguTMsX152mDInkNydKWOQUuI+89SnFdPcrSp4VoQaGlQxCDKF7aV06f7o6c8HPeJufT98lhhDt1cHQoQcUbbHknLKHCbcG+4S4zBUd/tiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755755751; c=relaxed/simple;
	bh=DyhUYlATE/nExkjiPRrlJAaOTEAWr2ozRbWOkzojttE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ9hPUXNt6oksBE/zUQK65qXCzgESfViFyyXySre7xKM+mxJ93ARiRBEwg8D6gEu/poYsRLHYfkal9wfKTlWU+7q9rM02WyXE1lQrDMNgf+tcVB02Eb/2JOMKGK/vvTNQOstogJZFQgyV3XjpCkGoViWdtL1X23clYhPWYWLzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from jtjnmail201606.home.langchao.com
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id 202508211355321975;
        Thu, 21 Aug 2025 13:55:32 +0800
Received: from localhost.localdomain.com (10.94.10.82) by
 jtjnmail201606.home.langchao.com (10.100.2.6) with Microsoft SMTP Server id
 15.1.2507.57; Thu, 21 Aug 2025 13:55:31 +0800
From: chuguangqing <chuguangqing@inspur.com>
To: Carlos Maiolino <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, chuguangqing
	<chuguangqing@inspur.com>
Subject: [PATCH 1/1]     xfs: fix typo in comment
Date: Thu, 21 Aug 2025 13:54:16 +0800
Message-ID: <20250821055416.2009-2-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250821055416.2009-1-chuguangqing@inspur.com>
References: <20250821055416.2009-1-chuguangqing@inspur.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 2025821135532a9f6cfad76f4763800e593758c50706e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

    Spelling mistake in comment.

Signed-off-by: chuguangqing <chuguangqing@inspur.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 fs/xfs/scrub/dirtree.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 86a111d0f2fc..3c4d545fe72a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1152,7 +1152,7 @@ xfs_calc_attrsetm_reservation(
  * Since the runtime attribute transaction space is dependent on the total
  * blocks needed for the 1st bmap, here we calculate out the space unit for
  * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by:
+ * to the attribute extent length in blocks by:
  *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
  */
 STATIC uint
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 3a9cdf8738b6..2072e4d9ccb2 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -995,7 +995,7 @@ xchk_dirtree(
 	return error;
 }
 
-/* Does the directory targetted by this scrub have no parents? */
+/* Does the directory targeted by this scrub have no parents? */
 bool
 xchk_dirtree_parentless(const struct xchk_dirtree *dl)
 {
-- 
2.43.5

