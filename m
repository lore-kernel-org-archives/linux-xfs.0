Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275794;
	b=SnoYK2Ap7JaxO3DugaOWulfOcig8Q9DuA/GnNlzVMI1sQinEQPsX1+EUJ04G0k6FZWZn
	 dDnRWKP4z83+g1Uta2Clf+GEYW4iQlaTmdbCGUjT1BvqnxsgsAGYAHUhJu50IrpQuiyL+
	 +tRod/c9uRV2sMK3hqxKA55leMB3mhlNkVdnwa31oz9vFnc8sOFbvcl09ume/km8ROB6H
	 /1w1EJ+r/PWzdbQ1Qajh10+ySEYOU7eS0TWwyjUnMCP7r9FWzK1mqmKKs3/CgMBclwCdp
	 Q2KcVvn2VFCp9QVHCOyGzM17+IQDpYNYlYp7BDH9yyQyxBMl6+FYxbc9lrmjTCUgHCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=n4/Oy4A7x388fHKkGcLIfHB1LsnPeZeEfoIDDVezIE4=;
	b=bnPVJA9Mer8MCLLvJ6W2Rp1riUK9k9PKjlfoKGVhTlGhgyevoOZQGydssRWTWqlQhDNp
	 zaqueQeZotyUvmn5JX83bBR6z9TMWk70BVYgkja8cKgebPWdyZQT4LhSwYLOxp4cVK+pK
	 1fJqN+kBzt/+8+EJgxo3646yTZCr/dFoXbU3es8rAwKEZ4gI7yqJGJvmbTyas5Lf2Nt2i
	 79tf46DjJlrEp0czL2kByh/KqXTCVWd0h5OCB8jR7Yc2W/gYVDZ2ZdLgCxd1wC+w8sdpA
	 R2n8z9UKYOrNOcslX5lSBgArO9OJBSx49PRDqTn8yytVINSGG2Cewb+dRP3eO7fhEug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHCQsv6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088D606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHCQsv6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44981F01828;
	Thu, 29 Oct 2026 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275793;
	bh=n4/Oy4A7x388fHKkGcLIfHB1LsnPeZeEfoIDDVezIE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHCQsv6HHNWgRO9j3s0+MbaZg/nLJKbMnzT0RaVgxKf2hmjUT+1grzq7auhCYU49j
	 4VUXAqvEz8FChspDdd1+m6iUNNUeOPb0l9JcdUp1OfXDKLaq85MRfCxQuqNDAJIoLw
	 /ieyCJKEy3f82LBQLL6v30IdZQAEf+gt2HK3A4pYz1ZPH2bV3HU2GVoe8ag2Cgv2+j
	 Zc4YBR/rlDuTzQZb7kw1nuWspq1dIohZUhYWyeq+fUzAi83Tj/DNGqsmTUajRcarkI
	 DO+IkeBlv1zCRU5yGRIOEDxBslPhkZ7V3LqrDKwob0Ht5zdpe6b1fFmrHbIzgr1kEe
	 p1ecH6HG1f7CA==
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
Subject: [PATCH 07/28] xfs: hide b_flags manipulation from code outside of xfs_buf.c
Date: Thu, 29 Oct 2026 13:06:04 +0100
Message-ID: <20261029120631.803074-8-aalbersh@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 9f224de410d7efafc44ce1880aabd0101aa8688f

Add helpers for the remaining buffer flags manipulation not done in the
core buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_btree_staging.c | 7 +++----
 libxfs/xfs_ialloc.c        | 2 +-
 libxfs/xfs_platform.h      | 5 +++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index c3c7ea54895a..7314dab4bcfb 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -248,11 +248,10 @@ xfs_btree_bload_drop_buf(
 		return 0;
 
 	/*
-	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
-	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 * Mark this buffer uptodate so that a subsequent xfs_buf_read will
+	 * not pointlessly reread the contents from the disk.
 	 */
-	bp->b_flags |= XBF_DONE;
-
+	xfs_buf_set_uptodate(bp);
 	xfs_buf_delwri_queue_here(bp, buffers_list);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index a064289e1634..912b796bf5b6 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -412,7 +412,7 @@ xfs_ialloc_inode_init(
 				xfs_trans_ordered_buf(tp, fbuf);
 			}
 		} else {
-			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_set_uptodate(fbuf);
 			xfs_buf_delwri_queue(fbuf, buffer_list);
 			xfs_buf_relse(fbuf);
 		}
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 4f4990a20dad..c6787ee4c83c 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -314,6 +314,11 @@ xfs_buf_incore(
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
+static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
+{
+	/* does nothing, XBF_DONE is not LIBXFS_B_UPTODATE */
+}
+
 static inline void
 xfs_buf_readahead(
 	struct xfs_buftarg	*target,
-- 
2.54.0

