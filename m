Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C110256B7C;
	Tue, 16 Jul 2024 08:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721116909; cv=none; b=NM1ZMsjcSuad47uRfhiklwn8SwPYVhmytzo9HseDNSbOPCB2Ia/LnUWq3XWITF45U0gAlY8lcSrsM5G/oZJQQPrKgqLL+PKq3Ez0F0t0Jxd6FypE15POhBdgWiF8qyIhJi/W7Kn2D0j1FyowUK5PLWxWoj8IKzkVCoY4cAjjRXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721116909; c=relaxed/simple;
	bh=KlgNy1kVrobCQlXXlavVPtTSx/NRsZB6hncNubs1eBk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bdqinZvJZQMLpXQAbQV6ITQuYEO8GvMJLW53c2xv/dbBNMF1uLy42ClZEWfb6zi6EaRaISqrwVmZ3AlJMpboUD0IiBGj5TcccblLS9NwZEEU3wxOUGYgy3mzfnT7szg3JTfkiE0fyJoQbf4xv8+iX8vNMs/rpw4AUTvPF6GrAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowABHMyDiKJZmkA6XAw--.55104S2;
	Tue, 16 Jul 2024 16:01:38 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: chandan.babu@oracle.com,
	djwong@kernel.org,
	dchinner@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] xfs: convert comma to semicolon
Date: Tue, 16 Jul 2024 16:01:12 +0800
Message-Id: <20240716080112.969170-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHMyDiKJZmkA6XAw--.55104S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZrWkJr4UuFyDZw1UKFg_yoW3KwbEkr
	47tF18K3y5Jry2vw17AFsYkw1v9w4kZFn3GayfXFyqkFyxJFW5Zw4kCrZIyr98WrW5Cr1f
	W3yFvr42kay7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
	GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj9qXPUUUU
	U==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Fixes: 178b48d588ea ("xfs: remove the for_each_xbitmap_ helpers")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/xfs/scrub/agheader_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0dbc484b182f..2f98d90d7fd6 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -696,7 +696,7 @@ xrep_agfl_init_header(
 	 * step.
 	 */
 	xagb_bitmap_init(&af.used_extents);
-	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
+	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-- 
2.25.1

