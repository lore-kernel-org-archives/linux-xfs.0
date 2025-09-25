Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAED2EC0BC;
	Thu, 25 Sep 2025 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758792633; cv=none; b=rv+rdWwGnlIki3VCb9nxlDkyV62Y5iHMU49efLn845otbbJg3a5cYZXIyWcOtrSBrtCzSxJx29fJa25IfOkvXszk3tR7zPtos4yM+qekF9vgopBd38Hw28cnCb4/4RtEEYXQlsAbgGbpKkDW+U/vDquwjPuUF8xSkFtQYoMfHL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758792633; c=relaxed/simple;
	bh=ytTJBF9oIqPwjFJd+qC/yrydiyh9eP218lkmybZ7E9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHKJBt9M5c491xnAqVSeYMH7eaKJhmuwvSA8dkZnJ18owAGya5K+RegUNOUPRWQEHFFLAc1khiITuG+7YO1x7b3Dbb+hKmBk9wWCN8G9YfnszvM2n4nicSJSRzCG466v6VnaW/KKH5MQBJNA+MJKS3aj4wvLK9qG2IqvC0gKpIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNYeNuwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNYeNuwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BDEC4CEF4;
	Thu, 25 Sep 2025 09:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758792632;
	bh=ytTJBF9oIqPwjFJd+qC/yrydiyh9eP218lkmybZ7E9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNYeNuwYksUV+814xYM4ux6Bf8HhRxtOdklH0RYiYo7dAPqw+XyeKbx/jddVbY/LI
	 J8mS930VOOFwmxEJjX8c5iH7jjBrswXSbiVVY/BzJSSTE1lXEkIXfKNJTx1sfTnb2n
	 qRY1l1AX6r1NX8B6PX0RLk/mAtB/tUe2b/kXu1WE6Kb8Aq7k3h0O33dK059C2r5d5O
	 K/l0Wzi47I5/qej9Tckm8tDShucsz1o55IgHkzS/F/G95NWRGS4WYZ+lVG96I01J+w
	 1301NUsZRE6vwK6uKSJEqXDSnL8a+qvt7C3MGj2tB19XL/1ct05rtI2c0y6b8iuCo5
	 YSlkbEPiFiz2w==
From: cem@kernel.org
To: zlang@redhat.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/3] xfs/613: remove attr2 tests
Date: Thu, 25 Sep 2025 11:29:25 +0200
Message-ID: <20250925093005.198090-3-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925093005.198090-1-cem@kernel.org>
References: <20250925093005.198090-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Linux kernel commit b9a176e54162 removes several deprecated options
from XFS, causing this test to fail.

Giving the options have been removed from Linux for good, just stop
testing these options here.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 tests/xfs/613     | 6 ------
 tests/xfs/613.out | 4 ----
 2 files changed, 10 deletions(-)

diff --git a/tests/xfs/613 b/tests/xfs/613
index 9b27a7c1f2c2..c26a4424f486 100755
--- a/tests/xfs/613
+++ b/tests/xfs/613
@@ -163,12 +163,6 @@ do_test()
 }
 
 echo "** start xfs mount testing ..."
-# Test attr2
-do_mkfs -m crc=0
-do_test "" pass "attr2" "true"
-do_test "-o attr2" pass "attr2" "true"
-do_test "-o noattr2" pass "attr2" "false"
-
 # Test logbsize=value.
 do_mkfs -m crc=0 -l version=1
 # New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
diff --git a/tests/xfs/613.out b/tests/xfs/613.out
index 2a693c53c584..add534bd63a9 100644
--- a/tests/xfs/613.out
+++ b/tests/xfs/613.out
@@ -2,10 +2,6 @@ QA output created by 613
 ** create loop device
 ** create loop mount point
 ** start xfs mount testing ...
-FORMAT: -m crc=0
-TEST: "" "pass" "attr2" "true"
-TEST: "-o attr2" "pass" "attr2" "true"
-TEST: "-o noattr2" "pass" "attr2" "false"
 FORMAT: -m crc=0 -l version=1
 TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
 TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
-- 
2.51.0

