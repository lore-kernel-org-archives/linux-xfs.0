Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C41A5B8A;
	Thu,  1 May 2025 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106746; cv=none; b=SD+YOvub/zd8YfcJjqaH1c20aCXZTyHzWBs6Y07kiUwxwQaPy/Q491VPZKHjD58mwAm1mcvULx7KZq7pEPn4RIa9g9WdPkWoRQspBsBYkOEoeEeb/fd1EiOUK51cUWQYiw7yvQmeELvMqbdRa2ee2mfhchcqqqKf1FYL7YY2t4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106746; c=relaxed/simple;
	bh=nRkBxtw3elENi+4f8k8LfBHXPKoPWyTjRT6B1CrAdlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c74ttsgIcPzZZI1Wxn3xg62IqjA1bwkHtmSgBHJpVRQqeQmy0nJfUPVZ5LKRJ1XqDogE+xwzbFn6kzkFfxC1IyrBCKFgy7yO4cMBt3wBfP0Z938K6i2PhdIdWGtzrbQ8YomQVYszL4YVdvCIPOBs//MsKwJG4fjCuP3x9tNsStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FBq5KhtZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FBq5KhtZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VcMUFp9w378vAQMvcTnB64pYMpwIJDz1IINaoZYXRnw=; b=FBq5KhtZeS+VXQ4LxLFUksHTIo
	DjuN/X/H7tKODf66w5iupXQaF7Yerahq9LajFoPlmkdZ+YxO8CK/Yp3gGEfBveuvlMmtcWiD5TPX1
	cwkvUd0Vf+zFsh0wx+i4IbnIF9BVU4g0HdwWY1N8hBtIo+N9vJiHlds7ATxT9luxgwYgdqMRxGwA2
	RoUxX3ZMRZ1W+8LIjixDjZuXLCWsli6C+RH3S3zhNyOfNKOKXKoTvY1gLa+mQiQFlHnvkwZlsVEVA
	om1ggZJzLBmR3n7cAx5a0qvg5KByn59KgGhDknviQ2DUNFRa/yjCVzrD037h0+VeRbS+n5pjRkDFh
	xKPA34Ow==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAU80-0000000Fqf7-1T3u;
	Thu, 01 May 2025 13:39:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] common: support internal RT device in _require_realtime
Date: Thu,  1 May 2025 08:38:57 -0500
Message-ID: <20250501133900.2880958-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501133900.2880958-1-hch@lst.de>
References: <20250501133900.2880958-1-hch@lst.de>
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
index f9ffe2d279bc..b174d77a75da 100644
--- a/common/rc
+++ b/common/rc
@@ -2351,10 +2351,15 @@ _require_no_large_scratch_dev()
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
2.47.2

