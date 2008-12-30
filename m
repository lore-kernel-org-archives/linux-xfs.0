Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUIElPC000557 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:14:48 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21CFC5312F
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:46 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 2WSiaSlsClIDb6xb for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 10:14:46 -0800 (PST)
Message-Id: <20081230181445.849221920@sandeen.net>
References: <20081230181413.518122170@sandeen.net>
Date: Tue, 30 Dec 2008 12:14:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 1/4] acl: add short option support to the acl commands.
Content-Disposition: inline; filename=acl-2.2.47-params.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Resolves Red Hat bugs:
 204087 -  getfacl/setfacl should support -n
 457244 -  setfacl does not recognize -v and -h

From: Jiri Moskovcak <jmoskovc@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: xfs-cmds/acl/getfacl/getfacl.c
===================================================================
--- xfs-cmds.orig/acl/getfacl/getfacl.c
+++ xfs-cmds/acl/getfacl/getfacl.c
@@ -43,7 +43,7 @@
 #define POSIXLY_CORRECT_STR "POSIXLY_CORRECT"
 
 #if !POSIXLY_CORRECT
-#  define CMD_LINE_OPTIONS "dRLP"
+#  define CMD_LINE_OPTIONS "aceEsRLPtpndvh"
 #endif
 #define POSIXLY_CMD_LINE_OPTIONS "d"
 
@@ -555,23 +555,23 @@ void help(void)
 #if !POSIXLY_CORRECT
 	} else {
 		printf(_(
-"      --access            display the file access control list only\n"
+"  -a,  --access           display the file access control list only\n"
 "  -d, --default           display the default access control list only\n"
-"      --omit-header       do not display the comment header\n"
-"      --all-effective     print all effective rights\n"
-"      --no-effective      print no effective rights\n"
-"      --skip-base         skip files that only have the base entries\n"
+"  -c, --omit-header       do not display the comment header\n"
+"  -e, --all-effective     print all effective rights\n"
+"  -E, --no-effective      print no effective rights\n"
+"  -s, --skip-base         skip files that only have the base entries\n"
 "  -R, --recursive         recurse into subdirectories\n"
 "  -L, --logical           logical walk, follow symbolic links\n"
 "  -P, --physical          physical walk, do not follow symbolic links\n"
-"      --tabular           use tabular output format\n"
-"      --numeric           print numeric user/group identifiers\n"
-"      --absolute-names    don't strip leading '/' in pathnames\n"));
+"  -t, --tabular           use tabular output format\n"
+"  -n, --numeric           print numeric user/group identifiers\n"
+"  -p, --absolute-names    don't strip leading '/' in pathnames\n"));
 	}
 #endif
 	printf(_(
-"      --version           print version and exit\n"
-"      --help              this help text\n"));
+"  -v, --version           print version and exit\n"
+"  -h, --help              this help text\n"));
 }
 
 int main(int argc, char *argv[])
Index: xfs-cmds/acl/man/man1/getfacl.1
===================================================================
--- xfs-cmds.orig/acl/man/man1/getfacl.1
+++ xfs-cmds/acl/man/man1/getfacl.1
@@ -12,10 +12,10 @@ getfacl \- get file access control lists
 .SH SYNOPSIS
 
 .B getfacl
-[\-dRLPvh] file ...
+[\-aceEsRLPrpndvh] file ...
 
 .B getfacl
-[\-dRLPvh] \-
+[\-aceEsRLPrpndvh] \-
 
 .SH DESCRIPTION
 For each file, getfacl displays the file name, owner, the group,
@@ -78,22 +78,22 @@ accessing the file mode.
 
 .SS OPTIONS
 .TP 4
-.I \-\-access
+.I \-a, \-\-access
 Display the file access control list.
 .TP
 .I \-d, \-\-default
 Display the default access control list.
 .TP
-.I \-\-omit-header
+.I \-c, \-\-omit-header
 Do not display the comment header (the first three lines of each file's output).
 .TP
-.I \-\-all-effective
+.I \-e, \-\-all-effective
 Print all effective rights comments, even if identical to the rights defined by the ACL entry.
 .TP
-.I \-\-no-effective
+.I \-E, \-\-no-effective
 Do not print effective rights comments.
 .TP
-.I \-\-skip-base
+.I \-s, \-\-skip-base
 Skip files that only have the base ACL entries (owner, group, others).
 .TP
 .I \-R, \-\-recursive
@@ -109,17 +109,20 @@ Physical walk, do not follow symbolic li
 link arguments.
 Only effective in combination with \-R.
 .TP
-.I \-\-tabular
+.I \-t, \-\-tabular
 Use an alternative tabular output format. The ACL and the default ACL are displayed side by side. Permissions that are ineffective due to the ACL mask entry are displayed capitalized. The entry tag names for the ACL_USER_OBJ and ACL_GROUP_OBJ entries are also displayed in capital letters, which helps in spotting those entries.
 .TP
-.I \-\-absolute-names
+.I \-p, \-\-absolute-names
 Do not strip leading slash characters (`/'). The default behavior is to
 strip leading slash characters.
 .TP
-.I \-\-version
+.I \-n, \-\-numeric
+List numeric user and group IDs
+.TP
+.I \-v, \-\-version
 Print the version of getfacl and exit.
 .TP
-.I \-\-help
+.I \-h, \-\-help
 Print help explaining the command line options.
 .TP
 .I \-\-
Index: xfs-cmds/acl/man/man1/setfacl.1
===================================================================
--- xfs-cmds.orig/acl/man/man1/setfacl.1
+++ xfs-cmds/acl/man/man1/setfacl.1
@@ -115,10 +115,10 @@ This also skips symbolic link arguments.
 Only effective in combination with \-R.
 This option cannot be mixed with `\-\-restore'.
 .TP 4
-.I \-\-version
+.I \-v, \-\-version
 Print the version of setfacl and exit.
 .TP 4
-.I \-\-help
+.I \-h, \-\-help
 Print help explaining the command line options.
 .TP 4
 .I \-\-
Index: xfs-cmds/acl/setfacl/setfacl.c
===================================================================
--- xfs-cmds.orig/acl/setfacl/setfacl.c
+++ xfs-cmds/acl/setfacl/setfacl.c
@@ -42,10 +42,10 @@ extern int do_set(const char *path_p, co
 
 /* '-' stands for `process non-option arguments in loop' */
 #if !POSIXLY_CORRECT
-#  define CMD_LINE_OPTIONS "-:bkndm:M:x:X:RLP"
+#  define CMD_LINE_OPTIONS "-:bkndvhm:M:x:X:RLP"
 #  define CMD_LINE_SPEC "[-bkndRLP] { -m|-M|-x|-X ... } file ..."
 #endif
-#define POSIXLY_CMD_LINE_OPTIONS "-:bkndm:M:x:X:"
+#define POSIXLY_CMD_LINE_OPTIONS "-:bkndvhm:M:x:X:"
 #define POSIXLY_CMD_LINE_SPEC "[-bknd] {-m|-M|-x|-X ... } file ..."
 
 struct option long_options[] = {
@@ -263,8 +263,8 @@ void help(void)
 	}
 #endif
 	printf(_(
-"      --version           print version and exit\n"
-"      --help              this help text\n"));
+"  -v, --version           print version and exit\n"
+"  -h, --help              this help text\n"));
 }
 
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
