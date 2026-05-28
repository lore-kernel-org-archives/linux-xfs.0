Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F8313522;
	Thu, 28 May 2026 04:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941181; cv=none; b=YiylTj30z/rz4J/3u3gq0gWMJF5QaBgqg6DVE4D4K8TbgsESa4lphM134K4ojKLScs6URxP+Te9b/T6nxjBl4wFfcCI/iqbI89D+M8JIA1CNgcCOwBKFgQYDMyjl+hMuAzjQzfAqJVWzp1csaVl1a37q1fSg3V5NE9aVBW448nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941181; c=relaxed/simple;
	bh=2qERNUCxXWYcGpa9LQgLszNMBMJgsfluUC7PMoQAEJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pux6k8O5HWopY6dtbn8lU5ETYO+KEwrCqv2HIc4zicnBAe4FF9qO6GDWW12+1kuq13RwongRn9gvVkPYgC0UoQKEK98m++d9eVRQd9bD/5vaqn5U8tpRv7GB7EMmGqac+2vBFdB5LBwnEA9Q3cYofMaduBmQhL1brcv8SFc7+og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDdasQZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDdasQZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BEC1F000E9;
	Thu, 28 May 2026 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941179;
	bh=WUek036XA17MzAJUJBvXynOAe7o9o+IXSarD48Lhz1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDdasQZFOr8hwcjR+uRFk51a5ubDI9ea8xd24FtF38hBGRuYkraIAWXTPg7lax1Z/
	 OdhilfsaRQlAj3boghBoAzWStddfr2bp4MjvPNur5jKik7/WU8ucxDSj5EDv45aQqy
	 UVQFEh+Mm/6QjB6pzp/CrZ2WnndAYbUzWM+2nXxaa8Q+gx4LnbZLnhFgIFXk8IpOLH
	 zm+Q/sJUC70YTV6oslYc4z518MVy7YVIvPKnB4h8OA3qbzObkuv2NYkkkzqocuqYsB
	 kCMaMugkACBMoQuGBtRaQR30Zb56NyipU35AviDaB9zPkSkDXYWDjG7PQqpbn6SQWJ
	 Zo8RLK0NOfiGQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 04/11] fstests: add _require_unique_f_fsid() helper
Date: Thu, 28 May 2026 12:05:35 +0800
Message-ID: <983ed0f63318c930379ee74220f23aa558c16d51.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
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
 common/rc | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/common/rc b/common/rc
index 937f478963b4..5446552aed92 100644
--- a/common/rc
+++ b/common/rc
@@ -6314,6 +6314,27 @@ _require_fanotify_ioerrors()
 	_notrun "$FSTYP does not support fanotify ioerrors"
 }
 
+# Ext4 derives f_fsid from the superblock UUID, meaning clones share the
+# same f_fsid until their UUIDs diverge. Conversely, XFS, Btrfs,
+# and F2FS ensure f_fsid remains unique per filesystem instance (often by
+# deriving it from the UUID and underlying block device.)
+#
+# Across all filesystems, a UUID collision causes libblkid tools to return
+# non-deterministic device mappings. It is ultimately the responsibility
+# of the userspace utility or use-case to enforce uniqueness when a clone
+# diverges. For details, see mailing list thread discussions titled:
+#      "ext4: derive f_fsid from block device to avoid collisions".
+_require_unique_f_fsid()
+{
+	# Skip the test if the filesystem does not enforce unique f_fsids
+	# natively. Checking this dynamically requires recreating a clone
+	# layout, so we use a static lookup based on FSTYP.
+	if [ "$FSTYP" == "ext4" ]; then
+		_notrun "Target filesystem ($FSTYP) does not guarantee unique f_fsid on clones."
+	fi
+}
+
+
 # Computes a percentage of the available space in a filesystem and
 # returns that quantity in MB. The percentage must not contain a percent
 # sign ("%").
-- 
2.43.0

