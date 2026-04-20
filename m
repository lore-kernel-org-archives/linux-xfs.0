Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5402E1EB5CE
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693029; cv=none; b=LeBddrAnhD7WZ5C2OYXIv3cpEAaBnOONDeIUGcaVS4eZwePPaMeiyFUB+fE3ieb0h+9jFyyFqXmOdCC4NRvxXqrG4KysVUL0Bk3zkoIjzVr1HKxgMuOjZxFAHn9DJxj6sfh6ZLXAtm/k/+cXxFPhF060gTSErpK95sPQjz7cpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693029; c=relaxed/simple;
	bh=B+F7oiZew4eh8gXYGysI6mG3r+Vh96cXL5C5/nwAN8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUMg9kqp4Xp9Qfxv5Le1V48PN/J2FtXYPX4O0MomDiLIV/Y4Xn8I5q7dKoby+yjTX0yAT3hdPTIYO6crHeQNASIEhUvmNT4d/htYkM9RzhlpsUqBE52RuB+crZoWExHv37z3PL3jNd/CGK9oWcSYcUvCwQCGvmfav8t/vkJ8D1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtLHuUWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtLHuUWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE74C2BCB4;
	Mon, 20 Apr 2026 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693028;
	bh=B+F7oiZew4eh8gXYGysI6mG3r+Vh96cXL5C5/nwAN8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtLHuUWozIYgC13AQZxpQp8Wkf8a9/Do6imczsRATPq3L4w24sBFsEUyDqGtExuFM
	 IfQTlVjyAviABYcrVrczMgwVI/3VSb+1vRLQSSZ0kiJCBb3ewdxby7Oj5N7VKczqtC
	 BZl5zPkwPaaGh2evZCIBBJ6diIVmyDibyAmGr3OAgi6qU+zOYAd0s7gYI0mUMstrws
	 wtjq+UwuiImrO929G6Z1cUsJgM/A+WpjuewZ1oOInoCZcdLs1R0Q9t9HD6770uXk6I
	 +JR02gQFkkRPLxVERbGtKHe2mnoU9r5Ozl8vuszXM+Jd9gRIkLiSDNE2+B5PsUrebf
	 gUlc5h+Au0lTA==
From: Niklas Cassel <cassel@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 2/2] xfs: expose the current zonegc required status in sysfs
Date: Mon, 20 Apr 2026 15:50:14 +0200
Message-ID: <20260420135011.624587-6-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420135011.624587-4-cassel@kernel.org>
References: <20260420135011.624587-4-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1938; i=cassel@kernel.org; h=from:subject; bh=B+F7oiZew4eh8gXYGysI6mG3r+Vh96cXL5C5/nwAN8Q=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDKf6Qtv4az+UxHZeE/vrUvoobkbX4l+4qh97eNa0Hlso vmC5VKhHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjICU9Ght27HGcv3PVMfqpy xNXQrjfr/5S+2fTcbcM/g6/SXcXuizcxMqzjmhrL+GrZVdctB716xB7Gnlh9VrHlncat/VmN6/7 e6GIFAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The current zonegc required status is currently available in
/proc/<pid>/mountstats (which contains stats for all mounted zoned XFS
filesystems), under "RT GC required:".

Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/zonegc_required for the same.
This makes it trivial for monitoring software to read the value, for a
specific filesystem, without any complex parsing.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 Documentation/admin-guide/xfs.rst |  4 ++++
 fs/xfs/xfs_sysfs.c                | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index be0d3f5e8b4c4..87ead41aa86c4 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -565,3 +565,7 @@ For zoned file systems, the following attributes are exposed in:
 	bursts at the cost of increased write amplification.  Regardless
 	of this value, garbage collection will always aim to free a minimum
 	amount of blocks to keep max_open_zones open for data placement purposes.
+
+  zonegc_required		(Min:  0  Default:  Varies  Max:  1)
+	This read-only attribute exposes if GC is currently required by the file
+	system.
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 312bae4cf70fd..1e1ee020df001 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -777,11 +777,22 @@ zonegc_low_space_show(
 }
 XFS_SYSFS_ATTR_RW(zonegc_low_space);
 
+static ssize_t
+zonegc_required_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	return sysfs_emit(buf, "%d\n",
+			xfs_zoned_need_gc(zoned_to_mp(kobj)));
+}
+XFS_SYSFS_ATTR_RO(zonegc_required);
+
 static struct attribute *xfs_zoned_attrs[] = {
 	ATTR_LIST(max_open_zones),
 	ATTR_LIST(nr_free_zones),
 	ATTR_LIST(nr_open_zones),
 	ATTR_LIST(zonegc_low_space),
+	ATTR_LIST(zonegc_required),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_zoned);
-- 
2.53.0

