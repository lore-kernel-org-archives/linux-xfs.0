Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC718E1A;
	Wed, 19 Feb 2025 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926251; cv=none; b=VUYAYsj5qWGBwnVJH6bc9mBTt1+lC+eYsb0N6D7ukOSzKL07RsX7V4mFoWl5owv772cgYzOg69CYi7e1Vz8rGQQZ5sw8suMSKAhhpdiSnxhJS/KTm2lPhbhlIxuFE/Zke1aaYThzoZ+XSyGY2h21DmMETOTaf09cpuIMdySloD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926251; c=relaxed/simple;
	bh=Pdo4jum97oxtLMf9nXg+sQs4Vv9nb2Ncl+f8UfufIBA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gcrGT+uYUXOueT/Mxn3/UW8qwgfhCjcQGDY4t85ji9YIOsMs1k+5K9M7l79udhQlccD6zhTxXoAO6L/47a1XNEJrE03yjWr/NUmiYKliDnSUlaFsv0ssFqHtnJJgAKOG5BWhi1RgObua5lkN+mP5fpVELjdNGlBo0OCt8Lz10UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pwrgfr30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pwrgfr30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFB4C4CEE2;
	Wed, 19 Feb 2025 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926251;
	bh=Pdo4jum97oxtLMf9nXg+sQs4Vv9nb2Ncl+f8UfufIBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pwrgfr30pePyXHWVh9Oqet4Rtt0MTOxWnana5i/UcCDSGuaGJ3VIIUlQpw2pDeRLg
	 I/Ea7+cZ6MNmk00V4Oqahs1hrUbjJdgcdH60jI7UVwZgSNXHgYSUmGah+aYPZFJSrn
	 8FwtwECwdWADqOnCvsDl0OfRV13OXEtI3iqnsZxyTfQ/vZyqAJ9UtDu+pETIsX/alM
	 jESjogsT8cZPgftoKqQegEPo9ywiXV4CmLF0T09s7hGqSSSd208Np4UdsfeYGkLmsw
	 D05n6DvoSxaI+dTdFUlIeNCICZ5JR77ZDT4KjrCNkpB5nqMt/fg1Sm3NDpmKtPblEm
	 aKBNPovNcQIew==
Date: Tue, 18 Feb 2025 16:50:50 -0800
Subject: [PATCH 02/12] misc: rename the dangerous_repair group to
 fuzzers_repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587440.4078254.13008688687033031883.stgit@frogsfrogsfrogs>
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

xfs_repair has been stable for many years now, so I think it's time the
fuzz tests for it stopped hiding behind the "dangerous" label.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    2 +-
 tests/xfs/350       |    2 +-
 tests/xfs/352       |    2 +-
 tests/xfs/354       |    2 +-
 tests/xfs/356       |    2 +-
 tests/xfs/358       |    2 +-
 tests/xfs/360       |    2 +-
 tests/xfs/362       |    2 +-
 tests/xfs/364       |    2 +-
 tests/xfs/366       |    2 +-
 tests/xfs/368       |    2 +-
 tests/xfs/370       |    2 +-
 tests/xfs/372       |    2 +-
 tests/xfs/374       |    2 +-
 tests/xfs/376       |    2 +-
 tests/xfs/378       |    2 +-
 tests/xfs/380       |    2 +-
 tests/xfs/382       |    2 +-
 tests/xfs/384       |    2 +-
 tests/xfs/386       |    2 +-
 tests/xfs/388       |    2 +-
 tests/xfs/390       |    2 +-
 tests/xfs/392       |    2 +-
 tests/xfs/394       |    2 +-
 tests/xfs/396       |    2 +-
 tests/xfs/398       |    2 +-
 tests/xfs/400       |    2 +-
 tests/xfs/402       |    2 +-
 tests/xfs/404       |    2 +-
 tests/xfs/406       |    2 +-
 tests/xfs/408       |    2 +-
 tests/xfs/410       |    2 +-
 tests/xfs/412       |    2 +-
 tests/xfs/414       |    2 +-
 tests/xfs/416       |    2 +-
 tests/xfs/418       |    2 +-
 tests/xfs/425       |    2 +-
 tests/xfs/427       |    2 +-
 tests/xfs/429       |    2 +-
 tests/xfs/496       |    2 +-
 tests/xfs/734       |    2 +-
 tests/xfs/737       |    2 +-
 tests/xfs/741       |    2 +-
 tests/xfs/742       |    2 +-
 tests/xfs/785       |    2 +-
 45 files changed, 45 insertions(+), 45 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 57aa2001311383..cf263ed537db1f 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -34,7 +34,6 @@ dangerous_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
