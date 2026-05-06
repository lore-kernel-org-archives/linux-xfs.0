Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFBD3F0759
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778085426; cv=none; b=N89INyk8/H/co0qk76UlvNXM+ajbMKEgWJJcuNA7ghed8j0WKVD7Q04Ay3w9Rxsd39fhdlb1w/8hQgK5rBcIDflfHWXnLa9yDxW/JTMq12cv72z4n9NmDEe0NLLMt4w3PX/3WC4h+TXMHjNhT8mEPzlQUATbhJoWvLefQg0KIag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778085426; c=relaxed/simple;
	bh=5bHtuy0sCeuAj2tjlyhJtiGZEL1Whf182f56eH+H21c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PnHgINZKR5wT7OXuUtJ4SyWgWVwPB/1mcgb7L5dDV8EiYJoQzKgpJt8gW+h30hq2TSV0ab5xFk+o/tCUPvMhbtLzKEUrWUYt20RvCE475DQsxL+cpSleBEnqIBYp7YF8AwIIBS+sKQ3Bl7u2iGYGHW3V5gzaovZTglDfsQYhh5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rRBm+J0u; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rRBm+J0u"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39393ec4ed0so42549621fa.0
        for <linux-xfs@vger.kernel.org>; Wed, 06 May 2026 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778085422; x=1778690222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6T/FntyDjZ2Qi3KeHTozHInxL5pNQcRPqrX9tiVywuw=;
        b=rRBm+J0u92lN+W4xy4KdoHUdcEsd/XxPfs2rMP0Jb1G4yfr1khyEFCtIR2+z/TD26N
         hnac++nGandjEpkqKt1L37H6b7aKbZmFhSJJXcETJopOofy1w6QYn7nSaplNoVfMosOV
         KruSbRl5+gqal82CbGPDmN2V9dsTRTQgZgOKajC2QHjMZS8JwbDx6O4DGzG9/FC0ARvr
         vc9snVCNBLw/1wZyINnS4PmJZwZYEpAwP+JqCWksmPFCdVuj+uAPYJ82cScTQxFdf2gg
         gN665+yuE5bP98phHcT/IgnZeY+X7cAfrTtX2aL4LAdIroQbHXKTludL4TiqGd121tOk
         prEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778085422; x=1778690222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6T/FntyDjZ2Qi3KeHTozHInxL5pNQcRPqrX9tiVywuw=;
        b=rQcXi4Uk8CCl9kkoDzTrhBHdVeuBE9Nip5rzIaIbGyyicOUHxxfpCXRDlIh9p5tH9/
         XW4lMGRtKFmPnZzGPhQcB3pNJUtLA9313CN8ft/PDL+ydzJMh30kD6vNAnNf/AL/NsPG
         hjUYL3ukgqPSpBydRVvUMRKabpvbHyWk4SBb31piIMH+/f1pr/y3ZOtn4mrEemP/PHV2
         hazl7veEwmQjEeMVb7+VnhmR1Q+grf2UgTg2VRIgLhimJ5oJjN0761ljdUSEwHLsuICI
         2z7L5kNoM12snlWqk3EJYkG3WsNzI96RU0W+ov/5tzXWq4CSav3tOSR+nM3hdr5Fwsqc
         l49w==
X-Gm-Message-State: AOJu0Yz6rdQgazcyIHbzrWUpeSq1szN3XZXNTF6L+syikbnQwO8AiWYE
	yiP9s8jA99Eq983Cm9ffdCRnTcJAmi2xE9EREvG+SXVpzbFISm1yzYCBvR73duaH
X-Gm-Gg: AeBDietVZwsBDHLShR3nm3ZK/dmjr0ExwJ4ncFuY3prqLIN1fvpUWsPKCY4aNiRqCzl
	YUSKeN13ki0LPgiqxnoLFL+BdtLHgyU1YMcXxftqhakUw7exmkAGOo/Bnnt3b+lBipe/8BOqPWG
	7mWu1v72cdB/QGG2k0PcakGezPgAusuGFtZUaKCyK0u4d8xTLkjYkiBfHi18oa3fE9FUatVmqSg
	NZZyE7ZjnF3v/SIK/hWrN6HkRPRBAqsZ/ooRryY3dPG0qvMjFFRuv7SUArK8tN42yINHzKBe2+c
	c7s6vGcRR4Mq7LlP1RpI1jFIV7yNetDPXX6AtBNhL9krFCZ+ZnhqHZtwHW2QSTPriWWud0lq4aK
	s5SrgSd3hozw6ocCIvkE1TpE/pZtZnzj/Y0O8xE18szZxJ3efz996/cx5Tll8nVMrxsQlKLDyT5
	ow9c3x82jXBKMW4MHYEEaFM/7QOHXhFyroe6cwb2TYd2K4eU+r4K0/fW1tfS2eZSpHbPW+tDFNj
	wA=
X-Received: by 2002:a05:651c:12cb:b0:38f:f8f3:6c47 with SMTP id 38308e7fff4ca-393c40a326dmr17654361fa.4.1778085421845;
        Wed, 06 May 2026 09:37:01 -0700 (PDT)
Received: from Shofiq (87-92-218-151.rev.dnainternet.fi. [87.92.218.151])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-393a11fcf41sm28292031fa.26.2026.05.06.09.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 09:37:01 -0700 (PDT)
From: Md Shofiqul Islam <shofiqtest@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Md Shofiqul Islam <shofiqtest@gmail.com>,
	cem@kernel.org,
	djwong@kernel.org
Subject: [PATCH v2] xfs: Fix typo in comment
Date: Wed,  6 May 2026 19:36:58 +0300
Message-ID: <20260506163658.2318-1-shofiqtest@gmail.com>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling mistake in comment:
 - occured -> occurred

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>
---
 fs/xfs/xfs_notify_failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 64c8afb935..b994ff15d5 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -350,7 +350,7 @@ xfs_dax_notify_dev_failure(
 	/*
 	 * Shutdown fs from a force umount in pre-remove case which won't fail,
 	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
-	 * CORRUPT flag if error occured or notify.want_shutdown was set during
+	 * CORRUPT flag if error occurred or notify.want_shutdown was set during
 	 * RMAP querying.
 	 */
 	if (mf_flags & MF_MEM_PRE_REMOVE)
-- 
2.54.0.windows.1

