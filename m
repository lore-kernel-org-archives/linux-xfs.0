Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8885182DB
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422890; cv=none; b=L6LgZAn0yaecjSpfsn9QikczqM3zyp3kUrb7FngvG0b1kU/dl+lBLWCQX0GC/4o3de+QDKuS58sPBSfLdRygnBXn75cu6qxtaMuKjuFZPcJoYBQxjD4IrnisprBw7l9icqbnJE8DrOWX5wiJt3ik6Inlkoo/1fH7TJrafUbypRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422890; c=relaxed/simple;
	bh=VlvW+q3j7F/886mmRuwTFBg9WaWALCrj5nWH2siGz6s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlDqOrWXqGwxzJ/b3vL/l6yPFubLs36DehUs7r6sPicDrP3tGuBwWyhRlo6y2vNtGLdmqUIMdBjXlr0A5Kld9R6hyRDo6AM9aLIzpxqnYLd0nUAPbQtYe3e2DQLDYaSwBYwJz1kG9vKs/yzm364Ttv+25rC7Xt7ioMtCxH+mSNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fl1OGB4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fl1OGB4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C19EC433F1;
	Tue, 26 Mar 2024 03:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422890;
	bh=VlvW+q3j7F/886mmRuwTFBg9WaWALCrj5nWH2siGz6s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fl1OGB4K4E8jGmTHnk5kjnheTaL4tuPDMXd3gjVE0CyH4HaZNuoRDMBRNqZuh11ht
	 oG7R+IPwXHpvwKJeKIGIdE+Wd0cnKumDP0BFD6Vg/4lKxxjIq2FGRMX/RAacXszB8q
	 BFKcdsR+RhlSNZjh36C5MY4Rev6aP5tZK+DupvTf0vVfnrzBPvopLK1gFMPZgiqSbQ
	 yIjVD/6yWDE3XPI69GznTGGr8m3BriqPt7rn5LbUMsi1I+Jmkhno3lOTKkd5nZMwZe
	 DWufdUhoVOSyvghafGEXS2HvmASxD8g2MwXnehiHt6cWOZROzHQ3KeEJVqbtGHXrMh
	 7miQfBGT3i4KQ==
Date: Mon, 25 Mar 2024 20:14:50 -0700
Subject: [PATCH 46/67] xfs: remove the xfs_alloc_arg argument to
 xfs_bmap_btalloc_accounting
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127619.2212320.17508317484895224639.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eef519d746bbfb90cbad4077c2d39d7a359c3282

xfs_bmap_btalloc_accounting only uses the len field from args, but that
has just been propagated to ap->length field by the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3520235b58af..ad058bb126e2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3259,8 +3259,7 @@ xfs_bmap_btalloc_select_lengths(
 /* Update all inode and quota accounting for the allocation we just did. */
 static void
 xfs_bmap_btalloc_accounting(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args)
+	struct xfs_bmalloca	*ap)
 {
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
@@ -3273,7 +3272,7 @@ xfs_bmap_btalloc_accounting(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 			return;
 		}
 
@@ -3285,22 +3284,22 @@ xfs_bmap_btalloc_accounting(
 		 * This essentially transfers the transaction quota reservation
 		 * to that of a delalloc extent.
 		 */
-		ap->ip->i_delayed_blks += args->len;
+		ap->ip->i_delayed_blks += ap->length;
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
-				-(long)args->len);
+				-(long)ap->length);
 		return;
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_nblocks += args->len;
+	ap->ip->i_nblocks += ap->length;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
-		ap->ip->i_delayed_blks -= args->len;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+		ap->ip->i_delayed_blks -= ap->length;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 	}
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		args->len);
+		ap->length);
 }
 
 static int
@@ -3374,7 +3373,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap, args);
+	xfs_bmap_btalloc_accounting(ap);
 }
 
 #ifdef DEBUG

