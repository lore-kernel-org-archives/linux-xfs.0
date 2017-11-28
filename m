Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28047 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdK1F7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 00:59:54 -0500
Date: Mon, 27 Nov 2017 21:59:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 08/12] libfrog: move conversion factors out of libxcmd
Message-ID: <20171128055948.GB19394@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
 <151094966001.29763.1497519664885559784.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151094966001.29763.1497519664885559784.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move all the conversion functions out of libxcmd since they'll be used
by scrub, which doesn't have a commandline.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix copyright/licensing statements
v2: actually include all of the patch <cough>
---
 include/convert.h |   37 +++++
 include/input.h   |   15 --
 libfrog/Makefile  |    1 
 libfrog/convert.c |  384 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxcmd/input.c   |  375 ----------------------------------------------------
 quota/Makefile    |    4 -
 spaceman/Makefile |    4 -
 7 files changed, 427 insertions(+), 393 deletions(-)
 create mode 100644 include/convert.h
 create mode 100644 libfrog/convert.c

diff --git a/include/convert.h b/include/convert.h
new file mode 100644
index 0000000..bb75041
--- /dev/null
+++ b/include/convert.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __CONVERT_H__
+#define __CONVERT_H__
+
+extern int64_t	cvt_s64(char *s, int base);
+extern int32_t	cvt_s32(char *s, int base);
+extern int16_t	cvt_s16(char *s, int base);
+
+extern uint64_t	cvt_u64(char *s, int base);
+extern uint32_t	cvt_u32(char *s, int base);
+extern uint16_t	cvt_u16(char *s, int base);
+
+extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
+extern void cvtstr(double value, char *str, size_t sz);
+extern unsigned long cvttime(char *s);
+
+extern uid_t	uid_from_string(char *user);
+extern gid_t	gid_from_string(char *group);
+extern prid_t	prid_from_string(char *project);
+
+#endif	/* __CONVERT_H__ */
diff --git a/include/input.h b/include/input.h
index 145114b..fe107b9 100644
--- a/include/input.h
+++ b/include/input.h
@@ -22,24 +22,14 @@
 #include <grp.h>
 #include <sys/types.h>
 #include "project.h"
+#include "convert.h"
 #include <stdbool.h>
 
 extern char	**breakline(char *input, int *count);
 extern void	doneline(char *input, char **vec);
 extern char	*fetchline(void);
 
-extern int64_t	cvt_s64(char *s, int base);
-extern int32_t	cvt_s32(char *s, int base);
-extern int16_t	cvt_s16(char *s, int base);
-
-extern uint64_t	cvt_u64(char *s, int base);
-extern uint32_t	cvt_u32(char *s, int base);
-extern uint16_t	cvt_u16(char *s, int base);
-
 extern size_t numlen(uint64_t val, size_t base);
-extern long long cvtnum(size_t blocksize, size_t sectorsize, char *s);
-extern void	cvtstr(double value, char *str, size_t sz);
-extern unsigned long cvttime(char *s);
 
 extern struct timeval tadd(struct timeval t1, struct timeval t2);
 extern struct timeval tsub(struct timeval t1, struct timeval t2);
