Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E2CC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 22:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbiEYWhI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 18:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345553AbiEYWfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 18:35:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BC010FE8
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 15:35:09 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtcKx017420
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 15:35:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KHrcNgpGoec04+4iaa68lI4ptLIlXN7oy1iPyC/evOA=;
 b=pSLJ95zwQCcSqAKcJMnQaAr+751tCdKASRfNLWwNM9SDX4vetjajODxve2cqaqs8LwHb
 HckwoIeOMxEqTVU+oeitSVtAn5q1OpcC30week6UbHRVKihsxewzHpNh3riJcymvw8G2
 IfDjsO3qJ94wZAxVTqp4loz8mZ9ec4BDwAU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93vs9ecm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 15:35:09 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 25 May 2022 15:35:06 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5105CF9E1B85; Wed, 25 May 2022 15:34:35 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v5 16/16] xfs: Enable async buffered write support
Date:   Wed, 25 May 2022 15:34:32 -0700
Message-ID: <20220525223432.205676-17-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220525223432.205676-1-shr@fb.com>
References: <20220525223432.205676-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: I12WKDRalmlLae25EAxU0oUCZ5nBiRNm
X-Proofpoint-GUID: I12WKDRalmlLae25EAxU0oUCZ5nBiRNm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This turns on the async buffered write support for XFS.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e9d615f4c209..2297770364b0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1169,7 +1169,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
 	return 0;
 }
=20
--=20
2.30.2

