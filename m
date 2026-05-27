Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7D5378D8B;
	Wed, 27 May 2026 03:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779853178; cv=none; b=CWl5wZnvuuf5E9fewkt0YrHm38t8mIj2fW3WZtThcY5k76EWoUu4f779e6L3UyaSwSM6bPW5ERr7JBjBSSpi5DOakN5kAyb3S8WCJM5At70N4QNXH+NhQqRUROFg+FTml8DkaWBd4RiZrKSCAvF80KD1IBT+js7jPYMUq8t6LXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779853178; c=relaxed/simple;
	bh=JEl078Wciz8mvWnHiuoRFA2lMD/KMgDNnX5ge5hQDyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c3Dpwor0foOnq1PGcCKCkpwtV0nepMuOPk4vb5ETiQeM1NO8jpKokz5B/YrpNkHkhqJ4AuXXcXhTVEssXHxfixY2Baq7ZK+G9t0NUoF2/zr13iu0TBIV7O0iRWPPKBi0GS3qiYfrTFyJf+rxY74Y2ZEq73412Wnit2tegEmEyjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=c6TdumZ2; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="c6TdumZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779853156;
	bh=4SGVGMXMNpXVhAGaMrYosKLI3hDQbD2P/sp/ok3tjow=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=c6TdumZ202yis1uQjchlwOnjXQTR2SOD6mPYflOUSxqJEXkixmkznS3MQb9QNBZWF
	 p8ncdQQk3g/xVxv/fmwrq59emjcREs7KhR5Bdnv9B9xf4aMg5l+uFOeSHyRwPtQNfn
	 e7wFuAHh62BgigsqHXLUt55fDds264FF8tEZafA4=
X-QQ-mid: esmtpsz10t1779853150tfba2582f
X-QQ-Originating-IP: A5hlVex08IZoZ0sYaECrGzCuLDyR8fheQgK5iJuUuB0=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 11:39:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15394946452561710018
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v2 1/2] xfs: fix error returns in CoW fork repair
Date: Wed, 27 May 2026 11:39:01 +0800
Message-Id: <20260527033902.1524007-2-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
 <20260527033902.1524007-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: NvjxSB0qfI57F8qvscn3TRwLroeH854XcjTWM4D4Fhx4QDBDzOmHhBhr
	iPK+DQT4p9YMc7H6wDWj0DfsxkuAgeNdGInr6IRZGphxGTnkf2+HTxM2dBFOTs+rfbvozQx
	EGtxuQ+o1bZaouwJBFuWZElRrCTcSQSAnjn6xpLRMA8GL+PyFEWUiiS4OKmxdEEowbFuuaR
	g+nIWtm7y6KtTvxb2AMESsrsgF6+oBgl5wMhYQDMOGo6XwVZGoZjmcgDAHYe5o3W2WQLMIE
	k7QhoPF5xXEKklLUjF17S3CtPDvFTHgB1+oM+VPw6bL1Z9iB0F1AwXlBfFFQPhHWSZyZ821
	WHxih8SxhMBYV2MTy7JKTv5aolQlK+KdHqNeZE6vf5ZaDMmUrbW8dUmL0PfQ0DX9AtMlXTl
	1RVBgqIc7w5L1mjZhXFq4JK2mz0R8BOXg+ltRkC2XtoFfiSTfJVm+kIQPMA5ljGriYk+n7r
	+flPVcmmOxr964MK86TbRjNrK5tGVzNF0OvtX+asHklFRNLVn5/huqgAfbEIi6diHqU5EXs
	iW7vChkhECHBTV3xXqdyOzn3eHfAIUNpzkLM6Hyi3pCaiHBCGz21QkYBdJnaYZlj5V9daR1
	7xTJEDvEuybgRhK/dWlrWNWvP5dRl8AQSQ9MVG5mXXYEgAf2SLdW0fZrVzdvBiwdh2DFXCj
	7AZCD6TaU18nxvnH+Hkd2R2Qz1RbamoduIPBn5GuHuTB5rTUfma1oOGkOWly2G7vG7LS9D/
	fw9XAJu9M+iFOm32xw/9+iE5BXPd0lhWbxs0QMSf1gn3wq01yiOLpi9ZFoduV+7YdKhXsZI
	RV5UTu6vIKv4k8T4srOhQJ1LWJ/agnme6YArRuwR29O0FE2v1RlLpGGoBTQmNdXyjKhBpyM
	OjzEiywgUpS4ptsLUVXwC0NHHz1ri7u44q48wiLVeRhsoYziV00JX7UIaEaC5Lhnsiw3y7i
	PcGKt6EOwe7vswem5UGJFyJW1TLHeX8d99rDbLCZvOdiT+w7YoiYCW1O44yTl54f4xk+6DZ
	hKDIs9OSQWlAmFXzApnF01b9KqS8OzE4Z32IXiLg==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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
 fs/xfs/scrub/cow_repair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index bffc4666ce60..d23238830216 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -303,15 +303,13 @@ xrep_cow_find_bad(
 	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			return error;
 	}
 
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

