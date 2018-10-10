Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53652 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbeJJObR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 10:31:17 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gA8dX-0002GG-JV
        for linux-xfs@vger.kernel.org; Wed, 10 Oct 2018 18:10:27 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gA8dX-0001mG-IM
        for linux-xfs@vger.kernel.org; Wed, 10 Oct 2018 18:10:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfsprogs: document changes for 4.19.0-rc0
Date: Wed, 10 Oct 2018 18:10:22 +1100
Message-Id: <20181010071023.6765-2-david@fromorbit.com>
In-Reply-To: <20181010071023.6765-1-david@fromorbit.com>
References: <20181010071023.6765-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because 'make deb' breaks without them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 debian/changelog | 7 +++++++
 doc/CHANGES      | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 01639f9efeec..ef129e278948 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,10 @@
+xfsprogs (4.19.0-rc0-1) unstable; urgency=low
+
+  * New upstream pre-release
+  * Merge libxfs changes from kernel-4.19
+
+ -- Nathan Scott <nathans@debian.org>  Wed, 10 Oct 2018 17:52:48 +1100
+
 xfsprogs (4.18.0-1) unstable; urgency=low
 
   * New upstream release
diff --git a/doc/CHANGES b/doc/CHANGES
index 3c1e39469008..1c41bd90a1c5 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,3 +1,10 @@
+xfsprogs-4.18.0-rc0 (10 Oct 2018)
+	- Majority of 4.18 libxfs changes merged from kernel
+	- Big sparse static checker cleanup (Eric Sandeen)
+	- mkfs.xfs discard fixes (Jan Tulak)
+	- xfs_io readv/writev cleanup (Zorro Lang)
+	- libxfs transaction commit error checking (Darrick Wong)
+
 xfsprogs-4.18.0 (24 Aug 2018)
 	- Tweak SPDX license in xfs_cksum.h (Darrick Wong)
 
-- 
2.17.0
