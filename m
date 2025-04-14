Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E802CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609105; cv=none; b=r4lNr28Oko0VDHAZRFT55rbohhkNEPwxIoJcddXsorLv5AwPf5NGjMBwtjzeQbT2BbbyluABBTwLFFhfFhsolTek3eoLBcPMK4c1UdckgYueJmCeHBHQx3O9M5XsF5I0JXfM7J0CAPRlAYmmnXU8UKE37tNaWKYCX7GiamINsuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609105; c=relaxed/simple;
	bh=4hLZtomDgAKWFBX08b4RIFn42fNMbuXN+1gxzWMfutA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smH5gnJIxXhdDg5fMx1d8mXGXDS5ImFIrijC/sFQOVTR6mBMuMW9INC80xXesty82kIzqni49Vvkb+dw4KmuqeTtNhyPLSQ4kdni0xE8wkCrwakmt8oZcLMCui/XjPYaFIPghbc5+N4ERGpH2KXVLHMVBzYCZxeZ16zyBPTQ86w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IHKtA1RR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IHKtA1RR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SXkZov5UWJ0j2IhmWhKK7OnOw4NwSwFBYp97YF8Q1BA=; b=IHKtA1RRWIMORqftfCy+CmcJJe
	6F369TyqkmrTEwKGRZuW54pUEd/a65du1LbQIYc7AUTKVAEAGR8scxrMdsPb1FCY7KmXSsXr8AWJx
	BGyNWfyRDqdncLj26TEeSgYIbO0LTXJ6uijKIxQkcy8kqD9tLeMc/0tbjiM9mBJ10uj14En0s+Btt
	rdk7i55wl+a12oV2Yvk/e9HBUYMmyiDXDkOXGAkcz5V9xCoWWfClJuNgYc5vcWS3VK7Y6z3rV2nGH
	sLNDN/N+S2y7E+YdLdolbFXA2hceggATjUKZKtl8iYakkYQUWB4VMUIKqLU0w9e6werds3Hm98mKM
	Ma7ybKiw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWV-00000000iTN-3z9p;
	Mon, 14 Apr 2025 05:38:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 40/43] xfs_spaceman: handle internal RT devices
Date: Mon, 14 Apr 2025 07:36:23 +0200
Message-ID: <20250414053629.360672-41-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Handle the synthetic fmr_device values for fsmap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 spaceman/freesp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index dfbec52a7160..9ad321c4843f 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -140,12 +140,19 @@ scan_ag(
 	if (agno != NULLAGNUMBER) {
 		l->fmr_physical = cvt_agbno_to_b(xfd, agno, 0);
 		h->fmr_physical = cvt_agbno_to_b(xfd, agno + 1, 0);
-		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
+		if (file->xfd.fsgeom.rtstart)
+			l->fmr_device = XFS_DEV_DATA;
+		else
+			l->fmr_device = file->fs_path.fs_datadev;
 	} else {
 		l->fmr_physical = 0;
 		h->fmr_physical = ULLONG_MAX;
-		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
+		if (file->xfd.fsgeom.rtstart)
+			l->fmr_device = XFS_DEV_RT;
+		else
+			l->fmr_device = file->fs_path.fs_rtdev;
 	}
+		h->fmr_device = l->fmr_device;
 	h->fmr_owner = ULLONG_MAX;
 	h->fmr_flags = UINT_MAX;
 	h->fmr_offset = ULLONG_MAX;
-- 
2.47.2

