Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF33DDDA9
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774467797; cv=none; b=dYD7YXtai20uWkAUebTr1uZwpU7uTQG2O07DzuALgzv6vrnUP8dreGnLDfjM4upkM3bqkeRF5Ij1Wh5ErsrM651UKeUIHH8VTcWiY7SfCZGlwbPX+JFMPaacY6mOczeklPg0KG9xpbxU/jK224i9mDimz3prRKP705FDU1Kp7Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774467797; c=relaxed/simple;
	bh=7zwsmyUip3CAkS6JVcgPiuvcXkqOuFIklXcl4CKLS7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kCKx3nBhh4rACzL7/kAHzu6OMKyKP+LiyC7TEGM/k2ctyQL0wIh04L8YtUx1EXddikUhytRFdsCxV3kya980CgEyrhqa6i9k4gR2V/BYC4Ix9jrVoywtx3gLBuub4w6Q2Sc8ReF+Hr9eHpWf2I23s9wmwgFTede4t86ghmINfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Au7sydVY; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Au7sydVY"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PJSgr83356014
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 15:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7qfY
	4Yey2B/8xRD7jk2HVXbmFsGdrb8gwFavo/knRp8=; b=Au7sydVYHJxfvhcGusjW
	FEbpn9GGkRrzgLrTHhOCMbptHSX/ALA6C88pzf3RJSXe3GRiSgydzJVOXWnM9VaY
	BNdVPii2y6i0oYq7y+9TO5mMxTct2pKIusyD79XPROlhYQeMKRNs87jKHrvyI0uw
	Wn8noKHIq4KB814b8F0P5FciGNk7ALGmCIX5JsU1y5+3ZOptL+6ahq1z3ywm2k1x
	MeMBSMQF62gu6jXDiXJrd/WT/tL/m6ciFKIBfAIwvo+/WigpyDrml510h3ho9m//
	h3PTLxppFUGY/IZ/ripHeVxqmM3JNsTeqGDbAUh4GSukZ/h2dod+qzk1+uc+2Tnd
	Ag==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d4f6vc4wj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 15:30:42 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5093b92f327so13564271cf.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 12:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467042; x=1775071842;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7qfY4Yey2B/8xRD7jk2HVXbmFsGdrb8gwFavo/knRp8=;
        b=newIeOVPOkiZp7J6gtnK5K+dlNfwh1DNAmltsUxK4Ev7QTsHGIcdOkFETKsQ4XHeEb
         mWRFsmF1b6TGfnrNMYgGkcC/Y4HqmdwPX5B6xUcRKWueMO5Jyot5HcMzntmA3lDowpBW
         sVcUROyC5LPKyce9WZPbozUndyw+YgVL6tywmfqBGYX3GT5gSXrlInzLMaG/yFr/8bZq
         lUN+DAhErSk6M5wsUmwUw6tj4B2oZcFkb0mztHb1KW+jgOmZlhGmBDiODGqFvrt86l3M
         6Sis99kQ9FZaRxP+u6k4ahO5E49vkx2j/GoeMgGWJX6WtYDOP1I/U/3EDErED98jCsP8
         glXA==
X-Forwarded-Encrypted: i=1; AJvYcCVXu1KIBcIVv7ZWV+Kbgk/OpMAHSdWPVN1Ug/L27NhShl4zfiqIU7/YRAVPic/ZV1Jum3uAaLXHTdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbaA5ut06E+36ENmd7D28EkmJDm3aF2o1YaE0VMRjRe+TBnQ/3
	G+kcEo5V9ehWFd/+uvmH7SfJRJnF+JYUITlTWjMH+zBZR8TOX4QwW0lJ88p+rZbsXI44xgBFTL0
	jKxIX9iklkVy21D6vhSZnL51yM5l9hK0zNMdptzC3F8UdG1rCRpXv9gI8ug==
X-Gm-Gg: ATEYQzwbV37WFnrNsBoRoZPBV6ZHpJMJXdQJSRzMfpjTPmbnPZD0d9rLE3sOtwn2YjB
	fHH1826I8D18X4PLGPS0OPq3k4GL/qbq/T8YRU012wpXVT3K7rJKC43S4Qheco7a+JuS7SAan/z
	XVMtwgk9dxf+/ErteEw6iaWSugHbOSCsrcR9zQ0IMFd3XFqILZLksnEISr4x8Wy0BM1Omw8TRq1
	u/4RUcE/2atSr6/rLCGFSa24Wq5bwhvSUC2lHeJe9GLHgSWlom+bBkIxi0t2N74wobyM0KEEUGJ
	BWc2j/BOOkt9CvcCWVANx6e8VuJcTQKcBtmrJ/6vIes5YCDKpjX3f+TZOdEaDRoEnIW9694eiCN
	DpiaQcVkcsW4mHe58IvazjplhUPLGYFcDxkYZXQ==
X-Received: by 2002:a05:622a:9d7:10b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-50b80ce31d4mr55571931cf.18.1774467041728;
        Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
X-Received: by 2002:a05:622a:9d7:10b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-50b80ce31d4mr55571251cf.18.1774467041146;
        Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Mar 2026 14:43:01 -0400
Subject: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
In-Reply-To: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=1665;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7zwsmyUip3CAkS6JVcgPiuvcXkqOuFIklXcl4CKLS7s=;
 b=L4CWzIK6kHXuFczj/fPjz2aWyUnS1OpJUL3M+esbeR43gMhMyjhAVsUMhpLPiY2zQSiPsjHza
 J5C73e08cUYBjjsRFhFa/ta9SjUn5dInI/J4XLjlsu/GNzv1JM0+xWE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=MohfKmae c=1 sm=1 tr=0 ts=69c437e2 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=wJ0dTj9p17mGQU10CegA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: qrevnguphKjvmAEbHNNPNrkYklObTOk_
X-Proofpoint-GUID: qrevnguphKjvmAEbHNNPNrkYklObTOk_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfX7e/ViAObNqOg
 7pLNRlQANBUVPsj6ouSmsbo4luZVPvJAMSTp4LFTpgpKt3O3h6kHtwppoRLBR9WP+/3zPDs68Ol
 elmyIdQeFMPfVrk2Sigs5DD7cMlgl2EgbRL+0M41OTHVyQRjJg6GfWk3gwOIjCDYQfNyE1jTY6U
 ueGxqhJOc/oX65MFqiGaJjfRi/AFV2tu2MqcSPWGWvM+u5toBkKE+fcVWk3AnZ+XhwAE5tWKNBA
 8ntzCsSGX1V428ERynwxfjaVnhgBF0Z9fMKslK471NIgPLiSVXH9EJGYLXTFk/d4palXc1dn/LI
 ZltD3CxxSS/pqTZyjHfXaos2btTjIdw7jfs3y3dHtq9W1ViEjPwuE2uZN3yYf6kObhvmAJiqucd
 RWjVCean56KsnuzbwXoHMG55afxmlN1utSuGxKsU8tbOd5q5KtRvdDJOyiLxaTTBvqFGjc+UhjW
 FT5q6249LTAq94mV6xw==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=10 spamscore=0
 suspectscore=0 clxscore=1015 bulkscore=10 malwarescore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250142

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
context, where folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically, XFS
no longer needs to route DONTCACHE ioends through its completion
workqueue for page cache invalidation. Remove the DONTCACHE check from
xfs_ioend_needs_wq_completion().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c  | 2 ++
 fs/xfs/xfs_aops.c | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index e4d57cb969f1..6b8375d11cc0 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 76678814f46f..0d469b91377d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -510,10 +510,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 

-- 
2.39.5

