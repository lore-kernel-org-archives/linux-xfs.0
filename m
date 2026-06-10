Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1F322A1D4;
	Wed, 10 Jun 2026 02:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781058139; cv=none; b=VGxnXlBKCmjXfOmvDYymA3QJWU7De8HiuDxf452gcKCqMqokcTrIXYhzd9vVEU5SCn2ThXilfwDmMEhueKJrZhWNwKjE98tT/vkdXhMPVmSCf+JlJ406dMtsZNO26nmy5kp+6U8SjiCb8Tsqs8SN/XFiKjh5H7JMRq2AUkRrtL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781058139; c=relaxed/simple;
	bh=8D80UHGt9FIv1/dq8twDbsjsscfk0/hmhC5N3D166dE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lHz6S4jGssBtA9L12qaqGZdFDzjf9A4J6OnChMwLGhVmEAwzVZjMau8fNvxaZf7iyZ3d56EHhm1j35q8lk9gFfVvF2oCRLtupV9bVReqRShwZP83r7aZsJ7ejysXrheC8oiOWUashLS34poNytLaqJZTwk9rrwVN7u4opzoZZE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HsaqlQhZ; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HsaqlQhZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781058108;
	bh=BdM+BXYzYlQ/OpoOeKQKS0cknExJ3EXMF3wo4YjSxqk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=HsaqlQhZIag9kEzLQmlvmrJFLlKR/4pBGZA1zR937vpljqp5dSJhG3phkcMcDMbkw
	 QBZy3ALI0LqI2PZ7z8CI5U52vF/mgirhqdTE7QuprRyeNUSwGh6WhMDN2Tuaid2w1U
	 NDd6zqNeC1kquJcSSDWPFpxDWLEWOMlkSAd+R8C0=
X-QQ-mid: zesmtpgz1t1781058103t07580bff
X-QQ-Originating-IP: TGLZfLUGP8yTpX8Zpbp2bnZ1BKRDrixIBsaxEq3j1BU=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 10:21:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4008731995869756064
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH v2 2/2] xfs: clean up attr intent recovery error paths
Date: Wed, 10 Jun 2026 10:20:28 +0800
Message-Id: <20260610022028.79846-3-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260610022028.79846-1-gaoyingjie@uniontech.com>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260610022028.79846-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: M83iEva+1QDBTMGPsiMlSX3+G4pzpPEbMawipSKMBKY8FzVQ4m80IzBB
	YSpcW4dhCLCGQa2eY1TfREL/tNktNbTLNpHeocJbfZG1aRlgDrd1mRim1sPnw/aLo5M2Yqg
	qxvm/htpYDmdOxxox/9e3b2MhSkmdCCQdt4jlsqnKVA1LuENqJsQ3XInxRBRtfo0qcGjLY6
	kMZi6aVnLZYzcbaRiCdwkAqgAw9URWn2cBXFQGCZgEFkfOyMRLf5eUrQP+ncqUTz2EIkqQ8
	b1mmUy7C93CTQlqRj0cXP+WYQdGGVtUs9QOhTPolc5gxfJei8f8eLXnNfXupzyECvOSVEOW
	SN48ljL4q7n+LUBbd8VtGuvocf2XHnf0sti+QbFlOvh/Er+LWVsAMwgqxb+Rup2QJSOJjlP
	RG634FRk7VaTyHCUBrS+Rn55g0e7zHq3a44WAIRnF59F/5nGmXlkZQCE2Ui2BlaNKV3gZrl
	pMqLTi8XMdgzNn5xLZr7sMwX9rZi5Wk3CqMNu+ejN1hPavOEpDzGB71OzP7zCTAarYZxXfI
	A+tSFgmO126JvpsChgDwq37UBkqH6oPFHNZOeo7vFoxBfWSm7JhJhZ8AgUzek2+fYfdcQX4
	wJRNVIP8w2JE4I4AqMZcErwybAjrzCuZ8/VPCdXlHUq7mtBZLbquDI26AwHyCrPwUTEaq3X
	8XUUJj+1WUl6d0M+m5O1hpQDQfJSn+rJzSk2oK3cCW2DwDdB51iv8HuduMb9t2JQCozMYHe
	WDnyOqFyKfxPfcYD33UVMMzOhWoRuPF+WSpWhwmGtQVu8KcTYCo7Td08ZFzgWNqbQypFxYV
	9jaA1FgOFclOrRdjrPfvwL/YVPVVuQVeOARrX7WQe/sL9/f2aOPZ23RWMB9hISSpuWkAWv7
	5uDPU1ZqC5t+TG7cvSCs4sDMWRiu10Iz0RoSQHFElDq6iMWoBjz6AIsIYGiYjHXTKZwfo3q
	QYAruFmJoH+Jeew9LjWm8wwuM7CbJApxobVOqIVA2h5Ku8svnkG5ojPM/bgFDeVej0XRDYV
	ujVHwPSEPcs0IWqXF/mLNWyHKAAI3QlYfBmq5sAA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

xfs_attr_recover_work() still uses a backward goto from out_cancel to
out_unlock.

Restructure the cleanup labels into the same linear fallthrough style
used by the neighboring bmap and exchmaps recovery helpers.  Initialize
the local error variable to zero as those helpers do as well, which
makes the shared return path easier to follow.

No functional change intended.

Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/xfs_attr_item.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 841838bc1d0f..f8aa9dd80bb9 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -739,7 +739,7 @@ xfs_attr_recover_work(
 	struct xfs_trans_res		resv;
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
-	int				error;
+	int				error = 0;
 	unsigned int			total = 0;
 
 	/*
@@ -789,14 +789,20 @@ xfs_attr_recover_work(
 		goto out_cancel;
 
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto out_unlock;
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_rele:
 	xfs_irele(ip);
 	return error;
-out_cancel:
-	xfs_trans_cancel(tp);
-	goto out_unlock;
 }
 
 /* Re-log an intent item to push the log tail forward. */
-- 
2.20.1

