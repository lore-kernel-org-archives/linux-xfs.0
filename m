Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DE4430CCE
	for <linux-xfs@vger.kernel.org>; Fri,  7 Aug 2026 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100347; cv=none; b=kn1w/812z7yyR2HHZjF2sYJhhga7nRd7wBb94ZY9zAUPjgiuhS3gjvpQhnxWTxCukhA324dAoajdZIkPYH8TWTltUtUGfNxhmZV8VAWVtm6YXawgP2X9m3bQ/JtfR1ng0Xl0j+nv0G8/SCSQuGXTK5njKOpbuSZFenm1UmSNAAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100347; c=relaxed/simple;
	bh=wsTCp8aKsOqPTwQd/q0xBx1KeJVOvouK9tlOINNOoug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Cn66zjP6BeEk+ADpFHe3JrQTVsOZyLVcBi+ic1z2399y6XH9CVgW2+L07v6/R8kCMhcO5wo8d7NLsUJ2u6ogXkk4be7F4xwJ/9thoJMLUNuVRdKLZQ5pyuVjt6SBujb6mi3RHkkkaPZWBjCWeL6PoFLoXQaA2qqYz+V+YY5C5QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Ou8MS/S7; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Ou8MS/S7"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6779W3AP2094273
	for <linux-xfs@vger.kernel.org>; Fri, 7 Aug 2026 06:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=sjVv6tLypOyR03i40yMmm5pwH/
	cWi3n2yZ64en1IsCk=; b=Ou8MS/S7RwRxEbp7nYaDxTGHpf8Hja9c3sahusYBzX
	rHForpv8UI2Bp949ySPCMxS//CsE7KtNl0TjFEc3MycEKQtyE/PEn0JjULZEtRDo
	6OieRie1/9/yi72nkLR5Alc60wXXS3/tPmYxZQEQo3KE2/HLUoLK9VWYzpLkfsya
	cwEMg4s3/MVXDOTyoQcwGXI0GKqnIZAEtxhAFhH/tsQGFzi3c+oJWpIUUDuYCf+h
	Al57C+9dR9sYjhP3H1s8J1V0p17EtJGQ+c9+BLyiRnGC2kaOjhQ86OSU77pBVQGB
	rAKUpqBsvZQDEZD3ouIt1iZ2CvXsnkODCWEOattpe2Xg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fvxbucgn9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Fri, 07 Aug 2026 06:59:03 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9077b4c35c5so55850976d6.2
        for <linux-xfs@vger.kernel.org>; Fri, 07 Aug 2026 03:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786100343; x=1786705143;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sjVv6tLypOyR03i40yMmm5pwH/cWi3n2yZ64en1IsCk=;
        b=WQxAoNoUb20qWitHXYzlLYXFxPbjiXjKiSnTtjAZMvb0/n6FKpVykL760cYR9LSM0q
         8x+pwBkoIh6EFxsUBOCaPfs+bu4snNmUEe4joLlW+8PH5BnfXRH71E2//wcZD5UOwL4q
         B5iE9HdetPpRRQ4t9+a0wHptnxXgBtNHd8oBSEDcKcLnGwsifc1YQQjytx48nTFGdL4a
         l916tP+MGCaGtML+olYlt0q+9lBb4m0LX27IAFtekq5aEEeuAA3MfNOxWcn1RFYcIo4W
         7YRecblt5nqIZO/gT0Mbkxaq9ff0Kx4+Mh5gcwvRUi1fy89HRFFfWk+X/+MBUz1cCHns
         5o7Q==
X-Gm-Message-State: AOJu0Ywij0HTZD/FyCCDOgZ899HvuWPCQdzDUFaXiFAKlZvfvRspOz5E
	ww9AegJJHUatJN3hujfAprfwUfWTtFY/VAB7NUptsJPuAjVK7kY+SC/cAYUTtCjF16ZPN1gAoM/
	FbQNWFEHrfjmlHQl4h7NYTJN3E1wXPpm8/VyMUB89pZ5zU5/Fs7NNJ1vo/g==
X-Gm-Gg: AR+sD123xv58TE/Q394+etp83ILlswuMKmWGil6psx2rCe2m7bqOQkOJmhql1fTA6u+
	oX9sxlnwDfAs5U3I5aoW16DWZPS3iribIUqohCB1oEkjHFv6+YmnEAbYt6xyEdxJcW1DB4QPtNm
	siIadXft5goBRPoUtUUVjChuO55wJa1QNegXQz1FcEORa1pIqFwJqB95wQxWzvz0JIdOLJ/0NXR
	Lzp4EY5byXhbaFrt6+lD77BmlMX3WLDINPYeaz5O2v6vQG5GiD+q3K8TrPE3zqIs0r7dibicNoN
	xRrv6I04J2i5k0w4cqsVo6OIcZKD8vsSOf/LUzwDDyAwOpp1mPmjKmRQ8kzIdFW3NoQvJrua4gd
	+SPpGdhk=
