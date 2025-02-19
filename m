Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511A81EA80;
	Wed, 19 Feb 2025 00:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926236; cv=none; b=KU8r6+UlyVIVP/GoSHW+z0+v3N927KIc+zEyo3ojDi2yC2ruNqK3saIFnOoJzmklDXmH285vTZixP0PpxG91r620/7A49NkoXIzC0ARwF1iAe26F9WA6Ery/h7oaDK0lde3DlkYf8TkJ/Yxuu3oSyG6K+RALWg9aWXr4as0Zj+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926236; c=relaxed/simple;
	bh=7RCtd4EyE+YirhYqRWZdOyUnUvi0Z+/wHsjIIssMMRg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lE99avIA6KpFIAIgrZfgArQUqZjbgj7UsKIqdnokrVW5op/gokzucIsBSqiOqZOq3tmKrVWnksj1e2rFyasui0g5hAy1jn+ynZgpb/pIU8l1j/LDRx32l/JWTYsRa0BskesveWX0PkGWmwhPAKkG6j2P+ppQ5Ns7sH0UG4AixfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdjgwUpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdjgwUpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E10C4CEE2;
	Wed, 19 Feb 2025 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926235;
	bh=7RCtd4EyE+YirhYqRWZdOyUnUvi0Z+/wHsjIIssMMRg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NdjgwUpYu8wfhvfUfZLweZoJNC1bzlxRVdhUpeQdyXD2m85sZubhAcAMZMwzYSyOx
	 QmFEJsItfGIioSbrhaEBNdpiGZ74R1PBeccQRWbEjVftgfktGqRqzjAm2ywtOpgLh0
	 9tAFdU3+9EOlwCN49O7c58/KQJ2idgnmX23fw64hNKsWhscptL48VGNmptwmNwyq1N
	 7CGX6ukgDmfEVFYXij6O6GmBWuFnlIeKHszB8TuEk3bD3dY102lXfRgoVoHCDnIrgj
	 8fHME6iz+mqb40zt0H0j17dTddEoM/ODFthwYdczmYNXOGzmgigYP9s+AbOUf/t/EB
	 gAVDS9vfHZqUQ==
Date: Tue, 18 Feb 2025 16:50:35 -0800
Subject: [PATCH 01/12] misc: drop the dangerous label from xfs_scrub fsstress
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587421.4078254.643040435477009688.stgit@frogsfrogsfrogs>
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
think it's stabilized enough that we don't need to hide the stress tests
behind the "dangerous" label anymore.

Also rename fsstress_repair to fsstress_online_repair to be consistent
with the online_repair group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    4 ++--
 tests/xfs/285       |    2 +-
 tests/xfs/286       |    2 +-
 tests/xfs/422       |    2 +-
 tests/xfs/561       |    2 +-
 tests/xfs/562       |    2 +-
 tests/xfs/563       |    2 +-
 tests/xfs/564       |    2 +-
 tests/xfs/565       |    2 +-
 tests/xfs/566       |    2 +-
 tests/xfs/570       |    2 +-
 tests/xfs/571       |    2 +-
 tests/xfs/572       |    2 +-
 tests/xfs/573       |    2 +-
 tests/xfs/574       |    2 +-
 tests/xfs/575       |    2 +-
 tests/xfs/576       |    2 +-
 tests/xfs/577       |    2 +-
 tests/xfs/578       |    2 +-
 tests/xfs/579       |    2 +-
 tests/xfs/580       |    2 +-
 tests/xfs/581       |    2 +-
 tests/xfs/582       |    2 +-
 tests/xfs/583       |    2 +-
 tests/xfs/584       |    2 +-
 tests/xfs/585       |    2 +-
 tests/xfs/586       |    2 +-
 tests/xfs/587       |    2 +-
 tests/xfs/588       |    2 +-
 tests/xfs/589       |    2 +-
 tests/xfs/590       |    2 +-
 tests/xfs/591       |    2 +-
 tests/xfs/592       |    2 +-
 tests/xfs/593       |    2 +-
 tests/xfs/594       |    2 +-
 tests/xfs/595       |    2 +-
 tests/xfs/621       |    2 +-
 tests/xfs/622       |    2 +-
 tests/xfs/628       |    2 +-
 tests/xfs/708       |    2 +-
 tests/xfs/709       |    2 +-
 tests/xfs/710       |    2 +-
 tests/xfs/711       |    2 +-
 tests/xfs/712       |    2 +-
 tests/xfs/713       |    2 +-
 tests/xfs/714       |    2 +-
 tests/xfs/715       |    2 +-
 tests/xfs/717       |    2 +-
 tests/xfs/718       |    2 +-
 tests/xfs/719       |    2 +-
 tests/xfs/721       |    2 +-
 tests/xfs/722       |    2 +-
 tests/xfs/723       |    2 +-
 tests/xfs/724       |    2 +-
 tests/xfs/725       |    2 +-
 tests/xfs/726       |    2 +-
 tests/xfs/727       |    2 +-
 tests/xfs/728       |    2 +-
 tests/xfs/729       |    2 +-
 tests/xfs/731       |    2 +-
 tests/xfs/793       |    2 +-
 tests/xfs/794       |    2 +-
 tests/xfs/796       |    2 +-
 tests/xfs/797       |    2 +-
 tests/xfs/799       |    2 +-
 tests/xfs/800       |    2 +-
 tests/xfs/801       |    2 +-
 67 files changed, 68 insertions(+), 68 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index f5bf79a56c3304..57aa2001311383 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -34,8 +34,6 @@ dangerous_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
