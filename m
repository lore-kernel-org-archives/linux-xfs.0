Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB7219007D;
	Wed, 19 Feb 2025 00:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926267; cv=none; b=EaNhSnaHyDHDRl2BwnYjjY8gkKTVeUKIrnsgN91VTf5TfKCBMF4BtEz+JZHl+5rJ0HYZrWJm58givcwOl0sAdUReEmbS35j15V5oTYif792SIyR1bfQU/lWBmjIPN0n4Atj2mr3xZz3eHuRaK1RFquFQPpD4DY1xX/nSrg7zOCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926267; c=relaxed/simple;
	bh=ytflsKbaXhpY/vYnyeMIGBjAAOfHBSm55lCrkGGhGx8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uknwk7q+J7/mnu5TCoLWngxK1y8l5spfMYhCtaCB31WYeubI7AyZqXap3I8bsObKFVRZ0MZVt+kg8w6kxb9yDa156Dz8KxniBaeO/5BfPkedorYvWy7OTK5ZrFQWbm95RmeeUNJb8CeA2HxQvbQ8C+b42HbLdBzsvAYiC26SlXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Efj7gS7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Efj7gS7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC3CC4CEE2;
	Wed, 19 Feb 2025 00:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926266;
	bh=ytflsKbaXhpY/vYnyeMIGBjAAOfHBSm55lCrkGGhGx8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Efj7gS7eG7HzwbOdJ5iPeH2avGTRdi4PWX4cyWPPgZVAm3G/OCU6ubEsPBOxIeBCL
	 SQ96FOqTSMYboZw00NgvV7IZK1FyWtWWn1EqUtvjOcBJRIIUley5FeHC26rj7LIWB9
	 +TRh9NQDLFXOXkpYEnWyyYMCFfOcpD/TY1vUCSszcuCOcoTpxODbH4NLP5T195KebQ
	 ys8QZ2BSoeO9rw5PDEZDiXhA4lMWAokzNYC2zVsJ5nnp6g1vNKMQEUwb73Y61Vb1zI
	 rLLXATqCzil8s8HT/lsTeRnGgQf7VW34RxwywXmnmQBWGisf7qLJkMGBST60TB+og8
	 VRgSahED9hcMA==
Date: Tue, 18 Feb 2025 16:51:06 -0800
Subject: [PATCH 03/12] misc: rename the dangerous_online_repair group to
 fuzzers_online_repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587458.4078254.18086350374208102213.stgit@frogsfrogsfrogs>
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
need to hide behind the "dangerous" label anymore.  It's time for more
widespread testing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    2 +-
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
 tests/xfs/426       |    2 +-
 tests/xfs/428       |    2 +-
 tests/xfs/430       |    2 +-
 tests/xfs/497       |    2 +-
 tests/xfs/730       |    2 +-
 tests/xfs/733       |    2 +-
 tests/xfs/736       |    2 +-
 tests/xfs/739       |    2 +-
 tests/xfs/740       |    2 +-
 tests/xfs/786       |    2 +-
 45 files changed, 45 insertions(+), 45 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index cf263ed537db1f..25a982b6740504 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -33,7 +33,6 @@ dangerous		dangerous test that can crash the system
 dangerous_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
-dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 dangerous_selftest	selftests that crash/hang
 data			data loss checkers
@@ -58,6 +57,7 @@ fsr			XFS free space reorganizer
 fsstress_online_repair	race fsstress and xfs_scrub online repair
 fsstress_scrub		race fsstress and xfs_scrub checking
 fuzzers			filesystem fuzz tests
+fuzzers_online_repair	fuzzers to evaluate xfs_scrub online repair
 fuzzers_repair		fuzzers to evaluate xfs_repair offline repair
 growfs			increasing the size of a filesystem
 hardlink		hardlinks
diff --git a/tests/xfs/351 b/tests/xfs/351
index d03cc3315dc49c..38f3690406f7ff 100755
--- a/tests/xfs/351
+++ b/tests/xfs/351
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/353 b/tests/xfs/353
index 017e3ce28768d1..326adc4c7e4b60 100755
--- a/tests/xfs/353
+++ b/tests/xfs/353
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/355 b/tests/xfs/355
index f7377bd89c0c2f..309a83038b80fe 100755
--- a/tests/xfs/355
+++ b/tests/xfs/355
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/357 b/tests/xfs/357
index d21b9d3207110c..1a1c9d8aebbe33 100755
--- a/tests/xfs/357
+++ b/tests/xfs/357
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/359 b/tests/xfs/359
index 8d0da3d1f8c59a..517b34b0810747 100755
--- a/tests/xfs/359
+++ b/tests/xfs/359
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/361 b/tests/xfs/361
index 46f84888cc6277..9b9f58d33a5f6b 100755
--- a/tests/xfs/361
+++ b/tests/xfs/361
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/363 b/tests/xfs/363
index 9a5e893c25b29c..56e0773c8a4783 100755
--- a/tests/xfs/363
+++ b/tests/xfs/363
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/365 b/tests/xfs/365
index 7a7bb51a61d62d..31def0682a1cb0 100755
--- a/tests/xfs/365
+++ b/tests/xfs/365
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/367 b/tests/xfs/367
index 5a357bc6a318cd..99f73345c78691 100755
--- a/tests/xfs/367
+++ b/tests/xfs/367
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/369 b/tests/xfs/369
index 398ff9e9433aa2..cb741b3df932a8 100755
--- a/tests/xfs/369
+++ b/tests/xfs/369
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/371 b/tests/xfs/371
index 37850c08416af3..453612d63cd06d 100755
--- a/tests/xfs/371
+++ b/tests/xfs/371
@@ -9,7 +9,7 @@
 # Use xfs_scrub to repair the problems.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/373 b/tests/xfs/373
