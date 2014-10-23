Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE5137F63
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:29:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4AB8CAC002
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 16:29:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eX2MFRdh97hVmbR8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 16:29:16 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NNTFZP004920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:29:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com
	[10.11.146.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9NNTELr022553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:29:15 -0400
Message-ID: <54498F4A.9030207@redhat.com>
Date: Thu, 23 Oct 2014 18:29:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: enable sparse checking
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Enable "make C=1" or "make C=2" to do sparse checking.
Blatantly ripped off from djwong's patch in e2fsprogs to
do the same.

Note, this requires unreleased sparse after v0.5, which
enables the CHAR_BIT definition; otherwise it chokes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Makefile b/Makefile
index f56aebd..bd0f9ee 100644
--- a/Makefile
+++ b/Makefile
@@ -15,6 +15,20 @@ else
   Q = @
 endif
 
+CHECK=sparse
+CHECK_OPTS=-Wsparse-all -Wno-transparent-union -Wno-return-void -Wno-undef \
+	-Wno-non-pointer-null -D__linux__
+ifeq ("$(C)", "2")
+  CHECK_CMD=$(CHECK) $(CHECK_OPTS) -Wbitwise -D__CHECK_ENDIAN__ 
+else
+  ifeq ("$(C)", "1")
+    CHECK_CMD=$(CHECK) $(CHECK_OPTS)
+   else
+    CHECK_CMD=@true
+  endif
+endif
+export CHECK_CMD
+
 MAKEOPTS = --no-print-directory Q=$(Q)
 
 TOPDIR = .
diff --git a/include/buildrules b/include/buildrules
index 399635e..feae376 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -41,10 +41,12 @@ $(LTLIBRARY) : $(SUBDIRS) $(LTOBJECTS)
 %.lo: %.c
 	@echo "    [CC]     $@"
 	$(Q)$(LTCOMPILE) -c $<
+	$(Q)$(CHECK_CMD) $(CFLAGS) $<
 else
 %.o: %.c
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(CFLAGS) -c $<
+	$(Q)$(CHECK_CMD) $(CFLAGS) $<
 
 endif
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
