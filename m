Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE75B5BA;
	Fri, 12 Jan 2024 05:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JO+sK6q5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k0B9sn9hjq/CgZvN1VkFrZOIPC3AhxaxewALf812BpA=; b=JO+sK6q5MKjRoHsGDXCFT2UlKX
	1T48FuIYtb6LHIx7MSUNjvxUNKF15G4nzLccZdU1J5dHOwJuecNG2hZ2gNCasT0vF8ZOWpwPNbyhD
	21DN1QRBJBQKb9L61cQRzu89EsSUF1QY+nHe98JRelcSef41gxK/eEsqn+0Mb/HI0Q89ms30Gxpz8
	VEXiHOvCjWtLzvTqB5+FCzyKxXhi12on+WKBb0I+M9EE2X7LC3dDRucJfyXsIjEA5mYsr6ybNeKN5
	8d5lvR99lwwxaadGwv1PwvFS0GU0bChf1upJc9dcka2BF03/vVvARj6Fkw7R/+FysJVO/N35V+4f3
	5bxGk5hw==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9mZ-001uje-2T;
	Fri, 12 Jan 2024 05:08:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: check that the mountpoint is actually mounted in _supports_xfs_scrub
Date: Fri, 12 Jan 2024 06:08:30 +0100
Message-Id: <20240112050833.2255899-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112050833.2255899-1-hch@lst.de>
References: <20240112050833.2255899-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a sanity check that the passed in mount point is actually mounted
to guard against actually calling _supports_xfs_scrub before
$SCRATCH_MNT is mounted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/common/xfs b/common/xfs
index f53b33fc5..4e54d75cc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -649,6 +649,9 @@ _supports_xfs_scrub()
 	test "$FSTYP" = "xfs" || return 1
 	test -x "$XFS_SCRUB_PROG" || return 1
 
+	mountpoint $mountpoint >/dev/null || \
+		_fail "$mountpoint is not mounted"
+
 	# Probe for kernel support...
 	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1
 	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
-- 
2.39.2

