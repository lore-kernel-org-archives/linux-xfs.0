Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B2419AD8D;
	Wed, 19 Feb 2025 00:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926376; cv=none; b=snR5Kt+dQE48THNcKr4SYsUkML/6IYTCbjpLJvJ8nygE9yOx1eWWbNYS1bg2BREI9Ge88KdSBRa41uYVVBegybsfKqxuH/MPADXYu0bI5e1g6n2mDCDx90w3nd/lpD33pHdo9opy+aWzanIaBsM36/WcFiXHPJGiWotCXYoK+c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926376; c=relaxed/simple;
	bh=6kVH+ylWctRJM+2Kg4W8Yowmkb+hfzXpeleB/EEnCsw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kho5s89bllRtgErb0DgZOl1xFCcIZ7Y4k5EFnNUnvrjYy4i/GhormH2tDNAuTIoyEdV5rWccIDqq0Q/GEPxgSVxB+a9g1iOmHCxGhzyW5KR02FJ0kCCLU41XBywKahqVT7FzwWvdZrcSNEPyYDlgrtDib1vWrztleTzLhynJl80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mu6OUJM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mu6OUJM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EBBC4CEE2;
	Wed, 19 Feb 2025 00:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926376;
	bh=6kVH+ylWctRJM+2Kg4W8Yowmkb+hfzXpeleB/EEnCsw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mu6OUJM/pZKRGklbLJ5R4yXSL62BaOR/s2j8mIPg9Sha3TU2IMywjM0jZgikaxHPw
	 MRJImm09gBKoOGETS+N47mwEzkjWaALxXQPOx4muNEQeCH6SdfIK2/o7zqLY1lfpcT
	 nXxFTPP2wRLxLBoUejWPNTGwGFXIVADROADriMb0KzweBH3UYotP23BH8xNOzF30ij
	 XGL7Gf6YL38YriA1E/NEOqOd679tGlWL3qF4N5xbELmQgys8GQXQ2tl/1CLMRHfwAr
	 a25Xd9iNE7alPRmzGdVuoxsXA6ek5L0ZEsQltoZJZ+AESsnHnGqJKthrB1r3RE2oPx
	 4xLHN9PSa3+rQ==
Date: Tue, 18 Feb 2025 16:52:56 -0800
Subject: [PATCH 10/12] misc: remove the dangerous_scrub group
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587588.4078254.2278340733226774088.stgit@frogsfrogsfrogs>
In-Reply-To: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that online fsck has been in the upstream kernel for 8 months, I
think it's stabilized enough that the scrub functionality tests don't
need to hide behind the "dangerous" label anymore.  Move them all to the
scrub group and delete the dangerous_scrub group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    1 -
 tests/xfs/351       |    2 +-
 tests/xfs/353       |    2 +-
 tests/xfs/355       |    2 +-
 tests/xfs/357       |    2 +-
 tests/xfs/359       |    2 +-
 tests/xfs/361       |    2 +-
 tests/xfs/363       |    2 +-
 tests/xfs/365       |    2 +-
 tests/xfs/367       |    2 +-
 tests/xfs/369       |    2 +-
 tests/xfs/371       |    2 +-
 tests/xfs/373       |    2 +-
 tests/xfs/375       |    2 +-
 tests/xfs/377       |    2 +-
 tests/xfs/379       |    2 +-
 tests/xfs/381       |    2 +-
 tests/xfs/383       |    2 +-
 tests/xfs/385       |    2 +-
 tests/xfs/387       |    2 +-
 tests/xfs/389       |    2 +-
 tests/xfs/391       |    2 +-
 tests/xfs/393       |    2 +-
 tests/xfs/395       |    2 +-
 tests/xfs/397       |    2 +-
 tests/xfs/399       |    2 +-
 tests/xfs/401       |    2 +-
 tests/xfs/403       |    2 +-
 tests/xfs/405       |    2 +-
 tests/xfs/407       |    2 +-
 tests/xfs/409       |    2 +-
 tests/xfs/411       |    2 +-
 tests/xfs/413       |    2 +-
 tests/xfs/415       |    2 +-
 tests/xfs/417       |    2 +-
 tests/xfs/423       |    2 +-
 tests/xfs/426       |    2 +-
 tests/xfs/428       |    2 +-
 tests/xfs/430       |    2 +-
 tests/xfs/497       |    2 +-
 tests/xfs/730       |    2 +-
 tests/xfs/733       |    2 +-
 tests/xfs/736       |    2 +-
 tests/xfs/739       |    2 +-
 tests/xfs/740       |    2 +-
 tests/xfs/743       |    2 +-
 tests/xfs/744       |    2 +-
 tests/xfs/783       |    2 +-
 tests/xfs/784       |    2 +-
 tests/xfs/786       |    2 +-
 50 files changed, 49 insertions(+), 50 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 9fb72e65f2a63e..f510bb827062f0 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -31,7 +31,6 @@ copy_range		copy_file_range syscall
 copyup			overlayfs copyup
 dangerous		dangerous test that can crash the system
 dangerous_fuzzers	fuzzers that can crash your computer
-dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 dangerous_selftest	selftests that crash/hang
 data			data loss checkers
 dax			direct access mode for persistent memory files
diff --git a/tests/xfs/351 b/tests/xfs/351
index 38f3690406f7ff..f52ba613f06841 100755
--- a/tests/xfs/351
+++ b/tests/xfs/351
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/353 b/tests/xfs/353
index 326adc4c7e4b60..12af64c678a115 100755
--- a/tests/xfs/353
+++ b/tests/xfs/353
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/355 b/tests/xfs/355
index 309a83038b80fe..4724d5137739cd 100755
--- a/tests/xfs/355
+++ b/tests/xfs/355
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/357 b/tests/xfs/357
index 1a1c9d8aebbe33..abd1d2b91fa83c 100755
--- a/tests/xfs/357
+++ b/tests/xfs/357
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/359 b/tests/xfs/359
index 517b34b0810747..e457383066f6d6 100755
--- a/tests/xfs/359
+++ b/tests/xfs/359
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/361 b/tests/xfs/361
index 9b9f58d33a5f6b..f5729b5a019580 100755
--- a/tests/xfs/361
+++ b/tests/xfs/361
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/363 b/tests/xfs/363
index 56e0773c8a4783..2568da5925aeb8 100755
--- a/tests/xfs/363
+++ b/tests/xfs/363
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/365 b/tests/xfs/365
index 31def0682a1cb0..79de2b95fd38c8 100755
--- a/tests/xfs/365
+++ b/tests/xfs/365
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/367 b/tests/xfs/367
index 99f73345c78691..af7faf08a58d50 100755
--- a/tests/xfs/367
+++ b/tests/xfs/367
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/369 b/tests/xfs/369
index cb741b3df932a8..ff0db2e6382ccf 100755
--- a/tests/xfs/369
+++ b/tests/xfs/369
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/371 b/tests/xfs/371
index 453612d63cd06d..df0586082d3653 100755
--- a/tests/xfs/371
+++ b/tests/xfs/371
@@ -9,7 +9,7 @@
 # Use xfs_scrub to repair the problems.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/373 b/tests/xfs/373
