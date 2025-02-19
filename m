Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB9D18C345;
	Wed, 19 Feb 2025 00:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926314; cv=none; b=jXRE0a4/l2nSJubRkIxcL7cug6VBM0Ujo6JUGKNDqim1WpWUnJuAQrDxjhuyxbvvSjLKhf8GT7ViMfx+ctNHWrlOkqbPMVdtnRqs6/CjQeE9fzaFYygpB7W9/IgTwQ2vYTlJyZSfkJzxdxBGGtElumMcaMW7lS+mcrHkJuT0uTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926314; c=relaxed/simple;
	bh=y5UjTnzGD+CQAU20GqBeIqVfkQXzJhvv3k+gykG96I4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HHmVWLY/au1QfVQm85SAcl6FiL29MX2kQDppFuuu+N85CYshgovk8vRhtWx6vZnyxVWJq+KKlF0veBNO9QmfiCY+oyaz8vOzXDAB2oZ2BzsS/5PCzUsyLDcAj9aPiYLKjTqgrq+f9gBycoxMy5p3fQW5mFjGv3XMMJVjH3Gglyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1KD4arQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1KD4arQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7FEC4CEE2;
	Wed, 19 Feb 2025 00:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926314;
	bh=y5UjTnzGD+CQAU20GqBeIqVfkQXzJhvv3k+gykG96I4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q1KD4arQG7U4kVekKtuKynIMBZkFcZmE8k2F/ZgTP9YwNpEcsm3UMaX4UyL6q35JD
	 n0B799DhDSMJuxTx+rcpAuJxtRhorN7UTJOR1Rhxq/3jtTEonfzP9Uv1J2ru4usRzL
	 jELMa8y89r4HWQ4F82sadea6rC7O51fyMNAmE+XTe3GqL6TyRzGR74OVvu2z1d5w9C
	 CMBowHwTIMAXVkfzSaOm8fPfm29tJUlUrhdFrtBkxpTmCcAe4y/cjkvfFWug141fyr
	 5+IC/0c+xuCzkBf3plQF+Wskh99/53J0O72EN0QQfYIYmMQmfrJ6NyVV0eZKkfRPey
	 t65O7SA/fhp3A==
Date: Tue, 18 Feb 2025 16:51:53 -0800
Subject: [PATCH 06/12] misc: fix misclassification of xfs_repair fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587514.4078254.13210003661775451613.stgit@frogsfrogsfrogs>
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

All the tests in the "fuzzers_repair" group actually test xfs_repair,
not scrub.  Therefore, we should remove them all from 'dangerous_scrub'
and put them in the 'repair' group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/350 |    2 +-
 tests/xfs/352 |    2 +-
 tests/xfs/354 |    2 +-
 tests/xfs/356 |    2 +-
 tests/xfs/358 |    2 +-
 tests/xfs/360 |    2 +-
 tests/xfs/362 |    2 +-
 tests/xfs/364 |    2 +-
 tests/xfs/366 |    2 +-
 tests/xfs/368 |    2 +-
 tests/xfs/370 |    2 +-
 tests/xfs/372 |    2 +-
 tests/xfs/374 |    2 +-
 tests/xfs/376 |    2 +-
 tests/xfs/378 |    2 +-
 tests/xfs/380 |    2 +-
 tests/xfs/382 |    2 +-
 tests/xfs/384 |    2 +-
 tests/xfs/386 |    2 +-
 tests/xfs/388 |    2 +-
 tests/xfs/390 |    2 +-
 tests/xfs/392 |    2 +-
 tests/xfs/394 |    2 +-
 tests/xfs/396 |    2 +-
 tests/xfs/398 |    2 +-
 tests/xfs/400 |    2 +-
 tests/xfs/402 |    2 +-
 tests/xfs/404 |    2 +-
 tests/xfs/406 |    2 +-
 tests/xfs/408 |    2 +-
 tests/xfs/410 |    2 +-
 tests/xfs/412 |    2 +-
 tests/xfs/414 |    2 +-
 tests/xfs/416 |    2 +-
 tests/xfs/418 |    2 +-
 tests/xfs/425 |    2 +-
 tests/xfs/427 |    2 +-
 tests/xfs/429 |    2 +-
 tests/xfs/496 |    2 +-
 tests/xfs/734 |    2 +-
 tests/xfs/737 |    2 +-
 tests/xfs/741 |    2 +-
 tests/xfs/742 |    2 +-
 tests/xfs/785 |    2 +-
 44 files changed, 44 insertions(+), 44 deletions(-)


