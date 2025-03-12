Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512891E25EF;
	Wed, 12 Mar 2025 06:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761965; cv=none; b=pPiQquAvgeFwzPt33hkEkK4+D+VS86AjyVFPItHdtCAxQQ/OEKdWmfbB8AmZPF+7KIYdrLt44nZlX10B5g9CAWvZvHBy8aG34JtzLmZ2oJz7BxUCkHFhyrZ/5spyl4i2Homugn4GBeohQyaWB947oZWuDd/BqDcO/rPasGTtayQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761965; c=relaxed/simple;
	bh=CJw3mEUDeN05s9GTK5cAyr7DBEN8k3JNUYcnQkxqs2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6lx+GhZxjmY8H4PHi54gbkeXkq2RNPB52Adwnjsd0eeK0unTKX3nchJunT/MFDg3vUzHlCVTag1qoM7gjxFaJF1qErVXxZ/xpJwdaorhkS4k0bQini1u4VqatdvwFv+f9McbxvA19mAEZzXZyOzVcsgBi6uhlN9/NwkiQKCBPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SFCA0y4D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SFCA0y4D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NoBGIt4bvnk2wsJvv02sGo7LMNk7ALyyQmU6RV7T2Gc=; b=SFCA0y4Dm4Yj1IgUMKl5SKcFmM
	ThOLbR6RcJrauZP25xUGWyofgz6x/0+/0eWWMF6xeXaCogMD/NmEsxzZHYFMw420JSKklxXlR4Rhf
	AxEnd8n+o4nDe6+o2BokQZgRvhgvX0s+Mmx5ayjLMu8WdPZIQHyPN/V461ubOvZqVbcgWpBCH0ch1
	XWpVrRUco0QFc59oli57dfsl/USEnHXl48yjhbeu5We5V6lWCe19X/K+v/Iy+RtFHIxOdel6Trxib
	0XydTIDcvQkAZzzzbsLRxrMhkNME4fxUBfHAUFTYG8KTFHDPqhGztt7SI+0ImJ575vOFSJzMT99bF
	ukQKQ8dA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqt-00000007cnr-2bwv;
	Wed, 12 Mar 2025 06:46:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/17] common: support internal RT devices in scratch_mkfs_sized
Date: Wed, 12 Mar 2025 07:44:59 +0100
Message-ID: <20250312064541.664334-8-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index 00a315db0fe7..5e56d90e5931 100644
--- a/common/rc
+++ b/common/rc
@@ -1268,6 +1268,7 @@ _try_scratch_mkfs_sized()
 	case $FSTYP in
 	xfs)
 		local rt_ops
+		local zone_type=`_zone_type $SCRATCH_DEV`
 
 		if [ -b "$SCRATCH_RTDEV" ]; then
 			local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
@@ -1275,6 +1276,12 @@ _try_scratch_mkfs_sized()
 				_notrun "Scratch rt device too small"
 			fi
 			rt_ops="-r size=$fssize"
+		elif [ "${zone_type}" != "none" ] ||
+		     [[ $MKFS_OPTIONS =~ "zoned=1" ]]; then
+			# Maybe also add back the size check, but it'll require
+			# somewhat complicated arithmetics for the size of the
+			# conventional zones
+			rt_ops="-r size=$fssize"
 		fi
 
 		# don't override MKFS_OPTIONS that set a block size.
-- 
2.45.2

