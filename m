Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C305283FEF;
	Thu, 25 Sep 2025 09:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758792631; cv=none; b=OG9cXbxj+yXo6+fTCe/fnnQjIB0iYSi4hGP/Mmb3YN0FuQvlFbzDf+tuGb5fFjZpTexThZ2vmCfBejbf01dPedSLg/W/tnBm8gMgSzU7Xr5ef57iwt1tde5Jdu2XgIpUE3YmX9rDZ65qgA4rlk6HQorv1d0r17aF0273E6B9uVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758792631; c=relaxed/simple;
	bh=CUTBokt/goftbNlPFMqmRjDhsio8EO4lxhzZmq8u4B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz3B2hMdjo8hb3dhbnvpunh5H7GYzw9cQtiyPzV3oezcjfLHsKg5l3GDHju2cSwtkVVYzm0BNgGflFPycgfVdQ2gtFKnalbMAoPKKixiAwSP40LijyDZSkNyCq8an5/Oqy6d2SPQwsJAuqAwFc4eN4WQiRd1swQWwcJRT+A0DdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BD7hzqSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BD7hzqSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3316C116D0;
	Thu, 25 Sep 2025 09:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758792631;
	bh=CUTBokt/goftbNlPFMqmRjDhsio8EO4lxhzZmq8u4B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD7hzqSfFxvBjxpkPu71/EnzVJAHejENXiy5UYaafRnCGWXMCzbGYBvhXXItKoiaj
	 6KOQze1RMaCjO8n6a6UQQryBgb00vPWM5uTD/Jgwu21drlDmxT/FUjhi07RRszQSem
	 UYMfUr+EDHtAM6mv7m9WMDS+zokuhLaoHtAETHiG+ASEG12rAYohQ1tU1zHIsoRZBw
	 0FoK0IhTtwXemMBnhYxvb5eAA+vWSE1casGD/t1pqKfoXr1voCo0ioW4UceBRq3Sjx
	 vDRjkVy4HCgYhOJjV4/SEaOjfSoD6gbE12YInxd0deHi6TVwzQoWoMtbJ+H558uG9P
	 ukSnT1wgFSQpg==
From: cem@kernel.org
To: zlang@redhat.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/3] xfs/513: remove attr2 and ikeep tests
Date: Thu, 25 Sep 2025 11:29:24 +0200
Message-ID: <20250925093005.198090-2-cem@kernel.org>
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
 tests/xfs/513     | 11 -----------
 tests/xfs/513.out |  7 -------
 2 files changed, 18 deletions(-)

diff --git a/tests/xfs/513 b/tests/xfs/513
index d3be3ced68a1..7dbd2626d9e2 100755
--- a/tests/xfs/513
+++ b/tests/xfs/513
@@ -182,12 +182,6 @@ do_test "-o allocsize=1048576k" pass "allocsize=1048576k" "true"
 do_test "-o allocsize=$((dbsize / 2))" fail
 do_test "-o allocsize=2g" fail
 
-# Test attr2
-do_mkfs -m crc=1
-do_test "" pass "attr2" "true"
-do_test "-o attr2" pass "attr2" "true"
-do_test "-o noattr2" fail
-
 # Test discard
 do_mkfs
 do_test "" pass "discard" "false"
@@ -205,11 +199,6 @@ do_test "-o sysvgroups" pass "grpid" "false"
 do_test "" pass "filestreams" "false"
 do_test "-o filestreams" pass "filestreams" "true"
 
-# Test ikeep
-do_test "" pass "ikeep" "false"
-do_test "-o ikeep" pass "ikeep" "true"
-do_test "-o noikeep" pass "ikeep" "false"
-
 # Test inode32|inode64
 do_test "" pass "inode64" "true"
 do_test "-o inode32" pass "inode32" "true"
diff --git a/tests/xfs/513.out b/tests/xfs/513.out
index 39945907140b..127f1681f979 100644
--- a/tests/xfs/513.out
+++ b/tests/xfs/513.out
@@ -9,10 +9,6 @@ TEST: "-o allocsize=PAGESIZE" "pass" "allocsize=PAGESIZE" "true"
 TEST: "-o allocsize=1048576k" "pass" "allocsize=1048576k" "true"
 TEST: "-o allocsize=2048" "fail"
 TEST: "-o allocsize=2g" "fail"
-FORMAT: -m crc=1
-TEST: "" "pass" "attr2" "true"
-TEST: "-o attr2" "pass" "attr2" "true"
-TEST: "-o noattr2" "fail"
 FORMAT: 
 TEST: "" "pass" "discard" "false"
 TEST: "-o discard" "pass" "discard" "true"
@@ -24,9 +20,6 @@ TEST: "-o nogrpid" "pass" "grpid" "false"
 TEST: "-o sysvgroups" "pass" "grpid" "false"
 TEST: "" "pass" "filestreams" "false"
 TEST: "-o filestreams" "pass" "filestreams" "true"
-TEST: "" "pass" "ikeep" "false"
-TEST: "-o ikeep" "pass" "ikeep" "true"
-TEST: "-o noikeep" "pass" "ikeep" "false"
 TEST: "" "pass" "inode64" "true"
 TEST: "-o inode32" "pass" "inode32" "true"
 TEST: "-o inode64" "pass" "inode64" "true"
-- 
2.51.0

