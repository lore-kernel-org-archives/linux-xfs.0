Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868317ADFC
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560515; cv=none; b=Wu3uFZEOmQp/xVS6u8D6Ab84RFI63hAirUT3FoL7jFeFL9yiM6VYZGDdj9FovHElJ5NqYBT2iNNddXxyDczwVXXp77OFooOFMBB8fFH9Cy5HmXKPEFQNDZgRedcDSS3eSzz0+3czvgsvOd6N64eAWnhX5Al+Llpflsjfq1IghTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560515; c=relaxed/simple;
	bh=P8HrQ8OTdayzL861yDijJFKOOl1b2FVyKfw2ER9ScN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJIpqRnIsLCCK362K3oojm2ixOWNu+pfFkdTwjQ2sDc1g83xxlgHnHMGBs/8v5TRsfJJ7GEqT6wxRG45UnvzciDjHIduIwxoHF/5syGzENE6z6BjV/PGibh1Ren0hbbYHi3Udykx8/odnehHoWpiwKpTdZIvAXC1LOgBGjYig8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOfNC5pu; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOfNC5pu"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71767ef16b3so745949b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560513; x=1726165313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YftxjRoJc0SoYF3SMn+V0Lig2UIZcgDtolUKgf0ffM0=;
        b=kOfNC5puQqntyfAD/jUgKFqryykCI/CNqS164ZSK1WwmaJK7lkHG5b8hEuqmPH0YES
         Mg/k3DIQfesCiKBw2zeBeLlGbVr2EwKuDXz59S/H19CPUPiKE9W2T1+n34GtLuAr3Qo8
         U0+jPk82yIL6zdQiFlFJ23v5OV3SwY+OqeKINukhvnReHMgF71Hr98OxZ4cbSBwH5/CV
         s2iGjZdBMxrkT1Kp0k/2UF/d0LQV0EldjN++lbfo5Bed0Cu+5zzfS5vGLPILGwsGA616
         GQhNTsB8GDPXjJWmmyc0X6lbw4lfPCUsmVP9va0es1c8N0kMqGAEtE/lkTbLpIBjH6qm
         ySHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560513; x=1726165313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YftxjRoJc0SoYF3SMn+V0Lig2UIZcgDtolUKgf0ffM0=;
        b=lHWeVia/+YjHP4OfVvhvKOPY4V3BkAufJjEotGO3r7nqS+1pp94rmUOj8gf22FEuZ2
         154rCXHBao49WlJR2s7+N9Y/We7eEy+g2g17zKD+ErJPrB3WVW1vRyNccAAkyn4k4oeT
         mI11oCQSgSmWT52byVUbhwQN/DMsTe01pBZKeiKB9qNGhKnQvriUSah/J7pPad3ePTO+
         6i3pLA9pGx35gXeKCoWDljCRczOfzixEPaTPocumxKNongjjUDlnjGEtib89IBl3q9BA
         MDq50SsPtHVhbU5G5a8gkb/icHPxNJhlOKN4E9heHyV8uqBAHxsdAHUeR/sPZv1SwZNy
         jIQQ==
X-Gm-Message-State: AOJu0YxRBkEyHBQPnWOdScZYobY4FJrP0ahRwfmjwRX3/GEHi8MybpQ9
	PW/y0Z2pWZ0sLQqeclNcLLq5i+GW4nFcIscg1Qk0bDjzgWRNNbsSNwcv5/Do
X-Google-Smtp-Source: AGHT+IEOBC1sUh11SsdlEwCtXIsRQloQf0ENvxKbZY3f5L4T1MVNtYBUzU2ADse+IuLGiBrcyU4PKA==
X-Received: by 2002:a17:902:f552:b0:206:c776:4f04 with SMTP id d9443c01a7336-206c776541cmr47823145ad.42.1725560512723;
        Thu, 05 Sep 2024 11:21:52 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:52 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	syzbot+912776840162c13db1a3@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 01/26] xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING
Date: Thu,  5 Sep 2024 11:21:18 -0700
Message-ID: <20240905182144.2691920-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 52f31ed228212ba572c44e15e818a3a5c74122c0 ]

Resulting in a UAF if the shrinker races with some other dquot
freeing mechanism that sets XFS_DQFLAG_FREEING before the dquot is
removed from the LRU. This can occur if a dquot purge races with
drop_caches.

Reported-by: syzbot+912776840162c13db1a3@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_qm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18bb4ec4d7c9..ff53d40a2dae 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -422,6 +422,14 @@ xfs_qm_dquot_isolate(
 	if (!xfs_dqlock_nowait(dqp))
 		goto out_miss_busy;
 
+	/*
+	 * If something else is freeing this dquot and hasn't yet removed it
+	 * from the LRU, leave it for the freeing task to complete the freeing
+	 * process rather than risk it being free from under us here.
+	 */
+	if (dqp->q_flags & XFS_DQFLAG_FREEING)
+		goto out_miss_unlock;
+
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
@@ -441,10 +449,8 @@ xfs_qm_dquot_isolate(
 	 * skip it so there is time for the IO to complete before we try to
 	 * reclaim it again on the next LRU pass.
 	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		xfs_dqunlock(dqp);
-		goto out_miss_busy;
-	}
+	if (!xfs_dqflock_nowait(dqp))
+		goto out_miss_unlock;
 
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
@@ -478,6 +484,8 @@ xfs_qm_dquot_isolate(
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
 	return LRU_REMOVED;
 
+out_miss_unlock:
+	xfs_dqunlock(dqp);
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
-- 
2.46.0.598.g6f2099f65c-goog

