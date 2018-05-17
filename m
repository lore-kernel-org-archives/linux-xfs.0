Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58936 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbeEQSda (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 14:33:30 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9158146C7CB
        for <linux-xfs@vger.kernel.org>; Thu, 17 May 2018 13:33:25 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] mkfs.xfs: if either sunit or swidth is nonzero, the other
 must be as well
Message-ID: <026467a9-0249-26a4-9661-c2f5f6e0586e@sandeen.net>
Date: Thu, 17 May 2018 13:33:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Don't allow the user to set one but not the other.

Reported-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5..b356d4d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2271,7 +2271,8 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
  		dswidth = big_dswidth;
  	}
  
-	if (dsunit && (!dswidth || (dswidth % dsunit != 0))) {
+	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
+           (dsunit && (dswidth % dsunit != 0))) {
  		fprintf(stderr,
  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
  			dswidth, dsunit);