X-Received: by 2002:ac8:5d4b:0:b0:51c:849b:86b with SMTP id d75a77b69052e-52ce620024cmr207725011cf.43.1786100343226;
        Fri, 07 Aug 2026 03:59:03 -0700 (PDT)
X-Received: by 2002:ac8:5d4b:0:b0:51c:849b:86b with SMTP id d75a77b69052e-52ce620024cmr207724781cf.43.1786100342813;
        Fri, 07 Aug 2026 03:59:02 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.65.65])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995e9e702dsm37988925e9.3.2026.08.07.03.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 03:59:01 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 07 Aug 2026 06:58:51 -0400
Subject: [PATCH] xfs: remove kmem_to_page()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kmem_to_page-removal-v1-1-7365a789acab@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAGq6dWoC/yXMUQqDMBCE4avIPjew+mC1VylF4jrVtY2RRKUg3
 r1pffwY5t8pIigi3bKdAjaN6qeE/JKRDHbqYbRLpoKLkiu+mpeDaxbfzDZtAc5v9m26HMIithZ
 mStc54Kmff/b+OB3XdoQsvxYdxxel0foDeAAAAA==
X-Change-ID: 20260807-kmem_to_page-removal-d1ec0cca9c00
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786100341; l=1084;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wsTCp8aKsOqPTwQd/q0xBx1KeJVOvouK9tlOINNOoug=;
 b=0xXtFuKpfrCPN/SWcS8NcTTABdVLr1oA6AmhHp1lhGz5yWazKrVNke6utev/a+gZ6Ctl8dr+a
 wBlRlCDXaOnAhDmZorRrgHAKby+rIJcn5uau5Q1Ep+gKdP1qcOYBkPa
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Wp8b99fv c=1 sm=1 tr=0 ts=6a75ba77 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=DusBeXBDAOkHeRiqZZRkKg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=-HnKlEq7N0PXuqhKTCkA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfXzm8uG86kSTTg
 t8WoUXfYyf/DhOgjrNbGwWbCCnzfnk0wUsI0Akh3PxOO55etAtF1pxJMh1YsztQ2kg99c7Xh/En
 RO8Z+VpTsOxrsX4Cbh2p4+6Y43dcVbBEibhIR5YnmoKFqxrKGx/CzgsyUqTEwEAIksNSvZfbgaX
 ica62+B9eDXnbk03q0draV4lDq/leFHxfz6VWOYrZ0gquneNsEnC9T7n6okmXwkWuROYl2mHvHu
 AZ3GVPcaURBbqN+UdEc3rChnEadlWzQ3lcGwKStuGYlUdePF+J7Do9+D6BVy5EARIipNZizGQZ7
 MOhtUCaU6yBxavYwdQg3snWYRzQ205Tn2teZ5S0z8eLmKF3XNxslORlVqoEQysIkuELqSSNFrYg
 1J4TbEVZMT16p/QXGoWRTXiK9OezA2RhhbpLEkz4EamDjKoRApgl/LKT6DhLkUmAp5bYtj+Gusk
 tOPZ2+VIBNx00m3MgWw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfXz1bch3Dw42DV
 YkXcVNydXeoxS1d7Z1btKhE7njbu7BStEW4Fi4gH9UL+ml4eYrR0n0H0D0mfu6UWllwng7pj72f
 y34a7DDf+SPTRazkQfLvaTLqtWbDT/o9ibhj/UQ7/Mp2xB9kjecG
X-Proofpoint-ORIG-GUID: _Wrn3y_S9Dd6ofBFbrIFSaYlk0bmTrKl
X-Proofpoint-GUID: _Wrn3y_S9Dd6ofBFbrIFSaYlk0bmTrKl
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0
 lowpriorityscore=10 adultscore=0 impostorscore=10 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070084

kmem_to_page() has been unused since commit 5ced480d4886 ("xfs: simplify
building the bio in xlog_write_iclog"), so remove it. This also removes
the last instance of 'struct page' in fs/xfs/.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/xfs/xfs_platform.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 59a33c60e0ca..5d542e95fe44 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -289,15 +289,4 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 # define PTR_FMT "%p"
 #endif
 
-/*
- * Helper for IO routines to grab backing pages from allocated kernel memory.
- */
-static inline struct page *
-kmem_to_page(void *addr)
-{
-	if (is_vmalloc_addr(addr))
-		return vmalloc_to_page(addr);
-	return virt_to_page(addr);
-}
-
 #endif /* _XFS_PLATFORM_H */

---
base-commit: 3708f6188677fa7d3eb88ac80b03a56ef415d9bc
change-id: 20260807-kmem_to_page-removal-d1ec0cca9c00

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>

