Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A96246344
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940356; cv=none; b=iKUR7RcJvAq34cNaNaOpt4OK53vd5Gut5o+mTE7WypNyvthcJkrlwH4TAMuaImTdRL4/tLGltIoU75M9HQFpWYRKEA1WT/W1tfPJWh5drk87OpWaDYV3gUkm2W8QXyjWc+e64Hh7GO5XCryXGKJWjDtLmMVk7mSHO2XlLuajHh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940356; c=relaxed/simple;
	bh=ZBbqlh8g89aCHFF+VU48UG8efs7Nuhs4FO7RWupUF7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6XrL3O2mUhm65LM0Hkw8yAjjlaD9UadAats9OEmG5Oj3kv43D1kZm0zewROgwc97xeJQmQmVpltkZekAsglnpfN/sstFe/+QZcBEpX8ktWg3b8hcgizSW48j7nsiSX3g3WIk7lE0tJDcFxwbTY7HCkxtRTwMeRi9oDF0UTGtIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hiJN1T9Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hiJN1T9Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QTiEYY497h7eG2bQ1BO3AUVcPZsU0jNVJGnCBkqkwvI=; b=hiJN1T9ZGhjtMoWbjLzOaoyKBA
	Z0le7P6nQdTzgdUcjHNzHpZXo5w+O2Ewnh9FEvtR9CWRLj1X+q1zENzkazg7iycGts7H/VREYS32N
	8igfYI/4h9fDdn6V8mNH6JXsDYwTYyPK1xdp4H0Muz5yHjim0rx5hEtl3Nea1mQRXnIx9upMsEBYH
	5AXP9XD9c0HCzJP2sf2qdEUe64KPVNfLJGESAg4i/NtltIonjOPp/COVc9hbBrk2jPEQNaMDo0FTc
	TFquqwQ5CYDo0eb9b5bTnkIVoMB+fLRtYgTdf4aV7DrrDlR24XY+92kWJJdaKt6OStmxDwezJBHRZ
	syRXfj1A==;
Received: from 2a02-8389-2341-5b80-99ee-4ff3-1961-a1ec.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:99ee:4ff3:1961:a1ec] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLR5q-0000000Fhgu-3rbC;
	Wed, 11 Dec 2024 18:05:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] man: document rgextents geom field
Date: Wed, 11 Dec 2024 19:05:37 +0100
Message-ID: <20241211180542.1411428-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211180542.1411428-1-hch@lst.de>
References: <20241211180542.1411428-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Document the new rgextent geom field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index c808ad5b8b91..502054f391e9 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -49,7 +49,8 @@ struct xfs_fsop_geom {
 
 	__u32         sick;
 	__u32         checked;
-	__u64         reserved[17];
+	__u64         rgextents;
+	__u64         reserved[16];
 };
 .fi
 .in
@@ -139,6 +140,9 @@ Please see the section
 .B XFS METADATA HEALTH REPORTING
 for more details.
 .PP
+.I rgextents
+Is the number of RT extents in each rtgroup.
+.PP
 .I reserved
 is set to zero.
 .SH FILESYSTEM FEATURE FLAGS
-- 
2.45.2

