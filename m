Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9053CC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 23:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiERXhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 19:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiERXhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 19:37:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC5965D29
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:21 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6It8013722
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4M9otmUSBPXBBIlvkoz2+qN3jsxgZUZNyrlzFng/Fh4=;
 b=POBgelXbYNsaiAUYMexkZx0HRdvmZGjOoWoCWzuEijHjx7rR3J0hf+Hbvy7VY06dMEXv
 ZTWYtmZQSh3Enb2LR4NmkJOtdsBbTP4FyO7AU0oe+paPeZopko3tquoZfIJouQKBcg/j
 d968XtoLYqOBu3nQSHH2kuJydmf9clJ0qrw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4dea3tj7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:37:21 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:17 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A5CF2F3ED851; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 01/18] block: Add check for async buffered writes to generic_write_checks
Date:   Wed, 18 May 2022 16:36:52 -0700
Message-ID: <20220518233709.1937634-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Q1cicBVmJq60L_D6OJhfg16SZAJPwU0_
X-Proofpoint-GUID: Q1cicBVmJq60L_D6OJhfg16SZAJPwU0_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This introduces the flag FMODE_BUF_WASYNC. If devices support async
buffered writes, this flag can be set. It also modifies the check in
generic_write_checks to take async buffered writes into consideration.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/read_write.c    | 4 +++-
 include/linux/fs.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e643aec2b0ef..544d4df33f4f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1633,7 +1633,9 @@ int generic_write_checks_count(struct kiocb *iocb, =
loff_t *count)
 	if (iocb->ki_flags & IOCB_APPEND)
 		iocb->ki_pos =3D i_size_read(inode);
=20
-	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+		!((iocb->ki_flags & IOCB_DIRECT) ||
+		  (file->f_mode & FMODE_BUF_WASYNC)))
 		return -EINVAL;
=20
 	return generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, count);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbde95387a23..3b479d02e210 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -177,6 +177,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t=
 offset,
 /* File supports async buffered reads */
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
=20
+/* File supports async nowait buffered writes */
+#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)
+
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
--=20
2.30.2

