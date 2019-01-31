Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbfAaUU7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 15:20:59 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E4D7DC91F
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 20:20:59 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA9FA608E5
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 20:20:58 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix incorrect return value in namecheck()
Message-ID: <f17672e5-63eb-0f74-afdf-55ff006ee28d@redhat.com>
Date: Thu, 31 Jan 2019 14:20:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Obviously a directory entry with a '/' in the name should return
1, i.e. failure.  This was just a dumb thinko.

Fixes: 45571fd5885d ("xfs_repair: allow '/' in attribute names")

Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/da_util.c b/repair/da_util.c
index c5e690c..4a258e5 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -31,7 +31,7 @@ namecheck(
 
 	for (c = name, i = 0; i < length; i++, c++) {
 		if (isadir && *c == '/')
-			return 0;
+			return 1;
 		if (*c == '\0')
 			return 1;
 	}