diff --git a/tests/xfs/350 b/tests/xfs/350
index 99596dc81c2160..ec49cc8d149094 100755
--- a/tests/xfs/350
+++ b/tests/xfs/350
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/352 b/tests/xfs/352
index 9da8db57b83250..d672a5c0d0bece 100755
--- a/tests/xfs/352
+++ b/tests/xfs/352
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/354 b/tests/xfs/354
index 645b8152223ef3..bed0c5d70bf170 100755
--- a/tests/xfs/354
+++ b/tests/xfs/354
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/356 b/tests/xfs/356
index 5d6497a1867918..bc8a7cc90e621a 100755
--- a/tests/xfs/356
+++ b/tests/xfs/356
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/358 b/tests/xfs/358
index 4fab6e72c4226f..f2345928ce7d74 100755
--- a/tests/xfs/358
+++ b/tests/xfs/358
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/360 b/tests/xfs/360
index 7385506824d7d1..0b423a934af16e 100755
--- a/tests/xfs/360
+++ b/tests/xfs/360
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/362 b/tests/xfs/362
index f1678aee1ea0ce..a95ecfb6165c08 100755
--- a/tests/xfs/362
+++ b/tests/xfs/362
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/364 b/tests/xfs/364
index aa5acbe2a07b3f..63e344240ff6d9 100755
--- a/tests/xfs/364
+++ b/tests/xfs/364
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/366 b/tests/xfs/366
index 2f28810cc3da03..9f32361306b927 100755
--- a/tests/xfs/366
+++ b/tests/xfs/366
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/368 b/tests/xfs/368
index 75046e4a9cad47..f30fcd2f3263f0 100755
--- a/tests/xfs/368
+++ b/tests/xfs/368
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/370 b/tests/xfs/370
index 16e444f8da9d3c..6f59757174bc41 100755
--- a/tests/xfs/370
+++ b/tests/xfs/370
@@ -9,7 +9,7 @@
 # Use xfs_repair to repair the problems.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/372 b/tests/xfs/372
