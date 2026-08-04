Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337503502A7;
	Tue,  4 Aug 2026 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847198; cv=none; b=f7nJCq0OYG9AeqKpNzIWZuRryGHjdjiadzukSt98Y9pBQ53gZ2bWh/MDtwnTNlrzaQbSgMPEU4yO69nKFPK5OI/O70h4iMw5f2mhq+wbttZDSxihLBbN0jmnGNA/fhNrMbhkBXpGAOIwYWgJkAn5byQOSvzE8egAxvpCy40dqlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847198; c=relaxed/simple;
	bh=gIyMP8qziDMPI1WkDFO/ZNKeSsyFWsqliQt+kuJVClI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWkRrM9noIdiV+/NvOcUlM2pNjjqPcQDTllzkeI+5XKsX74lWnTJK/6ik1R4ccdKVVamXH/hdebUyWNwGiZst3xdCzHOKjTzsCQRdj9yvOHCBezLmQyxTWhPzzfjRsN8l6NGcpqipoNwTufICe7epWZ7v8NsVVpe/IjTgQzKI4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ImrIYVD4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ImrIYVD4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qq9K0yOs00rawT9v7sg5f9KMXNPMI/X9Nnxwdde3otU=; b=ImrIYVD4qruvTekPIJEXd1c0ea
	dyvgc59BqbxieQheyh8e2zc7HNasexAvkbpoCwoi3Oqj8sfbuWydn98dXZgsEqkGc8mApk0zettzH
	/7vwXgruaaKInduR0oGXpYaaSyIORVolpQquH5m+ySB0mXjO4o59uVE96QvzUkwwWWqXEVE1RSKzG
	q3yYMZUM+lWlUZ7z3wx/vvHRxnkujcX6roeVIzifbSmMrlyauzfozOPe/A/YXQcMXmtsbzfpd3Axl
	0WaBvAq/O0al7BiAEWJblL2XYkynoiaLJPVfF0BqccY5pGcajIx8M7A/mOc6Y+P/vAEOjFRB7q1/p
	Pv8SFl+Q==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEQz-00000001pwN-0Qev;
	Tue, 04 Aug 2026 12:39:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] block: remove bip_should_check
Date: Tue,  4 Aug 2026 05:39:23 -0700
Message-ID: <20260804123928.736596-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804123928.736596-1-hch@lst.de>
References: <20260804123928.736596-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no benefit in using this helper over the simple flags check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity-auto.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index b1c733ecfd2e..43ac9f338183 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -45,10 +45,6 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 }
 
 #define BIP_CHECK_FLAGS (BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
-static bool bip_should_check(struct bio_integrity_payload *bip)
-{
-	return bip->bip_flags & BIP_CHECK_FLAGS;
-}
 
 /**
  * __bio_integrity_endio - Integrity I/O completion function
@@ -66,7 +62,7 @@ bool __bio_integrity_endio(struct bio *bio)
 		container_of(bip, struct bio_integrity_data, bip);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
-	    bip_should_check(bip)) {
+	    (bip->bip_flags & BIP_CHECK_FLAGS)) {
 		INIT_WORK(&bid->work, bio_integrity_verify_fn);
 		queue_work(kintegrityd_wq, &bid->work);
 		return false;
@@ -99,7 +95,7 @@ void bio_integrity_prep(struct bio *bio, unsigned int action)
 		bio_integrity_setup_default(bio);
 
 	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
+	if (bio_data_dir(bio) == WRITE && (bid->bip.bip_flags & BIP_CHECK_FLAGS))
 		bio_integrity_generate(bio);
 	else
 		bid->saved_bio_iter = bio->bi_iter;
-- 
2.53.0

