Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934597AbeFLAan (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 20:30:43 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 4/5] xfsprogs: reset opterr on platform_getoptreset()
Date: Mon, 11 Jun 2018 17:30:38 -0700
Message-Id: <20180612003039.17154-5-mcgrof@kernel.org>
In-Reply-To: <20180612003039.17154-1-mcgrof@kernel.org>
References: <20180612003039.17154-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Setting opterr = 0 is useful if you want to only parse a subset of
paremeters first. Later you will have to set opterr = 1 again, but
we already have a platform_getoptreset() and its expected to be used
in these contexts so just sprinkle it there.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 include/darwin.h      | 1 +
 include/gnukfreebsd.h | 1 +
 include/linux.h       | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 2632e1d6f08c..4c23a1a3f739 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -79,6 +79,7 @@ static __inline__ void platform_getoptreset(void)
 {
 	extern int optreset;
 	optreset = 0;
+	opterr = 1;
 }
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 1db3f4f010e3..26e5d9e08cd5 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -83,6 +83,7 @@ static __inline__ void platform_getoptreset(void)
 {
 	extern int optind;
 	optind = 0;
+	opterr = 1;
 }
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
diff --git a/include/linux.h b/include/linux.h
index 1998941a6df5..a9273239c419 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -88,6 +88,7 @@ static __inline__ void platform_getoptreset(void)
 {
 	extern int optind;
 	optind = 0;
+	opterr = 1;
 }
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
-- 
2.16.3

