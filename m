Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86AE2147E6;
	Wed, 27 May 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779856323; cv=none; b=gB9ZSQHbZ8hk3kkkUUid3q2VzrxmR1Td02lOVLv3KB/xDBA1vbXSWYuZ4mwM142NvfTMrBs89oZBqZoNMRnZDlH4nKlDihLQ4R1msmvnQYFbC/YfKOlpWnHUmS8jDVE+vMUJHRt7KCscgXdo8P1fuHxMkXWZCprXs6RH6vlPIWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779856323; c=relaxed/simple;
	bh=yKa3g431tJXPYxEbj3EI9go+1VuCSpaiSDMCH3N6GIk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q0dKdbKYZBb4lLxZoX440Q4iTuEqWSDrvT/I6J27vntrkEdCzUa/ftgdf2NelbpVgWXaYIUjDIZ2Ji2HvT0M4NlEfogpMSIrvBr7HgsK18gnXd1ldaZguqyMhVOYcXSVdrTzUGeqoodGuq5IVHg3vIR3FF622dAVQyzXiq/M5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=RUbz/U4s; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="RUbz/U4s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779856309;
	bh=yD4xWAyAhG5n7NNC9cM5FUGxKI2gkiq/yJM5gG0CHKI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=RUbz/U4sVhSHdoNpes9aHdOUP6eBVgid6XimIUJiAOPM5XlSMzg0np1J+GAj3spxh
	 MptCv8Fi7vui01bjlboUcfiy6Wod0SwoXRERvBXwo8jC+uaDzY4lKiRhjpy8OS8uIp
	 53K8j+LVAPgtEQ4T3azd8vPs7oLFHJma6ANOgwSo=
X-QQ-mid: zesmtpgz6t1779856304t91f8d6ed
X-QQ-Originating-IP: b5wCCwSixH8F5S7g0I3cDL9bhpLxOyfXhfYSOHLtxyU=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 27 May 2026 12:31:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8210572532558420053
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v3 2/2] xfs: fix rtgroup cleanup in CoW fork repair
Date: Wed, 27 May 2026 12:31:34 +0800
Message-Id: <20260527043134.1550710-3-gaoyingjie@uniontech.com>
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
X-QQ-XMAILINFO: OWtbkH21mRLJlsl+p+g6aDJ+DTe8KzdLv1w3ggPEx+zJu75y0HmNkgVM
	AoROP+ZedNFj+fyIjCZHzL0HABd59DjuJZQJFsARmEhKHlNl9dv19H0swX2l35OhPRMJ9H5
	a2cbq+UuzNLHtosi5L3v9DxGpF9lPelzY/QA40p7MMQu3nd86AKZQ2iRQQA6gMrTamtK+UV
	sU/TDaILpMdSKB8DRa0T2agQKtT/G+OHix0e6yxccp907pyAgx9UW8RL7G15Oh1DLU3oAN2
	9ZwnD1mUNob6TksAp7kM9uD0jyfy6wOI0zmFgpfM5KunuAUYP+5pNlZv56TID/A++DPAX6E
	3s2hXUTfKpFeiM61smBJeO8ZdmnfVVIyZQjk0sKvEvUp4mLbwhzAUq+A+BRlQ2tkRDNEe5X
	1l5CdoKno6td3h10/nSghCFtvgrLsUqxZkf4+Egqm+1iaaZEsx6y/xPaCl6jAAmZUUF/5I/
	D+NOOLFLhlF4L22Eu7wYMeVmTtfMeZiRqbw9byS5GshS3avgjh07VL1P0PCnztBiy2cold0
	shtcvcUNf03OhQ3BPYJAOvJtvydgAtzmCE7pYlJT4lwRBzRG6zDiB6tJPy/IpWN6WlA9NYJ
	LxTGj2R47gPWYq7WSXLXYAqwJGw/FKVtSX1RnHC1oyuHHyZVL/+xBP13WkCX1FVvPVV93kD
	VeTh8bA9Rkrvw8c0OVKVpYXQLqrzDOvaDvusJskFT7j26YMZuNhXeUp6rZpVuhPhKXRmhLJ
	l+YEivrVEj3CrHwDJuUuXmfuSJ3bcWsoWfW29X/z1Q2iRtTOGCHPH9kd5eZJ00FVE4h1Rdr
	8c9kf66HbrBQSV0TFYEzNGug35FgMCHatDrHH4kuWi/PBaKmvttzD0Hwg7JLyaJmVNl5BAt
	Gq1D54fm/a/29zqwDk8ARnlSLslYJ9IyzFupT1VDPVH8Dr7cVUmC4NZBTRVl4TW0/+OF115
	FJM6ckC7RR0ewlN/fQbzv+nrCa2zZYo0/5yZOjACARUHL6Fa++bQCQtct9BBdRxkiBL8KTM
	6BXWFxUudXC2X3R45BdgFNTAuujZqTC61JsgoyftHbqlMH0EvB6+G4do3y8excbapgvb7B4
	4sjPYZaTB4JpJW/ATwnOZYclnAvQ9oMgenra3fI26gB
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

xrep_cow_find_bad_rt() initializes scrub rtgroup state before the
force-rebuild path calls xrep_cow_mark_file_range(). If that call
fails, the code jumps directly to out_rtg, which skips the scrub
rtgroup cleanup and only drops the local rtgroup reference.

Remove the unnecessary jump so the function falls through to out_sr,
ensuring the realtime cursors, lock state, and sr->rtg reference are
released before returning.

Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/scrub/cow_repair.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index a6ff09ace43d..c25716fc4fee 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -382,12 +382,9 @@ xrep_cow_find_bad_rt(
 	 * CoW fork and then scan for staging extents in the refcountbt.
 	 */
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			goto out_rtg;
-	}
 
 out_sr:
 	xchk_rtgroup_btcur_free(&sc->sr);
-- 
2.20.1

