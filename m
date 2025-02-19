Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436716F265;
	Wed, 19 Feb 2025 00:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926361; cv=none; b=IJeilkLNYKfr9sizBeA0Opxqmuuu28pObXVIdTDYqMYjsKTwt/484andajHxbudYTsPaAB1VRJ7ivzrpOvSPvgsy3NnivRC3dxhgg7Vu+vgZFt1nKmDnAL2f0ssEzyuq647zhDO9MUldRHwmiU40ZbTVPpg6k4zABZG4Xk/u888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926361; c=relaxed/simple;
	bh=rW8AgLdc2TkBzsqnFDFWlY+21xk97owmXW3IBY28seg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g12EQq6VDu5uUqMVuW/7Eo6gi4/K0mJxKcRvaz45Cvkf/Bc+j+LWkuWB4VHzhvjV2glIalnZwsUmHsx/b+E1Tl1PftkoEXPiiXx7/h1XWVhuuGaX8kaS+nRalNM147/7cmwNQIy73KvXy2yElAl8R65JgauQPzrNbPzqZPDd1YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Td3AZNbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Td3AZNbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00914C4CEE2;
	Wed, 19 Feb 2025 00:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926361;
	bh=rW8AgLdc2TkBzsqnFDFWlY+21xk97owmXW3IBY28seg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Td3AZNbx2dwEnPWBSqpk4yWvcvIz2DJQcOHg0OB7WXDIJWjivE9RYlUQAMmgOcn+p
	 pFgO1LiRy3RGaqPsqvgSvE7yLZrFirgNDooNjCIoSoWzNcrCU73dy4GDmYzMZPwlaN
	 8ELdmNbnWe3Patz27TBVjzuVw4AN9QOW0C5oWQ6YvL8cyiuuGJ0qkTZVKlOxtuDZEz
	 iTANz5QJXO3z/jUSBFkPC4gmWz6bSJxUGbZchpvQuCdFI3r8Xn7K5A4eTJtlkUEYv+
	 aNKuShBoLJUTcxcDDx9DkUZnyOAdVeFZ5EXZHBgqQfgdJl7iTNR9WI0pE9aKnVuqpy
	 HRZhnuLAYP8Fw==
Date: Tue, 18 Feb 2025 16:52:40 -0800
Subject: [PATCH 09/12] misc: add xfs_scrub + xfs_repair fuzz tests to the
 scrub and repair groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587570.4078254.13226450369679038040.stgit@frogsfrogsfrogs>
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

All the tests in the "fuzzers_bothrepair" group test xfs_scrub +
xfs_repair, so they all should be in the 'scrub' and 'repair' groups.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/747 |    2 +-
 tests/xfs/748 |    2 +-
 tests/xfs/749 |    2 +-
 tests/xfs/750 |    2 +-
 tests/xfs/751 |    2 +-
 tests/xfs/752 |    2 +-
 tests/xfs/753 |    2 +-
 tests/xfs/754 |    2 +-
 tests/xfs/755 |    2 +-
 tests/xfs/756 |    2 +-
 tests/xfs/757 |    2 +-
 tests/xfs/758 |    2 +-
 tests/xfs/759 |    2 +-
 tests/xfs/760 |    2 +-
 tests/xfs/761 |    2 +-
 tests/xfs/762 |    2 +-
 tests/xfs/763 |    2 +-
 tests/xfs/764 |    2 +-
 tests/xfs/765 |    2 +-
 tests/xfs/766 |    2 +-
 tests/xfs/767 |    2 +-
 tests/xfs/768 |    2 +-
 tests/xfs/769 |    2 +-
 tests/xfs/770 |    2 +-
 tests/xfs/771 |    2 +-
 tests/xfs/772 |    2 +-
 tests/xfs/773 |    2 +-
 tests/xfs/774 |    2 +-
 tests/xfs/775 |    2 +-
 tests/xfs/776 |    2 +-
 tests/xfs/777 |    2 +-
 tests/xfs/778 |    2 +-
 tests/xfs/779 |    2 +-
 tests/xfs/780 |    2 +-
 tests/xfs/781 |    2 +-
 tests/xfs/782 |    2 +-
 tests/xfs/787 |    2 +-
 37 files changed, 37 insertions(+), 37 deletions(-)


