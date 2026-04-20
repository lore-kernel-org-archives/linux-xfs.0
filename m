Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A796220B80B
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693027; cv=none; b=FJznRuCjvQYrKOh4GLZlS11qRQyemahKWAY84VpSt1Np+QOL7enq9kwg5O+dgjzjHH03XY16D5XF11xhWf+XcElK4ZfKl9fI6vJHZehIidWHEgzxl7YVFIgx88vBTH36sT7oD/pspDwvVCqZhGaJJVI1cGQfnMwOnHUCq7Em1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693027; c=relaxed/simple;
	bh=z0d+CU/V5Pv9Au/KaezKszLtwk9So3MRPYDOV2i9RwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFQK3FGzJh0YyeZWY46tF59s2BtIqMHTjRYZx2PCzlksMur0BRseeiAuP0pS9Vj5UplTtcoUm1hn33cKlD1wmYTGWiJx8Kd5fZgcRqxuh3sLLBu/oCoDu5urioh8Voa8GGlI/kY0m4bARMaDVamMBmB8zYcTJ29d9uik4BGC7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxFNHGOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxFNHGOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B44BC2BCB6;
	Mon, 20 Apr 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693026;
	bh=z0d+CU/V5Pv9Au/KaezKszLtwk9So3MRPYDOV2i9RwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxFNHGOg4ELplkhc1T8tofc+3bPkIKrdsRFQ1l8K7osEKzKZ/4D94aDHgMo6D/BmZ
	 0LQNnWwy0DGHuF1CN1w4GyhbBdnBzP91ESBKo3kYrsidhNirJ+FS1oQNqlO2apfvNR
	 VETwg5x2gZu6PTN86D6SoYaPW6WqHb+bRc3MPeK31/Xk2Kz9miyzEqfB9TIOi9dna/
	 VawRGlqLQ4avDwl5/RFFjUvq+lY2mR09UYI0vUTOoqlKW1CjBYD8ny0/K00k5kG7S1
	 rZnIuotOfD2guzHfYPsi4TuDJ/4hANVIy5wPuwG2O46Mgrznr8On3Anl19zeJMiwoX
	 IP2gTjI62ClfA==
From: Niklas Cassel <cassel@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-xfs@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 1/2] xfs: expose the number of free zones in sysfs
Date: Mon, 20 Apr 2026 15:50:13 +0200
Message-ID: <20260420135011.624587-5-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420135011.624587-4-cassel@kernel.org>
References: <20260420135011.624587-4-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2118; i=cassel@kernel.org; h=from:subject; bh=z0d+CU/V5Pv9Au/KaezKszLtwk9So3MRPYDOV2i9RwQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDKf6Qs/sGDkFpzDOKdeeXnf9D1TcpPt287v1vnGul1wz tLA7+eCOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCRmFmMDA/2yIalsD/40qu6 onIPZ6v3syaN7BOduaLSiscy86IeejIy9B+S+KnsyCj/qbvjqVWSyLVDLn4fqiIM2e9+/NjPoCj MBQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

The number of free zones is currently available in /proc/<pid>/mountstats
(which contains stats for all mounted zoned XFS filesystems), under
"free zones:".

Add a sysfs attribute /sys/fs/xfs/<dev>/zoned/nr_free_zones for the same.
This makes it trivial for monitoring software to read the value, for a
specific filesystem, without any complex parsing.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 Documentation/admin-guide/xfs.rst |  4 ++++
 fs/xfs/xfs_sysfs.c                | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index acdd4b65964c0..be0d3f5e8b4c4 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -550,6 +550,10 @@ For zoned file systems, the following attributes are exposed in:
 	is limited by the capabilities of the backing zoned device, file system
 	size and the max_open_zones mount option.
 
+  nr_free_zones			(Min:  0  Default:  Varies  Max:  INTMAX)
+	This read-only attribute exposes the current number of free zones
+	available to the file system.
+
   nr_open_zones			(Min:  0  Default:  Varies  Max:  UINTMAX)
 	This read-only attribute exposes the current number of open zones
 	used by the file system.
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 676777064c2d7..312bae4cf70fd 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -720,6 +720,17 @@ max_open_zones_show(
 }
 XFS_SYSFS_ATTR_RO(max_open_zones);
 
+static ssize_t
+nr_free_zones_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&zi->zi_nr_free_zones));
+}
+XFS_SYSFS_ATTR_RO(nr_free_zones);
+
 static ssize_t
 nr_open_zones_show(
 	struct kobject		*kobj,
@@ -768,6 +779,7 @@ XFS_SYSFS_ATTR_RW(zonegc_low_space);
 
 static struct attribute *xfs_zoned_attrs[] = {
 	ATTR_LIST(max_open_zones),
+	ATTR_LIST(nr_free_zones),
 	ATTR_LIST(nr_open_zones),
 	ATTR_LIST(zonegc_low_space),
 	NULL,
-- 
2.53.0

