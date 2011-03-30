Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UHnVvD063901 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 12:49:31 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B4FC30408E
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 10:52:40 -0700 (PDT)
Subject: xfsprogs: avoid dot-directories when configuring
From: Alex Elder <aelder@sgi.com>
Date: Wed, 30 Mar 2011 12:52:39 -0500
Message-ID: <1301507559.2953.12.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

The "find" command used in the configure script to find localized
files searches through directories (including .git and .pc) that
really should be ignored.  Change it so it skips over these
directories.

I think it's reasonable to assume any such "dot directory" should be
ignored, so this change skips any directory at the top level whose
name begins with ".".  

Note that I found an odd anomaly in "find".  If you do not supply
the "-print" argument, the pruned directory names show up in the
output.  Supplying "-print" does not include them (and that's what
we want).

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 configure.in |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/configure.in
===================================================================
--- a/configure.in
+++ b/configure.in
@@ -76,9 +76,12 @@ esac
 AC_SUBST([root_sbindir])
 AC_SUBST([root_libdir])
 
-# Find localized files
+# Find localized files.  Don't descend into any "dot directories"
+# (like .git or .pc from quilt).  Strangely, the "-print" argument
+# to "find" is required, to avoid including such directories in the
+# list.
 LOCALIZED_FILES=""
-for lfile in `find ${srcdir} -name '*.c' -type f || exit 1`; do
+for lfile in `find ${srcdir} -path './.??*' -prune -o -name '*.c' -type f -print || exit 1`; do
     LOCALIZED_FILES="$LOCALIZED_FILES \$(TOPDIR)/$lfile"
 done
 AC_SUBST(LOCALIZED_FILES)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
