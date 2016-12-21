Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935134AbcLUPNK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 10:13:10 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D16BFC05AA54
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2016 15:13:09 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBLFD878002394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2016 10:13:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: Fix test for wrapped id from GETNEXTQUOTA
Message-ID: <44762cf0-ec69-4cb0-ee08-d5889f24df4b@redhat.com>
Date: Wed, 21 Dec 2016 09:13:08 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

dump_file and report_mount can be called with null *oid if
we aren't asking for the GETNEXTQUOTA interface, so we
should only test for the GETNEXTQUOTA wrap if *oid is
non-null.  Otherwise we'll deref a null pointer in the
test.

This only happens for certain invocations of reporting,
which apparently are not covered by any regression tests
at this point, at least on new kernels which contain
GETNEXTQUOTA.

Addresses-Coverity-ID: 1397415
Addresses-Coverity-ID: 1397416
Brown-paper-bag-worn-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/report.c b/quota/report.c
index fc02302..3833dd6 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -98,12 +98,12 @@ dump_file(
 		return 0;
 	}
 
-	if (oid)
+	if (oid) {
 		*oid = d.d_id;
-
-	/* Did kernelspace wrap? */
-	if (*oid < id)
-		return 0;
+		/* Did kernelspace wrap? */
+		if (*oid < id)
+			return 0;
+	}
 
 	if (!d.d_blk_softlimit && !d.d_blk_hardlimit &&
 	    !d.d_ino_softlimit && !d.d_ino_hardlimit &&
@@ -361,12 +361,12 @@ report_mount(
 		return 0;
 	}
 
-	if (oid)
+	if (oid) {
 		*oid = d.d_id;
-
-	/* Did kernelspace wrap? */
-	if (*oid < id)
-		return 0;
+		/* Did kernelspace wrap? */
+		if (* oid < id)
+			return 0;
+	}
 
 	if (flags & TERSE_FLAG) {
 		count = 0;

