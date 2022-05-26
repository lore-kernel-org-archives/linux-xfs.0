Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183C4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 17:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348317AbiEZRjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 13:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348329AbiEZRjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 13:39:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B70E9A980
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:39:13 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QFmm4l025717
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:39:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BE5eLO5Z7AZICxMCDTAcJeiKudbeydb7d4UMFp50BLA=;
 b=N3U1xiAxFgkogIuPm/YPEzp/VBDYT+eTo3MN4OpBH2ZNhSGIxTq5DO+IAH/aMQBdP5r6
 jT8Wlm+vYWcwTmJUjz5Cm/90vk5hV7KOj2slqX2078krc7m6R7qYhKwTkme+HZwQwhiG
 YYNCbJ82vON6zeV3isv8llcNQhz/EI7FY6E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gacgx8tkh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 10:39:12 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:39:12 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 965C7FA621E0; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 10/16] fs: Optimization for concurrent file time updates.
Date:   Thu, 26 May 2022 10:38:34 -0700
Message-ID: <20220526173840.578265-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: l1O8b54U3W78_4DhQJ7kVKN2G4PfXy38
X-Proofpoint-ORIG-GUID: l1O8b54U3W78_4DhQJ7kVKN2G4PfXy38
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This introduces the S_PENDING_TIME flag. If an async buffered write
needs to update the time, it cannot be processed in the fast path of
io-uring. When a time update is pending this flag is set for async
buffered writes. Other concurrent async buffered writes for the same
file do not need to wait while this time update is pending.

This reduces the number of async buffered writes that need to get punted
to the io-workers in io-uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 11 +++++++++--
 include/linux/fs.h |  3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4503bed063e7..7185d860d423 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2150,10 +2150,17 @@ static int file_modified_flags(struct file *file,=
 int flags)
 	ret =3D inode_needs_update_time(inode, &now);
 	if (ret <=3D 0)
 		return ret;
-	if (flags & IOCB_NOWAIT)
+	if (flags & IOCB_NOWAIT) {
+		if (IS_PENDING_TIME(inode))
+			return 0;
+
+		inode_set_flags(inode, S_PENDING_TIME, S_PENDING_TIME);
 		return -EAGAIN;
+	}
=20
-	return __file_update_time(file, &now, ret);
+	ret =3D __file_update_time(file, &now, ret);
+	inode_set_flags(inode, 0, S_PENDING_TIME);
+	return ret;
 }
=20
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2d9b3afcb4a5..5924c90eab1d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2143,6 +2143,8 @@ struct super_operations {
 #define S_CASEFOLD	(1 << 15) /* Casefolded file */
 #define S_VERITY	(1 << 16) /* Verity file (using fs/verity/) */
 #define S_KERNEL_FILE	(1 << 17) /* File is in use by the kernel (eg. fs/=
cachefiles) */
+#define S_PENDING_TIME (1 << 18) /* File update time is pending */
+
=20
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-syst=
em
@@ -2185,6 +2187,7 @@ static inline bool sb_rdonly(const struct super_blo=
ck *sb) { return sb->s_flags
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
 #define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
 #define IS_VERITY(inode)	((inode)->i_flags & S_VERITY)
+#define IS_PENDING_TIME(inode) ((inode)->i_flags & S_PENDING_TIME)
=20
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev =3D=3D WHITEOUT_DEV)
--=20
2.30.2

