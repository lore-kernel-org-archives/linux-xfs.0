Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51454 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755704AbdLTUVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Dec 2017 15:21:10 -0500
Date: Wed, 20 Dec 2017 12:21:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: fix crash when field list selector string has
 trailing slash
Message-ID: <20171220202105.GR12613@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If I run the following command:

xfs_db /dev/sdf -x -c 'agf 0' -c 'addr refcntroot' -c 'addr ptrs[1]\'

then ftok_free crashes on an invalid free() because picking up the
previous token (the closing bracket) xrealloc'd the token array to be 5
elements long but never set the last element's tok pointer.
Consequently the ftok_free tries to free whatever garbage pointer is in
that last element and kaboom.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/flist.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/db/flist.c b/db/flist.c
index e11acbf..b207354 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -400,6 +400,7 @@ flist_split(
 		strncpy(a, s, l);
 		a[l] = '\0';
 		v = xrealloc(v, (nv + 2) * sizeof(*v));
+		v[nv + 1].tok = NULL;
 		v[nv].tok = a;
 		v[nv].tokty = t;
 		nv++;
