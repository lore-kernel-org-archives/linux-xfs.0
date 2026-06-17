Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A63C9893;
	Wed, 17 Jun 2026 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695262; cv=none; b=h1/me49Ll9zmmDq49LdEJ2DuIQuwHBbwFwWIoyoxaoeYtegRT4dVEJOvMBxlMP6IROK0yzuxnMoXE1Ei2JbrmVbhRsCzT7CjfnmjQa48gnY2ulea/0+ohwkM1/LUYLgZsy/FMdhd9VNl1P62A65BZHAfalhw1nO9okuCqdERX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695262; c=relaxed/simple;
	bh=TV50wAgvY9JF6lMmDEgXH9SRCl47NLbAYC/3MSuUWWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZn3JRXRFSGbvs5WjTSXCXxTJ2deCeFhK4i96vwXY36sAhOvwSxiEyiSnxezb7BwbAUKDXjlGChDMDhwksBiYrDB1LlwElGeNDjBgWrUYDdiYl+zdLMptm5x1KWAw8tWZLcxRF+zIpyJa/6TGbmTptb4uXqpfu4GJ+nQ8LNk1Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8Mj6K11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8Mj6K11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121F31F00A3A;
	Wed, 17 Jun 2026 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695259;
	bh=t44VYnkqYUcNne6L8i6KxniT652yq2VD+rASCJVNRN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8Mj6K11sKGneKpuvwkdoFpeKVOYKDrMMNCV3dgXgBP4Xus8Y/+ThPr9sb2WhuDph
	 h5c6WfbuSqMmZj/DHVCu1j0Kzow0vUK8j9rJX5BNm2rygH5q9MPIGJWAsIs4b0F2g2
	 Vnr9wv0wOoVfmHW3LNxnEFmEXw3tJ3uoPzVA8fPmMg1+BZevKh2FgcDn2bsfASGNAU
	 XvsnTTroUr98HXLbYs9egxgdrpGifExPLlPz8+sa49dXwhqnKe9OwhO75cFUQ0yYBb
	 wKKGbxQN1wGireUOIXDH8EPKcxIFn/koxtY6MaboyIwsnv/Ejv1GBx3vDEEcCMykYL
	 7mqopCQ9BdWzA==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v7 04/11] fstests: add _require_unique_f_fsid() helper
Date: Wed, 17 Jun 2026 19:20:31 +0800
Message-ID: <f556db45f1ffc93508a69ce9f9e567b74384210f.1781694879.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781694879.git.asj@kernel.org>
References: <cover.1781694879.git.asj@kernel.org>
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
index 968ba33686f3..d95eec94f7b7 100644
--- a/common/rc
+++ b/common/rc
@@ -6310,6 +6310,27 @@ _require_fanotify_ioerrors()
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
+# diverges. For details, see mailing list thread discussions:
+#   Link: https://lore.kernel.org/linux-ext4/20260409131238.GC18443@macsyma-wired.lan/
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

