Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48046 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbeKOQLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 11:11:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAF64PYe148825
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:05:13 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nr7cs7jmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:05:13 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAF65Caq002839
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:05:12 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAF65CV4023823
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:05:12 GMT
Subject: [PATCH 8/9] xfs: abort xattr scrub if fatal signals are pending
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Nov 2018 22:05:11 -0800
Message-ID: <154226191127.13280.11230106325764595480.stgit@magnolia>
In-Reply-To: <154226186169.13280.4536602352984659736.stgit@magnolia>
References: <154226186169.13280.4536602352984659736.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The extended attribute scrubber should abort the "read all attrs" loop
if there's a fatal signal pending on the process.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 81d5e90547a1..9960bc5b5d76 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -82,6 +82,11 @@ xchk_xattr_listent(
 
 	sx = container_of(context, struct xchk_xattr, context);
 
+	if (xchk_should_terminate(sx->sc, &error)) {
+		context->seen_enough = 1;
+		return;
+	}
+
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
