Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ODSbxo144630 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:28:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E7C1148055
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:28:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id agAHE7ANAoMfjqi4 for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:28:07 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LbxJx-0003cM-8x
	for xfs@oss.sgi.com; Tue, 24 Feb 2009 13:27:37 +0000
Date: Tue, 24 Feb 2009 08:27:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: add projects(5) and projid(5) manpages
Message-ID: <20090224132737.GA8161@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Document the /etc/projects and /etc/projid files in their own manpages
instead of in xfs_quota(8).


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/man/man5/projid.5
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/man/man5/projid.5	2009-02-23 21:33:15.289051004 +0100
@@ -0,0 +1,29 @@
+.TH projid 5
+.SH NAME
+projid \- the project name mapping file
+.SH DESCRIPTION
+The
+.I /etc/projid
+file provides a mapping between numeric project identifiers and a
+simple human readable name (similar relationship to the one that
+exists between usernames and uids).
+Its format is simply:
+.nf
+.sp
+.in +5
+# comments are hash-prefixed
+# ...
+cage:10
+logfiles:42
+
+.in -5
+.fi
+.PP
+
+This file is optional, if a project identifier cannot be mapped to
+a name, it will be parsed and displayed as a numeric value.
+
+.SH SEE ALSO
+.BR xfs_quota (8),
+.BR xfsctl (3),
+.BR projects (5).
Index: xfsprogs-dev/man/man8/xfs_quota.8
===================================================================
--- xfsprogs-dev.orig/man/man8/xfs_quota.8	2009-02-23 21:35:34.889050486 +0100
+++ xfsprogs-dev/man/man8/xfs_quota.8	2009-02-23 21:36:25.138929778 +0100
@@ -628,46 +628,6 @@ for
 .I /etc/projects
 to exist. Note that if projects file exists then it is also used.
 
-.SH FILE FORMATS
-There are two files involved with the tree quota mechanism, namely
-.I /etc/projects
-and
-.IR /etc/projid .
-The latter is optional.
-The
-.I /etc/projects
-file provides a mapping between numeric project identifiers and those
-directories which are the roots of the quota tree.
-Its format is simply:
-.nf
-.sp
-.in +5
-# comments are hash-prefixed
-# ...
-10:/export/cage
-42:/var/log
-.in -5
-.fi
-.PP
-The
-.I /etc/projid
-file provides a mapping between numeric project identifiers and a
-simple human readable name (similar relationship to the one that
-exists between usernames and uids).
-Its format is simply:
-.nf
-.sp
-.in +5
-# comments are hash-prefixed
-# ...
-cage:10
-logfiles:42
-.in -5
-.fi
-.PP
-This file is optional, if a project identifier cannot be mapped to
-a name, it will be displayed as a number only.
-.PP
 .SH EXAMPLES
 Enabling quota enforcement on an XFS filesystem (restrict a user
 to a set amount of space).
@@ -752,4 +712,6 @@ Mapping of numeric project identifiers t
 .SH SEE ALSO
 .BR df (1),
 .BR mount (1),
-.BR sync (2).
+.BR sync (2),
+.BR projid (5),
+.BR projects (5).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
