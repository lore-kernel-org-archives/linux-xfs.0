Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07728CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCD620B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ekXC5lmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVSrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiSxi109633;
        Tue, 22 Oct 2019 18:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oPE4bsxHVPmHm7l8QGakFVtukGNmsW5y7FuIiCE2N40=;
 b=ekXC5lmV96p+sPnT79Q8+IEaYZvfByNbzA0Lj5w9QsdLYF8jsxrOKgJO+2M0ljH/VqCC
 WWnRaPUoUTIRBawsKWkIhDZdRHCngeT3qgZcYfVOBJYZxOoJdMZzaoACO2A1wYlg4fxx
 mSW93NU33gU7HNSe86yxdcUR44XRIINLuEWXcuwcct1/Cb55KxZ9d6tGGvWJ5QBi4PuA
 zkWvTshOB0ec4PN4Gh4q0eo+am2Ylr+c+2J2eat55KBkEA/zL+R/JjRgvhKzKVxTZAPQ
 cYsWfPzherzDGOjXwK9gvdU3WdDP3gpTlck9Rubj5VWihxNTz+Y+5QxQPttTS/nItJQD tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vqswtgumq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiNYh070477;
        Tue, 22 Oct 2019 18:47:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vsx2rkdfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIlCIQ002365;
        Tue, 22 Oct 2019 18:47:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:12 -0700
Subject: [PATCH 1/9] libfrog/xfs_scrub: improve iteration function
 documentation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:11 -0700
Message-ID: <157177003101.1459098.14051619846815688600.stgit@magnolia>
In-Reply-To: <157177002473.1459098.11320398367215468164.stgit@magnolia>
References: <157177002473.1459098.11320398367215468164.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Between libfrog and xfs_scrub, we have several item collection iteration
functions that take a pointer to a function that will be called for
every item in that collection.  They're not well documented, so improve
the description of when they'll be called and what kinds of return
values they expect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/ptvar.h  |    8 ++++++--
 scrub/filemap.h  |    4 ++++
 scrub/inodes.h   |    6 ++++++
 scrub/spacemap.h |    4 ++++
 scrub/vfs.h      |   10 ++++++++++
 5 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libfrog/ptvar.h b/libfrog/ptvar.h
index 42865c0b..b7d02d62 100644
--- a/libfrog/ptvar.h
+++ b/libfrog/ptvar.h
@@ -8,11 +8,15 @@
 
 struct ptvar;
 
-typedef int (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
-
 int ptvar_alloc(size_t nr, size_t size, struct ptvar **pptv);
 void ptvar_free(struct ptvar *ptv);
 void *ptvar_get(struct ptvar *ptv, int *ret);
+
+/*
+ * Visit each per-thread value.  Return 0 to continue iteration or nonzero to
+ * stop iterating and return to the caller.
+ */
+typedef int (*ptvar_iter_fn)(struct ptvar *ptv, void *data, void *foreach_arg);
 int ptvar_foreach(struct ptvar *ptv, ptvar_iter_fn fn, void *foreach_arg);
 
 #endif /* __LIBFROG_PTVAR_H__ */
diff --git a/scrub/filemap.h b/scrub/filemap.h
index cb331729..219be575 100644
--- a/scrub/filemap.h
+++ b/scrub/filemap.h
@@ -14,6 +14,10 @@ struct xfs_bmap {
 	uint32_t	bm_flags;	/* output flags */
 };
 
+/*
+ * Visit each inode fork mapping.  Return true to continue iteration or false
+ * to stop iterating and return to the caller.
+ */
 typedef bool (*xfs_bmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
 		int fd, int whichfork, struct fsxattr *fsx,
 		struct xfs_bmap *bmap, void *arg);
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 3341c6d9..e58795e7 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -6,6 +6,12 @@
 #ifndef XFS_SCRUB_INODES_H_
 #define XFS_SCRUB_INODES_H_
 
+/*
+ * Visit each space mapping of an inode fork.  Return 0 to continue iteration
+ * or a positive error code to interrupt iteraton.  If ESTALE is returned,
+ * iteration will be restarted from the beginning of the inode allocation
+ * group.  Any other non zero value will stop iteration.
+ */
 typedef int (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
 		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
 
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 8f2f0a01..c29c43a5 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -6,6 +6,10 @@
 #ifndef XFS_SCRUB_SPACEMAP_H_
 #define XFS_SCRUB_SPACEMAP_H_
 
+/*
+ * Visit each space mapping in the filesystem.  Return true to continue
+ * iteration or false to stop iterating and return to the caller.
+ */
 typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
 		struct fsmap *fsr, void *arg);
 
diff --git a/scrub/vfs.h b/scrub/vfs.h
index caef8969..af23674a 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -6,8 +6,18 @@
 #ifndef XFS_SCRUB_VFS_H_
 #define XFS_SCRUB_VFS_H_
 
+/*
+ * Visit a subdirectory prior to iterating entries in that subdirectory.
+ * Return true to continue iteration or false to stop iterating and return to
+ * the caller.
+ */
 typedef bool (*scan_fs_tree_dir_fn)(struct scrub_ctx *, const char *,
 		int, void *);
+
+/*
+ * Visit each directory entry in a directory.  Return true to continue
+ * iteration or false to stop iterating and return to the caller.
+ */
 typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 		int, struct dirent *, struct stat *, void *);
 

