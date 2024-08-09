Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006FD34CC4;
	Fri,  9 Aug 2024 08:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723191468; cv=none; b=dteRVjCBSkMm8MH8hXsmgNOl+flESj5iFMfNF2/tqguP+jzdWow3tdXdx8zOOywloAT/kJIqI/Xv8mkXTqN/aezesJ4enpu1DOlOy9J2Z+4BlUADLxHAkUIsdq/l4xUtiOYyMQmtn9yC+s6L2+qPh662h1R3txvu32RfUtYwG6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723191468; c=relaxed/simple;
	bh=9KGDamRzHnjrZWkM43z+S0wM2ZJsWXRFDwQSs2KOVRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R0ro276i2cz5/PhDU+hOitMD6rV8ytO//4U62QS+WI21QXKr5VCa9itzKNL5ZvEG5jN9Mbl+qK2qNVRP04PGUuwT0GKf3toQ87J2eP1ex9FsLrlcy9FvJxllDJvOxZ812ZJnM0lsFeIff0eLwZRps+P/d3JG+lvM3XNg20lK4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=AlghoGdo; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="AlghoGdo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1723191465; x=1754727465;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9KGDamRzHnjrZWkM43z+S0wM2ZJsWXRFDwQSs2KOVRk=;
  b=AlghoGdoGDgUYyKeAm4+5jSKF47zLYqT5YBLvDFvJsWdu6BG90Sh3dIe
   BOjMaiX20MMZMHCJ6ziRzJaLO4S1Of5cLPvNmpSMaHll0c1nAkG4XWf5O
   QuNina0g4bwjp8pB7/k7U9S+uamDKiHivvYn3/b3m5sNszlh2lvlpIHr4
   l6aiwvC+RyAYEm92exF621jcP9kjfeXIGwXAMz5/Nzs6rlZm7eJ1SVhB4
   G+MdzLw/cEeoDAoZKXvYO4qgdV2vcfJaD5Bzlxh24Gii6Zp1tjTBLD+tP
   h5NWtKn/3rZ/h4TYx/O2ndfBV05gCtzCi+L76SkXaQEQOdRAGrMPyRjwB
   Q==;
X-CSE-ConnectionGUID: fVz+ttUiStm06Eqh8RVEiQ==
X-CSE-MsgGUID: NJV7HAPpSPuJigLRKomqDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="170264944"
X-IronPort-AV: E=Sophos;i="6.09,275,1716217200"; 
   d="scan'208";a="170264944"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 17:16:34 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id B3B7952842;
	Fri,  9 Aug 2024 17:16:30 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 00A2AE99A;
	Fri,  9 Aug 2024 17:16:30 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 7E929228938;
	Fri,  9 Aug 2024 17:16:29 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.182])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 95E821A0002;
	Fri,  9 Aug 2024 16:16:28 +0800 (CST)
From: Ma Xinjian <maxj.fnst@fujitsu.com>
To: zlang@redhat.com,
	djwong@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Ma Xinjian <maxj.fnst@fujitsu.com>
Subject: [PATCH v2] xfs/348: add helper tags
Date: Fri,  9 Aug 2024 16:17:22 +0800
Message-ID: <20240809081722.795446-1-maxj.fnst@fujitsu.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28584.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28584.006
X-TMASE-Result: 10--7.717000-10.000000
X-TMASE-MatchedRID: /+von0vPuFE5rof3b4z0VKzGfgakLdja1QQ6Jx/fflaMJxigKCCiS78F
	Hrw7frluf146W0iUu2u9alSWGuOKxvoLRFtw/0CmjoyKzEmtrEd4SsGg2DQOYkxqTmWcX8+mNzn
	xs0sNGFwPNxz2EvpSILtwqADTAhklr78SC5iivxwURSScn+QSXmMVPzx/r2cb+gtHj7OwNO33FL
	eZXNZS4DjAdLIal4R6Pl8tQVP2PrkLkPhtQrPM8F2avgFHt3X2ky4PFHziZORI8esYkYuw3w==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
dbcc549317"), so note that in the test.

Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
---
 tests/xfs/348 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/xfs/348 b/tests/xfs/348
index 3502605c..00b81dbd 100755
--- a/tests/xfs/348
+++ b/tests/xfs/348
@@ -12,6 +12,13 @@
 . ./common/preamble
 _begin_fstest auto quick fuzzers repair
 
+_fixed_by_git_commit kernel 38de567906d95 \
+	"xfs: allow symlinks with short remote targets"
+
+# 1eb70f54c445f fixed null pointer failures due to insufficient validation
+_wants_kernel_commit kernel 1eb70f54c445f \
+	"xfs: validate inode fork size against fork format"
+
 # Import common functions.
 . ./common/filter
 . ./common/repair
-- 
2.42.0

