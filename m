Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F297B1E25EF;
	Wed, 12 Mar 2025 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761963; cv=none; b=q4mqxxUVB0P62C8XAWWQlm/lD/zI5ZEp/CUmT813Y1N8nrycp/s4QtPLbTQ8nH8h8EwiB7gG2ES6nTdHE9nZxX2VgviIejy5LeDOA+Y9SBAIsQpuyMpmeWbXNHCJeudRmgcGakoDoWNo9PudjtZA+uHBakuxMbO9NwuMHo8yCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761963; c=relaxed/simple;
	bh=zRnYF4wDNyluIlU0tJZ10Erbifxt6iYxQKXppu/4r3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es3z1oUJJM173EChJijCHaUPURpyUu8WAdI+8Y/ZeDUyKsSd/rgoIVL4ly7X64e4/mii3oDfTk82ffeAMHcxUt92mL3ylqKSJsU3dt9fblnlV3hNPTSo8bA+A2BjOqApMOKMIa9xYeWGtZzw0AUmCTJjZHw63+PVkPYT0XW/NRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gjCxtiGs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gjCxtiGs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iVtJ+TeOhiuT1xOGpUqf30pNV5N0f7xe7kwsff0a894=; b=gjCxtiGs7xLE9BHveqafhWJLmB
	QjcoKZcaoOpEDtEWiI2oa6UfqJLQrrw51UiH1JoKpXgDoXBH+iJkWyrNYeXIzEGVMMMADsvNVkKFB
	VvQS/CWmDTO72g6kjPP2mfBhYPLP0rEtJMOLfIxCWkLgB3XcMZgli1E9yUGrpQu1CIwC+ILIcoFW0
	g2njnTmD8x0K09h+6NHPYuzQiS0V/XpnWiQmQnv2TuNh3OVlXanOmj4pwSaHZ5SXgKdoA8IDXgUIU
	rZLM/q3dxNu0Jok4xjAVEIs3vJGnwqDR18uuCSoj2tUal+dab/1omJW209IRV/eyeDZaozsVAEAo7
	dTnPZKjw==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqr-00000007cnH-15hW;
	Wed, 12 Mar 2025 06:46:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/17] common: support internal RT device in _require_realtime
Date: Wed, 12 Mar 2025 07:44:58 +0100
Message-ID: <20250312064541.664334-7-hch@lst.de>
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

If SCRATCH_DEV is a zoned device it implies an internal zoned RT device
and should not be skipped in _require_realtime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index b0131526380a..00a315db0fe7 100644
--- a/common/rc
+++ b/common/rc
@@ -2354,10 +2354,15 @@ _require_no_large_scratch_dev()
 #
 _require_realtime()
 {
-    [ "$USE_EXTERNAL" = yes ] || \
-	_notrun "External volumes not in use, skipped this test"
-    [ "$SCRATCH_RTDEV" = "" ] && \
-	_notrun "Realtime device required, skipped this test"
+	local zone_type=`_zone_type $SCRATCH_DEV`
+	if [ "${zone_type}" = "none" ]; then
+		if [ "$USE_EXTERNAL" != "yes" ]; then
+			_notrun "External volumes not in use, skipped this test"
+		fi
+		if [ "$SCRATCH_RTDEV" = "" ]; then
+			_notrun "Realtime device required, skipped this test"
+		fi
+	fi
 }
 
 # This test requires that a realtime subvolume is not in use
-- 
2.45.2

