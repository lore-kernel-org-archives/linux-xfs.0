Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 10:47:27 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9SHlJTC013644
	for <linux-xfs@oss.sgi.com>; Sun, 28 Oct 2007 10:47:20 -0700
From: Andreas Gruenbacher <agruen@suse.de>
Subject: attr: xattr.conf
Date: Sun, 28 Oct 2007 18:38:10 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CkMJHqRsX6Tc6k/"
Message-Id: <200710281838.10658.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>

--Boundary-00=_CkMJHqRsX6Tc6k/
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

here is another patch which for some reason didn't get merged into the 
upstream version: the current attribute copying functions attr_copy_file and 
attr_copy_fd is a static list of exceptions for attributes that need special 
treatment. The list of those attributes tends to change (slowly) with kernel 
versions. We replaced the static list with a config file a while ago; this is 
the patch used. Any objections to merging this into the upstream version as 
well?

Attached is the patch, and an xattr.conf example.

Thanks,
Andreas

--Boundary-00=_CkMJHqRsX6Tc6k/
Content-Type: text/plain;
  charset="us-ascii";
  name="xattr.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xattr.conf"

# /etc/xattr.conf
#
# How to handle extended attributes when copying between files
#
# Format:
# <pattern> <action>
#
# Actions:
#   permissions - copy when trying to preserve permissions.
#   skip - do not copy.

system.nfs4_acl			permissions
system.nfs4acl			permissions
system.posix_acl_access		permissions
system.posix_acl_default	permissions
trusted.SGI_ACL_DEFAULT		skip		# xfs specific
trusted.SGI_ACL_FILE		skip		# xfs specific
trusted.SGI_CAP_FILE		skip		# xfs specific
trusted.SGI_DMI_*		skip		# xfs specific
trusted.SGI_MAC_FILE		skip		# xfs specific
xfsroot.*			skip		# xfs specific; obsolete
user.Beagle.*			skip		# ignore Beagle index data

--Boundary-00=_CkMJHqRsX6Tc6k/
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xattr_conf.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xattr_conf.diff"

Index: attr-2.4.39/libattr/Makefile
===================================================================
--- attr-2.4.39.orig/libattr/Makefile
+++ attr-2.4.39/libattr/Makefile
@@ -12,7 +12,7 @@ LT_CURRENT = 2
 LT_REVISION = 0
 LT_AGE = 1
 
-CFILES = libattr.c attr_copy_fd.c attr_copy_file.c attr_copy_check.c
+CFILES = libattr.c attr_copy_fd.c attr_copy_file.c attr_copy_check.c attr_copy_action.c
 HFILES = libattr.h
 
 ifeq ($(PKG_PLATFORM),linux)
