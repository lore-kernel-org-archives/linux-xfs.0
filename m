Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B184432F7;
	Tue,  4 Aug 2026 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836780; cv=none; b=BpgG/9tjgDzsiqVXhxqCN+U2lH89VzUG4+YGXIBrbEX0Yom9xSMBdoIAL0F6xNhUMgpEsTYAXeEgKid6bE/p+M5IRRR3bl8l+hYiNDcVDG7gNnQD/Wnm6cb4vQ+sycFdWVAtyep1H+SyNmlrvB5KlDCcy3g1yAvEj4SqfTZq0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836780; c=relaxed/simple;
	bh=5o4waX4tYcO96lu2V9JCXdXui466KVAfJCxo44iHj6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuR60aycwquA6IQ3PeFYvKjWvfNnC6oxpMAobe5byUwHWAmcEt7o9oZUtICT9U8kEv6cZbsjUl1Jh6ZiQeXEo87i9aWGBmQjHp34bx5sPeqFCW8lCP2BHqyD1E9YdCFpKgeSiHR2BM0oaGySB/eGrBfnH3hXhf8TqkAK6n8MlYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wf7Ax6Nz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wf7Ax6Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA24C1F000E9;
	Tue,  4 Aug 2026 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836778;
	bh=gEbA1stGp4temkIwHIMDReZrCcpfXyIaBqXoOwUrzbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wf7Ax6NztfChmjRWMqiGB/ca7FqVZHpYfxCNUZjdgc/mo+jJFaB8TynV/miUkBXRe
	 O2QJP/XQ3yZG7u4IK/VkQI68OefA9cuDpszAoxB391udt1fWtwJkjFJoKLdbqTYA3x
	 vKi4xW8lnf/agN3VGwrwciu+BtF3vDrkfTnsAH/wtngw3Tc/tM1kzcrjSyxgPVsfwv
	 bdXZjuiO75GG/gcpTbwYJ9oXUoT0FijX70QkaMBUr7ld4ydAYLDXV5eoXY3H6iPBRo
	 fl1kRTs86CO8rbC1Pxfq3FmJ+0v2IG9tFMYT0Opt9CUnVEKio8s8+BalLpWPTO1cNh
	 eSyYbzSdzGHSg==
From: cem@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 4/5] xfs: replace ns_capable_noaudit
Date: Tue,  4 Aug 2026 11:45:54 +0200
Message-ID: <20260804094602.84766-5-cem@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804094602.84766-1-cem@kernel.org>
References: <20260804094602.84766-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Now that capable_noaudit() is available, we don't need to keep
using ns_capable_noaudit() and specifying the usernaspace every single
time.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V4: Fix indentation on xfs_ioctl_setattr_get_trans() changes

 fs/xfs/xfs_fsmap.c | 3 +--
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_iops.c  | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7c79fbe0a74c..041bb2105ec6 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -1174,8 +1174,7 @@ xfs_getfsmap(
 	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
 		return -EINVAL;
 
-	use_rmap = xfs_has_rmapbt(mp) &&
-		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
+	use_rmap = xfs_has_rmapbt(mp) && capable_noaudit(CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1a8af827dde1..96ca3e480cb9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
+			capable_noaudit(CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7a8c77fdcf68..3f36d6e7b917 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
+			capable_noaudit(CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 
-- 
2.55.0

