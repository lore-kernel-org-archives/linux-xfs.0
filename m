Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ACD1E8328;
	Wed, 12 Mar 2025 06:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761973; cv=none; b=FvpMuzVTwZA8ZhdJKHXS+Gq6CfCSggkQg+CtE/cqCMeeObKJoTboAesVTQSvxEbOXDvgq1RWMt74SlyNTjcD4dicj3qBnfT7pFEI6JZhlJuJzMhhnGqoBxf+DMWDQdsKVEPNVUv1QaDzN42hQBbEPPigxY+Ayh9zuTz5PRiRWEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761973; c=relaxed/simple;
	bh=4980ixdozEiR9fAIVkseNO0wNhSB6I11xEnmLmqNyEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB/bRN250su7pO7Z2anARXz+KWGKr0HNhyJohv8SaOQS+xb0AICSKdGE8I9G1MRyx+2Gmb43mqHwWW2OLbNkK9BXfDFwhRpkhJkcqomS1CW7Cxo3p5EUpDcYatz6CuWtBN8n2YKbZzSpBSbWiBQH4JuXIctat/BwXx5OxWdZaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KJqPF3dL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KJqPF3dL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3QrNdjHatguZTK2DgQdbRVlgjCB7NzRbrigeYh2AFLA=; b=KJqPF3dLl1FB5beArzN2GYgm/z
	AePuExHGULswvlm2uYWj0bFICJZ3TIhxk/zRsDiDsymlNfSZrNXZ14Oor9VCfvapRZY3SuF0pKb20
	uu1NJ8/yc45KZtPIsC8PV5Ca2XY4spiqSmyUTgg1l9r6dlb8XMk+0U4VXM25lgSBmYHjYbcFvkLBY
	yUPIlJqGHhSOAjg6AlMbOBh9fxNCnnACQ4NRCLCJ0i74TA+oVg+/QQD8rByyb3ju8IZlD/Z8MDVOB
	0aFV9NFZp7OFFQISM92VD/GX9xk6PAizZ09whqr5mGB0z4gll+LP08KaGWKvxQdghLpsjfzzW1czy
	UtxQCVXg==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFr0-00000007cq7-3lC5;
	Wed, 12 Mar 2025 06:46:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/17] xfs: add helpers to require zoned/non-zoned file systems
Date: Wed, 12 Mar 2025 07:45:02 +0100
Message-ID: <20250312064541.664334-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looking at the max_open_zones sysfs attribute to see if a file system is
zoned or not, as various tests depend on that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/common/xfs b/common/xfs
index 807454d3e03b..86953b7310d9 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2076,6 +2076,33 @@ _scratch_xfs_force_no_metadir()
 	fi
 }
 
+# do not run on zoned file systems
+_require_xfs_scratch_non_zoned()
+{
+	if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
+		_notrun "Not supported on zoned file systems"
+	fi
+}
+
+# only run on zoned file systems
+_require_xfs_scratch_zoned()
+{
+	local attr="zoned/max_open_zones"
+	local min_open_zones=$1
+
+	if ! _has_fs_sysfs_attr $SCRATCH_DEV $attr; then
+		_notrun "Requires zoned file system"
+	fi
+
+	if [ -n "${min_open_zones}" ]; then
+		local has_open_zones=`_get_fs_sysfs_attr $SCRATCH_DEV $attr`
+
+		if [ "${min_open_zones}" -gt "${has_open_zones}" ]; then
+			_notrun "Requires at least ${min_open_zones} open zones"
+		fi
+	fi
+}
+
 # Decide if a mount filesystem has metadata directory trees.
 _xfs_mount_has_metadir() {
 	local mount="$1"
-- 
2.45.2

