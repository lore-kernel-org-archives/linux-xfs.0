Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E841D204;
	Fri,  4 Sep 2026 06:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502438; cv=none; b=OHrCX6h/B2moTbxm+Hm+uC9e73JZSfxJbvbyUUqgrXHEdLAFlBcXHvqcc7XcCSRAMe/siGbqSG6V8N+X6p3ENRfw2vMwupBrHEle+wxxBffAAKq9VX/JJ7LYAkO0QrcUX/MKS91O9WhwVsXqmgqPqcKDmESgqNAZC0n5fCIjhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502438; c=relaxed/simple;
	bh=Qc3skb2l/T96vCLnWJ2qAyiSmRfUBmOMvKBWQ6deZw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niptvspGiYcy/4EMzcmL/t7AW4btR2MR+jf/3a+BVUoU/GibeUH/ra66LpODDJqR1+CRkTL0vkp1Nxr262B0LYaWLtR68+gpr+PQLJPNtt471uA7FGwu0p3jA8fSA9OIaQKk3Jc9em9aKefAIqlFYYOCTvoMkP66fwQe8ZWQGiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbmNT6THszKHMTN;
	Fri,  4 Sep 2026 14:12:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8D7014056D;
	Fri,  4 Sep 2026 14:13:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbwqeYZpqTb3FAg--.50434S9;
	Fri, 04 Sep 2026 14:13:52 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: cem@kernel.org,
	dgc@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 5/5] xfs: remove never-implemented scrub declarations
Date: Fri,  4 Sep 2026 14:06:48 +0800
Message-ID: <20260904060648.1966130-6-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
References: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHbwqeYZpqTb3FAg--.50434S9
X-Coremail-Antispam: 1UD129KBjvJXoWxArW5Aw18Jr1kZr15Ar48Crg_yoW5Ww43pa
	18Kw15GFWDJr15uaykZF1rZ34jg3s3GrW7urs5Gw43Z3s8CryrKF17Kr1DA3Wjga1YgrW7
	uF1qq34kWwnxCFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
	0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZTmfUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit dcb660f9222f ("xfs: probe the scrub ioctl") added a declaration for
xfs_scrub_tester() (now xchk_tester) as a placeholder in 2017, but the
function was never implemented.

Likewise commit 99d9d8d05da2 ("xfs: scrub inode block mappings") declared
xfs_scrub_setup_inode_bmap_data() (now xchk_setup_inode_bmap_data) in 2017,
which was never implemented either; the scrub ioctl table uses
xchk_setup_inode_bmap() for BMBTD/BMBTA/BMBTC checks.

Finally, the !CONFIG_XFS_ONLINE_REPAIR stub of xrep_tempfile_iolock_both()
added by commit 84c14ee39dd3 ("xfs: create temporary files and directories
for online repair") has no callers.

Remove these dead declarations and the unused stub.

Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
Note: if any of them are intended to be implemented in the future, please
just ignore the corresponding patch. I'm only sending these because they
have been sitting unimplemented since 2017.

 fs/xfs/scrub/common.h   | 1 -
 fs/xfs/scrub/scrub.h    | 1 -
 fs/xfs/scrub/tempfile.h | 4 ----
 3 files changed, 6 deletions(-)

diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 9d627fd50687..f0f073a93413 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -74,7 +74,6 @@ int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xchk_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xchk_setup_inode(struct xfs_scrub *sc);
 int xchk_setup_inode_bmap(struct xfs_scrub *sc);
-int xchk_setup_inode_bmap_data(struct xfs_scrub *sc);
 int xchk_setup_directory(struct xfs_scrub *sc);
 int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6d7d3523b71f..737a5d6db15f 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -261,7 +261,6 @@ static inline int xchk_nothing(struct xfs_scrub *sc)
 }
 
 /* Metadata scrubbers */
-int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
 int xchk_agf(struct xfs_scrub *sc);
 int xchk_agfl(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index 71c1b54599c3..d44ed43bafe0 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -39,10 +39,6 @@ int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
 void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
 bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
-static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
-{
-	xchk_ilock(sc, XFS_IOLOCK_EXCL);
-}
 # define xrep_is_tempfile(ip)		(false)
 # define xrep_tempfile_adjust_directory_tree(sc)	(0)
 # define xrep_tempfile_rele(sc)
-- 
2.52.0

