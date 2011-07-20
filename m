Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KHxLwB241330 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 12:59:21 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64654EE835E
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 10:59:20 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id U5alsEt5xreHbeyq for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 10:59:20 -0700 (PDT)
Date: Wed, 20 Jul 2011 13:59:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Problems building xfsprogs
Message-ID: <20110720175918.GB17971@thunk.org>
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

I was trying to build xfsprogs in preparation for building xfstests in
an hermetic environment (as opposed to depending on magic XFS headers
being installed in /usr/include...)

What I found first of all (building on Ubuntu 10.10) was

a) "make configure" doesn't work until I patch the top-level Makefile:

diff --git a/Makefile b/Makefile
index c40fb2c..37973f5 100644
--- a/Makefile
+++ b/Makefile
@@ -82,7 +82,7 @@ configure:
 	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
 	cp include/install-sh .
 	aclocal -I m4
-	autoconf
+	autoconf -I m4
 
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS

b) By default xfsprogs builds with DEBUG, and this causes building
libxfs/xfs_ialloc.c to blow up since there a reference of
xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
two figure this out....

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
