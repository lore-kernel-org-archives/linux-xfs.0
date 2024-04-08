Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AED74BE5;
	Mon,  8 Apr 2024 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583194; cv=none; b=m1edTyF1nkaKL+x6oWn+dP3j6JSQG7oF8s78K0gIIFgV+jSpIC87eFG0lCg/hAPeNN6tAXn1EsLvudVZpsz10223Tx8/+Km/OUJz1kXlb8aCUHL3lsGdA1tfh4R+iVWNxJDcTDbhhhU6+KXLTNVw1bTU3TzJQjvO4B/RKMUPdq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583194; c=relaxed/simple;
	bh=eABoQ/iuPiwkHwtT/kaHegmUsqhj+sdOzEw8ebJW0p4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=txjDzwKreZwkZ0qdLpWBn1skukyrK/DsAkR1JqKe6nrWiuCY8N9n5KGyh+g8dGN2KQwvQmGMVMAUmaPBD69bgCzyf4fbUFZqhtM3FLH3GL4RN0Hu4+t1NHLLn8UKp8kDcymP+N/Ktfrl48hucs31CY2NConIwLbrtmBptSlezAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nyQIz9M4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nyQIz9M4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=taRk7UNW+ObDNsLEcsbi21P98HHHmZOnTii7q75osHo=; b=nyQIz9M4HQbe8oC9YNPJYXxci5
	f0yI8CWHqdr4oX1ijJdcAEIdnfZ5bqUofWwR1yvBRW8zkq2juAgMS+hJaib4QOEkq7y7dHqkRpXC0
	JEqCuDPyZ+WGCugfSnD1YikViBZfU3ngcTHg7qyromchy5E6WMwXRBkJtm7FYQMGG3roUXX8rUkuq
	8jSSqTfklWIEcid9wGZbhE09nIcL8s8oyuz3SmwRUNGW7t5ELEpgyN/NBDyoi+580gQVqIYMEdjwh
	4vSyH+Nvj6pTqtvWLnbBqktP33IMjtKXH3u3sndHKReaJ+WH8OmywOXqo/V7mBoi3mQMhWIDuvAKm
	+vPlON9Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp7V-0000000FjTi-1lwI;
	Mon, 08 Apr 2024 13:33:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 5/6] xfs/522: use reflink instead of crc as test feature
Date: Mon,  8 Apr 2024 15:32:42 +0200
Message-Id: <20240408133243.694134-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408133243.694134-1-hch@lst.de>
References: <20240408133243.694134-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace crc as the main test feature with reflink so that this test
do not require v4 file system support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/522 | 58 +++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/tests/xfs/522 b/tests/xfs/522
index 2475d5844..05251b0e2 100755
--- a/tests/xfs/522
+++ b/tests/xfs/522
@@ -46,58 +46,58 @@ test_mkfs_config() {
 echo Simplest config file
 cat > $def_cfgfile << ENDL
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config $def_cfgfile
 
 echo Piped-in config file
 test_mkfs_config << ENDL
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc = 1
+reflink = 1
 ENDL
 
 echo Full line comment
 test_mkfs_config << ENDL
 # This is a full line comment.
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
  # This is a full line comment.
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
 #This is a full line comment.
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 
 echo End of line comment
 test_mkfs_config << ENDL
 [metadata]
-crc = 0 ; This is an eol comment.
+reflink = 0 ; This is an eol comment.
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc = 0 ;This is an eol comment.
+reflink = 0 ;This is an eol comment.
 ENDL
 
 echo Multiple directives
 test_mkfs_config << ENDL
 [metadata]
-crc = 0
+reflink = 0
 finobt = 0
 ENDL
 
 echo Multiple sections
 test_mkfs_config << ENDL
 [metadata]
-crc = 0
+reflink = 0
 
 [inode]
 sparse = 0
@@ -111,92 +111,92 @@ ENDL
 echo Space around the section name
 test_mkfs_config << ENDL
  [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
 [metadata] 
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
  [metadata] 
-crc = 0
+reflink = 0
 ENDL
 
 echo Single space around the key/value directive
 test_mkfs_config << ENDL
 [metadata]
- crc=0
+ reflink=0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc =0
+reflink =0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc= 0
+reflink= 0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc=0 
+reflink=0 
 ENDL
 
 echo Two spaces around the key/value directive
 test_mkfs_config << ENDL
 [metadata]
- crc =0
+ reflink =0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
- crc= 0
+ reflink= 0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
- crc=0 
+ reflink=0 
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc = 0
+reflink = 0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc =0 
+reflink =0 
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc= 0 
+reflink= 0 
 ENDL
 
 echo Three spaces around the key/value directive
 test_mkfs_config << ENDL
 [metadata]
- crc = 0
+ reflink = 0
 ENDL
 test_mkfs_config << ENDL
 [metadata]
- crc= 0 
+ reflink= 0 
 ENDL
 test_mkfs_config << ENDL
 [metadata]
-crc = 0 
+reflink = 0 
 ENDL
 
 echo Four spaces around the key/value directive
 test_mkfs_config << ENDL
 [metadata]
- crc = 0 
+ reflink = 0 
 ENDL
 
 echo Arbitrary spaces and tabs
 test_mkfs_config << ENDL
 [metadata]
-	  crc 	  	=   	  	 0	  	 	  
+	  reflink 	  	=   	  	 0	  	 	  
 ENDL
 
 echo ambiguous comment/section names
 test_mkfs_config << ENDL
 [metadata]
 #[data]
-crc = 0
+reflink = 0
 ENDL
 
 echo ambiguous comment/variable names
-- 
2.39.2