-dangerous_fsstress_repair	race fsstress and xfs_scrub online repair
-dangerous_fsstress_scrub	race fsstress and xfs_scrub checking
 dangerous_repair	fuzzers to evaluate xfs_repair offline repair
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 dangerous_selftest	selftests that crash/hang
@@ -58,6 +56,8 @@ fsck			general fsck tests
 fsmap			FS_IOC_GETFSMAP ioctl
 fsproperties		Filesystem properties
 fsr			XFS free space reorganizer
+fsstress_online_repair	race fsstress and xfs_scrub online repair
+fsstress_scrub		race fsstress and xfs_scrub checking
 fuzzers			filesystem fuzz tests
 growfs			increasing the size of a filesystem
 hardlink		hardlinks
diff --git a/tests/xfs/285 b/tests/xfs/285
index 909db488b3c3ab..f08cb449b61ad4 100755
--- a/tests/xfs/285
+++ b/tests/xfs/285
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/286 b/tests/xfs/286
index 7743d03718a478..046638296e04c6 100755
--- a/tests/xfs/286
+++ b/tests/xfs/286
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/422 b/tests/xfs/422
index 1043d419145fcf..833fb93a1684e9 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -7,7 +7,7 @@
 # Race fsstress and rmapbt repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair freeze
+_begin_fstest online_repair fsstress_online_repair freeze
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/561 b/tests/xfs/561
index bbfcefcb13d13a..baf8a450b96a7e 100755
--- a/tests/xfs/561
+++ b/tests/xfs/561
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/562 b/tests/xfs/562
index 354992a614da67..aac363f071abd8 100755
--- a/tests/xfs/562
+++ b/tests/xfs/562
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/563 b/tests/xfs/563
index 3cd00651e4bf82..db5f94e67a0507 100755
--- a/tests/xfs/563
+++ b/tests/xfs/563
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/564 b/tests/xfs/564
index ae45952fea6034..5c21f5cf305913 100755
--- a/tests/xfs/564
+++ b/tests/xfs/564
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/565 b/tests/xfs/565
index 40f1139ae4a520..43185a253d4d71 100755
--- a/tests/xfs/565
+++ b/tests/xfs/565
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/566 b/tests/xfs/566
index 19c73ff9ec0ab0..5398d1d0827ca2 100755
--- a/tests/xfs/566
+++ b/tests/xfs/566
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/570 b/tests/xfs/570
index 4e64a03a0c8bbb..707ff232807025 100755
--- a/tests/xfs/570
+++ b/tests/xfs/570
@@ -7,7 +7,7 @@
 # Race fsstress and superblock scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/571 b/tests/xfs/571
