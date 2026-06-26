Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202CE3F23CF;
	Fri, 26 Jun 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474375; cv=none; b=SDrrfJvux2tz6t8O4CHQeZ1fmYyKP6bhSx/r6Mt/ymHLsK6PKQesaCtZjynVLVgS/u/u5npkLNQW/yKUPyJLYkpXzxZT16HRHVAZkOsty5tiQhDxcDu6nYvU1WowbDOFaqJtjSjyUS6nLvp2rBiO8mchbdWtOqfOQPvXbfbdZdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474375; c=relaxed/simple;
	bh=ZjNLy6IwSC7dDSgfQmhn68rPozHIdbPNWYjhPEY0ceU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR42VcQODI3MYdmj4kMu9gY1Lg42iq9jpsSOMqFFfHPXSldVdocSseMqz3ToqzSPvH4DT0Y+GCnTlT+NXxyzya72HwJsgNAgrc4UUVFsOLvj8dWUxsgmEFDDyBu50hRcNvvvpUsdUOcq4dlUXyqvUhG+pZqd4WBkweMGBsLSmd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fU9qfYFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fU9qfYFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997DA1F00A3A;
	Fri, 26 Jun 2026 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474372;
	bh=l9xAxHx3Xn936a+LnHIJKWDJnQxxZSbzL95AcnOQYiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fU9qfYFH3ELZrv7rzllzyUeXMITRtTk/rSIAunAmasmoINbrnyBomg6Bl47bbcR2k
	 qbVVWWHj/PFOW5NXB2G9isjlThwxcrjupPseEVO0Tfy8BoXWz3FELvZz75evgk6XKe
	 3KxmHrL6QGkPQDnPd8B6r4gaofHYxyQe4Ez/tTrPtO8R4UJLOAomR07KlkNKihIU/t
	 0CdySLOSH5Frbbju0DYpRFo+PkrR0HM1j4/ajcENe91ms+kHEqHfAL0sIgv6nZrYYM
	 3Gtf47Kh2uQs3PSct+iGbXWSrpvsZmHp5FPChoDcmyM0OTFBkY35b4fxJfpeze8QgF
	 PoFVvTiYa3nUQ==
From: cem@kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suze.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Date: Fri, 26 Jun 2026 13:45:22 +0200
Message-ID: <20260626114533.102138-4-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626114533.102138-1-cem@kernel.org>
References: <20260626114533.102138-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

We don't need to use ns_capable_noaudit() as all we care is the initial
user namespace, use capable_noaudit() instead.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 50e5b323f7f1..30c2f6ec0aac 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -835,7 +835,7 @@ xfs_trans_dqresv(
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
 	    dqp->q_id &&
 	    xfs_dquot_is_enforced(dqp) &&
-	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE)) {
+	    !capable_noaudit(CAP_SYS_RESOURCE)) {
 		int		quota_nl;
 		bool		fatal;
 
-- 
2.54.0

