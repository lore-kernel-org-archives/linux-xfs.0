Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5439B;
	Fri, 12 Jul 2024 06:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720766991; cv=none; b=hSyqnSWUcGu++lt5GyqgY+SvvDTwcrW4om20jBgp8kGqP28YhCPyatmnAU9suT8KYslCqEcJy49ZzKQQ2O8VLW5JKGp/hz3f5RYUeqqOEJijNwKNrbqI6EJQ17ch/zeqo2YdTUefgnmQERz0AC72iM3B+uuRgvydy5djnHIJQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720766991; c=relaxed/simple;
	bh=7V0zt1PDnCfLkBjQINrJ5mzZqGDGZlY9aJuodrfp9yQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3wDO9adIrgZEIev2dHPTZJgKIn9PdeVD8yjxQZzcwpIVsQHqmwp7h2Wg19z/R5UEc7WwI/JuIl+uewNiNgAeQ3dHHMiB+CGJjtrurPFvYZgj7cIl6gMe57KwxkYRefj2biO3zZZE9mzLSees47kcaVmAjR1rS0TGn8JrvPxILo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WL2CL0g4nz1T5yn;
	Fri, 12 Jul 2024 14:45:02 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DE00140361;
	Fri, 12 Jul 2024 14:49:47 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 12 Jul 2024 14:49:46 +0800
From: Long Li <leo.lilong@huawei.com>
To: <zlang@redhat.com>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <leo.lilong@huawei.com>,
	<yangerkun@huawei.com>
Subject: [PATCH 2/2] xfs/242: fix test failure due to incorrect filtering in _filter_bmap
Date: Fri, 12 Jul 2024 14:47:16 +0800
Message-ID: <20240712064716.3385793-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240712064716.3385793-1-leo.lilong@huawei.com>
References: <20240712064716.3385793-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)

I got a failure in xfs/242 as follows, it can be easily reproduced
when I run xfs/242 as a cyclic test.

  13. data -> unwritten -> data
  0: [0..127]: data
  -1: [128..511]: unwritten
  -2: [512..639]: data
  +1: [128..639]: unwritten

The root cause, as Dave pointed out in previous email [1], is that
_filter_bmap may incorrectly match the AG-OFFSET in column 5 for datadev
files. On the other hand, _filter_bmap missing a "next" to jump out when
it matches "data" in the 5th column, otherwise it might print the result
twice. The issue was introduced by commit 7d5d3f77154e ("xfs/242: fix
_filter_bmap for xfs_io bmap that does rt file properly"). The failure
disappeared when I retest xfs/242 by reverted commit 7d5d3f77154e.

Fix it by matching the 7th column first and then the 5th column in
_filter_bmap, because the rtdev file only has 5 columns in the `bmap -vp`
output.

[1] https://lore.kernel.org/all/Zh9UkHEesvrpSQ7J@dread.disaster.area/
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 common/punch | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/common/punch b/common/punch
index 9e730404..43ccab69 100644
--- a/common/punch
+++ b/common/punch
@@ -188,7 +188,10 @@ _filter_hole_fiemap()
 	_coalesce_extents
 }
 
-# Column 7 for datadev files and column 5 for rtdev files
+# Column 7 for datadev files and column 5 for rtdev files, To prevent the
+# 5th column in datadev files from being potentially matched incorrectly,
+# we need to match Column 7 for datadev files first, because the rtdev
+# file only has 5 columns in the `bmap -vp` output.
 #     10000 Unwritten preallocated extent
 #     01000 Doesn't begin on stripe unit
 #     00100 Doesn't end   on stripe unit
@@ -201,18 +204,19 @@ _filter_bmap()
 			print $1, $2, $3;
 			next;
 		}
-		$5 ~ /1[01][01][01][01]/ {
+		$7 ~ /1[01][01][01][01]/ {
 			print $1, $2, "unwritten";
 			next;
 		}
-		$5 ~ /0[01][01][01][01]/ {
+		$7 ~ /0[01][01][01][01]/ {
 			print $1, $2, "data"
+			next;
 		}
-		$7 ~ /1[01][01][01][01]/ {
+		$5 ~ /1[01][01][01][01]/ {
 			print $1, $2, "unwritten";
 			next;
 		}
-		$7 ~ /0[01][01][01][01]/ {
+		$5 ~ /0[01][01][01][01]/ {
 			print $1, $2, "data"
 		}' |
 	_coalesce_extents
-- 
2.39.2

