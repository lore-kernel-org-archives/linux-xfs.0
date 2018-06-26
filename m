Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754827AbeFZAGx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jun 2018 20:06:53 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8558E8A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jun 2018 19:06:42 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfsprogs: Remove barrier/nobarrier mount options from xfs.5
Message-ID: <7105a6a3-bd16-53be-2e4f-d1ec8a491d20@sandeen.net>
Date: Mon, 25 Jun 2018 19:06:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Remove the now-removed barrier/nobarrier mount options from
the xfs.5 manpage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 745dad4..628bfc3 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -132,20 +132,6 @@ by the filesystem.
 CRC enabled filesystems always use the attr2 format, and so
 will reject the noattr2 mount option if it is set.
 .TP
-.BR barrier | nobarrier
-Note: This option has been
-.B deprecated
-as of kernel v4.10; in that version, integrity operations are
-always performed and the mount option is ignored.  These mount
-options will be removed no earlier than kernel v4.15.
-.sp
-Enables/disables the use of block layer write barriers for
-writes into the journal and for data integrity operations.
-This allows for drive level write caching to be enabled, for
-devices that support write barriers.
-.sp
-Barriers are enabled by default.
-.TP
 .BR discard | nodiscard
 Enable/disable the issuing of commands to let the block
 device reclaim space freed by the filesystem.  This is

