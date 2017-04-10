Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21115 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755704AbdDJQxy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 12:53:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D0FE064D80
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2017 16:53:53 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A94228311F
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2017 16:53:53 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: document barrier deprecation in xfs(5)
Message-ID: <d24e1def-2f2d-5699-46e0-633d613004da@redhat.com>
Date: Mon, 10 Apr 2017 11:53:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Since kernel v4.10, the barrier mount option is deprecated:

2291dab2 xfs: Always flush caches when integrity is required
4cf4573d xfs: deprecate barrier/nobarrier mount option

Document this fact in the xfs(5) manpage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index c7fb780..745dad4 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -133,6 +133,12 @@ CRC enabled filesystems always use the attr2 format, and so
 will reject the noattr2 mount option if it is set.
 .TP
 .BR barrier | nobarrier
+Note: This option has been
+.B deprecated
+as of kernel v4.10; in that version, integrity operations are
+always performed and the mount option is ignored.  These mount
+options will be removed no earlier than kernel v4.15.
+.sp
 Enables/disables the use of block layer write barriers for
 writes into the journal and for data integrity operations.
 This allows for drive level write caching to be enabled, for

