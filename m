Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6122557C;
	Tue, 11 Mar 2025 07:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741677109; cv=none; b=JbU0RLAK/ypENS22EsaJr574hJK0wgCKumm5tDqNKMFqInkDV8e8dITSO1JS5JADSnVzlr7BUWu5U814w2lwcN2/2yUydThFubw+w8WBrISxvU+x5wvcaELOwg3WGsLxar1TTsfOnz3eutiwv/UFuvvyUhm1cy5rz+4Xs4tDvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741677109; c=relaxed/simple;
	bh=zranEsbod9ZNmZ+Uw6UXY7AtRfJTC9qLdHYi9HCC5Qg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QOKXC3hIbqZ8H3U7DkChVjn7mc1Q/i8/fyiByuNYomr34Q7p6qVuAaKK+kLosuzI6tobagm1kj0QVThFEJfRD/xtRYaCzrdKpK7flaE+QbT5nx0fU1wzCZxNKjiPSZf4DC95U7fRSGUodc1lSqb1ujAHGY7B0JN3rJDmFlz/6i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowABXXKAo4s9nPtzXEw--.3914S2;
	Tue, 11 Mar 2025 15:11:36 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] xfs: remove unnecessary NULL check before kvfree()
Date: Tue, 11 Mar 2025 15:11:14 +0800
Message-Id: <20250311071114.1037911-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXXKAo4s9nPtzXEw--.3914S2
X-Coremail-Antispam: 1UD129KBjvdXoWrXw4Dtw45urW3GFWDKr1UAwb_yoWxWFb_ua
	yxKr1kWw1UAFnrJw1Dt39Yqayq9397Gan7XwsYyFsxt347Ca15X39rWrWrtr9xCFZxKF18
	Ga4vyF9xtryS9jkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbV8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUS38nUUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove unnecessary NULL check before kvfree() reported by
Coccinelle/coccicheck and the semantic patch at
scripts/coccinelle/free/ifnullfree.cocci.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/xfs/xfs_rtalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 57bef567e011..9688e8ca6915 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1144,8 +1144,7 @@ xfs_growfs_rtg(
 			goto out_error;
 	}
 
-	if (old_rsum_cache)
-		kvfree(old_rsum_cache);
+	kvfree(old_rsum_cache);
 	xfs_rtgroup_rele(rtg);
 	return 0;
 
-- 
2.25.1

