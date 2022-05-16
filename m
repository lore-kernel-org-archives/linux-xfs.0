Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCA5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 16:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbiEPQtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 12:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343876AbiEPQst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 12:48:49 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D0F3C73A
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 09:48:48 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GAojg8013071
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 09:48:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ytINONjGb5g4AiCRPvl5zx2CjqhigNhOPZAk5ycuIEA=;
 b=V888tU8+rnxpRIkcK3Cwp13O4l7V8oOfFVTGIoGFzwDAqgLEkkMXYnKKk/7g90kgrdsc
 ZH3Uro3vm96cMB2mrgi1alyLZJDeITvN2aESHDbuTNz68yp4+AHReFVru0mDC4gT9te2
 sccT0oQAk5zlKD3c6Va6fp0KPzuMw3P+IQc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a5yakg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 09:48:47 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 652D9F146DDD; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 07/16] fs: split off need_file_update_time and do_file_update_time
Date:   Mon, 16 May 2022 09:47:09 -0700
Message-ID: <20220516164718.2419891-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: i62qyGiDG4N7DgFmY0Je5pEee1NNa6rS
X-Proofpoint-GUID: i62qyGiDG4N7DgFmY0Je5pEee1NNa6rS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This splits off the functions need_file_update_time() and
do_file_update_time() from the function file_update_time().

This is required to support async buffered writes.
No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c | 71 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a6d70a1983f8..1d0b02763e98 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2054,35 +2054,22 @@ int file_remove_privs(struct file *file)
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
+static int need_file_update_time(struct inode *inode, struct file *file,
+				struct timespec64 *now)
 {
-	struct inode *inode =3D file_inode(file);
-	struct timespec64 now;
 	int sync_it =3D 0;
-	int ret;
+
+	if (unlikely(file->f_mode & FMODE_NOCMTIME))
+		return 0;
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
@@ -2091,15 +2078,49 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
+	return sync_it;
+}
+
+static int do_file_update_time(struct inode *inode, struct file *file,
+			struct timespec64 *now, int sync_mode)
+{
+	int ret;
+
 	/* Finally allowed to write? Takes lock. */
 	if (__mnt_want_write_file(file))
 		return 0;
=20
-	ret =3D inode_update_time(inode, &now, sync_it);
+	ret =3D inode_update_time(inode, now, sync_mode);
 	__mnt_drop_write_file(file);
=20
 	return ret;
 }
+
+/**
+ *	file_update_time	-	update mtime and ctime time
+ *	@file: file accessed
+ *
+ *	Update the mtime and ctime members of an inode and mark the inode
+ *	for writeback.  Note that this function is meant exclusively for
+ *	usage in the file write path of filesystems, and filesystems may
+ *	choose to explicitly ignore update via this function with the
+ *	S_NOCMTIME inode flag, e.g. for network filesystem where these
+ *	timestamps are handled by the server.  This can return an error for
+ *	file systems who need to allocate space in order to update an inode.
+ */
+
+int file_update_time(struct file *file)
+{
+	int err;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	err =3D need_file_update_time(inode, file, &now);
+	if (err < 0)
+		return err;
+
+	return do_file_update_time(inode, file, &now, err);
+}
 EXPORT_SYMBOL(file_update_time);
=20
 /* Caller must hold the file's inode lock */
@@ -2108,6 +2129,7 @@ int file_modified(struct file *file)
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
 	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2122,10 +2144,11 @@ int file_modified(struct file *file)
 			return ret;
 	}
=20
-	if (unlikely(file->f_mode & FMODE_NOCMTIME))
-		return 0;
+	ret =3D need_file_update_time(inode, file, &now);
+	if (ret <=3D 0)
+		return ret;
=20
-	return file_update_time(file);
+	return do_file_update_time(inode, file, &now, ret);
 }
 EXPORT_SYMBOL(file_modified);
=20
--=20
2.30.2

