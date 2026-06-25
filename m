Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9852F2F8EA2;
	Thu, 25 Jun 2026 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393462; cv=none; b=PHS0JmqeY/cX6mWrGpbJaajN374Dbg6kNbBxo7j9ZRCnfLEqcUedMqiFsnPMU/+TeAownuP1u//AVqye7akcTe2b6SD8APUlc1VPFKMwCoae4XoOSUybpAqgPsABRbBYxS9+xJL/1XQ41J0eUUuErbKn8MJP1iMrxMU1gs3QXy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393462; c=relaxed/simple;
	bh=BvbMX9BZdsLlRbFURqn3Mdfj4Uv0xouRcvg1LzJGCg4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CzE2qGh1rNgnXUli7w/WmV9vcap4DB4lj4A+lJI6vjYOTrufcx0cYJe67QJehieu2S0HzfXf75jva6j/5VGZGRlyl0pN5qAVyjigGolIPl+j9ICnDp7/Uz2wVR/0IFBpoXGXxAJsZE2byNjRQyezU1nx1ww37UOIrPcLHvI6muU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UnNYvhG9; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UnNYvhG9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782393434;
	bh=TM6Spaje2Cym42PuVj+SOxsU2pobEUGJ0UnHeO4p1u8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UnNYvhG9XOADBgXS8naDoaaKjca9qzad/ITtw1HcAlaWjdzT+6MEMojcUGmNLjq9g
	 Zv89ELt8XpgsScvJOh96GgWpOF9O/A4edsGOiGKAJwvUFAGEPvB+UvhAls9nRw5hm/
	 MCVrYOzWtPo1k54VVxg49PUcFsxbRBFjqgQyNEnU=
X-QQ-mid: zesmtpsz7t1782393418t074c4a98
X-QQ-Originating-IP: k04syZ26EPRVWzqxjn4yJHJuPv89/l2iHausqJz8Ylc=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 25 Jun 2026 21:16:56 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16767552362201244657
EX-QQ-RecipientCnt: 6
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: release dquot buffer after dqflush failure
Date: Thu, 25 Jun 2026 21:16:23 +0800
Message-Id: <20260625131623.3261735-1-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: Nb940SUM1Q7XvIi7UsAPUgJiiqXptAbiGCYBUT1SB0uQU5dPIU9rf2J+
	zP8GjZAKWqO1d0Uzci/1hTG7kVZ6hHevnWL2Nh8ltvmyuFGey8KoG9OiCfeFd3jHeVWPAQ3
	HUukaQHrnWC504HQ2DCCR8OVe1mAfr/37fpIoPx6cpV0YAEqIlyfYSk0Fa9dXnMp20MO1yn
	Xys44Gk9XR1ugb4W0ArFfidPxdCJSH/2MVU/3XMeWEjaisUjuxo1PodNp+DmExhLzeYIfUk
	kpnBzzSGmBE3STQ5mdlgtMCeUZY5B70lOsc6rj2SbUQ84ruUJjkmAO13ZjWI6eTzAGk1M32
	qSt40P/DnV8cu+HSyxY+JDPi8aeGcnbStng3Xk8qjYLRV9VRfwbxOO6GywjqU9jsxmhjCwm
	P6W3D4ymu0XmvFVXPb9j9jPRGS9VBTfR6wEZiMeEg40uZk+YiaVhDVRYchkhfG4UFTeD1ai
	S8tTxDbCAean1AXudh+wzONWdBh8m0bha0vmXu7kbmo/QHRf32h1VgcE7DNEBEWcevIgCY9
	4Fjl669c+o46AKyN1KGi0XxipJYsYXHdN/lW3D4p4dx8gJLGxwkjCIAtmYRzdXfDfm7QnXU
	5jFHFOEyBQuEhEBI5FS2LW5jMj5HdLHAnEqI/TeGSlKcGBGQHFnIV20CZedlqUGxTJCSSxZ
	v+mjK/sOwX6/3R+5ydwKtA6mxho7yRb1J3juEPkyJgxrzsUNd9VuM1OTiM6u79zKSp6p0Fi
	oXdFuFHr8poZkP0JTqURSVYn7gKtna+qBBmiQJ/fIzGFMFqLo1xqX/2/rjKwrWCvPAgATLd
	9i0zEgmgDvulQvCNECbib2Bw8Tw9HMBN0ayEIdJdmt4am4npmktbqrq3iDdOqyhOLEBnHRs
	LWY7P86+FTNxuXUwoYrMce4JkLogV7GSCHprK+lh33PTw6gzUhHShhfN6fG068QSDtDHSw1
	2tBJF0Q+dKZNZ25cIpDFyn+Eecih7/1ZM3lInzAvtJ5+sfpnMlUku7BfVxmgKBkGbDY8wkK
	Xy0tZn5VkR0doHXyrt5LKdG20YN1o=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

xfs_qm_dqpurge() gets a locked buffer from xfs_dquot_use_attached_buf().
If xfs_qm_dqflush() fails, the error path skips xfs_buf_relse() and then
calls xfs_dquot_detach_buf(), which tries to lock the same buffer again.

Release the buffer after xfs_qm_dqflush() returns so the error path drops
the caller hold and unlocks the buffer before the dquot is detached,
matching the other dqflush callers.

Fixes: a40fe30868ba ("xfs: separate dquot buffer reads from xfs_dqflush")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/xfs_qm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa0d2976f1c3..896b24f87ac9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -166,10 +166,9 @@ xfs_qm_dqpurge(
 		 * does it on success.
 		 */
 		error = xfs_qm_dqflush(dqp, bp);
-		if (!error) {
+		if (!error)
 			error = xfs_bwrite(bp);
-			xfs_buf_relse(bp);
-		}
+		xfs_buf_relse(bp);
 		xfs_dqflock(dqp);
 	}
 	xfs_dquot_detach_buf(dqp);
-- 
2.20.1

