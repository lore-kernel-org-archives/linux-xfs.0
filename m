Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n24HXLhp098342 for <xfs@oss.sgi.com>; Wed, 4 Mar 2009 11:33:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D43316F5AF
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 09:32:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yKHJzt2hr49MBjf3 for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2009 09:32:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LeuxE-0000Yo-FD
	for xfs@oss.sgi.com; Wed, 04 Mar 2009 17:32:24 +0000
Date: Wed, 4 Mar 2009 12:32:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: add projects(5) and projid(5) manpages
Message-ID: <20090304173224.GB32471@infradead.org>
References: <20090224132737.GA8161@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090224132737.GA8161@infradead.org>
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

On Tue, Feb 24, 2009 at 08:27:37AM -0500, Christoph Hellwig wrote:
> Document the /etc/projects and /etc/projid files in their own manpages
> instead of in xfs_quota(8).

Doh, I forgot to quilt add projects.5, here's the complete patch:

Index: xfsprogs-dev/man/man5/projid.5
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/man/man5/projid.5	2009-03-04 18:30:40.451978384 +0100
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
--- xfsprogs-dev.orig/man/man8/xfs_quota.8	2009-03-03 16:45:43.355881326 +0100
+++ xfsprogs-dev/man/man8/xfs_quota.8	2009-03-04 18:30:40.452978791 +0100
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
Index: xfsprogs-dev/man/man5/projects.5
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/man/man5/projects.5	2009-03-04 18:31:01.456981579 +0100
@@ -0,0 +1,31 @@
+.TH projects 5
+.SH NAME
+projects \- persistent project root defintion
+.SH DESCRIPTION
+The
+.I /etc/projects
+file provides a mapping between numeric project identifiers and those directories
+which are the roots of the quota tree.  Its format is simply:
+
+.nf
+.sp
+.in +5
+# comments are hash-prefixed
+# ...
+10:/export/cage
+42:/var/log
+.in -5
+.fi
+.PP
+The
+.I /etc/projects
+file is optional, instead
+.BR xfs_quota (8)
+can be used with the
+.B \-p
+argument to specify a project root directly for each operation.
+
+.SH SEE ALSO
+.BR xfs_quota (8),
+.BR xfsctl (3),
+.BR projid (5).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
