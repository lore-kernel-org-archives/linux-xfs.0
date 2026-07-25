Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D963126B9;
	Sat, 25 Jul 2026 07:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965186; cv=none; b=jAPgJqFRoqEzexZvGYnOgQWVSDHNDLvkKAxdRiO3fxhW4C8npuc7gmc3TtgCGREt32Y+3mD5eOLfX2vO56JHNmEb6kdqI/pciZ0J1uDcnyOnW69Ir9mRSyV6COVuRTaabVo0QMQkPD1ci5dEkAUkFzw7raVoBp4/RDc4imn6h5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965186; c=relaxed/simple;
	bh=u0NJ44BIyjalePVuCqx5PgwmGLIS0tYJ8UbUaHWKgcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldbAa7/E4kFZx70ctaJq4lRxsBUFVYCwDvb+XzFNGl0GPzV/7En3ugtV5G0j3xzgrMNhHR202wwiTXscIL6ydrr8ELtGe2C/7S5Jxj47ilzy/qxklBBR8Yekija8r19C68d0jRz1v518DIdsVsU3+AmC5SQ7fByrHKCFyiHIa6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEpQWLi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEpQWLi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34711F00A3A;
	Sat, 25 Jul 2026 07:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965184;
	bh=mRZi9Vfr+5T/gOdThVCpmuf5WVpFWTSa3j7CdZPm880=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEpQWLi63DihQWPfdLmhMmIcrNPoZswCEvxSc+yrUi3JzpbCG6/RTm7n0GgvVmbaZ
	 ZDIvo3asJ+B1jIYoMdrTTKLF5t1+gBlqsv8v7ilbpCy4wTuX/5bTJqD/p+CS5Je+3N
	 TVhfEbyyNV8l8p4tMzr0XsQZmh/sDZgbxk1U8gt9xr1KlYGh4w8Jrk5AFBuDfcPhHZ
	 9k2HWUNP19cBNRl/76IibVuDYPFDxyBS0/YOiJyNHr8nuxzxpIdKzEO+gY17qMgBqe
	 BxmcyP99COCE6YW6r7QA5GLpYw1K9EZA0P8MsVG7e2Ix+z9uNr4CDYIXGNEPfkjqlW
	 mVPHkEyYirNNw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 05/13] fstests: add _require_unique_f_fsid() helper
Date: Sat, 25 Jul 2026 15:39:02 +0800
Message-ID: <878a21ea507cb955ed414072c82ab5e5493b8ae0.1784949155.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper to check if the target filesystem supports unique f_fsid
tracking across cloned or snapshot instances.

Certain filesystems like XFS, Btrfs, and F2FS ensure unique f_fsid
identifiers per filesystem instance. However, Ext4 derives its f_fsid
directly from its superblock UUID, which leads to identical f_fsid
values on cloned images until the UUID is manually modified by userspace.

Introduce _require_unique_f_fsid() to allow test cases requiring strict
f_fsid uniqueness to skip gracefully on unsupported filesystems.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/common/rc b/common/rc
index 21b516accdf7..f73251365a60 100644
--- a/common/rc
+++ b/common/rc
@@ -6356,6 +6356,33 @@ _require_fanotify_ioerrors()
 	_notrun "$FSTYP does not support fanotify ioerrors"
 }
 
+# Skip the test if the filesystem does not enforce unique f_fsids
+# natively. Checking this dynamically requires recreating a clone
+# layout, so we use a static lookup based on FSTYP.
+#
+# Across all filesystems, a UUID collision causes libblkid tools to return
+# non-deterministic device mappings. It is ultimately the responsibility
+# of the userspace utility or use-case to enforce uniqueness when a clone
+# diverges. For details, see mailing list thread discussions:
+#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
+_require_unique_f_fsid()
+{
+	case "$FSTYP" in
+	ext*)
+		# Ext4 derives f_fsid from the superblock UUID, meaning
+		# clones share the same f_fsid until their UUIDs
+		# diverge.
+		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
+		;;
+	*)
+		# Conversely, XFS, Btrfs, and F2FS ensure f_fsid remains
+		# unique per filesystem instance (often by deriving it
+		# from the UUID and underlying block device.)
+		;;
+	esac
+}
+
+
 # Computes a percentage of the available space in a filesystem and
 # returns that quantity in MB. The percentage must not contain a percent
 # sign ("%").
-- 
2.43.0

