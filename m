Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B729332C921
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950847; cv=none; b=MteqHmJ1+VBI3Kkp2WtkZVIBH4H789N536DGE7GlMa/Mnw/B53C029PpvLDT6tPuh2VOTSDHm5O6CEUhMEn0/I4H2XT/XAkyz/qKJ8+HOoKUnRBgzDEsV95ePidTI/nfE/x1bvje/JRljZE7z8WQ5VDrXASDlZpuQKRjLg0UnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950847; c=relaxed/simple;
	bh=z7/mVq0gtO0EkUKT9CDfwsCKhHR8VN1XdyIZDQ2OjNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V5M+YGo/q+D0iyGvvemz3xJh2ruWOTN9x2hE9ONeDbPiwHtaUgXuoT5zgCUQzwRFsMZm83SUJs1z2piAZ7x5UlUB31eir71Mzg1gp/8qJwV5xzMeaf0oXYUFeeMErkPsBOwLjL8NO8vmQR+fqUli87QYpmchUiLYF24fAGfEJ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWGjOFP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWGjOFP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323B9C4CEF8;
	Wed, 12 Nov 2025 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762950847;
	bh=z7/mVq0gtO0EkUKT9CDfwsCKhHR8VN1XdyIZDQ2OjNQ=;
	h=From:To:Cc:Subject:Date:From;
	b=rWGjOFP8Ycm8VJRYFZ6TNxhcMeC/PkWqw65Iw64mknG0U9MLfk4nnDcBsoISRKDsR
	 g6TN7WC4fhtpK4b023lj6pmTNC9jQ3rvVtoD6DUc1Ao6QDI/nRBZLKwdkjF10gJu5/
	 6OUwAm5Z+XQnNnxKQ0fgJ8FK2rvI+ivSgXEoE5/UHvftTrpPCjU+Hq6oYXf5AexGbf
	 hCf0r/2IWQ+BAE1CLHCp63nHe6sP+75jJfa6h4O9yMNB0JVkvxr263xGTLF7pzjw1M
	 WmnoKdk477vFURibL8YdZ/9dUWLgGUz7yGuZt7NejLWD7sw22ySY6wZcV5FaaKtxKI
	 GE9b7yFvoPkZg==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: [PATCH] mkfs: fix zone capacity check for sequential zones
Date: Wed, 12 Nov 2025 13:33:16 +0100
Message-ID: <20251112123356.701593-1-cem@kernel.org>
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

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

FWIS, writing the patch description I'm assuming that the conventional zones
always come first and we can't have a zoned device starting with
sequential zones followed by conventional zones.

 mkfs/xfs_mkfs.c | 50 +++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cd4f3ba4a549..1378e788eb95 100644
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
+	if (conventional && (zi->zone_capacity != zi->zone_size)) {
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

