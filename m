Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbfFYDEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:04:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xIbF093268
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:04:43 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9phf7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:04:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P32hg3098162
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6tx1wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:43 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5P32eqH013497
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:02:40 GMT
Subject: [PATCH 1/5] xfs: attribute scrub should use seen_enough to pass
 error values
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 24 Jun 2019 20:02:39 -0700
Message-ID: <156143175903.2221192.5580755117803210207.stgit@magnolia>
In-Reply-To: <156143175282.2221192.3546713622107331271.stgit@magnolia>
References: <156143175282.2221192.3546713622107331271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're iterating all the attributes using the built-in xattr
iterator, we can use the seen_enough variable to pass error codes back
to the main scrub function instead of flattening them into 0/1.  This
will be used in a more exciting fashion in upcoming patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index dce74ec57038..f0fd26abd39d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -83,7 +83,7 @@ xchk_xattr_listent(
 	sx = container_of(context, struct xchk_xattr, context);
 
 	if (xchk_should_terminate(sx->sc, &error)) {
-		context->seen_enough = 1;
+		context->seen_enough = error;
 		return;
 	}
 
@@ -125,7 +125,7 @@ xchk_xattr_listent(
 					     args.blkno);
 fail_xref:
 	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		context->seen_enough = 1;
+		context->seen_enough = XFS_ITER_ABORT;
 	return;
 }
 
@@ -464,6 +464,10 @@ xchk_xattr(
 	error = xfs_attr_list_int_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		goto out;
+
+	/* Did our listent function try to return any errors? */
+	if (sx.context.seen_enough < 0)
+		error = sx.context.seen_enough;
 out:
 	return error;
 }
