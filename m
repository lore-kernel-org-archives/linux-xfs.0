Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366201E5B71;
	Tue, 22 Apr 2025 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745315500; cv=none; b=tkGX16CfOY7rahGwEnyHhvrhbe1RC2uDpKh9/gZ0rq71SbQsDlERvNZ1wAEX5BPUCi8hcI/DY/DcrX9Pn1BQ7XSZXAzg7ehf7Yq/Z8Zn4Lmns18h+XGNw6JPJ/CuLsK5E6sFZuz+w1U2iFEFNwIkEYloZUURGWMAaFd1l6LaLeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745315500; c=relaxed/simple;
	bh=YAgiqX24EF1IChRDH7Q+iWlTconGy/9CB6eVKSr0bgg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s5sgXTC/WkzypDJQlI8npZb8/yJmDyOYu6DAL5GG3Y6XuQCKf8621wOeKge1arHb+HxR/JbtcbPamrlIzehJgK8Xn9JniIOXqoOCLihT+nMHJwZN3v09Q4vzvhjcrfPPnfcJSWkZwUhpgUcnd/ZHtN+AA3ExhjVLmjIsOGHD+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=jg6gHvN+; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="jg6gHvN+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1745315498; x=1776851498;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YAgiqX24EF1IChRDH7Q+iWlTconGy/9CB6eVKSr0bgg=;
  b=jg6gHvN+9TFcab4x5RDYA79aIyNUMEfl8c86FMwM0mEITQW8mxVoUz9q
   M9YSGkLmVlVr/ABy7KAm9PCuCNSu5/xEEy59b+TiX5oIzQSnCBWqgebuN
   85IU6oZvfauqe3imGfdh/fSf9ZArtOCHC3JwFPmGBc3PrA5n/gZkrc7Ed
   8tESzTYx7BrWKNEURo/JEoVO28w2bsN/iiBWQX5bjwhJTTbKpaiCzUHk+
   AjJeOpgzuF9ZjFDD5iCqWRBcZnOciVcmVeVG4X0UzDq1yLN9FOMmWXiWz
   72xTCUXUkvOEFlbJ7tVwDuZoq3GIG95v4mHyBh41DqXpA2RucYQsor6Wf
   Q==;
X-CSE-ConnectionGUID: nzk2TeBdSouXvbalIdRdeQ==
X-CSE-MsgGUID: ALzpD9VNTm+0S5nk2G3obQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="196490730"
X-IronPort-AV: E=Sophos;i="6.15,230,1739804400"; 
   d="scan'208";a="196490730"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 18:50:26 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id B6FDCDBB80;
	Tue, 22 Apr 2025 18:50:23 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 6D80ED4BDD;
	Tue, 22 Apr 2025 18:50:23 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.135.94])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 9EB9E1A0078;
	Tue, 22 Apr 2025 17:50:22 +0800 (CST)
From: Ma Xinjian <maxj.fnst@fujitsu.com>
To: fstests@vger.kernel.org
Cc: zlang@redhat.com,
	linux-xfs@vger.kernel.org,
	Ma Xinjian <maxj.fnst@fujitsu.com>
Subject: [PATCH] xfs/083: fix the judgment of the number of content lines in $ROUND2_LOG
Date: Tue, 22 Apr 2025 17:49:25 +0800
Message-ID: <20250422094925.7921-1-maxj.fnst@fujitsu.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 8973af00e ("fstests: cleanup fsstress process management") forces
the stdout of fsstress process to be redirected to the file $seqres.full,
so that there are only 7 lines of content in $ROUND2_LOG now.

The following is the content in $ROUND2_LOG before commit 8973af00e:
```
++ mount image (2)
++ chattr -R -i
+++ test scratch
+++ modify scratch
+++ stressing filesystem
seed = 1744949451
+++ xfs realtime not configured
++ umount
```

The following is the content in $ROUND2_LOG after commit 8973af00e:
```
++ mount image (2)
++ chattr -R -i
+++ test scratch
+++ modify scratch
+++ stressing filesystem
+++ xfs realtime not configured
++ umount
```

"seed = 1744949451" is redirected to the file $seqres.full since commit
8973af00e.

Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
---
 tests/xfs/083 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/083 b/tests/xfs/083
index 9291c8c0..76f52df0 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -142,7 +142,7 @@ echo "++ check fs (2)" >> $seqres.full
 _repair_scratch_fs >> $seqres.full 2>&1
 
 grep -E -q '(did not fix|makes no progress)' $seqres.full && echo "xfs_repair failed" | tee -a $seqres.full
-if [ "$(wc -l < "$ROUND2_LOG")" -ne 8 ]; then
+if [ "$(wc -l < "$ROUND2_LOG")" -ne 7 ]; then
 	echo "xfs_repair did not fix everything" | tee -a $seqres.full
 fi
 echo "finished fuzzing" | tee -a "$seqres.full"
-- 
2.47.0

