Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E203EA94C;
	Fri, 26 Jun 2026 09:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782467627; cv=none; b=Qco3yvqoCk3xqG4jYNQEO6MfcpjPzeSG2BS17DJycp3tNsM5fAr8gTs7lTRnZ0OXys/jzbSvh7aieYN1tDyNlHCfxgn4a04TEssaSd3wYyKPlFzrDk/IRetFBH6cRL88OnaqpxsMkA4ze+dY0eFIS7YD1JH35hYztpbb1zosppw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782467627; c=relaxed/simple;
	bh=ulKQOwvqfv5NwVJRwLbXwf9gv5JhK9bpJp/pOHUFpcA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rb9AaznPMOvtNh+eIrIkOKrOQK7ImlnBLGpilP5VNDhXoTmpmUIGTFhB+1S/75X04VeIwTn58MwziBWtNilTTWJL5Fa+lnVtCRoRxZhoccIorE06GwjOV8ffQ6Vrv5cRoHk0wGBShD1HAsmaXf0phSsp+lJYL2H14m1bVn1FAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=TiS/q2z5; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="TiS/q2z5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782467601;
	bh=vfvLhr65iEMu3izrgUXQ0P2O7TXf2pKb5t+U41jSuVA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=TiS/q2z5a0xDby9CKrKNPIIeSOU21B1pb4mQHk/3Lxgj+d3hQkEPo3VjeGmSSNkJ8
	 hQpVJXRBZww4nB9v03UnP3Pu8R9JJ/TmVa60au7guH+v4UG9ZwimjmAideNTvKGI26
	 q4J2p3Bk2QFYj2MPj5ns2BmUU2ZAUut6RNOzJByQ=
X-QQ-mid: zesmtpsz9t1782467595t3b555466
X-QQ-Originating-IP: BCP/nulRk57ZJbfdxseHmq4NgcrCc406oVjOklDSYZA=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Jun 2026 17:53:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 216098964550341658
EX-QQ-RecipientCnt: 7
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	hch@lst.de,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH] xfs: retry dqpurge when dquot buffer is busy
Date: Fri, 26 Jun 2026 17:52:53 +0800
Message-Id: <20260626095253.3445540-1-gaoyingjie@uniontech.com>
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
X-QQ-XMAILINFO: NvKPgl6nhXeJMcLpMKyREnUDY50szK1egZTjyp8eN1O9LNRY2F53QSjH
	e6mGvv5zpWuRiB2dQlMA1vNgc6rulJwNDwdawgXLSNvT87tOazaEOlsrTVyAf36WxIMqpYd
	b2GQX0wEB4X6NENfE5vF8sucqLOTRsFNvillcwElvwisjSziR+ZrZtL6PgWdFJGtwnOVwiN
	T3CxyjOe6iWO7DKzfSVedDEsJ/7BMUBbs/oEICZbqjz+hLV3oenp35xwfMEocZN3crYRUla
	ra0NJHqgm94VOY3tlCRU0+pkqGTJ70iSFfzUnWLY/IGj5sLHemKtRbcoQmQUUW0E/+eZFrg
	5+OQ+IvW5MqwJuFtaBrxR4rS177Vaf3IWQpy8p0fawJEtNnBGMZUOxtSbyAjwjgqBor6bVY
	d2OZqzWyQhY6/gYYE84PEc0CoOwbllxh6kzr3RdSuYljIlXIXBR0X+DL0ivqtRR+vh30HHM
	bvMU5RY1toynmqhFk4f/PuhwfmH1KTZOgUMZSCpJZzHSfjuxqO3XWVFVbOFU97i2eS42Mg4
	Qdl1wmFGFVQLAnvbhTc/1jsthfk4cp/xE56bzoc1L9yz+Hgp4IhOBJXIRZctF5OhLfLAOVz
	7AB5bDAm7kllOa73PJSnP8mmBif3kMQNGyctIZsuu8nlK1OHZMK/MA6XRlZBcAQ4HjXtn6C
	XYrMyhpmDm21A6030E0FnTHWrfiAoJpQ0uRQTU1/yV5m9tvkPuOYPRKY/Iekm52yfLRriot
	6heB6iyh7+lwDqTnSeiqOIDG7uGTQ+xsavv1UrIzK5u8HFeIydABRxmTwseshRqeUzfVPW7
	fQ0gb+GD/aGkU43GRKkZsORYXbaIHznMwMDsCUyEA1YKi8rxVhBOV70J65RCXEI0NK09389
	WhN9EHU2O6MF4oPP/2J/lZQvRmtB+kOJIYLFKR0P9YnzrOkvvtZZ16vhHTwroVfbct3JRHp
	9vacAomIqufZTZ8HLH58secVUjtKmz+OyfkcdSoVabM/CnYSG0ahpgnXZZBH2bDwflar09y
	WnJ86ZDjSO3mksIXnnWiNOSoGQkCmq2e5pALgkAVyPn++2dETgcKJ6YH+yFms=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

xfs_qm_dqpurge() marks a zero-reference dquot dead before trying to flush
a dirty dquot. If the attached buffer is busy, xfs_dquot_use_attached_buf()
returns -EAGAIN.

The error path restores q_lockref.count but then jumps to out_funlock,
which continues into the successful purge tail and destroys the dquot.  At
that point the attached buffer has not been detached and the dquot log item
may still be in the AIL.

Restore the retry behavior by dropping the locks and returning -EAGAIN
after resurrecting the lockref.

Link: https://lore.kernel.org/linux-xfs/20260625175519.GF6078@frogsfrogsfrogs/
Fixes: 0c5e80bd579f ("xfs: use a lockref for the xfs_dquot reference count")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/xfs_qm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa0d2976f1c3..0622c72292d8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -155,8 +155,12 @@ xfs_qm_dqpurge(
 		error = xfs_dquot_use_attached_buf(dqp, &bp);
 		if (error == -EAGAIN) {
 			/* resurrect the refcount from the dead. */
+			xfs_dqfunlock(dqp);
+			mutex_unlock(&dqp->q_qlock);
+			spin_lock(&dqp->q_lockref.lock);
 			dqp->q_lockref.count = 0;
-			goto out_funlock;
+			spin_unlock(&dqp->q_lockref.lock);
+			return -EAGAIN;
 		}
 		if (!bp)
 			goto out_funlock;
-- 
2.20.1