index 016387b43c631e..ce1ca3969dac22 100755
--- a/tests/xfs/571
+++ b/tests/xfs/571
@@ -7,7 +7,7 @@
 # Race fsstress and AGF scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/572 b/tests/xfs/572
index dfee982504cfd6..01122decf7d9b9 100755
--- a/tests/xfs/572
+++ b/tests/xfs/572
@@ -7,7 +7,7 @@
 # Race fsstress and AGFL scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/573 b/tests/xfs/573
index 5ff1bdbdc7a7d6..11c10a695bddc7 100755
--- a/tests/xfs/573
+++ b/tests/xfs/573
@@ -7,7 +7,7 @@
 # Race fsstress and AGI scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/574 b/tests/xfs/574
index 6250f5142c63ea..a6d7bf91100272 100755
--- a/tests/xfs/574
+++ b/tests/xfs/574
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/575 b/tests/xfs/575
index 6cf321ce47d4fb..75cc73e4c6a5cd 100755
--- a/tests/xfs/575
+++ b/tests/xfs/575
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/576 b/tests/xfs/576
index d3d3e783eea3e5..ffa5cacfb6ab9c 100755
--- a/tests/xfs/576
+++ b/tests/xfs/576
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/577 b/tests/xfs/577
index 35ca1468c2f64a..9afe9b2ee4b74f 100755
--- a/tests/xfs/577
+++ b/tests/xfs/577
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/578 b/tests/xfs/578
index 2101eb55c0a928..cc1203777ff02a 100755
--- a/tests/xfs/578
+++ b/tests/xfs/578
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/579 b/tests/xfs/579
index e552e499296efc..aa72276dd3b216 100755
--- a/tests/xfs/579
+++ b/tests/xfs/579
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/580 b/tests/xfs/580
index dac036f4ae5a0a..70a080e7a34fe5 100755
--- a/tests/xfs/580
+++ b/tests/xfs/580
@@ -8,7 +8,7 @@
 # if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/581 b/tests/xfs/581
index 73b51f994a3f00..39eb42da4b10c5 100755
--- a/tests/xfs/581
+++ b/tests/xfs/581
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/582 b/tests/xfs/582
index f390b77f3439ee..e92f128f8a5695 100755
--- a/tests/xfs/582
+++ b/tests/xfs/582
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/583 b/tests/xfs/583
index dcc60f126ed7f4..fc91d8f2596a44 100755
--- a/tests/xfs/583
+++ b/tests/xfs/583
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/584 b/tests/xfs/584
index 3f62261c06bbb3..12442b53c72abc 100755
--- a/tests/xfs/584
+++ b/tests/xfs/584
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/585 b/tests/xfs/585
index 987c799f5c2011..3f1b814c025349 100755
--- a/tests/xfs/585
+++ b/tests/xfs/585
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/586 b/tests/xfs/586
index d78dea5185ddfc..9e2312f4d1c05a 100755
--- a/tests/xfs/586
+++ b/tests/xfs/586
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/587 b/tests/xfs/587
index a9d4690471193c..0ae2f4c3bcc380 100755
--- a/tests/xfs/587
+++ b/tests/xfs/587
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/588 b/tests/xfs/588
index bd0788d3f18faf..a2249cc4aa9dbe 100755
--- a/tests/xfs/588
+++ b/tests/xfs/588
@@ -7,7 +7,7 @@
 # Race fsstress and data fork scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/589 b/tests/xfs/589
index 806c445fc43f2d..378e4f678ec51f 100755
--- a/tests/xfs/589
+++ b/tests/xfs/589
@@ -7,7 +7,7 @@
 # Race fsstress and attr fork scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/590 b/tests/xfs/590
index 59a42f11b68983..3a200ffc93c744 100755
--- a/tests/xfs/590
+++ b/tests/xfs/590
@@ -7,7 +7,7 @@
 # Race fsstress and cow fork scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/591 b/tests/xfs/591
