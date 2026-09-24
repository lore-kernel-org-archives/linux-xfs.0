Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6010471CE7;
	Thu, 24 Sep 2026 10:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244574; cv=none; b=WiPYYzT7XH2e27B7I6SJez0PPv+T6y2hLA3Iw4SdVCDR1qwshRsx+DGiXUwj6gUx7kwvv6+vKufVvlp4jq8AT2hxH2clHvcKpa7GxAQx57szZFjZzdic8P9gV69VTPZwbFMW8y+vQRRgiaRgJvd85quoV8IlGaWqjMQdO4hNnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244574; c=relaxed/simple;
	bh=kFyQUx2SARWCyPEZRoHcBrvHoKsH63Bbm6ujtSTTsbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2L11fhHXnrM17X4dUJ3z8JmDzomqAXQdIBGoXfViglxQHlh9H0h96DwsmfuiAcoPKnpJw5zGGtiZuOOWz8SaKKh1BAsy1rH32u8nF8pQ4k3CYe4vExA/phfkVJxbRedDQ6b1HTyWbrNCBBspvZ0wNpuqB7L58khN2i0sewy2Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xPENOg4Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xPENOg4Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RGbg0xyd/CEEo03Vvch2qab+6E5VSAEiM5ihyWhRaPk=; b=xPENOg4QenSC/foKyurtZZbZCx
	DUk/ZF66YN3zGiiYlVIpm0jsH01u0Xtq+n8MnpiKNhEWM57HQ6DZAEqmpooFXzjGcFCuipneuvj5g
	HM6f9/NWE2hjtbaCN6QblN9ndiRgfEg6eiebf1O+wf6ubp15MO4JbU0Zj1nBQ+DwpDCFlfGAfBthj
	wjII0HMj+FqzUnFy81PASkt5NJKG+xTFNQc0yahuxCSQuLE85Rxcyfk5aAIKw43kWcjUvCosIRnQI
	QyFyI0Q6ZDk7hgXqBwOXxBZQ8dPRyL2RnedtTs8Vkz3hh/EYrm1Irs1KB1Pd7qnfewV1PVnFFkR30
	O19W4IYg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOG-0000000Afna-13Rr;
	Thu, 24 Sep 2026 10:09:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] xfs: add a _require_xfs_data_csum helper
Date: Thu, 24 Sep 2026 12:07:46 +0200
Message-ID: <20260924100855.2734089-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper to check if a given mountpoint supports (RT) data checksums
on XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common/xfs b/common/xfs
index 8254e48603af..e9f6877c98cd 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2448,3 +2448,16 @@ _require_xfs_healer()
 
 	_scratch_mkfs_xfs_supported "$arg" concurrency=0
 }
+
+# require (RT) data checksum support on the passed mountpoint
+_require_xfs_data_csum()
+{
+	mnt=$1
+
+	csumval=$($XFS_IO_PROG -c 'statfs -g' $mnt | \
+		grep "geom.rtcsum_type" | awk '{print $3}')
+	echo "csumval: $csumval" >> $seqres.full
+	if [ -e "$csumval" -o "$csumval" -eq "0" ]; then
+		_notrun "requires XFS data checsums"
+	fi
+}
-- 
2.53.0

