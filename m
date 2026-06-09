Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EA337A485;
	Tue,  9 Jun 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003887; cv=none; b=QVBJUY6wguM0OfIiKYgsv0DYwyfLfq7SaFa+Z+PSMFDvgD8axLcSgohsESRk+EXGzsDOd9Kv4kyExu+D+Md/DrCFkQTmd+/owo5DYP3SqGh0O6vhAadx9GwU5SGdVHqWS3n6KPohQQ+htk3T79ImjAWPxSov+0P6+lrfjDkX5Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003887; c=relaxed/simple;
	bh=dbvpVx2cv8np2bqIEEzxPoktTsXzgTT+PzjCcSuLtfc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PmIWUhuLroPIYBelxyQ28b86jmxJa94AjktXrVY7FoIQzlhYpmYKpWRiIxzef0MlPEPcf70Dnjl59zYfTS512ob7QceoZ4m2rUIE6oIZzboMR0cm7+qpAHLL6Rv3pPTZDoPQNRpmlBQGqPOcferXEhA/zpZB+z2LN47iDlTza2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=OVQE4uBM; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="OVQE4uBM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781003861;
	bh=tuI97Mne40XeKY7vsUSNMcNz1Jv4TIyj+yACwEkVHmQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=OVQE4uBMOVXRbxYK/RMHTkahebhDWSK8cBeZAR6BxoqwSAdyY2nkP3c8uTk+8Zu+t
	 8B1Q1WHIk12VJ2l2LLVk4+UZVRWUZgJ62EwtHcB8y7TjBHqBFdgvzaPZE9XZ1QS47w
	 OTjThPJRnNbgb9AXW7LizYvfwJEng8MujPvOLEMs=
X-QQ-mid: zesmtpgz5t1781003856tb994cc8b
X-QQ-Originating-IP: 3+EfPb8l9Hkhc3/8PW7E9GukyMdXBllV9cNeflCCSmg=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 Jun 2026 19:17:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13479416758889949156
EX-QQ-RecipientCnt: 5
From: Yingjie Gao <gaoyingjie@uniontech.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	Yingjie Gao <gaoyingjie@uniontech.com>
Subject: [PATCH 2/2] xfs: clean up attr intent recovery error paths
Date: Tue,  9 Jun 2026 19:16:19 +0800
Message-Id: <20260609111619.1866748-3-gaoyingjie@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-1
X-QQ-XMAILINFO: MZIGq93qkLWz3t81fiuwaxi+bTbI+7WCOdL5fFAW2VWaSQyFjc6DRs9b
	HWU+3Tt6cjdLq1t855u10jwB/ljHC8BPTLInXRyIJbmXshTCtb0sp+HBCrSkxsg/vNnrnLM
	khg/yjjU3JDGkoGjCbdw5RXgnBjmayWejUsvY7+P6P+DTsX492F/eMZUHn8L+TTaLqZpiSK
	/LokRz0dhT5C4EKAYbNMQJVO5Ycto/akzh3Mj4dwQwsuClNn9DkXdqVMGXl8qbg5W2/F9cS
	bCaaweo1EsgwLd8bv4Msv1NTQ2O1mD52JgXUoQxg/pze7nwsoXuOhtV2CgzXmaEqTOBTi7A
	IAOt0ReEzyj4sZFz3HYkL+YFDxvAWmszzU+qROEO3DFJSzDwEhT93e84rUKuAHD+J1/pxyr
	ZndO4i4tTCBMJkf2NQyJTYFK706HHmWNDfKqQhl0A5DCXTggZVf3meAK+5wlPBDFemJ46LD
	++uKVUJN6s9+xJ/svxXACoMzYwiSpr1oaWOIb/+bHNwBsrCvTcok4F8CzgSDtGuSt0YkpKG
	zkKg7U8QS7iuSURCgIbpi27aHP4Gv0eAJ+J6M9V4XB2ICGS9VLdLLTxfV6q0XdqQbPj8Eoo
	z6nuqCSqUVpTkIm0N8Dzzg0eb/6F4n1G1TDVPQGdDzUYWC/isPegWuziKlo7CGGFLRWQ1jb
	2NIy2ibh1speHJxBOdpLdcTlInmUnTKUUk1pQmMpRu8vPknEgymGjcCiRNZwKi0VVbTWQr6
	um8cHXqs1DjOqdudtRrn2g1BpDrVJ6k/MidiGjTeC2janEwY8AKW+trrlBPxfqGjhmo+civ
	i9UjvPYQhgZfS1AkzQwNMkEMq0CU6oX0HdAl41xTZ6mI6ZCcCop1vSCV85TgObb9/Icmt1m
	PkQZCX94iC6AjdRCfP/pl+mD4AQR4IFqBeJ/YeSQKB2xqk6E8Uyct1lygCG6daHax2OzbeW
	0u0SfcoOfY++XOD31Zh1PZykdKR1BfLpXSlYTYt5jQrfKoPPM8QVRKDVd3dMVH9JmVLONG3
	pmpvcjjW/e9NYrjngxFLRfDowS2iX7ULltXdVENpczYwIcvPqW7K3/SsjgU5mCJw+Xs7zIH
	g==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

xfs_attr_recover_work() still uses a backward goto from out_cancel to
out_unlock, and the transaction allocation failure path returns from the
middle of the function.

Restructure the cleanup labels into the same linear fallthrough style
used by the neighboring bmap and exchmaps recovery helpers.  Initialize
the local error variable to zero as those helpers do as well, which
makes the shared return path easier to follow.

No functional change intended.

Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
---
 fs/xfs/xfs_attr_item.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c3d96c7a5bca..f8aa9dd80bb9 100644
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
@@ -773,10 +773,8 @@ xfs_attr_recover_work(
 	}
 	resv = xlog_recover_resv(&resv);
 	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
-	if (error) {
-		xfs_irele(ip);
-		return error;
-	}
+	if (error)
+		goto out_rele;
 	args->trans = tp;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -791,13 +789,20 @@ xfs_attr_recover_work(
 		goto out_cancel;
 
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
-out_unlock:
+	if (error)
+		goto out_unlock;
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-	return error;
+	return 0;
+
 out_cancel:
 	xfs_trans_cancel(tp);
-	goto out_unlock;
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+out_rele:
+	xfs_irele(ip);
+	return error;
 }
 
 /* Re-log an intent item to push the log tail forward. */
-- 
2.20.1

