Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725758AbeKJFKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 00:10:35 -0500
Date: Fri, 9 Nov 2018 11:28:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] make: don't spray static check failures all over the subdir
 build
Message-ID: <20181109192822.GF15721@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Debian package building is special -- it directly calls make -C libxfs
when building the debian-installer packages.  This means that any
variables we define in the top level Makefile don't get passed down to
subdir make processes.

This means that the new static checker support effectively runs the
first argument in $(CFLAGS) as a command, which is surprising.  Fix up
buildrules to patch out CHECK_CMD if nobody's defined it, so that direct
subdir make works again.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/buildrules |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/buildrules b/include/buildrules
index 83dfe05b..5c3e6eb9 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -36,6 +36,10 @@ $(SUBDIRS):
 	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
 endif
 
+ifndef CHECK_CMD
+CHECK_CMD = @true
+endif
+
 #
 # Standard targets
 #