index 6f33d4ba526504..ccdf4a5e37935a 100755
--- a/tests/xfs/373
+++ b/tests/xfs/373
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/375 b/tests/xfs/375
index bfd0a255521f12..81cd9d72d086cf 100755
--- a/tests/xfs/375
+++ b/tests/xfs/375
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/377 b/tests/xfs/377
index e10d01159e4899..b01a7c6511d720 100755
--- a/tests/xfs/377
+++ b/tests/xfs/377
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/379 b/tests/xfs/379
index 5d1592990dd24e..fc1ac6fa56a643 100755
--- a/tests/xfs/379
+++ b/tests/xfs/379
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/381 b/tests/xfs/381
index 0f371f7e025823..d3c0d5fc18cd08 100755
--- a/tests/xfs/381
+++ b/tests/xfs/381
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/383 b/tests/xfs/383
index 6abb49009d77b3..3e280e5dd1a382 100755
--- a/tests/xfs/383
+++ b/tests/xfs/383
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/385 b/tests/xfs/385
index 7fc4a614a43b1c..8b10c0bce08e97 100755
--- a/tests/xfs/385
+++ b/tests/xfs/385
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/387 b/tests/xfs/387
index 32df964413456e..6d8c3040685ce9 100755
--- a/tests/xfs/387
+++ b/tests/xfs/387
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/389 b/tests/xfs/389
index cdea039119c250..be27dbc92f39ad 100755
--- a/tests/xfs/389
+++ b/tests/xfs/389
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/391 b/tests/xfs/391
index c77d1d2c0478f1..d43ab5c025960c 100755
--- a/tests/xfs/391
+++ b/tests/xfs/391
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/393 b/tests/xfs/393
index 3032430023f0b5..8b70b6c2277ff5 100755
--- a/tests/xfs/393
+++ b/tests/xfs/393
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/395 b/tests/xfs/395
index ada20cf1ed901e..a119f12dc9fb5d 100755
--- a/tests/xfs/395
+++ b/tests/xfs/395
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/397 b/tests/xfs/397
index 10a62c6c850515..6d939139ea705b 100755
--- a/tests/xfs/397
+++ b/tests/xfs/397
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/399 b/tests/xfs/399
index 95d30351db60a4..7ac7059ffcbb2a 100755
--- a/tests/xfs/399
+++ b/tests/xfs/399
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/401 b/tests/xfs/401
index 3574190d9f1089..ab9320c6a1bedf 100755
--- a/tests/xfs/401
+++ b/tests/xfs/401
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/403 b/tests/xfs/403
index 1decf1805f8ee8..000083616495b9 100755
--- a/tests/xfs/403
+++ b/tests/xfs/403
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/405 b/tests/xfs/405
index 413c3b709cec3f..c5cfde01e1141a 100755
--- a/tests/xfs/405
+++ b/tests/xfs/405
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/407 b/tests/xfs/407
index 39c5f9833aaf88..035578b97b4793 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/409 b/tests/xfs/409
index 580c261d71acad..f3885e56010daa 100755
--- a/tests/xfs/409
+++ b/tests/xfs/409
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/411 b/tests/xfs/411
index 6cef828eb56600..b644f7045e2668 100755
--- a/tests/xfs/411
+++ b/tests/xfs/411
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/413 b/tests/xfs/413
index 89740083a51508..1123d305879917 100755
--- a/tests/xfs/413
+++ b/tests/xfs/413
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/415 b/tests/xfs/415
index 94dd0380f9ddd1..6c5758b9de7173 100755
--- a/tests/xfs/415
+++ b/tests/xfs/415
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/417 b/tests/xfs/417
index bf6ef478d83733..8f7e60f625954e 100755
--- a/tests/xfs/417
+++ b/tests/xfs/417
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/423 b/tests/xfs/423
index 78fd913017ccf7..7c6aeab82e7eb1 100755
--- a/tests/xfs/423
+++ b/tests/xfs/423
@@ -10,7 +10,7 @@
 # count them if the fork is in btree format.
 #
 . ./common/preamble
-_begin_fstest dangerous_scrub prealloc
+_begin_fstest scrub prealloc
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/426 b/tests/xfs/426
index 4e44431edc3c15..53bfd0d637fcb5 100755
--- a/tests/xfs/426
+++ b/tests/xfs/426
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/428 b/tests/xfs/428
index 57100a8a79c6b3..e112ccf84646c1 100755
--- a/tests/xfs/428
+++ b/tests/xfs/428
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/430 b/tests/xfs/430
index 8af00ce37a4f27..3e6527851069a9 100755
--- a/tests/xfs/430
+++ b/tests/xfs/430
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/497 b/tests/xfs/497
index 3e276d0dccf8fe..3f31607d704e2f 100755
--- a/tests/xfs/497
+++ b/tests/xfs/497
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/730 b/tests/xfs/730
index 8320bd97d73efb..79ea93ee72fce1 100755
--- a/tests/xfs/730
+++ b/tests/xfs/730
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/733 b/tests/xfs/733
index 65b19d9158fe09..a875c2ac906625 100755
--- a/tests/xfs/733
+++ b/tests/xfs/733
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/736 b/tests/xfs/736
index b76bb7d7802d19..f60edb0007ad21 100755
--- a/tests/xfs/736
+++ b/tests/xfs/736
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/739 b/tests/xfs/739
index 6cd1c1c289b96e..52c90b91b218df 100755
--- a/tests/xfs/739
+++ b/tests/xfs/739
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/740 b/tests/xfs/740
index d6819476e904fc..fb616a16362a6c 100755
--- a/tests/xfs/740
+++ b/tests/xfs/740
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/743 b/tests/xfs/743
index 1dcb79bc46fe48..8021d7ecdc9009 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair realtime
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/744 b/tests/xfs/744
index 7b554e977b20d2..0e719dcebf03d2 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair realtime
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/783 b/tests/xfs/783
index 79bf34c1b2bd12..52fe6e798b1164 100755
--- a/tests/xfs/783
+++ b/tests/xfs/783
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/784 b/tests/xfs/784
index 99d84545c90e79..9028c1d0d91106 100755
--- a/tests/xfs/784
+++ b/tests/xfs/784
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/786 b/tests/xfs/786
index bbc64f50ef926c..205f84ea2a8be0 100755
--- a/tests/xfs/786
+++ b/tests/xfs/786
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 

