Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275868;
	b=ekUI9xA2OK7AI1CEYH1/2IrolrmlfO1OxnWhnSmwkdHyAosWndXaJPPuqMXrDwAyFZBs
	 aeVotgeEzEwlkvAdRQe7AfXPzVPsIXuO8GFRAEkQGgfLnNX/X7r3agNejAwz8+GgRtLtW
	 WoyYRx3JG/KB1ILoexAZuqTX3AaFMOO84BNBfNg7Hpngk7h0NMnkkBN1cu9MzhbPtYNqE
	 e6kT2Cp1Zta1lSkR7xTzdrLTihtULfaBjU/9kPwYYyffewGscDLJ6cjmCWNSyNjQNyZML
	 FGPmmE7erXt0B6ZyLFaT6dZ2OyGF2rUePi42rALolYxLx5QIKvk1u4aHDIUZw7nfn7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ftHHy0ZQVaj0ooveAWZpNx0jwmeUcKl0UPHgp0rGjSI=;
	b=CIJxYn/27eR/gEE7IgFgZVnQG0eKHP9tfhx3S3UBRhNqwELwexu7A2uQM/thAT6+tQwr
	 oVMW+61iFSkAXnG2FfHgUDgbk7nPugCESJllPZvCu/AVVbjO5/oawxXxTPANY2nds0xcl
	 RhifOn0oZz3Bc6ovXVIyfi+i7miVKciWKZYMhiH/Gkk1pxA4fYuIc8ATTZMZQrF7rIh1Y
	 FhpTJaQmpAhcsTE/gYjfZ9VfEHBwy4/3Yf2KpRG4OFEzVQGQGOmdxvzjEYnTQLh76JcFx
	 JO/Df/IBOHuLS4Bl9zi8/JT0Jzl3tJRTWKI1amidukcqqVR0Sok1fJtWqNw9MsZLiKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d4cGLkyJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F02606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d4cGLkyJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54751F01825;
	Thu, 29 Oct 2026 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275867;
	bh=ftHHy0ZQVaj0ooveAWZpNx0jwmeUcKl0UPHgp0rGjSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4cGLkyJFRtiIXKEDBHq2cHQ1s1EKDYPbvUbGUVHc52ja0GQ37Vc1/HSAenQnkyCh
	 XN2ndjs/T2iCS326EBnkpvs4X8cR/m+OaMpaLy7JU8UbruF67HyRQrPwz+YstQRw0e
	 P7JvMYez3Vtxqx+qGeChXmw+bvB3d40VnEdzlY+5Saf+zTP7LtZDwZHPB08s1y47mx
	 PE+9z3F/eOpYiNkBad3xDsI7jXisMhhBFby7FkludibAj+3j7IAybllp83Z1ZAOMqp
	 xXQy5irFCncdAWFKhHjczl4nbNlsnYCfgpSrU3ZLDoNIaOSEW8pQECb9KWsvJMdAOX
	 QbtQW3NEEfnIw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 24/28] xfs: fix typos and repeated words in comments
Date: Thu, 29 Oct 2026 13:06:21 +0100
Message-ID: <20261029120631.803074-25-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hemanth Selam <hemanth.selam@gmail.com>

Source kernel commit: 2f3c2a6f963e57cf4f0f34cbf24ab11abb64d118

Correct ten misspellings and eight accidentally doubled words in
comments.  No code changes.

The doubled word in xfs_zone_alloc.c was not a duplicate: "so that is is
reused" is "it is" misspelt, so that one reads "so that it is reused"
rather than dropping a word.

Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h        | 2 +-
 libxfs/xfs_alloc.c     | 4 ++--
 libxfs/xfs_attr_leaf.c | 2 +-
 libxfs/xfs_errortag.h  | 2 +-
 libxfs/xfs_exchmaps.c  | 2 +-
 libxfs/xfs_format.h    | 2 +-
 libxfs/xfs_inode_buf.c | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index fd22fe598931..ee636b66a72f 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -207,7 +207,7 @@ xfs_perag_next(
 }
 
 /*
- * Per-ag geometry infomation and validation
+ * Per-ag geometry information and validation
  */
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index d99602bcc16f..f762dcce8d13 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3487,7 +3487,7 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Pre-proces allocation arguments to set initial state that we don't require
+ * Pre-process allocation arguments to set initial state that we don't require
  * callers to set up correctly, as well as bounds check the allocation args
  * that are set up.
  */
@@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
 	 * ABBA AGF deadlocks because a future allocation attempt in this
 	 * transaction may attempt to lock a lower number AGF.
 	 *
-	 * We can't release the AGF until the transaction is commited, so at
+	 * We can't release the AGF until the transaction is committed, so at
 	 * this point we must update the "first allocation" tracker to point at
 	 * this AG if the tracker is empty or points to a lower AG. This allows
 	 * the next allocation attempt to be modified appropriately to avoid
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b6288395f853..2c80f4fd0b78 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1715,7 +1715,7 @@ xfs_attr3_leaf_add_work(
 			/*
 			 * This freemap entry starts at the old end of the
 			 * leaf entry array, so we need to adjust its base
-			 * upward to accomodate the larger array.
+			 * upward to accommodate the larger array.
 			 */
 			diff = sizeof(struct xfs_attr_leaf_entry);
 		} else if (ichdr->freemap[i].size > 0 &&
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6de207fed2d8..f0c83f1f0b3b 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -83,7 +83,7 @@
 #define XFS_RANDOM_DEFAULT				100
 
 /*
- * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
+ * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
  *   1. The XFS_ERRTAG_ flag but without the prefix;
  *   2. The name of the sysfs knob; and
  *   3. The default value for the knob.
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 114463c101d6..9562784dd53d 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -394,7 +394,7 @@ xfs_exchmaps_one_step(
 	/*
 	 * Re-add both mappings.  We exchange the file offsets between the two
 	 * maps and add the opposite map, which has the effect of filling the
-	 * logical offsets we just unmapped, but with with the physical mapping
+	 * logical offsets we just unmapped, but with the physical mapping
 	 * information exchanged.
 	 */
 	swap(irec1->br_startoff, irec2->br_startoff);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index dd0ed046fbe9..1a7a7e60a170 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
  * block is 1KB in size.
  *
  * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
- * with 1KB sized blocks, a file can reach upto,
+ * with 1KB sized blocks, a file can reach up to,
  * 1KB * (2^31) = 2TB
  *
  * This is much larger than the theoretical maximum size of a directory
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 6fff9bbd39ab..02a56321059b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -624,7 +624,7 @@ xfs_dinode_verify(
 	 * have di_nlink track the link count, even if the actual filesystem
 	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
 	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
-	 * the the incore di_nlink value, which is why we cannot check for
+	 * the incore di_nlink value, which is why we cannot check for
 	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
 	 * di_onlink==0, so we can check that.
 	 */
-- 
2.54.0