index 0599c9b830a27b..2f2010b36a9e53 100755
--- a/tests/xfs/372
+++ b/tests/xfs/372
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/374 b/tests/xfs/374
index 0d69129f1652c7..8237bc1665b3a5 100755
--- a/tests/xfs/374
+++ b/tests/xfs/374
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/376 b/tests/xfs/376
index fe47b00bcc33d5..80e19f56d2b911 100755
--- a/tests/xfs/376
+++ b/tests/xfs/376
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/378 b/tests/xfs/378
index c2d37e7125c307..3eeb0e99429213 100755
--- a/tests/xfs/378
+++ b/tests/xfs/378
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/380 b/tests/xfs/380
index bd3c2cdc136495..45cbea8f391a9a 100755
--- a/tests/xfs/380
+++ b/tests/xfs/380
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/382 b/tests/xfs/382
index 85a612c18c3d6f..9ee2ca0a987855 100755
--- a/tests/xfs/382
+++ b/tests/xfs/382
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/384 b/tests/xfs/384
index 45d235a8347c85..a22768c800f9c0 100755
--- a/tests/xfs/384
+++ b/tests/xfs/384
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/386 b/tests/xfs/386
index 9b3023ad2b3af6..1e73a5978093cb 100755
--- a/tests/xfs/386
+++ b/tests/xfs/386
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/388 b/tests/xfs/388
index 2e1eb7f13de44a..de8ce74bb92edd 100755
--- a/tests/xfs/388
+++ b/tests/xfs/388
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/390 b/tests/xfs/390
index 4969bf66105513..d6449d291cb971 100755
--- a/tests/xfs/390
+++ b/tests/xfs/390
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/392 b/tests/xfs/392
index 619665f8e3aa38..a2e749d24323b2 100755
--- a/tests/xfs/392
+++ b/tests/xfs/392
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/394 b/tests/xfs/394
index fd6a3330c31b60..aa2dee3644d5d2 100755
--- a/tests/xfs/394
+++ b/tests/xfs/394
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/396 b/tests/xfs/396
index a7bcaa4a86ea2b..a49ef5b95ccfb6 100755
--- a/tests/xfs/396
+++ b/tests/xfs/396
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/398 b/tests/xfs/398
index 1b91347c4edb1e..1d6d6ba9e9adc8 100755
--- a/tests/xfs/398
+++ b/tests/xfs/398
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/400 b/tests/xfs/400
index 01f59b1b471f68..5465baea2939d4 100755
--- a/tests/xfs/400
+++ b/tests/xfs/400
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/402 b/tests/xfs/402
index 2bb4fc9c23bb1e..981fb5f5e4aa73 100755
--- a/tests/xfs/402
+++ b/tests/xfs/402
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/404 b/tests/xfs/404
index 075a788a66e638..074803ed8023e7 100755
--- a/tests/xfs/404
+++ b/tests/xfs/404
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/406 b/tests/xfs/406
index 9815090c9db335..7a6e8bdb535237 100755
--- a/tests/xfs/406
+++ b/tests/xfs/406
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/408 b/tests/xfs/408
index 1e1a7a7336c093..3c7d16f0e6c6b7 100755
--- a/tests/xfs/408
+++ b/tests/xfs/408
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/410 b/tests/xfs/410
index 78da6cb4f2fec5..257ed295f330a4 100755
--- a/tests/xfs/410
+++ b/tests/xfs/410
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/412 b/tests/xfs/412
index ba1eb482276782..98a28001780646 100755
--- a/tests/xfs/412
+++ b/tests/xfs/412
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/414 b/tests/xfs/414
index 18ed8343eb4e4f..80f83be4dba192 100755
--- a/tests/xfs/414
+++ b/tests/xfs/414
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/416 b/tests/xfs/416
index 68094b841fcace..0d87c4116c05ea 100755
--- a/tests/xfs/416
+++ b/tests/xfs/416
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/418 b/tests/xfs/418
index 41ec77041f0d4d..0f5cb7a93c6fef 100755
--- a/tests/xfs/418
+++ b/tests/xfs/418
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/425 b/tests/xfs/425
index 6108e19c0b5650..7ad53f97a6940c 100755
--- a/tests/xfs/425
+++ b/tests/xfs/425
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/427 b/tests/xfs/427
index c19c02f4ee3374..38de1360af6262 100755
--- a/tests/xfs/427
+++ b/tests/xfs/427
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/429 b/tests/xfs/429
index eeb35945ec20d1..ded8c3944a2648 100755
--- a/tests/xfs/429
+++ b/tests/xfs/429
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/496 b/tests/xfs/496
index af1a636faa6049..63205b7b31d97f 100755
--- a/tests/xfs/496
+++ b/tests/xfs/496
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/734 b/tests/xfs/734
index 3fe41ac2fe80ea..232ac4264bc33d 100755
--- a/tests/xfs/734
+++ b/tests/xfs/734
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/737 b/tests/xfs/737
index 0e35bbe340ea73..edfcf7e336ba44 100755
--- a/tests/xfs/737
+++ b/tests/xfs/737
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/741 b/tests/xfs/741
index da0805273bd255..ea1c2d98516fdb 100755
--- a/tests/xfs/741
+++ b/tests/xfs/741
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/742 b/tests/xfs/742
index d699aa10c68f6a..bbc186f8472b64 100755
--- a/tests/xfs/742
+++ b/tests/xfs/742
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair realtime
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/785 b/tests/xfs/785
index f3707c730f31ac..5610a5df5b9e1f 100755
--- a/tests/xfs/785
+++ b/tests/xfs/785
@@ -8,7 +8,7 @@
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_repair
+_begin_fstest dangerous_fuzzers repair fuzzers_repair
 
 _register_cleanup "_cleanup" BUS
 

