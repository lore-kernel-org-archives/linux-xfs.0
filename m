Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4DA77F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:39:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 910B3AC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 09:39:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WEpIwuAocEIMllqI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 09:39:31 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id B4CE58E3E8
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:39:30 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7PGdT5H030964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 12:39:30 -0400
Message-ID: <55DC9A41.8060006@redhat.com>
Date: Tue, 25 Aug 2015 11:39:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: properly terminate string in quota's restore_file()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This code copies up to the entire size of devbuffer, and then
tries to use "strlen" to null terminate it.

But strlen works by *finding* the null, so it's at best a
no-op, and at worst not properly terminating the string.

Fix this by placing the null at the last byte of the buffer.

Addresses-Coverity-Id: 1297519
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/edit.c b/quota/edit.c
index d226e89..a53a7e6 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -385,7 +385,7 @@ restore_file(
 	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
 		if (strncmp("fs = ", buffer, 5) == 0) {
 			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
-			dev[strlen(dev) - 1] = '\0';
+			dev[sizeof(devbuffer) - 1] = '\0';
 			continue;
 		}
 		rtbsoft = rtbhard = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
