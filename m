Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE3349AE8
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 06:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773730800; cv=none; b=hJZO1lLOtxQTBtFaJqAcU1AeGFvtweIxlA9TYAj/+X0sXOraeTASo+3CgoB3tVKKWtkF44bQ4NotWt7xg0xCPZE/YRw7HI1Uq8Poek4tj1dK4FGhTZLoETFSWiRrytljP8zwwlEQZyrC6PUMOCO4HEy3TL4KtP/4xyavT8HJRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773730800; c=relaxed/simple;
	bh=PE/xwOtz5UEtew4TT2ybzPmFU4GLZmECY3xYTXuJ8wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS3dZqa2UhQOyJzcvnhQogeus650qBvn1U1iJQBDo4dcX83VmUaWeFr6b8jNzA5HqJogMr+d+anhNb4Nv2rZDN/LEJJWirrhBVeV7MhTEzkCR5Z7xZQIQ+2/EAfriRJ7J3+zGOtO8qmrd4DH04jrwSr99euBlFRpAC2PetemGjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcbjRuFG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MO1lEYt/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcbjRuFG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MO1lEYt/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773730798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZ7ReJiYk1/9BPyCWPykLbLN3hvYPlD1LepuFJypFgU=;
	b=NcbjRuFGzQ6R+vV1boIdr53mDkz4seknF+/c/oPe/YwzEgfkmwjdea3Q/HDYiqGRPOlXsU
	W2LYWc6B37lyXy4yT9ZvV3a43l3Sm94/C9SAqzoQcHzUJwrFfkyENl3ePRpgrso3Ccxe42
	dxSupGVjCZc6RrGe6yq25+91Z4pBtmQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-7IKXGvNWNCqcKvi_p1fCLA-1; Tue, 17 Mar 2026 02:59:57 -0400
X-MC-Unique: 7IKXGvNWNCqcKvi_p1fCLA-1
X-Mimecast-MFC-AGG-ID: 7IKXGvNWNCqcKvi_p1fCLA_1773730796
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5091ee9f1d8so43533451cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 23:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773730795; x=1774335595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZ7ReJiYk1/9BPyCWPykLbLN3hvYPlD1LepuFJypFgU=;
        b=MO1lEYt/SVmfXG8R0tue/X4q2tpse9hiltAyMKg0vT4wfUFXwcH0Q2rDJZXNB1hm9V
         89bjHwn9zqVAljIkdj4hcaFrUOyIZDRkEml1sDAwjJ/xmgPAIgOtFExCo0+ZBy0lSC8/
         ja5bcyeXnvYW/PxMSscEga2BwQhGqu2BUYX+r3XLR3gyCN92KinOv7bfC9StoRm680fx
         PgpZ4xgFuc8/hpaC73Sum+iryMjxh7FUUYo8IQI/Axt3b8fF5Y+rPq5DkA1HyDdTZ88U
         Jg9BK+FM5GKuynnxAtcpoOlA6rlU5N+MBP7JjeGWMvGXSBypfypJ/H9r2A8vu+2op3Aa
         F7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773730795; x=1774335595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RZ7ReJiYk1/9BPyCWPykLbLN3hvYPlD1LepuFJypFgU=;
        b=PIG5E5iG2gGPZxkitIDrQfNO8+twVowPrF+cEq0bkoGwL04i52ln6PpFBvO/MGOQi+
         44J/DgHUpmbvURvnJm6+lgboLCpo+y21pGmvTyZ5NBdrI1qmzlVgGlcupERtbYJ6hB27
         IGpbh1gSUdMNiF1AhIu3bo+IWOnA/mj6+83D4a9KjUtD8rf16m5HfOFd23Q4CZGXl23j
         nqM5oeqXw+Kgre00E/u798lhi/08SCEyPJ4Oq/7gkI7PJwkbgpRG8rD8Tr4e/oARsrZy
         5jo4o3o1RySY6PotIJburg5BWd37LbX5rZrFcnO/FESabEc4PPl2KM82RjfgqVgaXFrV
         +v4Q==
X-Gm-Message-State: AOJu0Yw4OL7dmCoWummaysFzPIVaDMOwTl1BgTsLoHEUhyqkHQk9KfDH
	BhspCx6Pn18g+YyYdlK6UOnQHkZEg/88rA3LbHJGfP0pcAD7KU4IHCILRO+ozL14tDsyErXkz9z
	UB8kVvQGVfljCjT0cGBAzAeLpS/UVSNtiHLrOjWVTScLml5bFgazx+1PIsG3nEe5ZaPxlpIcwz6
	l6RcfXuSlNiZj6GskrXlf2vAxOLH/HVdWforQhMIgFryih8Q==
