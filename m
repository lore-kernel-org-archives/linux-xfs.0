Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2086018FDC5;
	Wed, 19 Feb 2025 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926283; cv=none; b=GOE7WB61NkN1BQcRL5SFJb+P02oiPSUkIlAK+BOVqCkd5ryOpUyWp3TBYunVPwpIuhgya2LwhVZ2CSJ0ZXri2OIdvz23xuzBsw5Z95p0XSTGNWOOJwWtPVzOaySa/sFhEGFHuuFeqo9Bqy7uOlbKam3sYxfw+KfL59AXiLsJx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926283; c=relaxed/simple;
	bh=J8iKY3MGkDubxmb0KTK4aHRWTTyA9qALXklLiA9VtrQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWBVqdVywYpHa02rMDOsd75E8vDLP3YhgvwC+FtOxTlznGkms0iYgplTl4yoLQxfvTk5GMjeKeZNHm/4/O53SAleCgUO/Q7nblLCIIyKnF1+xHZMVUHoEWtWwm1AbW9EbxghQUEZ5GASKnok03celKb0i6wrKpi15UNRHxJKUEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttgWCyhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttgWCyhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AE8C4CEE2;
	Wed, 19 Feb 2025 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926282;
	bh=J8iKY3MGkDubxmb0KTK4aHRWTTyA9qALXklLiA9VtrQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ttgWCyhv3FJQSzBPgpR85lTGkTPj42If7rLJ12b9LCTkX0/PTKOAych0qfKe7L5Cn
	 sw82cA8cdtXdoC9P3NvcqLI7EYV+P88yyixth1yJVikNdh8yT7sfYpnEOMNxU4nsmB
	 rk5QE0fNDaEXJ+p6505PDO11wx1W9kn5sWeO4CLi9JC3e89Q4u1i5DNVVRg+1JlvdH
	 Bz+T7LuGXl/ZBeXEpwmwAW2RN5FJoNnw0D7wqcYNdYZ03pMyMgfwv8U1FM9603oAYJ
	 UdzNoGZltx1jLisbKkmyWkD9RC44ocZ0sFNntDZ6HuURph1uVn0G/PzwAsmaHCuEM/
	 mhX/GjBgA/gDA==
Date: Tue, 18 Feb 2025 16:51:22 -0800
Subject: [PATCH 04/12] misc: rename the dangerous_bothrepair group to
 fuzzers_bothrepair
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587477.4078254.8323426815916976827.stgit@frogsfrogsfrogs>
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
think it's stabilized enough that the scrub + repair functionality tests
don't need to hide behind the "dangerous" label anymore.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 doc/group-names.txt |    2 +-
 tests/xfs/743       |    2 +-
 tests/xfs/744       |    2 +-
 tests/xfs/747       |    2 +-
 tests/xfs/748       |    2 +-
 tests/xfs/749       |    2 +-
 tests/xfs/750       |    2 +-
 tests/xfs/751       |    2 +-
 tests/xfs/752       |    2 +-
 tests/xfs/753       |    2 +-
 tests/xfs/754       |    2 +-
 tests/xfs/755       |    2 +-
 tests/xfs/756       |    2 +-
 tests/xfs/757       |    2 +-
 tests/xfs/758       |    2 +-
 tests/xfs/759       |    2 +-
 tests/xfs/760       |    2 +-
 tests/xfs/761       |    2 +-
 tests/xfs/762       |    2 +-
 tests/xfs/763       |    2 +-
 tests/xfs/764       |    2 +-
 tests/xfs/765       |    2 +-
 tests/xfs/766       |    2 +-
 tests/xfs/767       |    2 +-
 tests/xfs/768       |    2 +-
 tests/xfs/769       |    2 +-
 tests/xfs/770       |    2 +-
 tests/xfs/771       |    2 +-
 tests/xfs/772       |    2 +-
 tests/xfs/773       |    2 +-
 tests/xfs/774       |    2 +-
 tests/xfs/775       |    2 +-
 tests/xfs/776       |    2 +-
 tests/xfs/777       |    2 +-
 tests/xfs/778       |    2 +-
 tests/xfs/779       |    2 +-
 tests/xfs/780       |    2 +-
 tests/xfs/781       |    2 +-
 tests/xfs/782       |    2 +-
 tests/xfs/783       |    2 +-
 tests/xfs/784       |    2 +-
 tests/xfs/787       |    2 +-
 42 files changed, 42 insertions(+), 42 deletions(-)


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 25a982b6740504..8e1a62331738bb 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -30,7 +30,6 @@ copy			xfs_copy functionality
 copy_range		copy_file_range syscall
 copyup			overlayfs copyup
 dangerous		dangerous test that can crash the system
