Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649AD3DDDC1;
	Tue,  6 Oct 2026 08:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276977; cv=none; b=AbmvRWHiorlVBYY19Tu5x2tN1XMZUXPnrGVO2VtFW6RotHGZmuPrpRToBpSreKCnS+aUevjoDcPLKDtiBg74suZR7zz9bBtdiH3ZfB9+Le7VAqiigcfAKssx5mRSFusfzLS1XEZbPVGQz2M0wb/YqonWZYArC07A9ODczin6bh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276977; c=relaxed/simple;
	bh=CdBmrimaVM4daW7vbH4s3yqVirocvBKl1tmwQyDYyoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc+hdXaQdZ+iKPSwvAVIn7AWFRtRAnCP4We8eH4LIpz6ooM0RCL+Vga/ilz4PPL8BCcDb5eSflqy+xqMUq5mECLPxuV99wmtLCMHhjZqbMTur/mHTCluyib+yE3PptbNlfdVZSZBZb9JIddOP04jlOLNDfasg7+ydFny2Rr7YRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lb+VdIGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lb+VdIGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ED11F000FF;
	Tue,  6 Oct 2026 08:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276976;
	bh=ad31bi0Kt9xB6EotHGgbdirc7R49xwpFGiQK9AS1wLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lb+VdIGRkvZV+gQbZkJziy5TSW7MtwzUqcWWxQKwM7phfsAJCxxtbXK3i3yMuT3FU
	 hsSorhmZKvf4FWpJrc9Df7LMRFOfQPTHoI1KTKKEMRkjdda1fpYkiJldpSijrBw315
	 IPSbc3psNdih4xNcu67/yWUZT+JVKgmo3dckhJQYVHsvbmD820VoAfbZcnb7noivAR
	 pF5c85fKdJnqFa8oN0M2KaNAdpg98Di4ZSoSWpRMi1kjG1U2ooL3JnGASr3WrVZcIG
	 YJrzLEIbvdnuZbmK6j/1sgva4wVTu5cL3ccs8JAqNEsSsP2rLZlxUFs4qKNd2cuny3
	 w3GtBBqZurFAA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 01/21] fstests: introduce _require_clone_mount() helper
Date: Tue,  6 Oct 2026 16:55:27 +0800
Message-ID: <245314b2efd616b7ecf09f74e2a775e44e10ab43.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add _require_clone_mount() to common/rc to check whether the filesystem
supports mounting cloned block devices simultaneously. For Btrfs, it
verifies kernel support for the temp_fsid feature, while skipping
unsupported filesystem types with _notrun.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/common/rc b/common/rc
index 3958ac934980..7868e6d311a2 100644
--- a/common/rc
+++ b/common/rc
@@ -6124,6 +6124,21 @@ _force_inplace_writes()
 	esac
 }
 
+_require_clone_mount()
+{
+	case "$FSTYP" in
+	xfs|ext4|f2fs)
+		# No kernel-side restriction; always supported
+		;;
+	btrfs)
+		_require_btrfs_fs_feature "temp_fsid"
+		;;
+	*)
+		_notrun "$FSTYP does not support mounting cloned devices simultaneously"
+		;;
+	esac
+}
+
 # Test that a filesystem can do writes to a file in place (without allocating
 # new extents, without Copy-On-Write semantics).
 _require_inplace_writes()
-- 
2.43.0