X-Gm-Gg: ATEYQzwm34CxI49XPL8HDxFpkUcC2tPVLK0wR65r/sTa9nniTffeAxdlZOKwcDmMeke
	E8vAbbUKrJMdJwkll3xHr0pfzUp6z1SD5uhKdzn3szDXhGYTj5YecGfl/SAkfHQkXmkZJDhkE6u
	Y0HwQ+vuNkFKrpj42Cjj6anyeg6ckdMtG2DHgMNCSx+fC8r8vzey/BZVL8UlVgoXKjUxiqv29gk
	Lvef720A5O7X9vFKxgPbkfxF8fIDd/IL61+HdVO0Sas+yPEplbvu0HQN2LXakWJ/iKKKb5IA2TV
	cEPwLFEZui9bs9xG4zF+SQ7ntZ8lp6hnqhePLKP4AEA7PbkuyxA+y9BIeLkII0dsYIBdG3ieslr
	0IzjbzM3HsfY7aXtP
X-Received: by 2002:ac8:7fcf:0:b0:4f1:de87:ad90 with SMTP id d75a77b69052e-50997ff8dc4mr28823031cf.4.1773730795119;
        Mon, 16 Mar 2026 23:59:55 -0700 (PDT)
X-Received: by 2002:ac8:7fcf:0:b0:4f1:de87:ad90 with SMTP id d75a77b69052e-50997ff8dc4mr28822841cf.4.1773730794634;
        Mon, 16 Mar 2026 23:59:54 -0700 (PDT)
Received: from fedora.. ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c48689e14sm55785786d6.32.2026.03.16.23.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 23:59:54 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: adilger@dilger.ca,
	jack@suse.com,
	cem@kernel.org,
	ravising@redhat.com
Subject: [PATCH v2] xfs: return default quota limits for IDs without a dquot
Date: Tue, 17 Mar 2026 14:59:47 +0800
Message-ID: <20260317065947.306954-1-ravising@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260312090810.1145908-1-ravising@redhat.com>
References: <20260312090810.1145908-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
though default quota limits are configured and enforced against that
ID.  This means unprivileged users who have never used any resources
cannot see the limits that apply to them.

When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
zero-usage response with the default limits filled in from
m_quotainfo rather than propagating the error.  This is consistent
with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
pushes the same default limits into a dquot when it is first
allocated.

Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 v2:
  - Moved fix from VFS (fs/quota/quota.c) to XFS
    (fs/xfs/xfs_qm_syscalls.c) per review feedback
  - Return default limits on ENOENT instead of granting
    unprivileged access to ID 0's dquot

 fs/xfs/xfs_qm_syscalls.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index d50b7318c..2176dc617 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -391,6 +391,30 @@ xfs_qm_scall_setqlim(
 	return error;
 }
 
+/*
+ * Fill out the default quota limits for an ID that has no dquot on disk.
+ * The default limits are enforced against such IDs by
+ * xfs_qm_adjust_dqlimits() when a dquot is first allocated.
+ */
+static void
+xfs_qm_scall_getquota_fill_defaults(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type,
+	struct qc_dqblk		*dst)
+{
+	struct xfs_def_quota	*defq;
+
+	defq = xfs_get_defquota(mp->m_quotainfo, type);
+
+	memset(dst, 0, sizeof(*dst));
+	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, defq->blk.soft);
+	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, defq->blk.hard);
+	dst->d_ino_softlimit = defq->ino.soft;
+	dst->d_ino_hardlimit = defq->ino.hard;
+	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, defq->rtb.soft);
+	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, defq->rtb.hard);
+}
+
 /* Fill out the quota context. */
 static void
 xfs_qm_scall_getquota_fill_qc(
@@ -451,8 +475,18 @@ xfs_qm_scall_getquota(
 	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
 	 */
 	error = xfs_qm_dqget(mp, id, type, false, &dqp);
-	if (error)
+	if (error) {
+		/*
+		 * If there is no dquot for this ID and it is not ID 0,
+		 * return the default limits with zero usage so that
+		 * unprivileged users can see what limits apply to them.
+		 */
+		if (error == -ENOENT && id != 0) {
+			xfs_qm_scall_getquota_fill_defaults(mp, type, dst);
+			return 0;
+		}
 		return error;
+	}
 
 	/*
 	 * If everything's NULL, this dquot doesn't quite exist as far as
-- 
2.49.0

