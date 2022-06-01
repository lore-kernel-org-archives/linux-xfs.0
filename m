Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E5CCCA47A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 21:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiFAVEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiFAVE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 17:04:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E9C2309BD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jun 2022 14:04:25 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251IvCpc009929
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jun 2022 14:04:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aWGWWAgH7Bi/du0tMMunpKLV8jXk2Gb/WQnwadv9en0=;
 b=ikJDvnU3N1AnSdYXSBN/z345AIkwnUQKGe2IkGtbNy90uZ7Cf+kLCIrKcZ6FqaNjrmCG
 +cddw22iSlX/2CtXGlL2nhyKt8o8OufEuioMQRq0ajdVR7pVyi9rfcUpkhBJxbZytFYz
 NVuRcI0v8lXGbKILo0lWNk2W85huBbtGMJk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge5vcm9ex-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jun 2022 14:04:24 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:04:22 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E813DFEB23A7; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>
Subject: [PATCH v7 09/15] fs: Split off inode_needs_update_time and __file_update_time
Date:   Wed, 1 Jun 2022 14:01:35 -0700
Message-ID: <20220601210141.3773402-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: HfDi904zS-SpIvWjT0kBY19aPdxA8m6i
X-Proofpoint-ORIG-GUID: HfDi904zS-SpIvWjT0kBY19aPdxA8m6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This splits off the functions inode_needs_update_time() and
__file_update_time() from the function file_update_time().

This is required to support async buffered writes.
No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c | 76 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ac1cf5aa78c8..c44573a32c6a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2049,35 +2049,18 @@ int file_remove_privs(struct file *file)
 }
 EXPORT_SYMBOL(file_remove_privs);
=20
-/**
- *	file_update_time	-	update mtime and ctime time
- *	@file: file accessed
- *
- *	Update the mtime and ctime members of an inode and mark the inode
- *	for writeback.  Note that this function is meant exclusively for
- *	usage in the file write path of filesystems, and filesystems may
- *	choose to explicitly ignore update via this function with the
- *	S_NOCMTIME inode flag, e.g. for network filesystem where these
- *	timestamps are handled by the server.  This can return an error for
- *	file systems who need to allocate space in order to update an inode.
- */
-
-int file_update_time(struct file *file)
+static int inode_needs_update_time(struct inode *inode, struct timespec6=
4 *now)
 {
-	struct inode *inode =3D file_inode(file);
-	struct timespec64 now;
 	int sync_it =3D 0;
-	int ret;
=20
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
=20
-	now =3D current_time(inode);
-	if (!timespec64_equal(&inode->i_mtime, &now))
+	if (!timespec64_equal(&inode->i_mtime, now))
 		sync_it =3D S_MTIME;
=20
-	if (!timespec64_equal(&inode->i_ctime, &now))
+	if (!timespec64_equal(&inode->i_ctime, now))
 		sync_it |=3D S_CTIME;
=20
 	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
@@ -2086,15 +2069,50 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
-	/* Finally allowed to write? Takes lock. */
-	if (__mnt_want_write_file(file))
-		return 0;
+	return sync_it;
+}
+
+static int __file_update_time(struct file *file, struct timespec64 *now,
+			int sync_mode)
+{
+	int ret =3D 0;
+	struct inode *inode =3D file_inode(file);
=20
-	ret =3D inode_update_time(inode, &now, sync_it);
-	__mnt_drop_write_file(file);
+	/* try to update time settings */
+	if (!__mnt_want_write_file(file)) {
+		ret =3D inode_update_time(inode, now, sync_mode);
+		__mnt_drop_write_file(file);
+	}
=20
 	return ret;
 }
+
+ /**
+  * file_update_time - update mtime and ctime time
+  * @file: file accessed
+  *
+  * Update the mtime and ctime members of an inode and mark the inode fo=
r
+  * writeback. Note that this function is meant exclusively for usage in
+  * the file write path of filesystems, and filesystems may choose to
+  * explicitly ignore updates via this function with the _NOCMTIME inode
+  * flag, e.g. for network filesystem where these imestamps are handled
+  * by the server. This can return an error for file systems who need to
+  * allocate space in order to update an inode.
+  *
+  * Return: 0 on success, negative errno on failure.
+  */
+int file_update_time(struct file *file)
+{
+	int ret;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	ret =3D inode_needs_update_time(inode, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(file, &now, ret);
+}
 EXPORT_SYMBOL(file_update_time);
=20
 /**
@@ -2111,6 +2129,8 @@ EXPORT_SYMBOL(file_update_time);
 int file_modified(struct file *file)
 {
 	int ret;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2123,7 +2143,11 @@ int file_modified(struct file *file)
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
=20
-	return file_update_time(file);
+	ret =3D inode_needs_update_time(inode, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(file, &now, ret);
 }
 EXPORT_SYMBOL(file_modified);
=20
--=20
2.30.2