diff --git a/tests/xfs/747 b/tests/xfs/747
index 37682e3c11e8be..ba78563257dbcf 100755
--- a/tests/xfs/747
+++ b/tests/xfs/747
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/748 b/tests/xfs/748
index c7a89a1c9d5355..3a137a2fc0c6bb 100755
--- a/tests/xfs/748
+++ b/tests/xfs/748
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/749 b/tests/xfs/749
index 37f96e6f7c250e..cfd2e449926bca 100755
--- a/tests/xfs/749
+++ b/tests/xfs/749
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/750 b/tests/xfs/750
index 1bc6d5d4042535..8e9b569af624e3 100755
--- a/tests/xfs/750
+++ b/tests/xfs/750
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/751 b/tests/xfs/751
index 542ca4261430c8..ae4f550e19b717 100755
--- a/tests/xfs/751
+++ b/tests/xfs/751
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/752 b/tests/xfs/752
index f985e52fbdfeb6..45d822b5b52a3e 100755
--- a/tests/xfs/752
+++ b/tests/xfs/752
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/753 b/tests/xfs/753
index d4d30c165784f7..d20870b7a00a7a 100755
--- a/tests/xfs/753
+++ b/tests/xfs/753
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/754 b/tests/xfs/754
index 6464e52b88d3dd..43e9dea2126c12 100755
--- a/tests/xfs/754
+++ b/tests/xfs/754
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/755 b/tests/xfs/755
index f287880d84b72b..942b78522518ab 100755
--- a/tests/xfs/755
+++ b/tests/xfs/755
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/756 b/tests/xfs/756
index 0f6ffc5527a07e..218ea32c917e32 100755
--- a/tests/xfs/756
+++ b/tests/xfs/756
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/757 b/tests/xfs/757
index 21357b83657945..4b747e670ee787 100755
--- a/tests/xfs/757
+++ b/tests/xfs/757
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/758 b/tests/xfs/758
index 4652e1c3b88d2f..1204cb7480495d 100755
--- a/tests/xfs/758
+++ b/tests/xfs/758
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/759 b/tests/xfs/759
index 0c0f323fd3a8b0..b7a86fe36ff27a 100755
--- a/tests/xfs/759
+++ b/tests/xfs/759
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/760 b/tests/xfs/760
index 46aed18dc611a4..5f46b132ef1021 100755
--- a/tests/xfs/760
+++ b/tests/xfs/760
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/761 b/tests/xfs/761
index 10030e42ed3e8f..e3ee60877cdc21 100755
--- a/tests/xfs/761
+++ b/tests/xfs/761
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/762 b/tests/xfs/762
index cf094ac43b408f..356e0e28e65fbb 100755
--- a/tests/xfs/762
+++ b/tests/xfs/762
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/763 b/tests/xfs/763
index 745684bd4bdd01..b9de1cb0ae4644 100755
--- a/tests/xfs/763
+++ b/tests/xfs/763
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/764 b/tests/xfs/764
index f970e1fe5830bf..19f8a89977645b 100755
--- a/tests/xfs/764
+++ b/tests/xfs/764
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/765 b/tests/xfs/765
index ff0227ee0b9f32..297e4eef15f2d6 100755
--- a/tests/xfs/765
+++ b/tests/xfs/765
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/766 b/tests/xfs/766
index bc09949278a374..81fecbc26a6801 100755
--- a/tests/xfs/766
+++ b/tests/xfs/766
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/767 b/tests/xfs/767
index bdc2d559e0dc72..29eb138d54d35c 100755
--- a/tests/xfs/767
+++ b/tests/xfs/767
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/768 b/tests/xfs/768
index 0f25cb4338247b..60856c5f9491f9 100755
--- a/tests/xfs/768
+++ b/tests/xfs/768
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/769 b/tests/xfs/769
index 5eee69e498ba21..2c07bb9748916e 100755
--- a/tests/xfs/769
+++ b/tests/xfs/769
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/770 b/tests/xfs/770
index baadda2b282a92..d7175de019cde2 100755
--- a/tests/xfs/770
+++ b/tests/xfs/770
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/771 b/tests/xfs/771
index 1eaeaf82ea99e2..3b3ef433b8bc9b 100755
--- a/tests/xfs/771
+++ b/tests/xfs/771
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/772 b/tests/xfs/772
index a4f0fbac3715bb..aaa7bedb7a533f 100755
--- a/tests/xfs/772
+++ b/tests/xfs/772
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/773 b/tests/xfs/773
index 93e1d36c21daea..0c200bbc5b943a 100755
--- a/tests/xfs/773
+++ b/tests/xfs/773
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/774 b/tests/xfs/774
index b4dad7d9933e73..26e85135496406 100755
--- a/tests/xfs/774
+++ b/tests/xfs/774
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/775 b/tests/xfs/775
index 736dfde68cd1a9..4475fe09ced4b6 100755
--- a/tests/xfs/775
+++ b/tests/xfs/775
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/776 b/tests/xfs/776
index 6f86e43c465a76..5abd2d434a08da 100755
--- a/tests/xfs/776
+++ b/tests/xfs/776
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/777 b/tests/xfs/777
index f3fa114e020b67..f8e156f6ede16f 100755
--- a/tests/xfs/777
+++ b/tests/xfs/777
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/778 b/tests/xfs/778
index 20d91fb3e1f254..dc082719a1f8cf 100755
--- a/tests/xfs/778
+++ b/tests/xfs/778
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/779 b/tests/xfs/779
index 60b10511c8a7cd..acce522995c693 100755
--- a/tests/xfs/779
+++ b/tests/xfs/779
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/780 b/tests/xfs/780
index 1789c0468e2009..efcbeb8e147353 100755
--- a/tests/xfs/780
+++ b/tests/xfs/780
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/781 b/tests/xfs/781
index edbf195738b3b2..09d63bfeceb6e7 100755
--- a/tests/xfs/781
+++ b/tests/xfs/781
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/782 b/tests/xfs/782
index 1e86dc2d68d600..a92e933c87787d 100755
--- a/tests/xfs/782
+++ b/tests/xfs/782
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/787 b/tests/xfs/787
index d610ff5a47dfdb..6367f6a72d0913 100755
--- a/tests/xfs/787
+++ b/tests/xfs/787
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 

