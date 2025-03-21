Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891001E9B1C;
	Fri, 21 Mar 2025 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541723; cv=none; b=TlD3XM4fb56n6slFfmF/ZLoI8MSBNLyUN2g12OSdsHo11LwqyP5bEZfoFpNmEMosYvd6ck+yFbY3agmQlT6m41CTel+S1dEamtFbNU2XekGqaAcj98NpIg0930g90YIlgz4zPRT/h9d2UeF0j8pnq5VgcKtcpfibBnMzD3zLvDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541723; c=relaxed/simple;
	bh=UAgj2B1opqcPizJH/Pio/SMQ7CfP3Vh1NwsMw9QHgkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIDovIl9xevLXQr8dQW550EQCC6a1mCEQFCG5/d+c+esBYDrXF7JtyW2r2lms90HdMv83XuQ0Bl7vOZzsJRSL1LR1p+cmBdjGXvO6+xtYwWM1XqZ+Fbh42513QLRhu/soL0zHVTgswirw1vDLfyisBXQ00L/xCYVTGnxdHPy4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R81XMN9u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R81XMN9u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZPZK+t0sCJumFyAjbfXkHQMfVhEIyylK0lUGLsX1wlI=; b=R81XMN9uj1M7s2bUxt17FGqDwF
	X0PEEaRDJs14ZBO7RT4ruKoz/BIgfQSPZiubboa6LkhjYYLnLTPOeS2aMeqb8f7QrasnNtobk/Gr1
	j2JKT7nLvbEK1/oiR5tcEuP57a6528zxfSHoe2eOgZPfNKgAG2YSbIgMEfCzmTG246UKu7PyfkRRt
	DGETtFWVrcXcvd1ppW/k3tkz0wwsC+z12GW+4E1bId5NACO5WmiGJbVOiRLh0aGlJbo4SUk6QxF7y
	0cpihi3ELgj6gbN1qhvx9i6akjhYiE6I/qlchhXdFY0ChZGpkwq+dgcI/Bf4ACJKbWZG39gaLTxQ5
	qbpfnNOQ==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhd-0000000E5Du-3STe;
	Fri, 21 Mar 2025 07:22:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/13] xfs: add helpers to require zoned/non-zoned file systems
Date: Fri, 21 Mar 2025 08:21:35 +0100
Message-ID: <20250321072145.1675257-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/common/xfs b/common/xfs
index 93260fdb4599..3663e4cf03bd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2071,6 +2071,33 @@ _scratch_xfs_force_no_metadir()
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

