Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75E418E1A;
	Wed, 19 Feb 2025 00:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926298; cv=none; b=P3HNb/aRLxywpAmdNd8pvZYO//oOOsTxgBe7KNlNgEty22DOt+N2VBHx8WExmn/+iL0PY+V9wVnSqTXP1g0CFTilRaPmmaQNYg2JZT05NlYrjj81u3clAYNkQlV747ht26g9R+cTcjTRBWuQ/GfDJHfENBUcwUwn5NecRAv8VBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926298; c=relaxed/simple;
	bh=2r1dFfs5THTNKTA1EiczZG+u8oKcttKnXSPasO54JNU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PtB4ikCVi0bAMSIJtNALDGy4E3vcP76uvcH95BAJ9nWFbeU5BidHuv7kQ9prSEc/XMaKySU9vCuHltXqxPix0WA13bpg0dVXLBDQaTW8YzwgZW6HZf1TRzltm1jgZLFmd62E3Awot/tlPV9cxEZGzRvFho3sKcE7Nl+mTMleBrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkFGzlTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkFGzlTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274ABC4CEE2;
	Wed, 19 Feb 2025 00:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926298;
	bh=2r1dFfs5THTNKTA1EiczZG+u8oKcttKnXSPasO54JNU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CkFGzlTQ2THERSBj9iI3SQ5TifFCIIAmIPkbaWyvOTmCWqJ9ZEi5vriU15VzDrQT8
	 KOy4RpzUpSusz5CJ84sblahF1LwCeEV85vsh4ch2gwXBWrCn1i/BX412cWkhtT8vXu
	 8MY4s959OF0vfr7Xi7YWm8JqH7ltPuH/pB+Vnsb3HNVgqe0+HkuBw4UU9LUwNkyRXp
	 Kfc64TOr+AWhGDsOJQRWYhdxuj99eZSj7vQPSscl2GY7h5aVvyxNutc1RCaQRl41Wn
	 3lrB8jLUWxqDdNER9QWxeB19hgjS7lsSp185KYH2GfKVShhqSJhpXMo6EcDaoXJ+Ht
	 Uql+rddeAhXUw==
Date: Tue, 18 Feb 2025 16:51:37 -0800
Subject: [PATCH 05/12] misc: rename the dangerous_norepair group to
 fuzzers_norepair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587496.4078254.14824377885868657428.stgit@frogsfrogsfrogs>
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

I've been running the norepair fuzzers (aka the verifier checks) for
most of the time that online fsck has been in development, and I haven't
seen any of the VMs crash in a couple of years.  I think it's time that
these tests stopped hiding behind the "dangerous" label.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    2 +-
 tests/xfs/453       |    2 +-
 tests/xfs/454       |    2 +-
 tests/xfs/455       |    2 +-
 tests/xfs/456       |    2 +-
 tests/xfs/457       |    2 +-
 tests/xfs/458       |    2 +-
 tests/xfs/459       |    2 +-
 tests/xfs/460       |    2 +-
 tests/xfs/461       |    2 +-
 tests/xfs/462       |    2 +-
 tests/xfs/463       |    2 +-
 tests/xfs/464       |    2 +-
 tests/xfs/465       |    2 +-
 tests/xfs/466       |    2 +-
 tests/xfs/467       |    2 +-
 tests/xfs/468       |    2 +-
 tests/xfs/469       |    2 +-
 tests/xfs/470       |    2 +-
 tests/xfs/471       |    2 +-
 tests/xfs/472       |    2 +-
 tests/xfs/473       |    2 +-
 tests/xfs/474       |    2 +-
 tests/xfs/475       |    2 +-
 tests/xfs/476       |    2 +-
 tests/xfs/477       |    2 +-
 tests/xfs/478       |    2 +-
 tests/xfs/479       |    2 +-
 tests/xfs/480       |    2 +-
 tests/xfs/481       |    2 +-
 tests/xfs/482       |    2 +-
 tests/xfs/483       |    2 +-
 tests/xfs/484       |    2 +-
 tests/xfs/485       |    2 +-
 tests/xfs/486       |    2 +-
 tests/xfs/487       |    2 +-
 tests/xfs/488       |    2 +-
 tests/xfs/489       |    2 +-
 tests/xfs/498       |    2 +-
 tests/xfs/735       |    2 +-
 tests/xfs/738       |    2 +-
 tests/xfs/745       |    2 +-
 tests/xfs/746       |    2 +-
 tests/xfs/788       |    2 +-
 44 files changed, 44 insertions(+), 44 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 8e1a62331738bb..9fb72e65f2a63e 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -31,7 +31,6 @@ copy_range		copy_file_range syscall
 copyup			overlayfs copyup
 dangerous		dangerous test that can crash the system
 dangerous_fuzzers	fuzzers that can crash your computer
-dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 dangerous_selftest	selftests that crash/hang
 data			data loss checkers
@@ -57,6 +56,7 @@ fsstress_online_repair	race fsstress and xfs_scrub online repair
 fsstress_scrub		race fsstress and xfs_scrub checking
 fuzzers_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 fuzzers			filesystem fuzz tests
+fuzzers_norepair	fuzzers to evaluate kernel metadata verifiers
 fuzzers_online_repair	fuzzers to evaluate xfs_scrub online repair
 fuzzers_repair		fuzzers to evaluate xfs_repair offline repair
 growfs			increasing the size of a filesystem
diff --git a/tests/xfs/453 b/tests/xfs/453
index d586f79dd838ee..c005454f835262 100755
--- a/tests/xfs/453
+++ b/tests/xfs/453
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/454 b/tests/xfs/454
index 828b2d93aa6408..36b5746e80b2ee 100755
--- a/tests/xfs/454
+++ b/tests/xfs/454
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/455 b/tests/xfs/455
index c5d05b26cd94d3..05e9cc3d7e57a1 100755
--- a/tests/xfs/455
+++ b/tests/xfs/455
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/456 b/tests/xfs/456
index 3b2291570af786..d1cc3d9a2c1b0d 100755
--- a/tests/xfs/456
+++ b/tests/xfs/456
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/457 b/tests/xfs/457
index 41b51fb607528c..cc4867a619f569 100755
--- a/tests/xfs/457
+++ b/tests/xfs/457
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/458 b/tests/xfs/458
index fff31ce9b14c83..fbb27213591a76 100755
--- a/tests/xfs/458
+++ b/tests/xfs/458
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/459 b/tests/xfs/459
index b55899aed107e1..384a699d8018ce 100755
--- a/tests/xfs/459
+++ b/tests/xfs/459
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/460 b/tests/xfs/460
index d67ae555f48e3e..5ca6a34594ba2c 100755
--- a/tests/xfs/460
+++ b/tests/xfs/460
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/461 b/tests/xfs/461
index 7609ce9b080552..d1f6adfe639538 100755
--- a/tests/xfs/461
+++ b/tests/xfs/461
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/462 b/tests/xfs/462
index 0831f8e963a26d..bd891d330a3ecf 100755
--- a/tests/xfs/462
+++ b/tests/xfs/462
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/463 b/tests/xfs/463
index cbfd9c3c693f3d..184e827f5327e2 100755
--- a/tests/xfs/463
+++ b/tests/xfs/463
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/464 b/tests/xfs/464
index 71ce355726c001..f82762c7e14222 100755
--- a/tests/xfs/464
+++ b/tests/xfs/464
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/465 b/tests/xfs/465
index 30c472459be043..2384b1b1d0fab7 100755
--- a/tests/xfs/465
+++ b/tests/xfs/465
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/466 b/tests/xfs/466
index 4a470c90805c80..523d20727a3046 100755
--- a/tests/xfs/466
+++ b/tests/xfs/466
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/467 b/tests/xfs/467
index d64a7bb8cebcdf..1c0fe8e06458a4 100755
--- a/tests/xfs/467
+++ b/tests/xfs/467
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/468 b/tests/xfs/468
index fa501e402b8029..8bc6bb87c76be8 100755
--- a/tests/xfs/468
+++ b/tests/xfs/468
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/469 b/tests/xfs/469
index 20fdb78dc5f430..810e1b1d409d33 100755
--- a/tests/xfs/469
+++ b/tests/xfs/469
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/470 b/tests/xfs/470
index 52be985b3bb59d..dfb9b2edd7bd36 100755
--- a/tests/xfs/470
+++ b/tests/xfs/470
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/471 b/tests/xfs/471
index 6b72b80a8f440a..e3bdee5257ec68 100755
--- a/tests/xfs/471
+++ b/tests/xfs/471
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/472 b/tests/xfs/472
index 0ec3335ed9166d..74168fb4bf675c 100755
--- a/tests/xfs/472
+++ b/tests/xfs/472
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/473 b/tests/xfs/473
index 12924aee262b46..c51e93743b60da 100755
--- a/tests/xfs/473
+++ b/tests/xfs/473
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/474 b/tests/xfs/474
index d3c073524c73b3..f01f8935a033a1 100755
--- a/tests/xfs/474
+++ b/tests/xfs/474
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/475 b/tests/xfs/475
index 06317ee2a516bd..acd9d433583e9e 100755
--- a/tests/xfs/475
+++ b/tests/xfs/475
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/476 b/tests/xfs/476
index dd2fbf4dab3b51..da8fbe3487ce2d 100755
--- a/tests/xfs/476
+++ b/tests/xfs/476
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/477 b/tests/xfs/477
index fccd4f56a2ac62..ec0db3a3fff59a 100755
--- a/tests/xfs/477
+++ b/tests/xfs/477
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/478 b/tests/xfs/478
index 5909bd496c1232..2cf5d669c07638 100755
--- a/tests/xfs/478
+++ b/tests/xfs/478
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/479 b/tests/xfs/479
index e59726ef1ceab3..f4388ae2ec1f47 100755
--- a/tests/xfs/479
+++ b/tests/xfs/479
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/480 b/tests/xfs/480
index e5a1fa96a26e97..5dc2982e3d52fd 100755
--- a/tests/xfs/480
+++ b/tests/xfs/480
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/481 b/tests/xfs/481
index bc36beeec657fa..43eb14aafb2903 100755
--- a/tests/xfs/481
+++ b/tests/xfs/481
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair realtime
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/482 b/tests/xfs/482
index 66e44efd1a5192..2b08b9aab2bb01 100755
--- a/tests/xfs/482
+++ b/tests/xfs/482
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair realtime
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/483 b/tests/xfs/483
index 5225a18a7149f0..da19812ec955e8 100755
--- a/tests/xfs/483
+++ b/tests/xfs/483
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/484 b/tests/xfs/484
index ef768df8c09d7f..865fcc6c859f0b 100755
--- a/tests/xfs/484
+++ b/tests/xfs/484
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/485 b/tests/xfs/485
index f3dbc4f6644647..d82a39a809fc5e 100755
--- a/tests/xfs/485
+++ b/tests/xfs/485
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/486 b/tests/xfs/486
index 8ee65c0cb8ee64..4bdcef8f87d2ff 100755
--- a/tests/xfs/486
+++ b/tests/xfs/486
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/487 b/tests/xfs/487
index 8bd646ed908b39..0a5403a25dfd82 100755
--- a/tests/xfs/487
+++ b/tests/xfs/487
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/488 b/tests/xfs/488
index c58d21e2208589..0e67889f26f7a0 100755
--- a/tests/xfs/488
+++ b/tests/xfs/488
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/489 b/tests/xfs/489
index b9df871a236d7e..ef65525c224764 100755
--- a/tests/xfs/489
+++ b/tests/xfs/489
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/498 b/tests/xfs/498
index f4671519453bc1..f8580e2b912857 100755
--- a/tests/xfs/498
+++ b/tests/xfs/498
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/735 b/tests/xfs/735
index 04bbcc5cb9aa99..861763b3db8bd8 100755
--- a/tests/xfs/735
+++ b/tests/xfs/735
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/738 b/tests/xfs/738
index 32f12a70b3097e..f432607075ca91 100755
--- a/tests/xfs/738
+++ b/tests/xfs/738
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/745 b/tests/xfs/745
index d139aeefdd8a37..38a858e8cffd0a 100755
--- a/tests/xfs/745
+++ b/tests/xfs/745
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/746 b/tests/xfs/746
index 696d024532982a..e81d4f93a9059f 100755
--- a/tests/xfs/746
+++ b/tests/xfs/746
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/788 b/tests/xfs/788
index 46438eabafd008..0864823a9e35d4 100755
--- a/tests/xfs/788
+++ b/tests/xfs/788
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 

