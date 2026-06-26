Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D71C3BEB
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782469796; cv=none; b=bHcYG9Kkz4USY5ppq+qdsuCvALW8BYH97ef9qhEA1gi3N2Ay9yd+Sf01R1ep9+wSzHfEIsJWy8/Vw/m+XZQToKDUuRHin+QTEif741yFXjvcPsNEnpSM6ri4FY9eGbw2U64/Xx2LeRTW2fYdLrBBlmOC8+MhqX40EPHSsrG9Mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782469796; c=relaxed/simple;
	bh=QHjm4PGBl8pkGzY/9EPprcJ2+GPk73qp4hdilF/Of8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmWlYL3gjw/h5wr/MD7RMUUvLj/BBpovZ0z2mT5ciMpsdg7ja6/R9ys0FRdQ/1uRmL8Eqw1Ipt6UD/pmT1dM1TzO9T+ig2qSlV9x4ZumGQSywfia6o6XzZwQZ/f23f8lzj8ovrQLWMm66iiN+utzhfVG6C5hw/iAViq4WsWQCgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gx8RPytH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gx8RPytH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFF31F000E9;
	Fri, 26 Jun 2026 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782469793;
	bh=J/kQ+Y2THu+pfJeyaiggTenggc2rz33gsacGHkdBFGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gx8RPytHKoRLyWDJlJYzyHVLwnZujO5EsXJ254HTAfVJb6+bIN1cRho+JGIb9egw7
	 n3q4Nrsp+WWmpjR20/vzgIIMVOkdJAORRWw5NIyaLLr/h0Z7JV6PISnoX8WJJX/xWG
	 kxsC1BghkMvwBhV6bj/IevceAdJqxWBlUqjUMJ0DM5DlT7tkpMswxg24zmKmUpyRjJ
	 Ib1M3eMoIUAiDHyJRM8vNR4X4EGWeSB7J73uHCksOnnbZDw1ef9mizWOaJHxMngQRl
	 RNCo4myG0vgoeP1QJomv4gN7CyE33j3Dfhc7mmjk+ax/8oxpx5XpxJYx27mGPvdcN5
	 BRupjIcedbf8Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 2/2] xfs: lift quota capability check to xfs_trans_dqresv
Date: Fri, 26 Jun 2026 12:29:25 +0200
Message-ID: <20260626102934.57834-3-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102934.57834-1-cem@kernel.org>
References: <20260626102934.57834-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Instead of calling into ns_capable_noaudit() as an argument to
xfs_trans_alloc_ichange(), just pass false where XFS_QMOPT_FORCE_RES is
not explicitly required and let xfs_trans_dqresv() decide if quotas
should be bypassed or not.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_ioctl.c       | 3 +--
 fs/xfs/xfs_iops.c        | 4 +---
 fs/xfs/xfs_trans_dquot.c | 6 ++++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 852ff2ab4531..480feddc0e51 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -646,8 +646,7 @@ xfs_ioctl_setattr_get_trans(
 	if (xfs_is_shutdown(mp))
 		goto out_error;
 
-	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
+	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp, false, &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9db9ef1d8c3a..d2ae682f749f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -834,9 +834,7 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
-	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-				ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
-				&tp);
+	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL, false, &tp);
 	if (error)
 		goto out_dqrele;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index eaf9de6e07fd..50e5b323f7f1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -832,8 +832,10 @@ xfs_trans_dqresv(
 		qlim = &defq->rtb;
 	}
 
-	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
-	    xfs_dquot_is_enforced(dqp)) {
+	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
+	    dqp->q_id &&
+	    xfs_dquot_is_enforced(dqp) &&
+	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE)) {
 		int		quota_nl;
 		bool		fatal;
 
-- 
2.54.0

