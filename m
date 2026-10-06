Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DD63EC816;
	Tue,  6 Oct 2026 08:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791276987; cv=none; b=ktWfvFA6MMMzyMkjNupI8SFL2H2nXSamepv+GjLdU4/cdBJDQjyutaI9CMgfLK8npvFUkNQYp8sSgR7GrETBBgJnSVablYAI6qYquhhiOjJfiGdiXYq0vhT1+prSJSO9a9aT+nfrAl1MsuRwhIeO6INeuiK0YZJZUFBvSMFTnbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791276987; c=relaxed/simple;
	bh=KcoYe+yUSAmYBD7Xo59mn7uqKpVLB6I6/9bvyOrXoCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlYrNNe22SihYyhGjlyrpooHLvWDNu7TMbC5QlK7cMKt8ULnjyrwD5qQElQ8jR4/VAU2zgKPVWa7EJzesp9wOXnELUB8lo8R0mrnGzmxvgzMVaQXrffwZkpbYoyBMY5XWuw7IPMWLRDowYXbUZvbDPmWQ7/oTQYTL3Xx1ZcW9P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkgIkopW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkgIkopW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61601F000FF;
	Tue,  6 Oct 2026 08:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791276986;
	bh=WjebKDy45J5TQr0OIERHkGZV6V7teaZQJbQI7nWpxe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkgIkopWJaxkWXL1RvpkMVH3L7JIPGgrMUhqgcmN66ujYc3wgeVHN9QxC8krQ868z
	 koqMTc71K7KWNJQR5yzZ8ddGPHYYrtQGMYUkgObEPVGvONtnfIg2Bjt8heXwPJj3/o
	 xomO6fvsR1N29uuZfauu3srLy4yM2JU71J+QMCm2ei1xaFYgGf2XszFICAByfXFE2t
	 GAPiwWl+yAGH5mWKpNGM3GjOxd0iruDL3DFzTq03I2mTmBkk2021UvcAOQor7anfCG
	 TDwo+ZMGNZHwZl/HrKfhisI18Jg/zW6sn14E5Y9a4rADYPQUYs6KznKoyzwmf3S2Mu
	 SeGw7KFrtW5+g==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 06/21] fstests: add _require_unique_f_fsid() helper
Date: Tue,  6 Oct 2026 16:55:32 +0800
Message-ID: <523304ad35666548443b910955ae7d3a1669ae5a.1791272793.git.asj@kernel.org>
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
index 0fcc1a614ad1..37b32b498c80 100644
--- a/common/rc
+++ b/common/rc
@@ -6417,6 +6417,33 @@ _require_fanotify_ioerrors()
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

