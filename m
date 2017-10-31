Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49723 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753368AbdJaOMc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:12:32 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 3/4] generic: Adjust generic test ouputs for new fiemap implementation
Date: Tue, 31 Oct 2017 16:11:35 +0200
Message-Id: <1509459096-7585-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1509459096-7585-1-git-send-email-nborisov@suse.com>
References: <1509459011-7398-1-git-send-email-nborisov@suse.com>
 <1509459096-7585-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com, eguan@redhat.com, Nikolay Borisov <nborisov@suse.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/generic/012.out | 1 +
 tests/generic/016.out | 1 +
 tests/generic/021.out | 2 ++
 tests/generic/022.out | 2 ++
 tests/generic/058.out | 1 +
 tests/generic/060.out | 1 +
 tests/generic/061.out | 1 +
 tests/generic/063.out | 1 +
 tests/generic/255.out | 6 ++++++
 tests/generic/316.out | 6 ++++++
 10 files changed, 22 insertions(+)

diff --git a/tests/generic/012.out b/tests/generic/012.out
index ffbf8a3..8045471 100644
--- a/tests/generic/012.out
+++ b/tests/generic/012.out
@@ -1,5 +1,6 @@
 QA output created by 012
 	1. into a hole
+0: [0..95]: hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
 0: [0..95]: extent
diff --git a/tests/generic/016.out b/tests/generic/016.out
index c45a44a..1371ce7 100644
--- a/tests/generic/016.out
+++ b/tests/generic/016.out
@@ -1,5 +1,6 @@
 QA output created by 016
 	1. into a hole
+0: [0..95]: hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
 0: [0..95]: extent
diff --git a/tests/generic/021.out b/tests/generic/021.out
index 1137741..791b78a 100644
--- a/tests/generic/021.out
+++ b/tests/generic/021.out
@@ -1,5 +1,6 @@
 QA output created by 021
 	1. into a hole
+0: [0..95]: hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
 0: [0..95]: extent
@@ -34,6 +35,7 @@ f4f35d60b3cc18aaa6d8d92f0cd3708a
 1: [64..95]: hole
 d8f51c20223dbce5c7c90db87bc221b0
 	10. hole -> data -> hole
+0: [0..63]: hole
 bb7df04e1b0a2570657527a7e108ae23
 	11. data -> hole -> data
 0: [0..63]: extent
diff --git a/tests/generic/022.out b/tests/generic/022.out
index fbffa59..6dbc192 100644
--- a/tests/generic/022.out
+++ b/tests/generic/022.out
@@ -1,5 +1,6 @@
 QA output created by 022
 	1. into a hole
+0: [0..95]: hole
 f4f35d60b3cc18aaa6d8d92f0cd3708a
 	2. into allocated space
 0: [0..95]: extent
@@ -34,6 +35,7 @@ f4f35d60b3cc18aaa6d8d92f0cd3708a
 1: [64..95]: hole
 d8f51c20223dbce5c7c90db87bc221b0
 	10. hole -> data -> hole
+0: [0..63]: hole
 bb7df04e1b0a2570657527a7e108ae23
 	11. data -> hole -> data
 0: [0..63]: extent
diff --git a/tests/generic/058.out b/tests/generic/058.out
index b15308d..3bbc2a4 100644
--- a/tests/generic/058.out
+++ b/tests/generic/058.out
@@ -1,5 +1,6 @@
 QA output created by 058
 	1. into a hole
+0: [0..55]: hole
 cf845a781c107ec1346e849c9dd1b7e8
 	2. into allocated space
 0: [0..7]: extent
diff --git a/tests/generic/060.out b/tests/generic/060.out
index 909b578..210af74 100644
--- a/tests/generic/060.out
+++ b/tests/generic/060.out
@@ -1,5 +1,6 @@
 QA output created by 060
 	1. into a hole
+0: [0..55]: hole
 cf845a781c107ec1346e849c9dd1b7e8
 	2. into allocated space
 0: [0..7]: extent
diff --git a/tests/generic/061.out b/tests/generic/061.out
index 78d6c6d..6d95680 100644
--- a/tests/generic/061.out
+++ b/tests/generic/061.out
@@ -1,5 +1,6 @@
 QA output created by 061
 	1. into a hole
+0: [0..55]: hole
 cf845a781c107ec1346e849c9dd1b7e8
 	2. into allocated space
 0: [0..7]: extent
diff --git a/tests/generic/063.out b/tests/generic/063.out
index d828ff6..10db43f 100644
--- a/tests/generic/063.out
+++ b/tests/generic/063.out
@@ -1,5 +1,6 @@
 QA output created by 063
 	1. into a hole
+0: [0..55]: hole
 cf845a781c107ec1346e849c9dd1b7e8
 	2. into allocated space
 0: [0..7]: extent
diff --git a/tests/generic/255.out b/tests/generic/255.out
index 217ef3e..441fde8 100644
--- a/tests/generic/255.out
+++ b/tests/generic/255.out
@@ -1,5 +1,6 @@
 QA output created by 255
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -42,6 +43,7 @@ daa100df6e6711906b61c9ab5aa16032
 3: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: extent
@@ -79,6 +81,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -121,6 +124,7 @@ daa100df6e6711906b61c9ab5aa16032
 3: [32..39]: hole
 cc63069677939f69a6e8f68cae6a6dac
 	10. hole -> data -> hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: extent
@@ -158,6 +162,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -240,6 +245,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
diff --git a/tests/generic/316.out b/tests/generic/316.out
index 383f0d1..5506198 100644
--- a/tests/generic/316.out
+++ b/tests/generic/316.out
@@ -1,5 +1,6 @@
 QA output created by 316
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -16,6 +17,7 @@ cc63069677939f69a6e8f68cae6a6dac
 1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	10. hole -> data -> hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: extent
@@ -43,6 +45,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -59,6 +62,7 @@ cc63069677939f69a6e8f68cae6a6dac
 1: [8..39]: hole
 1b3779878366498b28c702ef88c4a773
 	10. hole -> data -> hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	11. data -> hole -> data
 0: [0..7]: extent
@@ -86,6 +90,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
@@ -133,6 +138,7 @@ eecb7aa303d121835de05028751d301c
 0000400 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
 *
 	1. into a hole
+0: [0..39]: hole
 daa100df6e6711906b61c9ab5aa16032
 	2. into allocated space
 0: [0..7]: extent
-- 
2.7.4