-dangerous_repair	fuzzers to evaluate xfs_repair offline repair
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
 dangerous_selftest	selftests that crash/hang
 data			data loss checkers
@@ -59,6 +58,7 @@ fsr			XFS free space reorganizer
 fsstress_online_repair	race fsstress and xfs_scrub online repair
 fsstress_scrub		race fsstress and xfs_scrub checking
 fuzzers			filesystem fuzz tests
+fuzzers_repair		fuzzers to evaluate xfs_repair offline repair
 growfs			increasing the size of a filesystem
 hardlink		hardlinks
 health			XFS health reporting
diff --git a/tests/xfs/350 b/tests/xfs/350
index 4e618f41c5a4bf..99596dc81c2160 100755
--- a/tests/xfs/350
+++ b/tests/xfs/350
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/352 b/tests/xfs/352
index 8f56a2b8f6987b..9da8db57b83250 100755
--- a/tests/xfs/352
+++ b/tests/xfs/352
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/354 b/tests/xfs/354
index 625c4e955c57dc..645b8152223ef3 100755
--- a/tests/xfs/354
+++ b/tests/xfs/354
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/356 b/tests/xfs/356
index 3529425eb31504..5d6497a1867918 100755
--- a/tests/xfs/356
+++ b/tests/xfs/356
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/358 b/tests/xfs/358
index 11b29c5ce1efbe..4fab6e72c4226f 100755
--- a/tests/xfs/358
+++ b/tests/xfs/358
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/360 b/tests/xfs/360
index 7f5348a18a898d..7385506824d7d1 100755
--- a/tests/xfs/360
+++ b/tests/xfs/360
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/362 b/tests/xfs/362
index 0b54fc580bdc9d..f1678aee1ea0ce 100755
--- a/tests/xfs/362
+++ b/tests/xfs/362
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/364 b/tests/xfs/364
index 002b4765055816..aa5acbe2a07b3f 100755
--- a/tests/xfs/364
+++ b/tests/xfs/364
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/366 b/tests/xfs/366
index e902d1d360066d..2f28810cc3da03 100755
--- a/tests/xfs/366
+++ b/tests/xfs/366
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/368 b/tests/xfs/368
index 3de32a0c3bf191..75046e4a9cad47 100755
--- a/tests/xfs/368
+++ b/tests/xfs/368
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/370 b/tests/xfs/370
index ff19505b4d4abd..16e444f8da9d3c 100755
--- a/tests/xfs/370
+++ b/tests/xfs/370
@@ -9,7 +9,7 @@
 # Use xfs_repair to repair the problems.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/372 b/tests/xfs/372
