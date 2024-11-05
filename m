Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6268F1FBCA3
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844655; cv=none; b=DPK8+RIY+02LZQ0wLaDygUkbFUoQVWT3fqbOWRiPpR5+NFuamhNGHgBqi5/PeDVEdxg8+7ODZRF52dqym81kY3eCi1bFx/qLq1ouHiPX2H2mWEDEs1QVECeB/oJK7Ps9bA4XPEC5GDnwFyXvDnJiwA8CExOxpxIck3eNzi2cYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844655; c=relaxed/simple;
	bh=TQiqsWpoPSNq4PtAkhm4olLDwxB1Sq3me2LfASbu2uI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5zRmlt8saYTBN32dAQo3Md7zWFfd1XJTQBFZej0S8NGclxY2jcmcAb+HsuOBOhNFu/tS/G46Mc1huoIcGqCwcGk4SK8l1JVtuL+N25J5U4YKRGv+oEwkYFTYD7XyvWmOqxIBj3EJ9sZEfPGJTRnhmG6sx6A30I0/GlBnlg+YrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atfPwIJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atfPwIJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0822EC4CECF;
	Tue,  5 Nov 2024 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844655;
	bh=TQiqsWpoPSNq4PtAkhm4olLDwxB1Sq3me2LfASbu2uI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=atfPwIJP5wacLS1aiVPm9tKGK8+q+EmMLPVEE5dqiM5LzcfaAepFqZcBmNrg5xD8W
	 TJeWtQvXU8PVvBiE8zDAHJvyQsqsEnsC5ocA0bhoqvsyNVgGvsGx1S609t90MjD6/e
	 j2TXl6O2dxsRwxGdDW+5i4gjW29ujesPCw4yi48siP9NTE4F+oyjoP+dbp5Fc/wDSy
	 1R/mE5s7fxva58TkV1EIOK6usBiLThTNEH73RzB4wfWhq0sDwr4oOzZYj1UiUX1od8
	 57156yofzswmA87E/lnLhj2ItPFftwcvl3jKje0eIE0bI1Z/L/YnhdJJc8B1d03G7x
	 xA3FnI3lyWwnw==
Date: Tue, 05 Nov 2024 14:10:54 -0800
Subject: [PATCH 17/23] xfs: pass the iunlink item to the
 xfs_iunlink_update_dinode trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394743.1868694.4744784504423118480.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

So that decoding is only done when tracing is actually enabled and the
call site look a lot neater.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iunlink_item.c |   13 ++++++-------
 fs/xfs/xfs_trace.c        |    1 +
 fs/xfs/xfs_trace.h        |   15 ++++++++-------
 3 files changed, 15 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 2ddccb172fa013..1fd70a7aed6347 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -52,14 +52,14 @@ xfs_iunlink_log_dinode(
 	struct xfs_trans	*tp,
 	struct xfs_iunlink_item	*iup)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip = iup->ip;
 	struct xfs_dinode	*dip;
 	struct xfs_buf		*ibp;
+	xfs_agino_t		old_ptr;
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	error = xfs_imap_to_bp(tp->t_mountp, tp, &ip->i_imap, &ibp);
 	if (error)
 		return error;
 	/*
@@ -73,22 +73,21 @@ xfs_iunlink_log_dinode(
 	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
 
 	/* Make sure the old pointer isn't garbage. */
-	if (be32_to_cpu(dip->di_next_unlinked) != iup->old_agino) {
+	old_ptr = be32_to_cpu(dip->di_next_unlinked);
+	if (old_ptr != iup->old_agino) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
-	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
-			XFS_INO_TO_AGINO(mp, ip->i_ino),
-			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
+	trace_xfs_iunlink_update_dinode(iup, old_ptr);
 
 	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
 	offset = ip->i_imap.im_boffset +
 			offsetof(struct xfs_dinode, di_next_unlinked);
 
-	xfs_dinode_calc_crc(mp, dip);
+	xfs_dinode_calc_crc(tp->t_mountp, dip);
 	xfs_trans_inode_buf(tp, ibp);
 	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
 	return 0;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 2af9f274e8724e..7ef50107224647 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -32,6 +32,7 @@
 #include "xfs_fsmap.h"
 #include "xfs_btree_staging.h"
 #include "xfs_icache.h"
+#include "xfs_iunlink_item.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index efd89d79dff2b6..7b1fbcf970655a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,6 +74,7 @@ struct xfs_refcount_irec;
 struct xfs_fsmap;
 struct xfs_rmap_irec;
 struct xfs_icreate_log;
+struct xfs_iunlink_item;
 struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
@@ -4055,9 +4056,8 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
 );
 
 TRACE_EVENT(xfs_iunlink_update_dinode,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
-		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
-	TP_ARGS(mp, agno, agino, old_ptr, new_ptr),
+	TP_PROTO(const struct xfs_iunlink_item *iup, xfs_agino_t old_ptr),
+	TP_ARGS(iup, old_ptr),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -4066,11 +4066,12 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		__field(xfs_agino_t, new_ptr)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agino = agino;
+		__entry->dev = iup->pag->pag_mount->m_super->s_dev;
+		__entry->agno = iup->pag->pag_agno;
+		__entry->agino =
+			XFS_INO_TO_AGINO(iup->ip->i_mount, iup->ip->i_ino);
 		__entry->old_ptr = old_ptr;
-		__entry->new_ptr = new_ptr;
+		__entry->new_ptr = iup->next_agino;
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x old 0x%x new 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

