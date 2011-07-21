Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LNq72a049999 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:52:07 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C9C61D8A721
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:52:05 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id LgJGE3TLz2XKvoAl for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:52:05 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH XFSTESTS 3/3] dmapi: fix build failure if libdm is provided
	via -ldm
Date: Thu, 21 Jul 2011 19:52:04 -0400
Message-Id: <1311292324-4348-3-git-send-email-tytso@mit.edu>
In-Reply-To: <1311292324-4348-1-git-send-email-tytso@mit.edu>
References: <1311292324-4348-1-git-send-email-tytso@mit.edu>
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>

The value of $(LIBDM) may be a linker specification -ldm, and not a
file.  So it's not OK to add this to the dependency, since make will
then complain that it doesn't know how to make the target -ldm.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 dmapi/src/common/cmd/Makefile                  |    2 +-
 dmapi/src/sample_hsm/Makefile                  |    2 +-
 dmapi/src/suite1/cmd/Makefile                  |    2 +-
 dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c |    2 +-
 dmapi/src/suite2/src/Makefile                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/dmapi/src/common/cmd/Makefile b/dmapi/src/common/cmd/Makefile
index 4b0e550..4525581 100644
--- a/dmapi/src/common/cmd/Makefile
+++ b/dmapi/src/common/cmd/Makefile
@@ -38,7 +38,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/sample_hsm/Makefile b/dmapi/src/sample_hsm/Makefile
index 7a4ca8c..55df563 100644
--- a/dmapi/src/sample_hsm/Makefile
+++ b/dmapi/src/sample_hsm/Makefile
@@ -38,7 +38,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/suite1/cmd/Makefile b/dmapi/src/suite1/cmd/Makefile
index 7e51763..05dbead 100644
--- a/dmapi/src/suite1/cmd/Makefile
+++ b/dmapi/src/suite1/cmd/Makefile
@@ -61,7 +61,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
index 6b4d0b6..c01dff0 100644
--- a/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
+++ b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
@@ -69,7 +69,7 @@ xfsctl_punch_hole(
 	xfs_flock64_t   flock;
 	int		fd;
 	
-	if ((fd = open(path, O_RDWR|O_CREAT)) < 0) {
+	if ((fd = open(path, O_RDWR|O_CREAT, 0600)) < 0) {
 		perror(path);
 		exit(errno);
 	}
diff --git a/dmapi/src/suite2/src/Makefile b/dmapi/src/suite2/src/Makefile
index 91a0f00..c5cf6da 100644
--- a/dmapi/src/suite2/src/Makefile
+++ b/dmapi/src/suite2/src/Makefile
@@ -44,7 +44,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
