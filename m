Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BED26ACD;
	Thu, 13 Mar 2025 03:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741836669; cv=none; b=BMztJl/ag99p/HWSuVep7zXJ53F0cztBoGkOg3TYEH0lbud58p2nqjAdUld4M5oWQ1RovFqK3rKE5i2zevXbjnpD6EvHPqexD7bM1zBrj2w78MUBaSI7g/s/P4mj9hfDWcOk8ZjCcErMeASd8MIdP7Ehkv5L4yNVCbDi+ppmM38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741836669; c=relaxed/simple;
	bh=6j+CW8n+AP9HuqY8JnQFaZKjkOcDpC5b/YgSGjy0TLE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W3FPOb4i7L4YWY4i06x4Nz8lGoNI63hohb6Wed1JVnvec71T02oyvhGvF/AsLv2SqSZ5GpDHEo8rJpKiGSPSaI8qKpED7ujZqIbGD+Fc8lCX7EZaIUFXlM+ZNpj9UyAyJItiJciF84c/87kBpsU9DxyzC32UNinrAqCjHmA/MNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAAnLw9qUdJnXpnEFA--.18983S2;
	Thu, 13 Mar 2025 11:30:50 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH -next V2] xfs: remove unnecessary NULL check before kvfree()
Date: Thu, 13 Mar 2025 11:28:59 +0800
Message-Id: <20250313032859.2094462-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAnLw9qUdJnXpnEFA--.18983S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr45CFWkur4fXrWUZryxXwb_yoW3Xrc_Ca
	n7t3Z7Ww4UArnrJw1DJwsY9w4qva1xJFs7Xws3tF43tryDA3WUWwnrXrWrtry7WFZIkF1U
	Gas7KFZIvry8ujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
	wI0_Jw0_GFylc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUedgADUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove unnecessary NULL check before kvfree() reported by
Coccinelle/coccicheck and the semantic patch at
scripts/coccinelle/free/ifnullfree.cocci.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
Changelog:

v1 -> v2:

1. rebase it on top of for-next.
---
 fs/xfs/xfs_rtalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9a99629d7de4..3aa222ea9500 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1212,8 +1212,7 @@ xfs_growfs_rtg(
 			goto out_error;
 	}
 
-	if (old_rsum_cache)
-		kvfree(old_rsum_cache);
+	kvfree(old_rsum_cache);
 	goto out_rele;
 
 out_error:
-- 
2.25.1

