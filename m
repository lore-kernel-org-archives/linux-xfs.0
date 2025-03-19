Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D44F10FD;
	Wed, 19 Mar 2025 03:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742356131; cv=none; b=n0R1SHQU1hDptc2sshulNCgspRGbA6DWLQGNMnt/LLTgfjaO3262TUUy8WWgiMjYHA4hRZ30qY3TCITap1j25btUMRMscJv7rWLS3f+n/ImUOrsPTJnlEV903qNGp+0miKmiCkzc5zog79BdrrS5ob4nNGgOmXA2nDEIKlu7VGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742356131; c=relaxed/simple;
	bh=wA0gSlT2qOkb8shKSYUHPnqoSigHRaoG7FwxyliD/YM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dUq+dTYr7y0JNqK1jimxyYJI30+s9zJFpUaaJY5Tp0+j0sXFUPUdMh8t/ZLfLwjYJrtw37xbzpGDPJ+Z9xq2wwAznsR/XzYi0DsmipJjDd4yxP4ZjpdkkT8sBb1NG2i1iANNmAh1PGWwLPw9w+3USn86okirrvwix+BjySqQgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAXHKCaPtpnjmgyFg--.14469S2;
	Wed, 19 Mar 2025 11:48:43 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] xfs: remove duplicate xfs_rtbitmap.h header
Date: Wed, 19 Mar 2025 11:48:06 +0800
Message-Id: <20250319034806.3812673-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXHKCaPtpnjmgyFg--.14469S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYk7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4
	A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr
	1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r
	126r1DMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU0a9aDUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove duplicate header which is included twice.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/xfs/scrub/repair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f8f9ed30f56b..5ce5064d67e5 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -21,7 +21,6 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
-#include "xfs_rtbitmap.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
-- 
2.25.1

