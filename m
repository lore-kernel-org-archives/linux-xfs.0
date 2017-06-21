Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22576 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdFUVTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 17:19:53 -0400
Date: Wed, 21 Jun 2017 14:19:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 02/12] libxcmd: add cvt{int, long} to convert strings to
 int and long
Message-ID: <20170621211947.GR4733@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755896133.3625.13813626356334626083.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149755896133.3625.13813626356334626083.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

Create some helper functions to convert strings to int or long
in a standard way and work around problems in the C library
atoi/strtol functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: various comment fixes requested by Eric Sandeen.
---
 include/input.h |    8 +++
 libxcmd/input.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/include/input.h b/include/input.h
index 82cd2f4..145114b 100644
--- a/include/input.h
+++ b/include/input.h
@@ -28,6 +28,14 @@ extern char	**breakline(char *input, int *count);
 extern void	doneline(char *input, char **vec);
 extern char	*fetchline(void);
 
+extern int64_t	cvt_s64(char *s, int base);
+extern int32_t	cvt_s32(char *s, int base);
+extern int16_t	cvt_s16(char *s, int base);
+
+extern uint64_t	cvt_u64(char *s, int base);
+extern uint32_t	cvt_u32(char *s, int base);
+extern uint16_t	cvt_u16(char *s, int base);
+
 extern size_t numlen(uint64_t val, size_t base);
 extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
 extern void	cvtstr(double value, char *str, size_t sz);
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 9437be3..7a69dc1 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -149,6 +149,158 @@ numlen(
 	return len == 0 ? 1 : len;
 }
 
+/*
+ * Convert string to int64_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+int64_t
+cvt_s64(
+	char		*s,
+	int		base)
+{
+	long long	i;
+	char		*sp;
+
+	errno = 0;
+	i = strtoll(s, &sp, base);
+	/*
+	 * If the input would over or underflow, return the clamped
+	 * value and let the user check errno.  If we went all the
+	 * way to the end of the input, return the converted value;
+	 * errno will be zero.
+	 */
+	if (errno || (*sp == '\0' && sp != s))
+		return i;
+
+	/* Not all the input was consumed, return error. */
+	errno = -ERANGE;
+	return INT64_MIN;
+}
+
+/*
+ * Convert string to int32_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+int32_t
+cvt_s32(
+	char		*s,
+	int		base)
+{
+	int64_t		i;
+
+	i = cvt_s64(s, base);
+	if (errno)
+		return i;
+	if (i > INT32_MAX || i < INT32_MIN) {
+		errno = -ERANGE;
+		return INT32_MIN;
+	}
+	return i;
+}
+
+/*
+ * Convert string to int16_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+int16_t
+cvt_s16(
+	char		*s,
+	int		base)
+{
+	int64_t		i;
+
+	i = cvt_s64(s, base);
+	if (errno)
+		return i;
+	if (i > INT16_MAX || i < INT16_MIN) {
+		errno = -ERANGE;
+		return INT16_MIN;
+	}
+	return i;
+}
+
+/*
+ * Convert string to uint64_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+uint64_t
+cvt_u64(
+	char		*s,
+	int		base)
+{
+	long long	i;
+	char		*sp;
+
+	errno = 0;
+	i = strtoll(s, &sp, base);
+	/*
+	 * If the input would over or underflow, return the clamped
+	 * value and let the user check errno.  If we went all the
+	 * way to the end of the input, return the converted value;
+	 * errno will be zero.
+	 */
+	if (errno || (*sp == '\0' && sp != s))
+		return i;
+
+	/* Not all the input was consumed, return error. */
+	errno = -ERANGE;
+	return UINT64_MAX;
+}
+
+/*
+ * Convert string to uint32_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+uint32_t
+cvt_u32(
+	char		*s,
+	int		base)
+{
+	uint64_t	i;
+
+	i = cvt_u64(s, base);
+	if (errno)
+		return i;
+	if (i > UINT32_MAX) {
+		errno = -ERANGE;
+		return UINT32_MAX;
+	}
+	return i;
+}
+
+/*
+ * Convert string to uint16_t, set errno if the conversion fails or
+ * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
+ * prior to conversion so you can check for bad inputs by examining
+ * errno immediately after the call.
+ */
+uint16_t
+cvt_u16(
+	char		*s,
+	int		base)
+{
+	uint64_t	i;
+
+	i = cvt_u64(s, base);
+	if (errno)
+		return i;
+	if (i > UINT16_MAX) {
+		errno = -ERANGE;
+		return UINT16_MAX;
+	}
+	return i;
+}
+
 #define EXABYTES(x)	((long long)(x) << 60)
 #define PETABYTES(x)	((long long)(x) << 50)
 #define TERABYTES(x)	((long long)(x) << 40)
