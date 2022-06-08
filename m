Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC11CCA47B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 17:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiFHRYf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 13:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiFHRYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 13:24:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA86A5C770
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 10:18:06 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FPS9l015588
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jun 2022 10:18:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Ql6iLhooUD0Dcm1lXif58GidTsVYMKW+1JrVOBVCBsc=;
 b=jGKOz5XyLaAscJ7ZtRK4zatK4Ndha6AMDoPI8i6GZzjMzknzbwjlHhtO1tJJT7ijalm4
 Les7221p+yUVyQhjzddJAET37InAiy0TmDbQGOHsmRy0sY+0yOP9OHepv13+JmLxKjFC
 hMAbgG64xcGXMqZzGUrClyeG/Tu/eDskH0I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj13ctwgt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 10:18:06 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 8 Jun 2022 10:18:04 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9B2E5103BFB5C; Wed,  8 Jun 2022 10:17:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v8 06/14] iomap: Return -EAGAIN from iomap_write_iter()
Date:   Wed, 8 Jun 2022 10:17:33 -0700
Message-ID: <20220608171741.3875418-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608171741.3875418-1-shr@fb.com>
References: <20220608171741.3875418-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: SdUpXpki2gL65NTob9OQFxnzIOBIspqu
X-Proofpoint-ORIG-GUID: SdUpXpki2gL65NTob9OQFxnzIOBIspqu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b06a5c24a4db..f701dcb7c26a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -829,7 +829,13 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		length -=3D status;
 	} while (iov_iter_count(i) && length);
=20
-	return written ? written : status;
+	if (status =3D=3D -EAGAIN) {
+		iov_iter_revert(i, written);
+		return -EAGAIN;
+	}
+	if (written)
+		return written;
+	return status;
 }
=20
 ssize_t
--=20
2.30.2

