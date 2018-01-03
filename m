Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43605 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbeACSka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 13:40:30 -0500
Subject: [PATCH 3/5] xfs_db: fix crash when field list selector string has
 trailing slash
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 03 Jan 2018 10:40:25 -0800
Message-ID: <151500482583.7713.12763799098036486380.stgit@magnolia>
In-Reply-To: <151500479880.7713.6538509149156363572.stgit@magnolia>
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

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

