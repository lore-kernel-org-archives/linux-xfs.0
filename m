Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6993A1BDCF;
	Wed, 12 Mar 2025 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761957; cv=none; b=uQxxULIyi2ctHvlyZoY5/EKZHtoIIUy5EeGF59tx8i8oKy6vGYhmOTGajRSjC1OzMROKU7Pi4OascOqh8IqlthCKHrL3gwop9hucjiIYcnSORTU/nIs42iiwGHUYqHf/vFbHRn/lyBcG1/U3SghkH7bODyw3EMoNTQ2AT3uG7fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761957; c=relaxed/simple;
	bh=STF2JQgQZYn4CiPUmjKmtjyClZhd8AApANiHjcGqA7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIobwtQPqlSZm3NuSowdbF8OJMX8jWg+09a6kBY1y27vKiqNN+OdOMUzP53ZrMHFQZ23+WlzuiQrX49WmoZ+dCCLq4BgRSJqoxi0af2IayELNawwyArwIv/mHg4IQyHzsGt+NZ/0i5xMRvzPm3CjhhmUIgv3ov51kmz1nfSQ75c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X5PSyeBS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X5PSyeBS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F/du0xmIb6jThZo5bRLMdXsJONPyIqYddA2GCtp0F5k=; b=X5PSyeBSbiosqmSokQ9j2X8icK
	M2Eb2lti7bQf5NgLMobefjQnema+UbdXlKQmhN//nQahEj5i189662xmIurTzdyqht3wPMS9afksy
	oPBhINeX5d68Xx7xXQWlB9jKUoYo5m1n21tR2UMXryAyc6f0UNpDdXUFYenzPueTZ9T9Bzt523+rK
	fN4qq/kzkRCvW4t8PjyTQPe7+UpttXw/5Rbtrxck9hmHAJp1LhV7VyN/J6y3qdUaO+TNjmPcMKiLI
	1B7H5xmROYdJeubs1rcOXgYWMTkl+O3pBfZpHE3cxogXGMBmj8ovCV/JlYf2wuYE74tb6x4oYEnKg
	arI5YclA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFql-00000007ckJ-2LSW;
	Wed, 12 Mar 2025 06:45:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/17] common: extend the zoned device checks in _require_dm_target
Date: Wed, 12 Mar 2025 07:44:56 +0100
Message-ID: <20250312064541.664334-5-hch@lst.de>
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

Also check for zoned log and rt devices in _require_dm_target

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/rc b/common/rc
index dcdfa86e43b1..753e86f91a04 100644
--- a/common/rc
+++ b/common/rc
@@ -2501,6 +2501,12 @@ _require_dm_target()
 	case $target in
 	snapshot|thin-pool)
 		_require_non_zoned_device ${SCRATCH_DEV}
+	        if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_RTDEV" ]; then
+			_require_non_zoned_device ${SCRATCH_RTDEV}
+		fi
+	        if [ "$FSTYP" = "xfs" ] && [ -b "$SCRATCH_LOGDEV" ]; then
+			_require_non_zoned_device ${SCRATCH_LOGDEV}
+		fi
 		;;
 	esac
 }
-- 
2.45.2

