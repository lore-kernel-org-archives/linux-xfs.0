Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F22C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA248206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hnxtUIUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgAABK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xnS091250
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SRRhRamSo2xDBLPehn4FrTri740GtGgIbEqYy6N38KQ=;
 b=hnxtUIUIOTS357jwV5vzxqT9rpLuVu2NR2MUoNMMxG82Jg0CaPTnIzh/TciHhH8Ncqc1
 LpINXrjaXyl7u0L1o6cMhE/1JQubUE8tH8I1qBVdArC5E7hnjgJftGAcKCktM9rSm6+m
 2gYi5gBpGZX26F1thA2OuO2bBN/ISt6f+S7bRqhPgBH0Q5CrNT6GWp0EaksRWcBVnlxC
 tN5B4azlWHZzNKSdPUqxl3XnUvWT0KBM8iV2S7zEvQEJn6DAAM/4JlHgX3Qd9clSrffW
 gRt7UBUKcHkaAsHf52gZm2nQRDt3+2ARoR97Jkth5SFVO7rpTvFx3fvYtO/WgZvsDSva Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x7M172393
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj916nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:24 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011AOA8031954
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:24 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:23 -0800
Subject: [PATCH 2/5] xfs: make xfile io asynchronous
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:21 -0800
Message-ID: <157784102139.1364003.16248268874192354389.stgit@magnolia>
In-Reply-To: <157784100871.1364003.10658176827446969836.stgit@magnolia>
References: <157784100871.1364003.10658176827446969836.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use a workqueue thread to call xfile io operations because lockdep
complains when we freeze the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/array.c |   20 ++++++-----
 fs/xfs/scrub/array.h |    1 +
 fs/xfs/scrub/blob.c  |   16 ++++++---
 fs/xfs/scrub/blob.h  |    1 +
 fs/xfs/scrub/xfile.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/xfile.h |    1 +
 6 files changed, 107 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/scrub/array.c b/fs/xfs/scrub/array.c
index 47028449071e..7e1fef3c947a 100644
--- a/fs/xfs/scrub/array.c
+++ b/fs/xfs/scrub/array.c
@@ -66,6 +66,7 @@ xfbma_init(
 	array->filp = filp;
 	array->obj_size = obj_size;
 	array->nr = 0;
+	array->io_flags = 0;
 	return array;
 out_filp:
 	fput(filp);
@@ -105,7 +106,8 @@ xfbma_get(
 		return -ENODATA;
 	}
 
-	return xfile_io(array->filp, XFILE_IO_READ, &pos, ptr, array->obj_size);
+	return xfile_io(array->filp, array->io_flags | XFILE_IO_READ, &pos,
+			ptr, array->obj_size);
 }
 
 /* Put an element in the array. */
@@ -122,8 +124,8 @@ xfbma_set(
 		return -ENODATA;
 	}
 
-	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
-			array->obj_size);
+	return xfile_io(array->filp, array->io_flags | XFILE_IO_WRITE, &pos,
+			ptr, array->obj_size);
 }
 
 /* Is this array element NULL? */
@@ -172,8 +174,8 @@ xfbma_nullify(
 	}
 
 	memset(temp, 0, array->obj_size);
-	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, temp,
-			array->obj_size);
+	return xfile_io(array->filp, array->io_flags | XFILE_IO_WRITE, &pos,
+			temp, array->obj_size);
 }
 
 /* Append an element to the array. */
@@ -190,8 +192,8 @@ xfbma_append(
 		return -ENODATA;
 	}
 
-	error = xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
-			array->obj_size);
+	error = xfile_io(array->filp, array->io_flags | XFILE_IO_WRITE, &pos,
+			ptr, array->obj_size);
 	if (error)
 		return error;
 	array->nr++;
