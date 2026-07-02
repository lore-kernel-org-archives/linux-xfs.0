Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29709480DF2;
	Thu,  2 Jul 2026 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782985132; cv=none; b=IaYts4GTn+g9SXOWtujYBWW36FAVAqdzIWINTuCc1YbmfWmB7f8ghu+beqPZ2XPYPYVmoSTNEiVmR5KaBVMB5rNUWNHh8ynAyx4kPAhvbUMvHuGomiYDx4AJw8DuclVTIj5zp7lcGfDurDSQ/dAMK7jwSQU0g1JNou17w4lz01o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782985132; c=relaxed/simple;
	bh=tjcwhTXcIvLmCsaPisntsFFW4sheX6cRZL/zWV7kWQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTd+oTkvUMqRhiJmYLawNIaDHJcN+PheorKYeEJAKTXYKU/esVZHaMi+sP4WGdsJ0DzyK8KzT/UBxV0osgWcgJQ8avnh8idsVDKWSn3NzM/r06ZR0fmoByyJb8BssdafOVJLSkhUF0vxb1+SaXRVr1DYNmOC5MfzybXt0yMfrIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNxg2g8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNxg2g8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B8D1F00A3A;
	Thu,  2 Jul 2026 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782985130;
	bh=wu+L64DM3PK/ebfywGSwThzLaOzLIBJsQl0gpUhjT3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNxg2g8aZNaK9OKDyZBiS+dq2+eE+4Nz+WRV+0C6WuWl5Sh9zIOPdh+T+U0AN6xdG
	 5MbsCNYU14JcQf6xyccZn4+bW57agN2zJGOMay1ujM8CLNO8Dsdu7kTm3aep3rXEOJ
	 3HEFF8TJjjN3kO2UT6h3X7RFGQyugbjLzpuOqryCdwca2/gGjJQSjqq5rK+YuyPkvt
	 E5/ihnOJFQ8FiIhi7hyR9GqptKk/uO2wV9fM1esDqCOaZncx4IdFW5A0ZBzCmrKmmf
	 LmfpY6/eAR1PCNhZdSdt6YQt/HVI8xDboHAlEMDHi48des8XOjz4+qR5+xxr7PLLcf
	 X83GsSowb2hXg==
From: cem@kernel.org
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] xfs: replace ns_capable_noaudit
Date: Thu,  2 Jul 2026 11:33:23 +0200
Message-ID: <20260702093324.127450-9-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702093324.127450-1-cem@kernel.org>
References: <20260702093324.127450-1-cem@kernel.org>
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
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
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
index 1a8af827dde1..374b488f0416 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
+					capable_noaudit(CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 205fe2dae732..ce9f8b8468fc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -835,7 +835,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-					ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
+					capable_noaudit(CAP_FOWNER),
 					&tp);
 	if (error)
 		goto out_dqrele;
-- 
2.54.0

