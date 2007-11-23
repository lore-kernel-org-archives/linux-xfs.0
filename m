Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 04:24:55 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANCOaxQ014561
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2007 04:24:43 -0800
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: acl and attr: Fix path walking code
Date: Fri, 23 Nov 2007 13:24:40 +0100
References: <200710281858.24428.agruen@suse.de> <473A82E6.50709@sgi.com> <47426C70.3070704@sgi.com>
In-Reply-To: <47426C70.3070704@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IasRH48hyGEZElM"
Message-Id: <200711231324.40494.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

--Boundary-00=_IasRH48hyGEZElM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 20 November 2007 06:11:12 Timothy Shimmin wrote:
> Okay, looked at the code.
>
> ---
>
> no -h => stat, getxattr, listxattr
> -h    => lstat, lgetxattr, llistxattr

Yes.

> -P => skip symlinks (as soon as see them, then return from place in walk)

No, -h never skips symlinks. (But depending on -L and -P, it may not follow 
symlinks to directories.) Here is an additional comment for do_print, and an 
equivalent version of the if in there. I hope that this will finally clarify 
the code.

> it would be nicer to have more explanation in the man page.

Agreed. How about the attached manpage patches?

Thanks,
Andreas

--Boundary-00=_IasRH48hyGEZElM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="equivalent-version.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="equivalent-version.diff"

Index: attr-2.4.39/getfattr/getfattr.c
===================================================================
--- attr-2.4.39.orig/getfattr/getfattr.c
+++ attr-2.4.39/getfattr/getfattr.c
@@ -355,14 +355,15 @@ int do_print(const char *path, const str
 		return 1;
 	}
 
-	 /*
-	 * When doing a physical walk or neither doing a logical walk nor processing a
-	 * direct command like argument, do not dereference symlinks.
+	/*
+	 * Only dereference symlinks when doing a logical walk, or when procesing
+	 * a direct command-line argument while not doing a physical walk.
 	 */
 	if ((walk_flags & WALK_TREE_SYMLINK) &&
 	    (walk_flags & WALK_TREE_DEREFERENCE) &&
+	    !(walk_flags & WALK_TREE_LOGICAL) &&
 	    ((walk_flags & WALK_TREE_PHYSICAL) ||
-	    !(walk_flags & (WALK_TREE_TOPLEVEL | WALK_TREE_LOGICAL))))
+	     !(walk_flags & (WALK_TREE_TOPLEVEL))))
 		return 0;
 
 	if (opt_name)

--Boundary-00=_IasRH48hyGEZElM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="comment.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="comment.diff"

Index: attr-2.4.39/getfattr/getfattr.c
===================================================================
--- attr-2.4.39.orig/getfattr/getfattr.c
+++ attr-2.4.39/getfattr/getfattr.c
@@ -355,6 +355,10 @@ int do_print(const char *path, const str
 		return 1;
 	}
 
+	 /*
+	 * When doing a physical walk or neither doing a logical walk nor processing a
+	 * direct command like argument, do not dereference symlinks.
+	 */
 	if ((walk_flags & WALK_TREE_SYMLINK) &&
 	    (walk_flags & WALK_TREE_DEREFERENCE) &&
 	    ((walk_flags & WALK_TREE_PHYSICAL) ||

--Boundary-00=_IasRH48hyGEZElM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="man-acl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="man-acl.diff"

Index: acl-2.2.45/man/man1/getfacl.1
===================================================================
--- acl-2.2.45.orig/man/man1/getfacl.1
+++ acl-2.2.45/man/man1/getfacl.1
@@ -100,13 +100,14 @@ Skip files that only have the base ACL e
 List the ACLs of all files and directories recursively.
 .TP
 .I \-L, \-\-logical
-Logical walk, follow symbolic links. The default behavior is to follow
-symbolic link arguments, and to skip symbolic links encountered in
-subdirectories.
+Logical walk, follow symbolic links to directories. The default behavior is to follow
+symbolic link arguments, and skip symbolic links encountered in subdirectories.
+Only effective in combination with \-R.
 .TP
 .I \-P, \-\-physical
-Physical walk, skip all symbolic links. This also skips symbolic link
-arguments.
+Physical walk, do not follow symbolic links to directories. This also skips symbolic
+link arguments.
+Only effective in combination with \-R.
 .TP
 .I \-\-tabular
 Use an alternative tabular output format. The ACL and the default ACL are displayed side by side. Permissions that are ineffective due to the ACL mask entry are displayed capitalized. The entry tag names for the ACL_USER_OBJ and ACL_GROUP_OBJ entries are also displayed in capital letters, which helps in spotting those entries.
Index: acl-2.2.45/man/man1/setfacl.1
===================================================================
--- acl-2.2.45.orig/man/man1/setfacl.1
+++ acl-2.2.45/man/man1/setfacl.1
@@ -104,11 +104,15 @@ Test mode. Instead of changing the ACLs 
 Apply operations to all files and directories recursively. This option cannot be mixed with `\-\-restore'.
 .TP 4
 .I \-L, \-\-logical
-Logical walk, follow symbolic links. The default behavior is to follow symbolic link arguments, and to skip symbolic links encountered
-in subdirectories. This option cannot be mixed with `\-\-restore'.
+Logical walk, follow symbolic links to directories. The default behavior is to follow
+symbolic link arguments, and skip symbolic links encountered in subdirectories.
+Only effective in combination with \-R.
+This option cannot be mixed with `\-\-restore'.
 .TP 4
 .I \-P, \-\-physical
-Physical walk, skip all symbolic links. This also skips symbolic link arguments.
+Physical walk, do not follow symbolic links to directories.
+This also skips symbolic link arguments.
+Only effective in combination with \-R.
 This option cannot be mixed with `\-\-restore'.
 .TP 4
 .I \-\-version

--Boundary-00=_IasRH48hyGEZElM
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="man-attr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="man-attr.diff"

Index: attr-2.4.39/man/man1/getfattr.1
===================================================================
--- attr-2.4.39.orig/man/man1/getfattr.1
+++ attr-2.4.39/man/man1/getfattr.1
@@ -56,11 +56,8 @@ while strings encoded as hexidecimal and
 0x and 0s, respectively.
 .TP
 .BR \-h ", " \-\-no-dereference
-Do not follow symlinks.
-If
-.I pathname
-is a symbolic link, the symbolic link itself is examined,
-rather than the file the link refers to.
+Do not dereference symlinks. Instead of the file a symlink refers to, the
+symlink itself is examined.
 .TP
 .BR \-m " \f2pattern\f1, " \-\-match "=\f2pattern\f1"
 Only include attributes with names matching the regular expression
@@ -85,13 +82,15 @@ Dump out the extended attribute value(s)
 List the attributes of all files and directories recursively.
 .TP
 .BR \-L ", " \-\-logical
-Logical walk, follow symbolic links.
+Logical walk, follow symbolic links to directories.
 The default behaviour is to follow symbolic link arguments, and to 
 skip symbolic links encountered in subdirectories.
+Only effective in combination with \-R.
 .TP
 .BR \-P ", " \-\-physical
-Physical walk, skip all symbolic links.
+Physical walk, do not follow symbolic links to directories.
 This also skips symbolic link arguments.
+Only effective in combination with \-R.
 .TP
 .B \-\-version
 Print the version of

--Boundary-00=_IasRH48hyGEZElM--