index 6759d78fc7ed78..6f33d4ba526504 100755
--- a/tests/xfs/373
+++ b/tests/xfs/373
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/375 b/tests/xfs/375
index 6518ac3c2ecdc2..bfd0a255521f12 100755
--- a/tests/xfs/375
+++ b/tests/xfs/375
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/377 b/tests/xfs/377
index 6be8c45ba57397..e10d01159e4899 100755
--- a/tests/xfs/377
+++ b/tests/xfs/377
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/379 b/tests/xfs/379
index b7e89fce976f86..5d1592990dd24e 100755
--- a/tests/xfs/379
+++ b/tests/xfs/379
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/381 b/tests/xfs/381
index aa5fb9149bcedb..0f371f7e025823 100755
--- a/tests/xfs/381
+++ b/tests/xfs/381
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/383 b/tests/xfs/383
index be619100872320..6abb49009d77b3 100755
--- a/tests/xfs/383
+++ b/tests/xfs/383
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/385 b/tests/xfs/385
index 63a7649e71ed6f..7fc4a614a43b1c 100755
--- a/tests/xfs/385
+++ b/tests/xfs/385
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/387 b/tests/xfs/387
index 805e27034b7b40..32df964413456e 100755
--- a/tests/xfs/387
+++ b/tests/xfs/387
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/389 b/tests/xfs/389
index f40bb6dae6d84b..cdea039119c250 100755
--- a/tests/xfs/389
+++ b/tests/xfs/389
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/391 b/tests/xfs/391
index 400ec31b82c576..c77d1d2c0478f1 100755
--- a/tests/xfs/391
+++ b/tests/xfs/391
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/393 b/tests/xfs/393
index e18572b5ab3802..3032430023f0b5 100755
--- a/tests/xfs/393
+++ b/tests/xfs/393
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/395 b/tests/xfs/395
index 5dac51cfef4647..ada20cf1ed901e 100755
--- a/tests/xfs/395
+++ b/tests/xfs/395
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/397 b/tests/xfs/397
index 878929e2786997..10a62c6c850515 100755
--- a/tests/xfs/397
+++ b/tests/xfs/397
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/399 b/tests/xfs/399
index 3a2ea05ab33d02..95d30351db60a4 100755
--- a/tests/xfs/399
+++ b/tests/xfs/399
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/401 b/tests/xfs/401
index 0e95a7dfe60d80..3574190d9f1089 100755
--- a/tests/xfs/401
+++ b/tests/xfs/401
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/403 b/tests/xfs/403
index b9276c8d9ab6d8..1decf1805f8ee8 100755
--- a/tests/xfs/403
+++ b/tests/xfs/403
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/405 b/tests/xfs/405
index 76f5afb70f859d..413c3b709cec3f 100755
--- a/tests/xfs/405
+++ b/tests/xfs/405
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/407 b/tests/xfs/407
index ee67a40f67566c..39c5f9833aaf88 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/409 b/tests/xfs/409
index 12d7c5cd9d76ee..580c261d71acad 100755
--- a/tests/xfs/409
+++ b/tests/xfs/409
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/411 b/tests/xfs/411
index 93af836be9dc45..6cef828eb56600 100755
--- a/tests/xfs/411
+++ b/tests/xfs/411
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/413 b/tests/xfs/413
index 5a36f29c292d41..89740083a51508 100755
--- a/tests/xfs/413
+++ b/tests/xfs/413
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/415 b/tests/xfs/415
index 2d5816d0eea61f..94dd0380f9ddd1 100755
--- a/tests/xfs/415
+++ b/tests/xfs/415
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/417 b/tests/xfs/417
index 30501ea35d772b..bf6ef478d83733 100755
--- a/tests/xfs/417
+++ b/tests/xfs/417
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/426 b/tests/xfs/426
index 2cda865a0c0509..4e44431edc3c15 100755
--- a/tests/xfs/426
+++ b/tests/xfs/426
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/428 b/tests/xfs/428
index 31694e1802860e..57100a8a79c6b3 100755
--- a/tests/xfs/428
+++ b/tests/xfs/428
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/430 b/tests/xfs/430
index 6331f82ea55620..8af00ce37a4f27 100755
--- a/tests/xfs/430
+++ b/tests/xfs/430
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/497 b/tests/xfs/497
index f9f36c6b084f7c..3e276d0dccf8fe 100755
--- a/tests/xfs/497
+++ b/tests/xfs/497
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/730 b/tests/xfs/730
index cd58d446d8d2ce..8320bd97d73efb 100755
--- a/tests/xfs/730
+++ b/tests/xfs/730
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/733 b/tests/xfs/733
index 71f16c2575191d..65b19d9158fe09 100755
--- a/tests/xfs/733
+++ b/tests/xfs/733
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/736 b/tests/xfs/736
index 2314d12a074c05..b76bb7d7802d19 100755
--- a/tests/xfs/736
+++ b/tests/xfs/736
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/739 b/tests/xfs/739
index a4f553d818c2be..6cd1c1c289b96e 100755
--- a/tests/xfs/739
+++ b/tests/xfs/739
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/740 b/tests/xfs/740
index 971bf31e3239b1..d6819476e904fc 100755
--- a/tests/xfs/740
+++ b/tests/xfs/740
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/786 b/tests/xfs/786
index 0a8bde8ccf9189..bbc64f50ef926c 100755
--- a/tests/xfs/786
+++ b/tests/xfs/786
@@ -8,7 +8,7 @@
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_online_repair
 
 _register_cleanup "_cleanup" BUS
 