-dangerous_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 dangerous_fuzzers	fuzzers that can crash your computer
 dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
 dangerous_scrub		fuzzers to evaluate xfs_scrub checking
@@ -56,6 +55,7 @@ fsproperties		Filesystem properties
 fsr			XFS free space reorganizer
 fsstress_online_repair	race fsstress and xfs_scrub online repair
 fsstress_scrub		race fsstress and xfs_scrub checking
+fuzzers_bothrepair	fuzzers to evaluate xfs_scrub + xfs_repair repair
 fuzzers			filesystem fuzz tests
 fuzzers_online_repair	fuzzers to evaluate xfs_scrub online repair
 fuzzers_repair		fuzzers to evaluate xfs_repair offline repair
diff --git a/tests/xfs/743 b/tests/xfs/743
index b5cec7d71a4002..90b3872440cb07 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/744 b/tests/xfs/744
index e2d097c2f0d59f..e7778417b53ff4 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/747 b/tests/xfs/747
index 03d0f5a42c67ec..37682e3c11e8be 100755
--- a/tests/xfs/747
+++ b/tests/xfs/747
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/748 b/tests/xfs/748
index 66b59fe44f2568..c7a89a1c9d5355 100755
--- a/tests/xfs/748
+++ b/tests/xfs/748
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/749 b/tests/xfs/749
index ea9c34a5002b02..37f96e6f7c250e 100755
--- a/tests/xfs/749
+++ b/tests/xfs/749
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/750 b/tests/xfs/750
index 0f451ecdacde2c..1bc6d5d4042535 100755
--- a/tests/xfs/750
+++ b/tests/xfs/750
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/751 b/tests/xfs/751
index dfd9e09b00bd33..542ca4261430c8 100755
--- a/tests/xfs/751
+++ b/tests/xfs/751
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/752 b/tests/xfs/752
index 88c064e73f92f8..f985e52fbdfeb6 100755
--- a/tests/xfs/752
+++ b/tests/xfs/752
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/753 b/tests/xfs/753
index b0984e99a35599..d4d30c165784f7 100755
--- a/tests/xfs/753
+++ b/tests/xfs/753
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/754 b/tests/xfs/754
index 9a37871125a34b..6464e52b88d3dd 100755
--- a/tests/xfs/754
+++ b/tests/xfs/754
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/755 b/tests/xfs/755
index 06b9cafe68b914..f287880d84b72b 100755
--- a/tests/xfs/755
+++ b/tests/xfs/755
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/756 b/tests/xfs/756
index 02dfc222cceeb3..0f6ffc5527a07e 100755
--- a/tests/xfs/756
+++ b/tests/xfs/756
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/757 b/tests/xfs/757
index 46391e1e9a5fe0..21357b83657945 100755
--- a/tests/xfs/757
+++ b/tests/xfs/757
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/758 b/tests/xfs/758
index 2a32c2f2836e27..4652e1c3b88d2f 100755
--- a/tests/xfs/758
+++ b/tests/xfs/758
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/759 b/tests/xfs/759
index 117dc6b1cb9c39..0c0f323fd3a8b0 100755
--- a/tests/xfs/759
+++ b/tests/xfs/759
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/760 b/tests/xfs/760
index f5032b95e55fd5..46aed18dc611a4 100755
--- a/tests/xfs/760
+++ b/tests/xfs/760
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/761 b/tests/xfs/761
index 19a2a273ce708a..10030e42ed3e8f 100755
--- a/tests/xfs/761
+++ b/tests/xfs/761
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/762 b/tests/xfs/762
index 98c48e89ddadc2..cf094ac43b408f 100755
--- a/tests/xfs/762
+++ b/tests/xfs/762
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/763 b/tests/xfs/763
index 430c01ba55eb4c..745684bd4bdd01 100755
--- a/tests/xfs/763
+++ b/tests/xfs/763
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/764 b/tests/xfs/764
index 83378ae2fa13c4..f970e1fe5830bf 100755
--- a/tests/xfs/764
+++ b/tests/xfs/764
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/765 b/tests/xfs/765
index 28c96737ca7dd1..ff0227ee0b9f32 100755
--- a/tests/xfs/765
+++ b/tests/xfs/765
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/766 b/tests/xfs/766
index c241d992bf2d09..bc09949278a374 100755
--- a/tests/xfs/766
+++ b/tests/xfs/766
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/767 b/tests/xfs/767
index 8fd5dded9c4fd0..bdc2d559e0dc72 100755
--- a/tests/xfs/767
+++ b/tests/xfs/767
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/768 b/tests/xfs/768
index f77e0942b7fb51..0f25cb4338247b 100755
--- a/tests/xfs/768
+++ b/tests/xfs/768
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/769 b/tests/xfs/769
index f09424e9e666a1..5eee69e498ba21 100755
--- a/tests/xfs/769
+++ b/tests/xfs/769
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/770 b/tests/xfs/770
index 96a64142f92b7c..baadda2b282a92 100755
--- a/tests/xfs/770
+++ b/tests/xfs/770
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/771 b/tests/xfs/771
index 568c6fd793a642..1eaeaf82ea99e2 100755
--- a/tests/xfs/771
+++ b/tests/xfs/771
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/772 b/tests/xfs/772
index a558877144daa7..a4f0fbac3715bb 100755
--- a/tests/xfs/772
+++ b/tests/xfs/772
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/773 b/tests/xfs/773
index e4e91d65fa9095..93e1d36c21daea 100755
--- a/tests/xfs/773
+++ b/tests/xfs/773
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/774 b/tests/xfs/774
index ca01eb2f4f8dd4..b4dad7d9933e73 100755
--- a/tests/xfs/774
+++ b/tests/xfs/774
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/775 b/tests/xfs/775
index 89f20ad6d255a2..736dfde68cd1a9 100755
--- a/tests/xfs/775
+++ b/tests/xfs/775
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/776 b/tests/xfs/776
index cfa5874ffd6479..6f86e43c465a76 100755
--- a/tests/xfs/776
+++ b/tests/xfs/776
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/777 b/tests/xfs/777
index de30fa32f2a54b..f3fa114e020b67 100755
--- a/tests/xfs/777
+++ b/tests/xfs/777
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/778 b/tests/xfs/778
index 893187d738a2a4..20d91fb3e1f254 100755
--- a/tests/xfs/778
+++ b/tests/xfs/778
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/779 b/tests/xfs/779
index 7c338b1c215abd..60b10511c8a7cd 100755
--- a/tests/xfs/779
+++ b/tests/xfs/779
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/780 b/tests/xfs/780
index 06194d3250c83d..1789c0468e2009 100755
--- a/tests/xfs/780
+++ b/tests/xfs/780
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/781 b/tests/xfs/781
index 7113a143406839..edbf195738b3b2 100755
--- a/tests/xfs/781
+++ b/tests/xfs/781
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/782 b/tests/xfs/782
index ba89d2198cc5fe..1e86dc2d68d600 100755
--- a/tests/xfs/782
+++ b/tests/xfs/782
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/783 b/tests/xfs/783
index 32f4ddfc9cc36d..dcb1292217d37d 100755
--- a/tests/xfs/783
+++ b/tests/xfs/783
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/784 b/tests/xfs/784
index b7067efc60c447..286797257e025e 100755
--- a/tests/xfs/784
+++ b/tests/xfs/784
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair
+_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/787 b/tests/xfs/787
index 090c3f8b9e1f10..d610ff5a47dfdb 100755
--- a/tests/xfs/787
+++ b/tests/xfs/787
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_bothrepair
+_begin_fstest dangerous_fuzzers fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 

