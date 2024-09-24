Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4E61AC45A;
	Tue, 24 Sep 2024 18:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203141; cv=none; b=Oc/7CJhBFSG05bZTf9UOKYEDV1QNVOsSaNFt2wjLXs9RzWHCELZrr/w7wKzvaCqbGycK4PRVZ7PbaPdeVPcWGj/OwBsB9a8vJjFqOyh6VvC7yymEsQi5x2RNKzd4dlQrv6Q8ChRyhvKjuyaJGrIcWMY1s2VDXrZWKqnPbHRK7cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203141; c=relaxed/simple;
	bh=oobLH3ROj0eZGQvh1Gbz4aAcohO6kDihZ3oNiNCAMVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy9JAfhWtPLh48nVcl+hwe/26dppfkhyJErlsOZef/7FHTX0DxYxLhuR8DZjLg61GatDMJMtv+crA0AkDZhmajwigXrB21sccMFtJ3t+SscsygIjyme7N0x/MZq51nVv9KMHs7QtDhrL3zNPcqjuSDStVu26hVcZr4g5VtyFXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X1XXRThg; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X1XXRThg"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2daaa9706a9so4789674a91.1;
        Tue, 24 Sep 2024 11:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203139; x=1727807939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/NRkptMRzWHndvNssccbQUiqHKP0aF5n/yC1Yx0/88=;
        b=X1XXRThg0b3O+7WKe2w7GIqjtB9tPCoE1Qx/6PwDuJ3RGTPEOdRqG2Xq9G4+3mCrQ3
         A1Uh8KLm+gIeDXb+jsyUbVT6FD3SveaZekYtBBZ2PVsCFGsOzSKzjmbVMlMyEoKmfESR
         mgHg79TaWWcnT3HcuYMjRz4XTR2EQW7RagXxh69KUJfSE0Oy58lkK/t+zYZKTgShbOBG
         Fy6KTbTBI6bL382ZsOMcJ4saiGG4cuZZRSIpdKzsftXQ+BE8vfS+AOZKQBlRODhMeRFY
         64MBo2EJ5CH0U17ZYmsoJTNF/iOnmAEmJ8z2efP4mYZg0CfjZVDEAQ3HJ33W51Fvvk8D
         E1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203139; x=1727807939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/NRkptMRzWHndvNssccbQUiqHKP0aF5n/yC1Yx0/88=;
        b=LbXcqAQC+ttlNTRhXoFFyp6ske50PSgyUHpHSCyq70CE/rvulGSagi9sloQbDTqfH6
         ZH4qPrOT6kuKLYigPFEkAR+qm5gwyisktUei/5Wb+YgIKGR+PQyhFqz4hzgfKhwVjCBQ
         DuodSvTqh5Ntc5zX/EBeIMbzIyg5UsSz+a0fFHDt3n6G0HcFRAC+Rm7kJ22+MpU3cNDB
         79gFh9dU1tWecZnwx5vNGeNEsiCww0JfsqBfP4G//cBlM9SNUAnadgFSbeuu0FCFnMvl
         qD8jWdaiZo8NqNMW0JwDqqzRAFSXLhEkQpOv66NeNGHanY++Dxm0f4Er2490HwXciSkm
         r9bw==
X-Gm-Message-State: AOJu0Yx4sRG1s83+t0ImrO+1VcunNvkgair1nhkyAEBCzJ7v/O8Z4Vzb
	dn9f1/DP406S5r9DQD8F7yY9AIoBbHixpOfAzc7TMGAWU0qmyLrL9grgj4jm
X-Google-Smtp-Source: AGHT+IHGkfvpQO1te1+j79Og1/h/bMVvfriLvfp+nDnk+Y0DucEEBSedFsTytKmhzt1ofHfdzUAWxg==
X-Received: by 2002:a17:90a:51c4:b0:2c9:9f50:3f9d with SMTP id 98e67ed59e1d1-2e06ae2cae8mr115047a91.5.1727203138804;
        Tue, 24 Sep 2024 11:38:58 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:38:58 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	syzbot+912776840162c13db1a3@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 01/26] xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING
Date: Tue, 24 Sep 2024 11:38:26 -0700
Message-ID: <20240924183851.1901667-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

