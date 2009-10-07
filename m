Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97IpNbq204301 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 13:51:24 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C165BD8F57
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 11:52:48 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id j4p89F8x7Yp0AA5P for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 11:52:48 -0700 (PDT)
Message-ID: <4ACCE37F.4070006@sandeen.net>
Date: Wed, 07 Oct 2009 13:52:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: allow using libblkid instead of libdisk
References: <20091006185252.GA10250@infradead.org>
In-Reply-To: <20091006185252.GA10250@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: util-linux-ng@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Add a new --enable-blkid switch to use libblkid from util-linux to detect
> the device geometry and check for existing partitions or filesystem on a
> device.  Note that this requires the latest blkid from util-linux-ng git
> for the topology calls, odler ones won't work.  If I had a little more
> autoconf fu we might be able to detect a too early one, but right now it
> just fails if it's too old and --enable-blkid is specified.

Here's some autoconf fu to check for blkid topo support; this changes it to
default to using blkid, optionally disable-able, and disables it automatically
if the topo stuff isn't found (I think ;)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/configure.in b/configure.in
index 78ac522..f75fad1 100644
--- a/configure.in
+++ b/configure.in
@@ -35,11 +35,10 @@ AC_ARG_ENABLE(termcap,
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
 AC_SUBST(libtermcap)
 
+# AC_HAVE_BLKID_TOPO below wil find the library & check for topo support
 AC_ARG_ENABLE(blkid,
-[ --enable-blkid=[yes/no] Enable block device id library [default=no]],
-	test $enable_blkid = yes && libblkid="-lblkid",)
-AC_SUBST(libblkid)
-AC_SUBST(enable_blkid)
+[ --enable-blkid=[yes/no] Enable block device id library [default=yes]],,
+	enable_blkid=yes)
 
 AC_ARG_ENABLE(lib64,
 [ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
@@ -96,6 +95,7 @@ AC_HAVE_SENDFILE
 AC_HAVE_GETMNTENT
 AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
+AC_HAVE_BLKID_TOPO($enable_blkid)
 
 AC_TYPE_PSINT
 AC_TYPE_PSUNSIGNED
diff --git a/m4/package_blkid.m4 b/m4/package_blkid.m4
new file mode 100644
index 0000000..44ca2cc
--- /dev/null
+++ b/m4/package_blkid.m4
@@ -0,0 +1,20 @@
+#
+# See if blkid has the topology bits
+#
+
+AC_DEFUN([AC_HAVE_BLKID_TOPO],
+[
+  enable_blkid="$1"
+  if test "$enable_blkid" = "yes"; then
+    AC_SEARCH_LIBS([blkid_probe_all], [blkid])
+    AC_CHECK_FUNCS(blkid_probe_get_topology)
+    if test $ac_cv_func_blkid_probe_get_topology = yes; then
+      libblkid="-lblkid"
+    else
+      libblkd=""
+      enable_blkid="no"
+      AC_SUBST(enable_blkid)
+    fi
+  fi
+  AC_SUBST(libblkid)
+])

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
