Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD540191F7A;
	Tue, 30 Jul 2024 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326095; cv=none; b=V7n2uE1Pk6JV3+KPylvZCZRRz8c7VkgXW8DVjMnGJQCpJx9UEUEFPj1PcI1dbHmgLiuPNzUTy9bQCcigVO+/j/vrMPzRcD1yBVubujopIdkuSS3PenNTkTT9TyECfL1FyLlN7/5+u9oBEMn/7lAC+fz8LQm55AC2UxRG9NsI83A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326095; c=relaxed/simple;
	bh=pWLbYcTX0Uo9Oyj3U5DKEUpvp02NIcc1CTkivDSH9u8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=heUE6Y/NJoK4LVkppR8PhVBXfZ7ljRQIT+OZDiX4/OGbD9hv7PhdSOChoRVV3dK4eQIDx/Ra6YQ+rY7xGbYnZVpU+9YwrdS7sBFJQhnmPppVsYKGEURbylVBlURXG3+UJzIL6gcRM6etNYVsemDq0FFetAxykDMwdi+tfaXGrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=MfbU20Us; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="MfbU20Us"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1722326092; x=1753862092;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pWLbYcTX0Uo9Oyj3U5DKEUpvp02NIcc1CTkivDSH9u8=;
  b=MfbU20UsHan41l54RJoS9zL+WK0BK3o+cYBhH/nMWTfJtzrYY+aoE7Oi
   IC39pp2ZzY336NhtHhoeuK215MLV9CTyPNdYpaEMcQ4RYQIydpKnUZ951
   ac52yvf9u9hPlHOM8WxiT2DiaCJERClmqn6C9uBYMW4INQTSfODQrxuB5
   x/0J3SLZV33tfMaHKLJVB17q/+zASsNNt8x9SfcZyGZYYmMFs1fZ0E9HZ
   9uODECn2FGWhld7qB96tp8PhMt10EPudQTLzW1n9KHrd4pDgac1+2J5Eq
   HInQ3k1hgLkDyjSbh8fEu/9AA2OnWXyShLmjpVES5Zx0BaKd0ZdDKBJXE
   w==;
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="147920829"
X-IronPort-AV: E=Sophos;i="6.09,248,1716217200"; 
   d="scan'208";a="147920829"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 16:54:43 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id D7A8AD9223;
	Tue, 30 Jul 2024 16:54:41 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 25D28D8AD8;
	Tue, 30 Jul 2024 16:54:41 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id A9EE56BED7;
	Tue, 30 Jul 2024 16:54:40 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.182])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 047DD1A000B;
	Tue, 30 Jul 2024 15:54:39 +0800 (CST)
From: Ma Xinjian <maxj.fnst@fujitsu.com>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Ma Xinjian <maxj.fnst@fujitsu.com>
Subject: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Date: Tue, 30 Jul 2024 15:56:53 +0800
Message-ID: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28564.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28564.003
X-TMASE-Result: 10--4.430400-10.000000
X-TMASE-MatchedRID: JUGAxiLh1cM5rof3b4z0VKzGfgakLdja1QQ6Jx/fflaMJxigKCCiS78F
	Hrw7frluf146W0iUu2u9alSWGuOKxvoLRFtw/0CmjoyKzEmtrEd4SsGg2DQOYkxqTmWcX8+mux6
	8HkBCq1Di8zVgXoAltvqFFlQp0msE0C1sQRfQzEHEQdG7H66TyHEqm8QYBtMOV57Osr9DRXp17R
	/9wu8nBgozzo88pXiLA4SZO0rQSwdQwtkgqrDFWNxH7DG6UFSVzd5H8M+VmysSm5w1cAiPERnsR
	Xz5kGKvW4wbpXTb5DJKKve1kh3RY37qSWrndbmQn0bOriG5BVc=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
dbcc549317"), so note that in the test.

Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
---
 tests/xfs/348 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/348 b/tests/xfs/348
index 3502605c..e4bc1328 100755
--- a/tests/xfs/348
+++ b/tests/xfs/348
@@ -12,6 +12,9 @@
 . ./common/preamble
 _begin_fstest auto quick fuzzers repair
 
+_fixed_by_git_commit kernel 38de567906d95 \
+	"xfs: allow symlinks with short remote targets"
+
 # Import common functions.
 . ./common/filter
 . ./common/repair
-- 
2.42.0

