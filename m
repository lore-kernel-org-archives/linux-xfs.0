Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190953E832D;
	Tue,  9 Jun 2026 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992059; cv=none; b=HJUDJe4Bo3nsyOZoQ6SJgjBqW5m7fydaH3u65h9X3l54xLdNhj8WSkxZ057+TAPV3AwBcedMChlRrJtTYs7FL+p37XNYgW8GU5mdBySX44Qt+if5jC6JlXa0YOxX/V6KhSJ/MzNu2V7f9OPDv31Y2e8uRenLVjTMmLDvf/Hr3IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992059; c=relaxed/simple;
	bh=8Ma+I3kF7kNz6OHBnC9mlcYIDiBNIDuzj1VuaIfR8so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfJz2W5SRnPP4P974wIw6sQN5RIl+S4lRzsUBnr8CjgizkuAjSmUz4NdTPVUxrkF2Xjh7c1k4KRhkEY8uufBmlxhHqB2+W9GiUvKgG+cIOLmkBWk3v7kNB9xIALNFNoKE3Et7E3FDLOv1Jbytb3iUZeQQcbIOqf+GtZ0j8lYCQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vkpzTYoW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vkpzTYoW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2SacbTZNdwztwwXkayiYwK7laCXQjAXQA6ToakTcsDc=; b=vkpzTYoWqJYuwdcHRMWWaKuVCP
	ObEnP89ujTfEo/WKuK7ij9waeA0YSEiFh1xtPGjbemDSnhetllKRZgoWNsnegRmMot4UdgAeUZlGk
	SUnYYajHsRUOMbek3+/V6cfgczBFuFgUddRxm8qiqAhhBoqQg9C+3LavLLe85RUJ6J3/Sb819l4Bo
	ix5QV6G2BdHZH4phDJwmodql6AHHQaq5QnQVwp1Mg9ArdMNBzxg+i5GV8aexp7ypSedMSmr+yFj5f
	evVQnRRurlIdYfYk9+TMNZpaWBzgQ2RuxSLZ30UEhE5vdTN1CadO3C1OQCqiu+CpLq2oatjnBnFSJ
	E14FxZZg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWrOL-000000051Gn-2F92;
	Tue, 09 Jun 2026 08:00:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] common: add a _require_external_realtime_device helper
Date: Tue,  9 Jun 2026 10:00:43 +0200
Message-ID: <20260609080051.1712103-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609080051.1712103-1-hch@lst.de>
References: <20260609080051.1712103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Factor out the check for an RT device on an external section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/common/rc b/common/rc
index 71d872881610..336441c7a522 100644
--- a/common/rc
+++ b/common/rc
@@ -2405,6 +2405,17 @@ _require_no_large_scratch_dev()
 	_notrun "Large filesystem testing in progress, skipped this test"
 }
 
+# require an external realtime device (excludes the internal RT device)
+_require_external_realtime_device()
+{
+	if [ "$USE_EXTERNAL" != "yes" ]; then
+		_notrun "External volumes not in use, skipped this test"
+	fi
+	if [ "$SCRATCH_RTDEV" = "" ]; then
+		_notrun "Realtime device required, skipped this test"
+	fi
+}
+
 # this test requires that a realtime subvolume is in use, and
 # that the kernel supports realtime as well.
 #
@@ -2412,12 +2423,7 @@ _require_realtime()
 {
 	local zone_type=`_zone_type $SCRATCH_DEV`
 	if [ "${zone_type}" = "none" ]; then
-		if [ "$USE_EXTERNAL" != "yes" ]; then
-			_notrun "External volumes not in use, skipped this test"
-		fi
-		if [ "$SCRATCH_RTDEV" = "" ]; then
-			_notrun "Realtime device required, skipped this test"
-		fi
+		_require_external_realtime_device
 	fi
 }
 
-- 
2.53.0