index 9f080ebbefa7f7..856e2dfd1f0f51 100755
--- a/tests/xfs/591
+++ b/tests/xfs/591
@@ -7,7 +7,7 @@
 # Race fsstress and directory scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/592 b/tests/xfs/592
index 653ad256905fef..998be997519347 100755
--- a/tests/xfs/592
+++ b/tests/xfs/592
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/593 b/tests/xfs/593
index 118b7e75931d24..1706c83b912cc5 100755
--- a/tests/xfs/593
+++ b/tests/xfs/593
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/594 b/tests/xfs/594
index c86234e1f62778..7de5eed556eda7 100755
--- a/tests/xfs/594
+++ b/tests/xfs/594
@@ -8,7 +8,7 @@
 # We can't open symlink files directly for scrubbing, so we use xfs_scrub(8).
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/595 b/tests/xfs/595
index 75797b6cc41107..12cd0352b559cb 100755
--- a/tests/xfs/595
+++ b/tests/xfs/595
@@ -9,7 +9,7 @@
 # xfs_scrub(8).
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/621 b/tests/xfs/621
index 24fbbc4e9bbc0e..feafc6fd560b0d 100755
--- a/tests/xfs/621
+++ b/tests/xfs/621
@@ -8,7 +8,7 @@
 # see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/622 b/tests/xfs/622
index 59503cfa940422..2ba27947b39139 100755
--- a/tests/xfs/622
+++ b/tests/xfs/622
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/628 b/tests/xfs/628
index 8dc2689888e778..c77d67db358983 100755
--- a/tests/xfs/628
+++ b/tests/xfs/628
@@ -9,7 +9,7 @@
 # handle unlinked directories.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/708 b/tests/xfs/708
index 40c4d92d241b74..6e4e98f40ced96 100755
--- a/tests/xfs/708
+++ b/tests/xfs/708
@@ -7,7 +7,7 @@
 # Race fsstress and bnobt repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/709 b/tests/xfs/709
index 3a29ca12fc3b23..ae531359199e09 100755
--- a/tests/xfs/709
+++ b/tests/xfs/709
@@ -7,7 +7,7 @@
 # Race fsstress and inobt repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/710 b/tests/xfs/710
index dc599c0b647ab2..4e9d9862801e13 100755
--- a/tests/xfs/710
+++ b/tests/xfs/710
@@ -7,7 +7,7 @@
 # Race fsstress and refcountbt repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/711 b/tests/xfs/711
index 685ada10b82693..2bd2812cee8a0c 100755
--- a/tests/xfs/711
+++ b/tests/xfs/711
@@ -7,7 +7,7 @@
 # Race fsstress and superblock repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/712 b/tests/xfs/712
index 15a94a525bd99c..ef6afdc681704b 100755
--- a/tests/xfs/712
+++ b/tests/xfs/712
@@ -7,7 +7,7 @@
 # Race fsstress and agf repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/713 b/tests/xfs/713
index 551653917eba4b..32603fd1ddd6dc 100755
--- a/tests/xfs/713
+++ b/tests/xfs/713
@@ -7,7 +7,7 @@
 # Race fsstress and agfl repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/714 b/tests/xfs/714
index aa209ce5bb21ee..4371d93f125031 100755
--- a/tests/xfs/714
+++ b/tests/xfs/714
@@ -7,7 +7,7 @@
 # Race fsstress and agi repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/715 b/tests/xfs/715
index e6821c02556c98..01c1963ef974d8 100755
--- a/tests/xfs/715
+++ b/tests/xfs/715
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/717 b/tests/xfs/717
index 6368d704b8b0ee..ac8e83f66749d8 100755
--- a/tests/xfs/717
+++ b/tests/xfs/717
@@ -7,7 +7,7 @@
 # Race fsstress and data fork repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/718 b/tests/xfs/718
index 7b0fe2c467876c..6bff5461f20976 100755
--- a/tests/xfs/718
+++ b/tests/xfs/718
@@ -7,7 +7,7 @@
 # Race fsstress and attr fork repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/719 b/tests/xfs/719
