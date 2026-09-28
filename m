Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2D74B95DE;
	Mon, 28 Sep 2026 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597060; cv=none; b=CUfW2/rP7ujttU0VrQj5FzUetpoRiKE11gIfM2sae63oa73nxmLSvYhGDk5YO1uB59khQTnXl8HlYsH74+mM7GxAUTFH82eecRuKG39CniWUGYYafKzSbUcSLjl9evfxSAdOn6g4kNoO67lC7HehgpkqzeGQpCqvsFULGR4bIfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597060; c=relaxed/simple;
	bh=cuDP/LmgK9zpuNdSvO47DvZhOuUIEMc/liVCJbzuFxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPX4NrlzeLC4iv1xiAglzq3bTWC05wc0LWPb2bP5PnVsue+NvIvipi3QYlfp9nFq/n8QjycROxMQBkbdZlH45bxChLwlKBz3FPBaCT59oBUgtkAG9WmaAiTA1cI1ry0KhSteWNj9TUzMhOQM8gvSYUL+Wb/TuJrVUAE0D8gYCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MRCLpCuC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MRCLpCuC"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZfNQ3971356;
	Mon, 28 Sep 2026 12:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WtfTn+x0FLSmKfaOx
	1RzxmhrR5ci27ocuZcS9amsYds=; b=MRCLpCuCgns1J4mO6A2mrpaWR1TDQBEoc
	GCbIx7MVsnQ0PcUEn7EqfTrLwyrri8F316KoXsITTKbUe+A8Qp9wQr4DAHA4lk2X
	J+vzwQDGjGYFjOga3rIzVmuaLDIp81VlB1HQYZ3axeOE1uu8v5YDpt3vSc8DzL1c
	0/dQh84nXgROLZDex3xDhHoLYrJieDBjVRoYFGqeVTaiK36aaGdNWW7uO69oGWjr
	lZ+IogvFP+y7GM4Jkcs0PjZELn9x+kN7XY4ensg/dmypyOxSGIDOC1xpHYvK8WvS
	vnACPW2A/KGrx5w2ivoyy54Eg/KhM2TKnGZ/XmBVfUE3dg4N/XA0w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe0v3x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHgT9057349;
	Mon, 28 Sep 2026 12:03:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxu2y4uf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:40 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3cZa49217998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68A192004B;
	Mon, 28 Sep 2026 12:03:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 648B720040;
	Mon, 28 Sep 2026 12:03:32 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:32 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 03/12] mm: Refactor folio_clear_dirty_for_io()
Date: Mon, 28 Sep 2026 17:33:04 +0530
Message-ID: <fc3594a05c19f420aef5d62f1303a7bde2ef328b.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba579d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=GwQEhMSs4eZOB5FW1yQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX/3vlYo9wxcsr
 JYYcyqhk3tR9Z3/dBT0dDpX60V4tn2TrLVasPnO88LnHiVYFA6o7HVagUWdRJYU5sd6EairKjyH
 Kj98axIGNZcBIfwvqObYcM3RFKRBfuI=
X-Proofpoint-ORIG-GUID: YxDXl9EG5Z-Bi_gPE-Z5ZZOq21ooSo17
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX8CAeBjrDL4qh
 EyKepIOm4FTLtbTYg2dumoYiwXp8tG6tzkkxt6Fd+bO9xSyAC3lrJJOFq1FnMg8RlrvMNzYanhp
 +03dQmag9wJYE08BbruT0MIt0yl++Acu9+cf2Y5/7pkdSf7YKcV9OpKEakhnU80mkiy3OYRcnCR
 nKp/kT4U4Z72zVSfPRz0iFbPdKRl/oC346WvkwKRGZw4IfgPAh8TUGpyPz6X85dOqmeSru80+3L
 vocwycxlpJ2V+tB0goybYnhPLaez/f1VMbkLhEwfUgXQ1LGlGkJwPXuEeVbsNT1hhq3hiudI/l6
 DQrM7uFqNk7EJ2pu8YS1H1dVpUO/ebbxb27fK/17tA/ImNoUc5B7itNRQMHK2eOa+O4m5SElGAP
 P8W7gUZUm7nUXldvu0sRaxIgl6Sqz8lh1aAtDf12f36ivw5dEISVTfi/ybchvsusU5grob22UXr
 pFmHfpKQbOfnYCqmyWw==
X-Proofpoint-GUID: -313Jdo5_M6ccwY9ufVouOsxkcYyQZV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046

Add a new __folio_clear_dirty_for_io() helper which takes an extra
parameter to indicate folio_mkclean() is needed. This is in preparation
of buffered writethrough support where we already do folio_mkclean()
before calling into this function.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 mm/page-writeback.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce36..2f8059ab55b9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2850,20 +2850,12 @@ void __folio_cancel_dirty(struct folio *folio)
 EXPORT_SYMBOL(__folio_cancel_dirty);
 
 /*
- * Clear a folio's dirty flag, while caring for dirty memory accounting.
- * Returns true if the folio was previously dirty.
- *
- * This is for preparing to put the folio under writeout.  We leave
- * the folio tagged as dirty in the xarray so that a concurrent
- * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
- * The ->writepage implementation will run either folio_start_writeback()
- * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
- * and xarray dirty tag back into sync.
- *
- * This incoherency between the folio's dirty flag and xarray tag is
- * unfortunate, but it only exists while the folio is locked.
+ * Internal helper to take care of clearing dirty bit on a folio in preparation
+ * of an IO. For some cases we might not want to do mkclean, eg, if we've
+ * already taken care of it, hence pass the should_mkclean flag to indicate if
+ * its needed.
  */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool should_mkclean)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -2900,7 +2892,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
+		if (should_mkclean && folio_mkclean(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * We carefully synchronise fault handlers against
@@ -2925,6 +2917,25 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+/*
+ * Clear a folio's dirty flag, while caring for dirty memory accounting.
+ * Returns true if the folio was previously dirty.
+ *
+ * This is for preparing to put the folio under writeout.  We leave
+ * the folio tagged as dirty in the xarray so that a concurrent
+ * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
+ * The ->writepage implementation will run either folio_start_writeback()
+ * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
+ * and xarray dirty tag back into sync.
+ *
+ * This incoherency between the folio's dirty flag and xarray tag is
+ * unfortunate, but it only exists while the folio is locked.
+ */
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.55.0