@@ -53,9 +43,6 @@ enum {
 
 extern void	timestr(struct timeval *tv, char *str, size_t sz, int flags);
 
-extern uid_t	uid_from_string(char *user);
-extern gid_t	gid_from_string(char *group);
-extern prid_t	prid_from_string(char *project);
 extern bool	isdigits_only(const char *str);
 extern int	timespec_from_string(const char *sec, const char *nsec, struct timespec *ts);
 
diff --git a/libfrog/Makefile b/libfrog/Makefile
index bffc346..467362c 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -12,6 +12,7 @@ LT_AGE = 0
 
 CFILES = \
 avl64.c \
+convert.c \
 list_sort.c \
 radix-tree.c \
 topology.c \
diff --git a/libfrog/convert.c b/libfrog/convert.c
new file mode 100644
index 0000000..b36f77e
--- /dev/null
+++ b/libfrog/convert.c
@@ -0,0 +1,384 @@
+/*
+ * Copyright (c) 2003-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "platform_defs.h"
+#include "input.h"
+#include <ctype.h>
+#include <stdbool.h>
+
+size_t
+numlen(
+	uint64_t	val,
+	size_t		base)
+{
+	uint64_t	tmp;
+	size_t		len;
+
+	for (len = 0, tmp = val; tmp > 0; tmp = tmp / base)
+		len++;
+	return len == 0 ? 1 : len;
+}
+
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
+#define EXABYTES(x)	((long long)(x) << 60)
+#define PETABYTES(x)	((long long)(x) << 50)
+#define TERABYTES(x)	((long long)(x) << 40)
+#define GIGABYTES(x)	((long long)(x) << 30)
+#define MEGABYTES(x)	((long long)(x) << 20)
+#define KILOBYTES(x)	((long long)(x) << 10)
+
+long long
+cvtnum(
+	size_t		blocksize,
+	size_t		sectorsize,
+	char		*s)
+{
+	long long	i;
+	char		*sp;
+	int		c;
+
+	i = strtoll(s, &sp, 0);
+	if (i == 0 && sp == s)
+		return -1LL;
+	if (*sp == '\0')
+		return i;
+
+	if (sp[1] != '\0')
+		return -1LL;
+
+	c = tolower(*sp);
+	switch (c) {
+	case 'b':
+		return i * blocksize;
+	case 's':
+		return i * sectorsize;
+	case 'k':
+		return KILOBYTES(i);
+	case 'm':
+		return MEGABYTES(i);
+	case 'g':
+		return GIGABYTES(i);
+	case 't':
+		return TERABYTES(i);
+	case 'p':
+		return PETABYTES(i);
+	case 'e':
+		return  EXABYTES(i);
+	}
+	return -1LL;
+}
+
+#define TO_EXABYTES(x)	((x) / EXABYTES(1))
+#define TO_PETABYTES(x)	((x) / PETABYTES(1))
+#define TO_TERABYTES(x)	((x) / TERABYTES(1))
+#define TO_GIGABYTES(x)	((x) / GIGABYTES(1))
+#define TO_MEGABYTES(x)	((x) / MEGABYTES(1))
+#define TO_KILOBYTES(x)	((x) / KILOBYTES(1))
+
+void
+cvtstr(
+	double		value,
+	char		*str,
+	size_t		size)
+{
+	char		*fmt;
+	int		precise;
+
+	precise = ((double)value * 1000 == (double)(int)value * 1000);
+
+	if (value >= EXABYTES(1)) {
+		fmt = precise ? "%.f EiB" : "%.3f EiB";
+		snprintf(str, size, fmt, TO_EXABYTES(value));
+	} else if (value >= PETABYTES(1)) {
+		fmt = precise ? "%.f PiB" : "%.3f PiB";
+		snprintf(str, size, fmt, TO_PETABYTES(value));
+	} else if (value >= TERABYTES(1)) {
+		fmt = precise ? "%.f TiB" : "%.3f TiB";
+		snprintf(str, size, fmt, TO_TERABYTES(value));
+	} else if (value >= GIGABYTES(1)) {
+		fmt = precise ? "%.f GiB" : "%.3f GiB";
+		snprintf(str, size, fmt, TO_GIGABYTES(value));
+	} else if (value >= MEGABYTES(1)) {
+		fmt = precise ? "%.f MiB" : "%.3f MiB";
+		snprintf(str, size, fmt, TO_MEGABYTES(value));
+	} else if (value >= KILOBYTES(1)) {
+		fmt = precise ? "%.f KiB" : "%.3f KiB";
+		snprintf(str, size, fmt, TO_KILOBYTES(value));
+	} else {
+		snprintf(str, size, "%f bytes", value);
+	}
+}
+
+#define MINUTES_TO_SECONDS(m)	((m) * 60)
+#define HOURS_TO_SECONDS(h)	((h) * MINUTES_TO_SECONDS(60))
+#define DAYS_TO_SECONDS(d)	((d) * HOURS_TO_SECONDS(24))
+#define WEEKS_TO_SECONDS(w)	((w) * DAYS_TO_SECONDS(7))
+
+unsigned long
+cvttime(
+	char		*s)
+{
+	unsigned long	i;
+	char		*sp;
+
+	i = strtoul(s, &sp, 0);
+	if (i == 0 && sp == s)
+		return 0;
+	if (*sp == '\0')
+		return i;
+	if ((*sp == 'm' && sp[1] == '\0') ||
+	    (strcmp(sp, "minutes") == 0) ||
+	    (strcmp(sp, "minute") == 0))
+		return MINUTES_TO_SECONDS(i);
+	if ((*sp == 'h' && sp[1] == '\0') ||
+	    (strcmp(sp, "hours") == 0) ||
+	    (strcmp(sp, "hour") == 0))
+		return HOURS_TO_SECONDS(i);
+	if ((*sp == 'd' && sp[1] == '\0') ||
+	    (strcmp(sp, "days") == 0) ||
+	    (strcmp(sp, "day") == 0))
+		return DAYS_TO_SECONDS(i);
+	if ((*sp == 'w' && sp[1] == '\0') ||
+	    (strcmp(sp, "weeks") == 0) ||
+	    (strcmp(sp, "week") == 0))
+		return WEEKS_TO_SECONDS(i);
+	return 0;
+}
+
+/*
+ * Convert from arbitrary user strings into a numeric ID.
+ * If it's all numeric, we convert that inplace, else we do
+ * the name lookup, and return the found identifier.
+ */
+
+prid_t
+prid_from_string(
+	char		*project)
+{
+	fs_project_t	*prj;
+	unsigned long	prid_long;
+	char		*sp;
+
+	/*
+	 * Allow either a full numeric or a valid projectname, even
+	 * if it starts with a digit.
+	 */
+	prid_long = strtoul(project, &sp, 10);
+	if (*project != '\0' && *sp == '\0') {
+		if ((prid_long == ULONG_MAX && errno == ERANGE)
+				|| (prid_long > (prid_t)-1))
+			return -1;
+		return (prid_t)prid_long;
+	}
+	prj = getprnam(project);
+	if (prj)
+		return prj->pr_prid;
+	return -1;
+}
+
+uid_t
+uid_from_string(
+	char		*user)
+{
+	struct passwd	*pwd;
+	unsigned long	uid_long;
+	char		*sp;
+
+	uid_long = strtoul(user, &sp, 10);
+	if (sp != user && *sp == '\0') {
+		if ((uid_long == ULONG_MAX && errno == ERANGE)
+				|| (uid_long > (uid_t)-1))
+			return -1;
+		return (uid_t)uid_long;
+	}
+	pwd = getpwnam(user);
+	if (pwd)
+		return pwd->pw_uid;
+	return -1;
+}
+
+gid_t
+gid_from_string(
+	char		*group)
+{
+	struct group	*grp;
+	unsigned long	gid_long;
+	char		*sp;
+
+	gid_long = strtoul(group, &sp, 10);
+	if (sp != group && *sp == '\0') {
+		if ((gid_long == ULONG_MAX && errno == ERANGE)
+				|| (gid_long > (gid_t)-1))
+			return -1;
+		return (gid_t)gid_long;
+	}
+	grp = getgrnam(group);
+	if (grp)
+		return grp->gr_gid;
+	return -1;
+}
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 7a69dc1..441bb2f 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -136,308 +136,6 @@ doneline(
 	free(vec);
 }
 
-size_t
-numlen(
-	uint64_t	val,
-	size_t		base)
-{
-	uint64_t	tmp;
-	size_t		len;
-
-	for (len = 0, tmp = val; tmp > 0; tmp = tmp / base)
-		len++;
-	return len == 0 ? 1 : len;
-}
-
-/*
- * Convert string to int64_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-int64_t
-cvt_s64(
-	char		*s,
-	int		base)
-{
-	long long	i;
-	char		*sp;
-
-	errno = 0;
-	i = strtoll(s, &sp, base);
-	/*
-	 * If the input would over or underflow, return the clamped
-	 * value and let the user check errno.  If we went all the
-	 * way to the end of the input, return the converted value;
-	 * errno will be zero.
-	 */
-	if (errno || (*sp == '\0' && sp != s))
-		return i;
-
-	/* Not all the input was consumed, return error. */
-	errno = -ERANGE;
-	return INT64_MIN;
-}
-
-/*
- * Convert string to int32_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-int32_t
-cvt_s32(
-	char		*s,
-	int		base)
-{
-	int64_t		i;
-
-	i = cvt_s64(s, base);
-	if (errno)
-		return i;
-	if (i > INT32_MAX || i < INT32_MIN) {
-		errno = -ERANGE;
-		return INT32_MIN;
-	}
-	return i;
-}
-
-/*
- * Convert string to int16_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-int16_t
-cvt_s16(
-	char		*s,
-	int		base)
-{
-	int64_t		i;
-
-	i = cvt_s64(s, base);
-	if (errno)
-		return i;
-	if (i > INT16_MAX || i < INT16_MIN) {
-		errno = -ERANGE;
-		return INT16_MIN;
-	}
-	return i;
-}
-
-/*
- * Convert string to uint64_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-uint64_t
-cvt_u64(
-	char		*s,
-	int		base)
-{
-	long long	i;
-	char		*sp;
-
-	errno = 0;
-	i = strtoll(s, &sp, base);
-	/*
-	 * If the input would over or underflow, return the clamped
-	 * value and let the user check errno.  If we went all the
-	 * way to the end of the input, return the converted value;
-	 * errno will be zero.
-	 */
-	if (errno || (*sp == '\0' && sp != s))
-		return i;
-
-	/* Not all the input was consumed, return error. */
-	errno = -ERANGE;
-	return UINT64_MAX;
-}
-
-/*
- * Convert string to uint32_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-uint32_t
-cvt_u32(
-	char		*s,
-	int		base)
-{
-	uint64_t	i;
-
-	i = cvt_u64(s, base);
-	if (errno)
-		return i;
-	if (i > UINT32_MAX) {
-		errno = -ERANGE;
-		return UINT32_MAX;
-	}
-	return i;
-}
-
-/*
- * Convert string to uint16_t, set errno if the conversion fails or
- * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
- * prior to conversion so you can check for bad inputs by examining
- * errno immediately after the call.
- */
-uint16_t
-cvt_u16(
-	char		*s,
-	int		base)
-{
-	uint64_t	i;
-
-	i = cvt_u64(s, base);
-	if (errno)
-		return i;
-	if (i > UINT16_MAX) {
-		errno = -ERANGE;
-		return UINT16_MAX;
-	}
-	return i;
-}
-
-#define EXABYTES(x)	((long long)(x) << 60)
-#define PETABYTES(x)	((long long)(x) << 50)
-#define TERABYTES(x)	((long long)(x) << 40)
-#define GIGABYTES(x)	((long long)(x) << 30)
-#define MEGABYTES(x)	((long long)(x) << 20)
-#define KILOBYTES(x)	((long long)(x) << 10)
-
-long long
-cvtnum(
-	size_t		blocksize,
-	size_t		sectorsize,
-	char		*s)
-{
-	long long	i;
-	char		*sp;
-	int		c;
-
-	i = strtoll(s, &sp, 0);
-	if (i == 0 && sp == s)
-		return -1LL;
-	if (*sp == '\0')
-		return i;
-
-	if (sp[1] != '\0')
-		return -1LL;
-
-	c = tolower(*sp);
-	switch (c) {
-	case 'b':
-		return i * blocksize;
-	case 's':
-		return i * sectorsize;
-	case 'k':
-		return KILOBYTES(i);
-	case 'm':
-		return MEGABYTES(i);
-	case 'g':
-		return GIGABYTES(i);
-	case 't':
-		return TERABYTES(i);
-	case 'p':
-		return PETABYTES(i);
-	case 'e':
-		return  EXABYTES(i);
-	}
-	return -1LL;
-}
-
-#define TO_EXABYTES(x)	((x) / EXABYTES(1))
-#define TO_PETABYTES(x)	((x) / PETABYTES(1))
-#define TO_TERABYTES(x)	((x) / TERABYTES(1))
-#define TO_GIGABYTES(x)	((x) / GIGABYTES(1))
-#define TO_MEGABYTES(x)	((x) / MEGABYTES(1))
-#define TO_KILOBYTES(x)	((x) / KILOBYTES(1))
-
-void
-cvtstr(
-	double		value,
-	char		*str,
-	size_t		size)
-{
-	char		*fmt;
-	int		precise;
-
-	precise = ((double)value * 1000 == (double)(int)value * 1000);
-
-	if (value >= EXABYTES(1)) {
-		fmt = precise ? "%.f EiB" : "%.3f EiB";
-		snprintf(str, size, fmt, TO_EXABYTES(value));
-	} else if (value >= PETABYTES(1)) {
-		fmt = precise ? "%.f PiB" : "%.3f PiB";
-		snprintf(str, size, fmt, TO_PETABYTES(value));
-	} else if (value >= TERABYTES(1)) {
-		fmt = precise ? "%.f TiB" : "%.3f TiB";
-		snprintf(str, size, fmt, TO_TERABYTES(value));
-	} else if (value >= GIGABYTES(1)) {
-		fmt = precise ? "%.f GiB" : "%.3f GiB";
-		snprintf(str, size, fmt, TO_GIGABYTES(value));
-	} else if (value >= MEGABYTES(1)) {
-		fmt = precise ? "%.f MiB" : "%.3f MiB";
-		snprintf(str, size, fmt, TO_MEGABYTES(value));
-	} else if (value >= KILOBYTES(1)) {
-		fmt = precise ? "%.f KiB" : "%.3f KiB";
-		snprintf(str, size, fmt, TO_KILOBYTES(value));
-	} else {
-		snprintf(str, size, "%f bytes", value);
-	}
-}
-
-#define MINUTES_TO_SECONDS(m)	((m) * 60)
-#define HOURS_TO_SECONDS(h)	((h) * MINUTES_TO_SECONDS(60))
-#define DAYS_TO_SECONDS(d)	((d) * HOURS_TO_SECONDS(24))
-#define WEEKS_TO_SECONDS(w)	((w) * DAYS_TO_SECONDS(7))
-
-unsigned long
-cvttime(
-	char		*s)
-{
-	unsigned long	i;
-	char		*sp;
-
-	i = strtoul(s, &sp, 0);
-	if (i == 0 && sp == s)
-		return 0;
-	if (*sp == '\0')
-		return i;
-	if ((*sp == 'm' && sp[1] == '\0') ||
-	    (strcmp(sp, "minutes") == 0) ||
-	    (strcmp(sp, "minute") == 0))
-		return MINUTES_TO_SECONDS(i);
-	if ((*sp == 'h' && sp[1] == '\0') ||
-	    (strcmp(sp, "hours") == 0) ||
-	    (strcmp(sp, "hour") == 0))
-		return HOURS_TO_SECONDS(i);
-	if ((*sp == 'd' && sp[1] == '\0') ||
-	    (strcmp(sp, "days") == 0) ||
-	    (strcmp(sp, "day") == 0))
-		return DAYS_TO_SECONDS(i);
-	if ((*sp == 'w' && sp[1] == '\0') ||
-	    (strcmp(sp, "weeks") == 0) ||
-	    (strcmp(sp, "week") == 0))
-		return WEEKS_TO_SECONDS(i);
-	return 0;
-}
-
-struct timeval
-tadd(struct timeval t1, struct timeval t2)
-{
-	t1.tv_usec += t2.tv_usec;
-	if (t1.tv_usec > 1000000) {
-		t1.tv_usec -= 1000000;
-		t1.tv_sec++;
-	}
-	t1.tv_sec += t2.tv_sec;
-	return t1;
-}
-
 struct timeval
 tsub(struct timeval t1, struct timeval t2)
 {
@@ -513,79 +211,6 @@ timespec_from_string(
 	return 0;
 }
 
-/*
- * Convert from arbitrary user strings into a numeric ID.
- * If it's all numeric, we convert that inplace, else we do
- * the name lookup, and return the found identifier.
- */
-
-prid_t
-prid_from_string(
-	char		*project)
-{
-	fs_project_t	*prj;
-	unsigned long	prid_long;
-	char		*sp;
-
-	/*
-	 * Allow either a full numeric or a valid projectname, even
-	 * if it starts with a digit.
-	 */
-	prid_long = strtoul(project, &sp, 10);
-	if (*project != '\0' && *sp == '\0') {
-		if ((prid_long == ULONG_MAX && errno == ERANGE)
-				|| (prid_long > (prid_t)-1))
-			return -1;
-		return (prid_t)prid_long;
-	}
-	prj = getprnam(project);
-	if (prj)
-		return prj->pr_prid;
-	return -1;
-}
-
-uid_t
-uid_from_string(
-	char		*user)
-{
-	struct passwd	*pwd;
-	unsigned long	uid_long;
-	char		*sp;
-
-	uid_long = strtoul(user, &sp, 10);
-	if (sp != user && *sp == '\0') {
-		if ((uid_long == ULONG_MAX && errno == ERANGE)
-				|| (uid_long > (uid_t)-1))
-			return -1;
-		return (uid_t)uid_long;
-	}
-	pwd = getpwnam(user);
-	if (pwd)
-		return pwd->pw_uid;
-	return -1;
-}
-
-gid_t
-gid_from_string(
-	char		*group)
-{
-	struct group	*grp;
-	unsigned long	gid_long;
-	char		*sp;
-
-	gid_long = strtoul(group, &sp, 10);
-	if (sp != group && *sp == '\0') {
-		if ((gid_long == ULONG_MAX && errno == ERANGE)
-				|| (gid_long > (gid_t)-1))
-			return -1;
-		return (gid_t)gid_long;
-	}
-	grp = getgrnam(group);
-	if (grp)
-		return grp->gr_gid;
-	return -1;
-}
-
 bool isdigits_only(
 	const char *str)
 {
diff --git a/quota/Makefile b/quota/Makefile
index 9c6411e..120af2e 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -14,8 +14,8 @@ CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
 
-LLDLIBS = $(LIBXCMD)
-LTDEPENDENCIES = $(LIBXCMD)
+LLDLIBS = $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 95ec3c0..8b31030 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
 CFILES = init.c file.c prealloc.c trim.c
 
-LLDLIBS = $(LIBXCMD)
-LTDEPENDENCIES = $(LIBXCMD)
+LLDLIBS = $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_READLINE),yes)