Index: attr-2.4.39/libattr/attr_copy_action.c
===================================================================
--- /dev/null
+++ attr-2.4.39/libattr/attr_copy_action.c
@@ -0,0 +1,163 @@
+/* Copyright (C) 2006 Andreas Gruenbacher <agruen@suse.de>, SuSE Linux AG.
+
+  This program is free software; you can redistribute it and/or
+  modify it under the terms of the GNU Lesser General Public
+  License as published by the Free Software Foundation; either
+  version 2 of the License, or (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  Lesser General Public License for more details.
+
+  You should have received a copy of the GNU Lesser General Public
+  License along with this library; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+*/
+
+#include <alloca.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <stdarg.h>
+#include <fnmatch.h>
+
+#include "attr/libattr.h"
+#define ERROR_CONTEXT_MACROS
+#include "error_context.h"
+
+#define ATTR_CONF "/etc/xattr.conf"
+
+struct attr_action {
+	struct attr_action *next;
+	char *pattern;
+	int action;
+};
+
+static struct attr_action *attr_actions;
+
+static void
+free_attr_actions(void)
+{
+	struct attr_action *tmp;
+
+	while (attr_actions) {
+		tmp = attr_actions->next;
+		free(attr_actions->pattern);
+		free(attr_actions);
+		attr_actions = tmp;
+	}
+}
+
+static int
+attr_parse_attr_conf(struct error_context *ctx)
+{
+	char *text, *t;
+	size_t size_guess = 4096, len;
+	FILE *file;
+	char *pattern = NULL;
+	struct attr_action *new;
+	int action;
+
+	if (attr_actions)
+		return 0;
+
+repeat:
+	text = malloc(size_guess + 1);
+	if (!text)
+		goto fail;
+
+	if ((file = fopen(ATTR_CONF, "r")) == NULL) {
+		if (errno == ENOENT)
+			return 0;
+		goto fail;
+	}
+	len = fread(text, 1, size_guess, file);
+	if (ferror(file))
+		goto fail;
+	if (!feof(file)) {
+		fclose(file);
+		file = NULL;
+		free(text);
+		size_guess *= 2;
+		goto repeat;
+	}
+	fclose(file);
+	file = NULL;
+
+	text[len] = 0;
+	t = text;
+	for (;;) {
+		t += strspn(t, " \t\n");
+		len = strcspn(t, " \t\n#");
+		if (t[len] == '#') {
+			if (len)
+				goto parse_error;
+			t += strcspn(t, "\n");
+			continue;
+		} else if (t[len] == 0)
+			break;
+		else if (t[len] == '\n')
+			goto parse_error;
+		pattern = strndup(t, len);
+		if (!pattern)
+			goto fail;
+		t += len;
+
+		t += strspn(t, " \t");
+		len = strcspn(t, " \t\n#");
+		if (len == 4 && !strncmp(t, "skip", 4))
+			action = ATTR_ACTION_SKIP;
+		else if (len == 11 && !strncmp(t, "permissions", 11))
+			action = ATTR_ACTION_PERMISSIONS;
+		else
+			goto parse_error;
+		t += len;
+		t += strspn(t, " \t");
+		if (*t != '#' && *t != '\n')
+			goto parse_error;
+
+		new = malloc(sizeof(struct attr_action));
+		if (!new)
+			goto parse_error;
+		new->next = attr_actions;
+		new->pattern = pattern;
+		new->action = action;
+		attr_actions = new;
+
+		t += strcspn(t, "\n");
+	}
+	return 0;
+
+parse_error:
+	errno = EINVAL;
+
+fail:
+	{
+		const char *q = quote (ctx, ATTR_CONF);
+		error (ctx, "%s", q);
+		quote_free (ctx, q);
+	}
+
+	free(pattern);
+	if (file)
+		fclose(file);
+	free(text);
+	free_attr_actions();
+	return -1;
+}
+
+int
+attr_copy_action(const char *name, struct error_context *ctx)
+{
+	struct attr_action *action = attr_actions;
+
+	if (!attr_parse_attr_conf(ctx)) {
+		for (action = attr_actions; action; action = action->next) {
+			if (!fnmatch(action->pattern, name, 0))
+				return action->action;
+		}
+	}
+	return 0;
+}
Index: attr-2.4.39/libattr/attr_copy_fd.c
===================================================================
--- attr-2.4.39.orig/libattr/attr_copy_fd.c
+++ attr-2.4.39/libattr/attr_copy_fd.c
@@ -119,7 +119,7 @@ attr_copy_fd(const char *src_path, int s
 			quote_free (ctx, qname);
 			quote_free (ctx, qpath);
 			ret = -1;
-			continue;  /* may not have permission to access */
+			continue;
 		}
 		value = (char *) realloc (old_value = value, size);
 		if (size != 0 && value == NULL) {
@@ -136,6 +136,7 @@ attr_copy_fd(const char *src_path, int s
 			quote_free (ctx, qname);
 			quote_free (ctx, qpath);
 			ret = -1;
+			continue;
 		}
 		if (fsetxattr (dst_fd, name, value, size, 0) != 0) {
 			if (errno == ENOTSUP)
Index: attr-2.4.39/libattr/attr_copy_file.c
===================================================================
--- attr-2.4.39.orig/libattr/attr_copy_file.c
+++ attr-2.4.39/libattr/attr_copy_file.c
@@ -117,7 +117,7 @@ attr_copy_file(const char *src_path, con
 			quote_free (ctx, qname);
 			quote_free (ctx, qpath);
 			ret = -1;
-			continue;  /* may not have permission to access */
+			continue;
 		}
 		value = (char *) realloc (old_value = value, size);
 		if (size != 0 && value == NULL) {
@@ -134,6 +134,7 @@ attr_copy_file(const char *src_path, con
 			quote_free (ctx, qname);
 			quote_free (ctx, qpath);
 			ret = -1;
+			continue;
 		}
 		if (lsetxattr (dst_path, name, value, size, 0) != 0) {
 			if (errno == ENOTSUP)
Index: attr-2.4.39/libattr/attr_copy_check.c
===================================================================
--- attr-2.4.39.orig/libattr/attr_copy_check.c
+++ attr-2.4.39/libattr/attr_copy_check.c
@@ -23,32 +23,6 @@
 int
 attr_copy_check_permissions(const char *name, struct error_context *ctx)
 {
-	/* Skip POSIX ACLs. */
-	if (strncmp(name, "system.posix_acl_", 17) == 0 &&
-	    (strcmp(name+17, "access") == 0 ||
-	     strcmp(name+17, "default") == 0))
-		return 0;
-
-	/* Skip permissions attributes which are used on IRIX, and
-	   hence are part of the XFS ondisk format (incl. ACLs).
-	   Also skip SGI DMF attributes as they are inappropriate
-	   targets for copying over as well. */
-	if (strncmp(name, "trusted.SGI_", 12) == 0 &&
-	    (strcmp(name+12, "ACL_DEFAULT") == 0 ||
-	     strcmp(name+12, "ACL_FILE") == 0 ||
-	     strcmp(name+12, "CAP_FILE") == 0 ||
-	     strcmp(name+12, "MAC_FILE") == 0 ||
-	     strncmp(name+12, "DMI_", 4) == 0))
-		return 0;
-
-	/* The xfsroot namespace mirrored attributes, some of which
-	   are also also available via the system.* and trusted.*
-	   namespaces.  To avoid the problems this would cause,
-	   we skip xfsroot altogether.
-	   Note: xfsroot namespace has now been removed from XFS. */
-	if (strncmp(name, "xfsroot.", 8) == 0)
-		return 0;
-
-	return 1;
+	return attr_copy_action(name, ctx) == 0;
 }
 
Index: attr-2.4.39/include/libattr.h
===================================================================
--- attr-2.4.39.orig/include/libattr.h
+++ attr-2.4.39/include/libattr.h
@@ -14,9 +14,14 @@ extern int attr_copy_fd (const char *, i
 			 int (*) (const char *, struct error_context *),
 			 struct error_context *);
 
-/* The default check function used by attr_copy_{fd,file}. */
+/* Keep this function for backwards compatibility. */
 extern int attr_copy_check_permissions(const char *, struct error_context *);
 
+#define ATTR_ACTION_SKIP	1
+#define ATTR_ACTION_PERMISSIONS	2
+
+extern int attr_copy_action(const char *, struct error_context *);
+
 #ifdef __cplusplus
 }
 #endif

--Boundary-00=_CkMJHqRsX6Tc6k/--
