Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AB02951C8;
	Mon, 12 May 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747055904; cv=none; b=D+WasD0quNhcTPfUJEs1h5+VyJp2KM9lWuUQV3BHPXZwKGphp64Zq1jzBQndTkdPXnPs/GSvyju9Nj9Qg1UaTIr6JRhV5PNGk1dMoW8ktJC0UTAglo4aR83j3wDQXNAZaKZ9YPuyaUeJTp+Jim4VVxOrVEwgU5Fo4pO6y/kj+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747055904; c=relaxed/simple;
	bh=hrDd+FaghFKQjrTMP7l/2FDSWlmL2EARYTif9Ni+kXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FvZvqrK83qIk2E5j8v/vGgsD/zLq2/QOuXwXw8pylGdFWOlc7EiBcUiGvTAPngJGdFxnRWMMSTZFT4ZlDFCKbWbXlzIpyTqSPu7EMgC2xNF+/X2DsGLQN8KKBml8qPMFH84TBRUTgsJWvrsuqrgNq/IsExHFKtfZa+mZ5jDH5Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2W5JFYne; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2W5JFYne"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=afPfu5pxd89GFqzpFqaRr35zkbMyJaDiVW+sTSEj4gQ=; b=2W5JFYneybvNOeGgBn+1y5C1X/
	FT6XH8CbC4UIX0v6NBjXSV4x/vPBEfkcDEc2Hc0StQBn4uv4FLzDzzsfoBU8MkwLNPfP+pcQmI7Rn
	mCYzct+EEhOYtM0be4XsFj1QMmg/2RbshgQ6i/2D3kMSuS9Z7WIFkrqkqyjCn7BDTbxYT7rxuqdNj
	PfgcyYBiJ8v3BmiYLV4UInAXb8+tsQ6wrFsk1UOHzeXDOJes4p1bj43o0MlKKQycfQU/ctdmmvy7V
	FBjkmtdCnlgsWWhnUdks+Pq49ORMyyGJLadAxEe8o8SBR+oAyNaN6TqpeD/UdMFU0A8W/WJs7E1mK
	FaYHXtVw==;
Received: from 2a02-8389-2341-5b80-6dec-1ead-dc3c-1d26.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:6dec:1ead:dc3c:1d26] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uET2z-00000009Vm9-3aTZ;
	Mon, 12 May 2025 13:18:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] common: skip zoned devices in _require_populate_commands
Date: Mon, 12 May 2025 15:18:19 +0200
Message-ID: <20250512131819.629435-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

mdrestore doesn't work on zoned device, so skip tests using to
pre-populate a file system image.

This was previously papered over by requiring fallocate, which got
removed in commit eff1baf42a79 ("common/populate: drop fallocate
mode 0 requirement").

Note that the populate helpers for placement on the data device anyway,
so they never exercised the rt device.  Maybe we should skip them for
all rt device setups and not just zoned ones to save some execution
time?

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/populate | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/populate b/common/populate
index 50dc75d35259..6190eac7ad83 100644
--- a/common/populate
+++ b/common/populate
@@ -20,6 +20,10 @@ _require_populate_commands() {
 		_require_command "$XFS_DB_PROG" "xfs_db"
 		_require_command "$WIPEFS_PROG" "wipefs"
 		_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
+
+		# mdrestore can't restore to zoned devices
+		_require_non_zoned_device $SCRATCH_DEV
+		_require_non_zoned_device $SCRATCH_RTDEV
 		;;
 	ext*)
 		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
-- 
2.47.2

