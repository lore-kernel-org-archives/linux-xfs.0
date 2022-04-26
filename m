Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C8CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 17:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353610AbiDZRrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353630AbiDZRr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 13:47:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBF01836FB
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:14 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQTdS024678
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EjuL5XfWq8/3lvIRoHbxsUr77eOxAiBo1twjCs1GDcA=;
 b=OGLB2OVMIcqRvne7an9F9ZnIe8cw6Ny18x1aHS13Ct+URtWdg+SSYN5Ys97V6OJWB7+B
 OJpq3n/PZ5Nrmebl7LwN0Y1xJF+9pZl0Q4pPCO1jzSDSQWnebiantDfZcjMAHyDM5Ii1
 1hFCSkP+oCZ68qSFP04Bz4tADwCmnNcDkMw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge03h8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 10:44:13 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:12 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id D5C35E2D4873; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 16/18] iomap: User throttling for async buffered writes.
Date:   Tue, 26 Apr 2022 10:43:33 -0700
Message-ID: <20220426174335.4004987-17-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Y5qRmsqO2zZ5puJFN2sLsxubulO7FEJN
X-Proofpoint-GUID: Y5qRmsqO2zZ5puJFN2sLsxubulO7FEJN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This enables throttling for async buffered writes.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5c53a5715c85..0f0a6fe36699 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -843,7 +843,8 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		written +=3D status;
 		length -=3D status;
=20
-		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
+		balance_dirty_pages_ratelimited_flags(iter->inode->i_mapping,
+						(iter->flags & IOMAP_NOWAIT));
 	} while (iov_iter_count(i) && length);
=20
 	return written ? written : status;
--=20
2.30.2

