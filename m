Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF027713;
	Tue,  9 Jul 2024 07:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720510617; cv=none; b=Yl4ZGAHWD9H3YlJdaZmpTzChtK3VKjWc8SFh49RxLIQVjDSM9udw8nY8qBWjqQNZjJ3KIM5lSZNeVlp4vkidEXTLE0wbisX2QuywAeebW1P6UlgPHeB4N5VtK3qqsfblfsPZUOHOJA3qHC4GYc9mPDAKtsqoCo6MayTOQJE3qsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720510617; c=relaxed/simple;
	bh=kJVEraRI21h/N6nGEGKFv74pdsh0FUQihuPipEu8lKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JZtH7gMNWWGPQLHyK0dlTk/87khwwFQeqO/QrodHXWdiwX7F3ihUOnOR1fT3rEc+lX7AaFMZy/V3VrJAve0ZrPk2NRYv1fEErEDiYlfQl95aDfna0TgCVuR4ThWm200lz8QZe6HoDbR85wbGuqW+djlQRDiZZNXVbWG1w3Doe6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAD3_lqR6IxmUgrNFA--.40028S2;
	Tue, 09 Jul 2024 15:36:49 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] xfs: convert comma to semicolon
Date: Tue,  9 Jul 2024 15:36:32 +0800
Message-Id: <20240709073632.1152995-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAD3_lqR6IxmUgrNFA--.40028S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZF15Zr47JF17Ww45KFg_yoW3WFc_ua
	98tF1kG3W5Jr17K3ZrAryFya1rX397ArnrX392yFnIy3s0qF4UXws0gr4UtFnxWr15A3ZY
	93Z0gFWYkF9I9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
	GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5HUDDUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/xfs/xfs_attr_list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5c947e5ce8b8..7db386304875 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -139,7 +139,7 @@ xfs_attr_shortform_list(
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
-		sbp->value = &sfe->nameval[sfe->namelen],
+		sbp->value = &sfe->nameval[sfe->namelen];
 		sbp->valuelen = sfe->valuelen;
 		sbp->flags = sfe->flags;
 		sbp->hash = xfs_attr_hashval(dp->i_mount, sfe->flags,
-- 
2.25.1

