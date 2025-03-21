Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAA31E9B1C;
	Fri, 21 Mar 2025 07:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541719; cv=none; b=RMajcHAbgJbd+E/jEN0/hMajPwDDxPVgj+vXcLA6EJFAoZlatIiFY95stLrlMofa8VOQDKljBstiQRePePlFgknbhuh5PCP5Q81JXtE8wkz0+s1DhqhXinc3QwPZnkCqb6Ef88RxB6FBM7la+Urg+L26vkMQ1Ejojdjh7gySdVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541719; c=relaxed/simple;
	bh=YoTog3JCYumt7NceQT/JXO/VHQbAtKB+Hy4d/WtQL64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ob2q6nMOzAwvf/OPPCbdOXdGtz2gzmpPC7Oe990WzL+knZj+7SYpI8ftp0q0ovPfE34fGgFUftJutmA6KsQnqDJEZV8vKM7yVIzud1l5rA/Q8Z85XokMa/GmZg5zmC7XNkp4JvfmK5EYupHwWEfO6aCnI65U1usDplBiSIUXo9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LklBp96A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LklBp96A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wafHntLpyaWJ78lt1whZXdZjtDmmxOgzVbnXJKeUQbo=; b=LklBp96AOS52g/h0e764D1Oxw9
	IKfA6+QVOq5n7Al6kRQ2nfZJvtLkLwaA9Axo2YgNYvsGymO5aXogxXwNACzvABBduxlIWg1Wsx/5r
	ZVkmtQUmLT6/dDcQpbZhkjEufFONYVVga5wuYuoCgEHXiUoC9sanLV5BTFOl0m14SbmOmcyHjl4w5
	1aKGigZ5+Rfzwx6L1F9hOAGeQ8nKyuHcYkTp2nThcf5g/UqVQFu5i48T8iYVZk6ulwSt05DFtY6qt
	JuBmRAl1/oSeCoL+0tZMMmErOiVmCn3b40+W8UJf8FbCBFSgmqVzXJ9hhTu7UMXZkgYIH+VYnfA2H
	HEQ/7C2w==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhZ-0000000E5By-0NFd;
	Fri, 21 Mar 2025 07:21:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] common: extend the zoned device checks in _require_dm_target
Date: Fri, 21 Mar 2025 08:21:33 +0100
Message-ID: <20250321072145.1675257-5-hch@lst.de>
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

Also check for zoned log and rt devices in _require_dm_target

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/rc b/common/rc
index e51686389a78..7cd8d5ffd2e8 100644
--- a/common/rc
+++ b/common/rc
@@ -2501,6 +2501,12 @@ _require_dm_target()
 	case $target in
 	snapshot|thin-pool)
 		_require_non_zoned_device ${SCRATCH_DEV}
+	        if [ "$FSTYP" = "xfs" ] && [ -n "$SCRATCH_RTDEV" ]; then
+			_require_non_zoned_device ${SCRATCH_RTDEV}
+		fi
+	        if [ "$FSTYP" = "xfs" ] && [ -n "$SCRATCH_LOGDEV" ]; then
+			_require_non_zoned_device ${SCRATCH_LOGDEV}
+		fi
 		;;
 	esac
 }
-- 
2.45.2

