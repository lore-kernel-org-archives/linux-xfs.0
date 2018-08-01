Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55480 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732307AbeHAXYs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 19:24:48 -0400
Subject: [PATCH V2] misc: add handy tarball targets
References: <89353d1e-b141-e8e6-e039-fb8340a45df0@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3aeaf299-136f-b6ea-bde8-63086bdedf92@sandeen.net>
Date: Wed, 1 Aug 2018 16:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <89353d1e-b141-e8e6-e039-fb8340a45df0@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

It's a pain to need to know which version we're on to be able
to create a tarball, just make a couple of simple "tarball"
and "tarxz" targets that just DTRT and make a tarball with the
current version.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: give Darrick names he likes ;) and mark these and a bunch of other
targets as .PHONY

diff --git a/Makefile b/Makefile
index 6774825..ad35114 100644
--- a/Makefile
+++ b/Makefile
@@ -178,6 +178,11 @@ $(SRCTARXZ) : default $(SRCTARINC) .gitcensus
 	   `cat .gitcensus` $(SRCTARINC)
 	echo Wrote: $@
 
+targz: $(SRCTAR)
+tarxz: $(SRCTARXZ)
+
+.PHONY: install install-dev dist clean distclean realclean targz tarxz
+
 .gitcensus: $(_FORCE)
 	$(Q)if test -d .git; then \
 	  git ls-files > .gitcensus && echo "new .gitcensus"; \

