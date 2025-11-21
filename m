Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B592DD61E;
	Fri, 21 Nov 2025 07:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709027; cv=none; b=Nqdqr6yp3mPM+7YvA+emJUffW4827P16xS/5g6TIZd38ChGG0vpHFO/UoWbKqhxgVO2m0TrlkhUhlNO/GXVdiyM6c74QBfVXXCm+xHFJbFwe5UBuuNpSOEOYUtZnoaLnut6dxsMF/cR+UPQKQj4lUOCwtLsYIIY1G0MhUEojhIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709027; c=relaxed/simple;
	bh=liLXuYlI0RHFJP/jtBkXmfvBJMvzj22IpVyjt3qhltc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgfOicZWGoAbRInJDpvGd4GR4XJcg5Xg531EyKlIsZOt/8g4FLA0ko+Gv6gJbzQ3SJCILP6cENo8wVSYBQHBSJNH9LlZes2qdURjc0jlrpUJwNYhLTItshlztQF9x9eSXK2tKh3+lGSaRXJxIOh8E5QTWcurSDRjiwvz5vxQ2ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R1mFkydD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R1mFkydD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yGjvqfMQI2kgwY23vVCk2WTFqpMDet7BnseKaz+lePA=; b=R1mFkydDZPAMrUNN/Cz3oGd+DP
	8VdLWYJEV9G2Uh3QhqH6ZOvFLAAX96NjgG0hd29eQlMcaR4uVDBolnGHiYW89ZpPxVo9B8UHufFTh
	PmYZYTgcISfWbtgjMOb2gkNrb/AZN3yiT8D0P7UAcHGAoWGMAVd3P9XlOozASDurVquacwsxxfFAz
	em9yCaPMl3t1rLGDoVAtoPyC669asi0j5ONTEU+eug7XjAQDaWWLJclJZHHGEXwv3IWzFme9pQ+4U
	NbNfihph7WQtsH8faS6Zm39LyQm6FETtqcFIjWwuIIX00OgEDVevgJydTQbWB/GY4TWzjmTWGSNgW
	W5XF3Fhw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMLHk-00000007xCs-2aGy;
	Fri, 21 Nov 2025 07:10:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] generic/484: force I/O to the data device for XFS
Date: Fri, 21 Nov 2025 08:10:05 +0100
Message-ID: <20251121071013.93927-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251121071013.93927-1-hch@lst.de>
References: <20251121071013.93927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise the error injection to the data device might not work as
expected.  For example in some zoned setups I see the failures in
a slightly different spot than expected without this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/484 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/484 b/tests/generic/484
index ec50735a5b58..0455efcb6000 100755
--- a/tests/generic/484
+++ b/tests/generic/484
@@ -42,6 +42,9 @@ _scratch_mkfs > $seqres.full 2>&1
 _dmerror_init
 _dmerror_mount
 
+# ensure we are on the data device, as dm error inject the error there
+[ "$FSTYP" == "xfs" ] && _xfs_force_bdev data $SCRATCH_MNT
+
 # create file
 testfile=$SCRATCH_MNT/syncfs-reports-errors
 touch $testfile
-- 
2.47.3

