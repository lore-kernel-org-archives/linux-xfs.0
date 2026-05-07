Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F146DCE1;
	Thu,  7 May 2026 05:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130595; cv=none; b=lKAa9c8DNklSKjtHuanDYWmzqBjWubdyeE69G0zpwCCOvZbIzT+l67mh8IU7hvoaYlfWY4rQLfzH4fiSLWtWPMGS0PIx5ZQpSkBLRvQOBfDrfU/H1dBTjGgTAgfE4gaQgEqEQW0/mBDMxi1obUSUArUdN2CSWKAyp252uQ1t5Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130595; c=relaxed/simple;
	bh=60RZ8CDA9nJq53Bgjv5eQn0K5+iNXyyqTfwdr3qtc+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrqTgBsyEEo2H/Pn0Rb2Gb71VzmPpodjF2SCHmGoDbsGaHQAhYMuSThoL1wV7iXLjBLLpSh6DG8eJawnSccyXAUL7Z9HJ/FS+Kft0+kyjvRvdYaY4OzL+J1UOgcc2QDP+lukX7UgDLxwz9NNdLiz+FTX3V66/bb9EB6fnvSFVl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nszfFJBL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nszfFJBL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=cWi8oeCR0E3IVT4+bFt5o7KazDbGSRMxa8sp1Ulq6Wg=; b=nszfFJBLM/f+KzUYw4TOiZTffo
	z6LCFhcDGQdASUYkslt+YQnwQw66jfSF68Z4gxDrbfCexUaWzu0DABoxj7yS+/EYWk7OZ7mr8nWPs
	YE1tctRwQeQZleN24Sgb63Q4CCG5e+4V+t/QE/L1wag5MXUmDA/2hJTiAqiBjrN5jyYKlJ9Mp2MjY
	IsRwWXhT/XKiAQjSBY1/B0edijM7sR2sbivdGSyYxAtbv0PybArsnPbGJn3P7BDYDSo8W02lI9IcQ
	XWwLe/7exiNMe3DKDbg4+oHZ2h+N84TYq7EHXvkk6l7rhzjU6kCyquO7EdeJpFkDRMyaFYcX4hQKH
	Q/atJjcg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKqzg-00000002mZY-3EDP;
	Thu, 07 May 2026 05:09:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/216: pass -t xfs to _mount
Date: Thu,  7 May 2026 07:09:49 +0200
Message-ID: <20260507050950.1300316-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this, mount probes different file system type, which ended up
exposing kernel bugs in blocksize > PAGE_SIZE bugs in tons of
legacy file systems.  Bypass that by forcing XFS and making the
mount a little more efficient.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/216 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/216 b/tests/xfs/216
index 091c11d08642..2096dd9b53d9 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -57,7 +57,7 @@ _do_mkfs()
 		echo -n "fssize=${i}g "
 		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
 			-d size=${i}g $loop_mkfs_opts $loop_dev |grep log
-		_mount $loop_dev $LOOP_MNT
+		_mount -t xfs $loop_dev $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
 		_unmount $LOOP_MNT > /dev/null 2>&1
 	done
-- 
2.53.0