index 01ac0e2b63fdb4..0599c9b830a27b 100755
--- a/tests/xfs/372
+++ b/tests/xfs/372
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/374 b/tests/xfs/374
index 807a8cd015a32a..0d69129f1652c7 100755
--- a/tests/xfs/374
+++ b/tests/xfs/374
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/376 b/tests/xfs/376
index dfca8f0be16433..fe47b00bcc33d5 100755
--- a/tests/xfs/376
+++ b/tests/xfs/376
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/378 b/tests/xfs/378
index 94c0dcdbc8ad65..c2d37e7125c307 100755
--- a/tests/xfs/378
+++ b/tests/xfs/378
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/380 b/tests/xfs/380
index 84715b09f26420..bd3c2cdc136495 100755
--- a/tests/xfs/380
+++ b/tests/xfs/380
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/382 b/tests/xfs/382
index ee7a18208b99bc..85a612c18c3d6f 100755
--- a/tests/xfs/382
+++ b/tests/xfs/382
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/384 b/tests/xfs/384
index 490701e438d0f2..45d235a8347c85 100755
--- a/tests/xfs/384
+++ b/tests/xfs/384
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/386 b/tests/xfs/386
index f8f5798cd49347..9b3023ad2b3af6 100755
--- a/tests/xfs/386
+++ b/tests/xfs/386
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/388 b/tests/xfs/388
index 504f786fbdd2db..2e1eb7f13de44a 100755
--- a/tests/xfs/388
+++ b/tests/xfs/388
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/390 b/tests/xfs/390
index c272fd8940cb40..4969bf66105513 100755
--- a/tests/xfs/390
+++ b/tests/xfs/390
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/392 b/tests/xfs/392
index 8eb7b962d16318..619665f8e3aa38 100755
--- a/tests/xfs/392
+++ b/tests/xfs/392
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/394 b/tests/xfs/394
index 692d45f548fe15..fd6a3330c31b60 100755
--- a/tests/xfs/394
+++ b/tests/xfs/394
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/396 b/tests/xfs/396
index 9b2a9a068a7e28..a7bcaa4a86ea2b 100755
--- a/tests/xfs/396
+++ b/tests/xfs/396
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/398 b/tests/xfs/398
index d9826725f9fc10..1b91347c4edb1e 100755
--- a/tests/xfs/398
+++ b/tests/xfs/398
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/400 b/tests/xfs/400
index 7191cff0be6abb..01f59b1b471f68 100755
--- a/tests/xfs/400
+++ b/tests/xfs/400
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/402 b/tests/xfs/402
index 0c2174e2ed417e..2bb4fc9c23bb1e 100755
--- a/tests/xfs/402
+++ b/tests/xfs/402
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/404 b/tests/xfs/404
index 2901b015c88d1e..075a788a66e638 100755
--- a/tests/xfs/404
+++ b/tests/xfs/404
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/406 b/tests/xfs/406
index 444dbd7266f498..9815090c9db335 100755
--- a/tests/xfs/406
+++ b/tests/xfs/406
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/408 b/tests/xfs/408
index 55b061ed436376..1e1a7a7336c093 100755
--- a/tests/xfs/408
+++ b/tests/xfs/408
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/410 b/tests/xfs/410
index 4155e03b5d9579..78da6cb4f2fec5 100755
--- a/tests/xfs/410
+++ b/tests/xfs/410
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/412 b/tests/xfs/412
index 2119282f988106..ba1eb482276782 100755
--- a/tests/xfs/412
+++ b/tests/xfs/412
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/414 b/tests/xfs/414
index c92c6eb0fc33fa..18ed8343eb4e4f 100755
--- a/tests/xfs/414
+++ b/tests/xfs/414
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/416 b/tests/xfs/416
index 2ee0e75140bcdc..68094b841fcace 100755
--- a/tests/xfs/416
+++ b/tests/xfs/416
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/418 b/tests/xfs/418
index dd7b70a46901cd..41ec77041f0d4d 100755
--- a/tests/xfs/418
+++ b/tests/xfs/418
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/425 b/tests/xfs/425
index 9ca10c666b3b1d..6108e19c0b5650 100755
--- a/tests/xfs/425
+++ b/tests/xfs/425
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/427 b/tests/xfs/427
index 539cb4f15ce4c0..c19c02f4ee3374 100755
--- a/tests/xfs/427
+++ b/tests/xfs/427
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/429 b/tests/xfs/429
index b0b5fa5770394b..eeb35945ec20d1 100755
--- a/tests/xfs/429
+++ b/tests/xfs/429
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/496 b/tests/xfs/496
index 22282ba0eb8c52..af1a636faa6049 100755
--- a/tests/xfs/496
+++ b/tests/xfs/496
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/734 b/tests/xfs/734
index 1ae020ea2d9397..3fe41ac2fe80ea 100755
--- a/tests/xfs/734
+++ b/tests/xfs/734
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/737 b/tests/xfs/737
index d85d251252126d..0e35bbe340ea73 100755
--- a/tests/xfs/737
+++ b/tests/xfs/737
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/741 b/tests/xfs/741
index 4e24fb4e2fef31..da0805273bd255 100755
--- a/tests/xfs/741
+++ b/tests/xfs/741
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/742 b/tests/xfs/742
index eabe766d725c07..d699aa10c68f6a 100755
--- a/tests/xfs/742
+++ b/tests/xfs/742
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/785 b/tests/xfs/785
index a51f62e842a5b6..f3707c730f31ac 100755
--- a/tests/xfs/785
+++ b/tests/xfs/785
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 