index 81805402055468..8ea2faf796dc19 100755
--- a/tests/xfs/719
+++ b/tests/xfs/719
@@ -7,7 +7,7 @@
 # Race fsstress and CoW fork repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/721 b/tests/xfs/721
index c25cd269d8470b..fe9a93314e09d5 100755
--- a/tests/xfs/721
+++ b/tests/xfs/721
@@ -8,7 +8,7 @@
 # We can't open special files directly for scrubbing, so we use xfs_scrub(8).
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/722 b/tests/xfs/722
index b96163e32d0570..f04914945c4522 100755
--- a/tests/xfs/722
+++ b/tests/xfs/722
@@ -9,7 +9,7 @@
 # xfs_scrub(8).
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/723 b/tests/xfs/723
index 21b608aaae3f56..1cd3f7a7922503 100755
--- a/tests/xfs/723
+++ b/tests/xfs/723
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/724 b/tests/xfs/724
index a832063bed9573..890140b9978b7c 100755
--- a/tests/xfs/724
+++ b/tests/xfs/724
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/725 b/tests/xfs/725
index 2972aeb7164c4a..7e843d75689ed0 100755
--- a/tests/xfs/725
+++ b/tests/xfs/725
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/726 b/tests/xfs/726
index f4bedcca5f9fc7..24f5ef7e352b63 100755
--- a/tests/xfs/726
+++ b/tests/xfs/726
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/727 b/tests/xfs/727
index 2e882775442e71..d9abea46b36a91 100755
--- a/tests/xfs/727
+++ b/tests/xfs/727
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/728 b/tests/xfs/728
index b4cf95f57baae2..cc3f41c6b7e6cf 100755
--- a/tests/xfs/728
+++ b/tests/xfs/728
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/729 b/tests/xfs/729
index 45d65892eac29d..710ace978abdb8 100755
--- a/tests/xfs/729
+++ b/tests/xfs/729
@@ -7,7 +7,7 @@
 # Race fsstress and nlinks scrub for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/731 b/tests/xfs/731
index 8cc38f5841119f..496fd78a58cf77 100755
--- a/tests/xfs/731
+++ b/tests/xfs/731
@@ -9,7 +9,7 @@
 # filesystem activity, so we can't have userspace wandering in and thawing it.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/793 b/tests/xfs/793
index d942d9807967b5..a779bf81738537 100755
--- a/tests/xfs/793
+++ b/tests/xfs/793
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/794 b/tests/xfs/794
index cdccf9699861f3..e0025ed5729658 100755
--- a/tests/xfs/794
+++ b/tests/xfs/794
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/796 b/tests/xfs/796
index e6a88cc6b21f89..df1161b7288c99 100755
--- a/tests/xfs/796
+++ b/tests/xfs/796
@@ -7,7 +7,7 @@
 # Race fsstress and directory repair for a while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/797 b/tests/xfs/797
index 642930f2feebeb..a9d1a6c162c0c1 100755
--- a/tests/xfs/797
+++ b/tests/xfs/797
@@ -8,7 +8,7 @@
 # livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	_scratch_xfs_stress_scrub_cleanup &> /dev/null
diff --git a/tests/xfs/799 b/tests/xfs/799
index 0a43eb01199e69..da13247b098b1f 100755
--- a/tests/xfs/799
+++ b/tests/xfs/799
@@ -8,7 +8,7 @@
 # while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/800 b/tests/xfs/800
index f12ef69e0afa3b..40ad12a15c1d80 100755
--- a/tests/xfs/800
+++ b/tests/xfs/800
@@ -8,7 +8,7 @@
 # while to see if we crash or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub dangerous_fsstress_scrub
+_begin_fstest scrub fsstress_scrub
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/801 b/tests/xfs/801
index 53122352ad75a3..1190cfab8a9f94 100755
--- a/tests/xfs/801
+++ b/tests/xfs/801
@@ -9,7 +9,7 @@
 # because the xfile code wasn't folioized.
 #
 . ./common/preamble
-_begin_fstest online_repair dangerous_fsstress_repair
+_begin_fstest online_repair fsstress_online_repair
 
 declare -A oldvalues
 

