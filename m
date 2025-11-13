Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513E635CBC6
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041604; cv=none; b=RR7oaMuai8em1s9oY6tpckMiFoH2kNGamPbe8DTB1qfIwNnC8ynsAbYHKd9JgGsysqgoePnWpebxr/+JU1/IAwEvqb2gOcrUW+oi1tevovtPLou9eZNYVYDe+wdrHGfOHi8kPhCVf3J8Af0SeA3b+IYmaKFBpWlFhb3GMGqE1o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041604; c=relaxed/simple;
	bh=2H6rlx29WaH6+Ck5dAl4McPh5eS7DdZ2e2j7s8uw6r4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s+YDwDyvgt1mp9iYWcQEjRPuux8xGQtRJKaLMHSVopJM+ncmYg4OsCZNjvNpF6vkmFPdLlbmo9uaPQv/85OLaS5MVKiNJUNOB5ByLylcWKJowywXNUT/rfpX2KgkM+XLc7OLWwK0bMg+miVMS971QgShl9hHchnAKuAqribjsoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ue2swg17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue2swg17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33007C4CEF1;
	Thu, 13 Nov 2025 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763041604;
	bh=2H6rlx29WaH6+Ck5dAl4McPh5eS7DdZ2e2j7s8uw6r4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ue2swg17VobiVv12Y1Z/ZLca7Tb+zzXteUshMB9NRN56e21aTRDYu+2kKBSQCru7O
	 CUdeIWUY3+LIS2/PqBNgNX8KMZs4wOepXRRbUyKvSSbBhAlrcTyWb8Dx2Rv1PUrXpO
	 ctQFi1ucY3TBzJbtZXUsSV5D5HuLuqpBs8srlbFLryR5s9WCqySeMgMAyhJjU6SKK1
	 JM19K9Ga7EZPa43o8AYxfIgOqnPXOPiHv3hPH90mXqPzC+ULcswjUiTwEpGWWuMRka
	 boklpXBYxNU8pbNOFXjpwjjUKOS98DzzqbdM9jmQH5PdDYO+JfFyRa3womxz9eHp/O
	 P5zPOIWCN8/dQ==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: [PATCH V2] mkfs: fix zone capacity check for sequential zones
Date: Thu, 13 Nov 2025 14:46:13 +0100
Message-ID: <20251113134632.754351-1-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Sequential zones can have a different, smaller capacity than
conventional zones.

Currently mkfs assumes both sequential and conventional zones will have
the same capacity and and set the zone_info to the capacity of the first
found zone and use that value to validate all the remaining zones's
capacity.

Because conventional zones can't have a different capacity than its
size, the first zone always have the largest possible capacity, so, mkfs
will fail to validate any consecutive sequential zone if its capacity is
smaller than the conventional zones.

What we should do instead, is set the zone info capacity accordingly to
the settings of first zone found of the respective type and validate
the capacity based on that instead of assuming all zones will have the
same capacity.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	v2:
	 - remove unnecessary braces
	 - add hch's RwB

 mkfs/xfs_mkfs.c | 50 +++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cd4f3ba4a549..8f5a6fa56764 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2545,6 +2545,28 @@ struct zone_topology {
 /* random size that allows efficient processing */
 #define ZONES_PER_IOCTL			16384
 
+static void
+zone_validate_capacity(
+	struct zone_info	*zi,
+	__u64			capacity,
+	bool			conventional)
+{
+	if (conventional && zi->zone_capacity != zi->zone_size) {
+		fprintf(stderr, _("Zone capacity equal to Zone size required for conventional zones.\n"));
+		exit(1);
+	}
+
+	if (zi->zone_capacity > zi->zone_size) {
+		fprintf(stderr, _("Zone capacity larger than zone size!\n"));
+		exit(1);
+	}
+
+	if (zi->zone_capacity != capacity) {
+		fprintf(stderr, _("Inconsistent zone capacity!\n"));
+		exit(1);
+	}
+}
+
 static void
 report_zones(
 	const char		*name,
@@ -2621,6 +2643,11 @@ _("Inconsistent zone size!\n"));
 
 			switch (zones[i].type) {
 			case BLK_ZONE_TYPE_CONVENTIONAL:
+				if (!zi->zone_capacity)
+					zi->zone_capacity = zones[i].capacity;
+				zone_validate_capacity(zi, zones[i].capacity,
+						       true);
+
 				/*
 				 * We can only use the conventional space at the
 				 * start of the device for metadata, so don't
@@ -2632,6 +2659,11 @@ _("Inconsistent zone size!\n"));
 					zi->nr_conv_zones++;
 				break;
 			case BLK_ZONE_TYPE_SEQWRITE_REQ:
+				if (!found_seq)
+					zi->zone_capacity = zones[i].capacity;
+				zone_validate_capacity(zi, zones[i].capacity,
+						       false);
+
 				found_seq = true;
 				break;
 			case BLK_ZONE_TYPE_SEQWRITE_PREF:
@@ -2644,19 +2676,6 @@ _("Unknown zone type (0x%x) found.\n"), zones[i].type);
 				exit(1);
 			}
 
-			if (!n) {
-				zi->zone_capacity = zones[i].capacity;
-				if (zi->zone_capacity > zi->zone_size) {
-					fprintf(stderr,
-_("Zone capacity larger than zone size!\n"));
-					exit(1);
-				}
-			} else if (zones[i].capacity != zi->zone_capacity) {
-				fprintf(stderr,
-_("Inconsistent zone capacity!\n"));
-				exit(1);
-			}
-
 			n++;
 		}
 		sector = zones[rep->nr_zones - 1].start +
@@ -2683,11 +2702,6 @@ validate_zoned(
 _("Data devices requires conventional zones.\n"));
 				usage();
 			}
-			if (zt->data.zone_capacity != zt->data.zone_size) {
-				fprintf(stderr,
-_("Zone capacity equal to Zone size required for conventional zones.\n"));
-				usage();
-			}
 
 			cli->sb_feat.zoned = true;
 			cfg->rtstart =
-- 
2.51.0

