Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71LwTZG032358 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 16:58:29 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 966B84C500A
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 14:58:28 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 1J7PYX6nKPQ2ragc for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2011 14:58:28 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Build using CFLAGS passed in at configure
Date: Mon,  1 Aug 2011 17:58:24 -0400
Message-Id: <1312235904-21187-1-git-send-email-tytso@mit.edu>
In-Reply-To: <20110730165517.GA13918@infradead.org>
References: <20110730165517.GA13918@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: hch@infradead.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

In order to build xfsprogs in a hermetic build, we need be able to
pass in -I and -L flags to the compiler and linker, respectively.
This needs to be used by the configure script, but we also need to
make sure these flags are used by the Makefiles as well.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/builddefs.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 4c8ec64..81ebfcd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
+CFLAGS = @CFLAGS@
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
