Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0313D51D;
	Fri, 12 Jul 2024 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720766989; cv=none; b=dXQQte4l5TPlhUc9AbIuv/Nt+zblb/4jgCdYCpEs0A4xy/+cdLl5pGFFT5FTbXzq+frbN8oWksgCtP9xhKB3QLmHZBp3jDtONcpvNEAwVg6/BzqvHiZUgKQhG89IYmKFg6MlI0MEOmRVhY/oPjKlPpp7LtJ99q6TPCzRY5bUu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720766989; c=relaxed/simple;
	bh=29X7l4fMTIr8mV+7y8NyDxaOdx1mHeGt8t2UQ+ivhpg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XrLDkpII8NGlq2XB0gIhBkxxImqpimTQQ/b9vSw6mcMYbDTDum5IEiDSPgysw4wD5QmUa2zJxArY27owBRhJWGAx7KFXlyufwkMZGhS+L1GhvjDJc4C2fLULx0ikL1RP9fiOEuTLMM2rXP3/6/HmXEcmvG2Q4HAehZYw3hztOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WL2CF5hMMz1T6HL;
	Fri, 12 Jul 2024 14:44:57 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id BA55C140361;
	Fri, 12 Jul 2024 14:49:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 12 Jul 2024 14:49:41 +0800
From: Long Li <leo.lilong@huawei.com>
To: <zlang@redhat.com>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <leo.lilong@huawei.com>,
	<yangerkun@huawei.com>
Subject: [PATCH 1/2] xfs/016: fix test fail when head equal to near_end_min
Date: Fri, 12 Jul 2024 14:47:15 +0800
Message-ID: <20240712064716.3385793-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

xfs/016 checks for corruption in the log when it wraps. It looks for a log
head that is at or above the minimum log size. If the final position of
the log head equals near_end_min, the test will fail. Under these
conditions, we should let the test continue.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 tests/xfs/016 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/016 b/tests/xfs/016
index 6337bb1f..335a2d61 100755
--- a/tests/xfs/016
+++ b/tests/xfs/016
@@ -239,7 +239,7 @@ while [ $head -lt $near_end_min ]; do
 	head=$(_log_head)
 done
 
-[ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
+[ $head -ge $near_end_min -a $head -lt $log_size_bb ] || \
     _fail "!!! unexpected near end log position $head"
 
 # Step 4: Try to wrap the log, checking for corruption with each advance.
-- 
2.39.2

