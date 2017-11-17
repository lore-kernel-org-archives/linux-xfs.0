Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29803 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752934AbdKQUNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:13:47 -0500
Subject: [PATCH 03/12] libfrog: add bit manipulation functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:13:43 -0800
Message-ID: <151094962315.29763.11728783735414860730.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Duplicate the libxfs bit manipulation functions -- this is for programs
that don't need libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/bitops.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)


diff --git a/include/bitops.h b/include/bitops.h
index 7774950..dd561c2 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -56,4 +56,62 @@ static inline unsigned fls_long(unsigned long l)
  */
 #define ffz(x)	ffs(~(x))
 
+/*
+ * XFS bit manipulation routines.  Repeated here so that some programs
+ * don't have to link in all of libxfs just to have bit manipulation.
+ */
+
+/*
+ * masks with n high/low bits set, 64-bit values
+ */
+static inline uint64_t mask64hi(int n)
+{
+	return (uint64_t)-1 << (64 - (n));
+}
+static inline uint32_t mask32lo(int n)
+{
+	return ((uint32_t)1 << (n)) - 1;
+}
+static inline uint64_t mask64lo(int n)
+{
+	return ((uint64_t)1 << (n)) - 1;
+}
+
+/* Get high bit set out of 32-bit argument, -1 if none set */
+static inline int highbit32(uint32_t v)
+{
+	return fls(v) - 1;
+}
+
+/* Get high bit set out of 64-bit argument, -1 if none set */
+static inline int highbit64(uint64_t v)
+{
+	return fls64(v) - 1;
+}
+
+/* Get low bit set out of 32-bit argument, -1 if none set */
+static inline int lowbit32(uint32_t v)
+{
+	return ffs(v) - 1;
+}
+
+/* Get low bit set out of 64-bit argument, -1 if none set */
+static inline int lowbit64(uint64_t v)
+{
+	uint32_t	w = (uint32_t)v;
+	int		n = 0;
+
+	if (w) {	/* lower bits */
+		n = ffs(w);
+	} else {	/* upper bits */
+		w = (uint32_t)(v >> 32);
+		if (w) {
+			n = ffs(w);
+			if (n)
+				n += 32;
+		}
+	}
+	return n - 1;
+}
+
 #endif

