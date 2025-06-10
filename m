Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246321CA16;
	Tue, 10 Jun 2025 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546808; cv=none; b=u59ldR4mv2IC7ENyp+ha1kJZlleb4OoB6s5oOjumkoMyRoqVIa/ioB1Kn1POLQG9wE0elFZO1stmvjA58GyNHUvW+iSXpA4QyO6T3daMfE6UDOUDvDaghTGBjrJL6a8tdMnLJx7e04sLnMuM6f0PcRpqX2wNoLlZSU2DZtjJ9jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546808; c=relaxed/simple;
	bh=O/w01L8ahjJUSGQKPEFEg9HqO2IubeOSfBA8MZtkXak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tbZWGExhttEz7WfmAI/MelmRwL3cPiAsgB7sTid4IPbRtN+Ow496lESjdZTI7FpcUOO6tzfwEevj8YPolMys2D8aMtLAF/X0NcZhVe6OdubqoXX9z7gSbB1+mw4M6P+TZDeYfEdhwBfzd7Y9D0fH8SW8JtT5XU4fkjx/3FIQA9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=pmufySNy; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="pmufySNy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1749546806; x=1781082806;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O/w01L8ahjJUSGQKPEFEg9HqO2IubeOSfBA8MZtkXak=;
  b=pmufySNyPiaWIxY4nEN/FvW0Csvgx5JhWcFkduNyiC7a8KUaG+KEifJs
   SF5NJpy5V9sHNO+mMAZ0igUspHNPKSLuGbjcXQz67/AgcO+ISDVnuiwmJ
   uOg2tPqrZVFmm4zqPT4FoyV+iELwYeQwKOqzPBLxNIVO2RW0rqawd0Fqi
   hyHBFWUyueDBGgoOgK/HcQzqkC89ZBs1G5234JPjA4ClLWHW1Kdjbq9p6
   OewlwuoWMc6ts0IkFpr3rlCdB8u+twQKzEFKnh+gGpNoKbcVLvZ/+zs1N
   TKhiJLu1FsOoDd8iTafSKBHm9J43/6uGcVr4v1PjOW3csvF9D6kEXdSWu
   g==;
X-CSE-ConnectionGUID: 5dMsL8O9RDmsOUfCKLTkNg==
X-CSE-MsgGUID: HN90nAiFQMKkyoqH5u/6sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="205325609"
X-IronPort-AV: E=Sophos;i="6.16,224,1744038000"; 
   d="scan'208";a="205325609"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 18:12:15 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id E0D95D8033;
	Tue, 10 Jun 2025 18:12:12 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 832893A4EE;
	Tue, 10 Jun 2025 18:12:12 +0900 (JST)
Received: from fedora.g08.fujitsu.local (unknown [10.167.136.80])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 2D10C1A000B;
	Tue, 10 Jun 2025 17:12:10 +0800 (CST)
From: Ma Xinjian <maxj.fnst@fujitsu.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Xinjian Ma <maxj.fnst@fujitsu.com>
Subject: [PATCH] xfs/603: add _require_scrub
Date: Tue, 10 Jun 2025 17:11:34 +0800
Message-ID: <20250610091134.152557-1-maxj.fnst@fujitsu.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xinjian Ma <maxj.fnst@fujitsu.com>

This test uses xfs_scrub which is an EXPERIMENTAL and unstable feature.
Add _require_scrub to check if the system supports it.

Signed-off-by: Xinjian Ma <maxj.fnst@fujitsu.com>
---
 tests/xfs/603 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/603 b/tests/xfs/603
index 04122b55..d6058a3e 100755
--- a/tests/xfs/603
+++ b/tests/xfs/603
@@ -20,6 +20,7 @@ _require_xfs_db_command iunlink
 # until after the directory repair code was merged
 _require_xfs_io_command repair -R directory
 _require_scratch_nocheck	# repair doesn't like single-AG fs
+_require_scrub
 
 # From the AGI definition
 XFS_AGI_UNLINKED_BUCKETS=64
-- 
2.49.0