@@ -219,8 +221,8 @@ xfbma_iter_del(
 	for (pos = 0, i = 0; pos < max_bytes; i++) {
 		pgoff_t	pagenr;
 
-		error = xfile_io(array->filp, XFILE_IO_READ, &pos, temp,
-				array->obj_size);
+		error = xfile_io(array->filp, array->io_flags | XFILE_IO_READ,
+				&pos, temp, array->obj_size);
 		if (error)
 			break;
 		if (xfbma_is_null(array, temp))
diff --git a/fs/xfs/scrub/array.h b/fs/xfs/scrub/array.h
index 77b7f6005da4..6ce40c2e61f1 100644
--- a/fs/xfs/scrub/array.h
+++ b/fs/xfs/scrub/array.h
@@ -10,6 +10,7 @@ struct xfbma {
 	struct file	*filp;
 	size_t		obj_size;
 	uint64_t	nr;
+	unsigned int	io_flags;
 };
 
 struct xfbma *xfbma_init(size_t obj_size);
diff --git a/fs/xfs/scrub/blob.c b/fs/xfs/scrub/blob.c
index 94912fcb1fd1..30e189a8bd3c 100644
--- a/fs/xfs/scrub/blob.c
+++ b/fs/xfs/scrub/blob.c
@@ -46,6 +46,7 @@ xblob_init(void)
 
 	blob->filp = filp;
 	blob->last_offset = PAGE_SIZE;
+	blob->io_flags = 0;
 	return blob;
 out_filp:
 	fput(filp);
@@ -73,7 +74,8 @@ xblob_get(
 	loff_t		pos = cookie;
 	int		error;
 
-	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	error = xfile_io(blob->filp, blob->io_flags | XFILE_IO_READ, &pos,
+			&key, sizeof(key));
 	if (error)
 		return error;
 
@@ -86,7 +88,8 @@ xblob_get(
 		return -EFBIG;
 	}
 
-	return xfile_io(blob->filp, XFILE_IO_READ, &pos, ptr, key.size);
+	return xfile_io(blob->filp, blob->io_flags | XFILE_IO_READ, &pos, ptr,
+			key.size);
 }
 
 /* Store a blob. */
@@ -105,11 +108,13 @@ xblob_put(
 	loff_t		pos = blob->last_offset;
 	int		error;
 
-	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, &key, sizeof(key));
+	error = xfile_io(blob->filp, blob->io_flags | XFILE_IO_WRITE, &pos,
+			&key, sizeof(key));
 	if (error)
 		goto out_err;
 
-	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, ptr, size);
+	error = xfile_io(blob->filp, blob->io_flags | XFILE_IO_WRITE, &pos,
+			ptr, size);
 	if (error)
 		goto out_err;
 
@@ -131,7 +136,8 @@ xblob_free(
 	loff_t		pos = cookie;
 	int		error;
 
-	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	error = xfile_io(blob->filp, blob->io_flags | XFILE_IO_READ, &pos,
+			&key, sizeof(key));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/blob.h b/fs/xfs/scrub/blob.h
index c6f6c6a2e084..77b515aa4d21 100644
--- a/fs/xfs/scrub/blob.h
+++ b/fs/xfs/scrub/blob.h
@@ -9,6 +9,7 @@
 struct xblob {
 	struct file	*filp;
 	loff_t		last_offset;
+	unsigned int	io_flags;
 };
 
 typedef loff_t		xblob_cookie;
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 2d96e2f9917c..504f1aa30c61 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -41,14 +41,76 @@ xfile_destroy(
 	fput(filp);
 }
 
+struct xfile_io_args {
+	struct work_struct	work;
+	struct completion	*done;
+
+	struct file		*filp;
+	void			*ptr;
+	loff_t			*pos;
+	size_t			count;
+	ssize_t			ret;
+	bool			is_read;
+};
+
+static void
+xfile_io_worker(
+	struct work_struct	*work)
+{
+	struct xfile_io_args	*args;
+	unsigned int		pflags;
+
+	args = container_of(work, struct xfile_io_args, work);
+	pflags = memalloc_nofs_save();
+
+	if (args->is_read)
+		args->ret = kernel_read(args->filp, args->ptr, args->count,
+				args->pos);
+	else
+		args->ret = kernel_write(args->filp, args->ptr, args->count,
+				args->pos);
+	complete(args->done);
+
+	memalloc_nofs_restore(pflags);
+}
+
 /*
- * Perform a read or write IO to the file backing the array.  We can defer
- * the work to a workqueue if the caller so desires, either to reduce stack
- * usage or because the xfs is frozen and we want to avoid deadlocking on the
- * page fault that might be about to happen.
+ * Perform a read or write IO to the file backing the array.  Defer the work to
+ * a workqueue to avoid recursing into the filesystem while we have locks held.
  */
-int
-xfile_io(
+static int
+xfile_io_async(
+	struct file	*filp,
+	unsigned int	cmd_flags,
+	loff_t		*pos,
+	void		*ptr,
+	size_t		count)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct xfile_io_args	args = {
+		.filp = filp,
+		.ptr = ptr,
+		.pos = pos,
+		.count = count,
+		.done = &done,
+		.is_read = (cmd_flags & XFILE_IO_MASK) == XFILE_IO_READ,
+	};
+
+	INIT_WORK_ONSTACK(&args.work, xfile_io_worker);
+	schedule_work(&args.work);
+	wait_for_completion(&done);
+	destroy_work_on_stack(&args.work);
+
+	/*
+	 * Since we're treating this file as "memory", any IO error should be
+	 * treated as a failure to find any memory.
+	 */
+	return args.ret == count ? 0 : -ENOMEM;
+}
+
+/* Perform a read or write IO to the file backing the array. */
+static int
+xfile_io_sync(
 	struct file	*filp,
 	unsigned int	cmd_flags,
 	loff_t		*pos,
@@ -71,6 +133,20 @@ xfile_io(
 	return ret == count ? 0 : -ENOMEM;
 }
 
+/* Perform a read or write IO to the file backing the array. */
+int
+xfile_io(
+	struct file	*filp,
+	unsigned int	cmd_flags,
+	loff_t		*pos,
+	void		*ptr,
+	size_t		count)
+{
+	if (cmd_flags & XFILE_IO_ASYNC)
+		return xfile_io_async(filp, cmd_flags, pos, ptr, count);
+	return xfile_io_sync(filp, cmd_flags, pos, ptr, count);
+}
+
 /* Discard pages backing a range of the file. */
 void
 xfile_discard(
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 41817bcadc43..ae52053bf2e3 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -13,6 +13,7 @@ void xfile_destroy(struct file *filp);
 #define XFILE_IO_READ		(0)
 #define XFILE_IO_WRITE		(1)
 #define XFILE_IO_MASK		(1 << 0)
+#define XFILE_IO_ASYNC		(1 << 1)
 int xfile_io(struct file *filp, unsigned int cmd_flags, loff_t *pos,
 		void *ptr, size_t count);
 

