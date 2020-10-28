Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643E4C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED3232076B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 23:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gaGCgxkg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgJ1XOw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390238AbgJ1XOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 19:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603926878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=xlF6OroCad+FhuXUcHx97jSEANkEUs2pPxpIDjuCo/0=;
        b=gaGCgxkgT9GUqli37FCPEmGX4ue4h9Eivn9lJtgWTqgdffYxmK5WuAVPTjP+Tesac8Wz8V
        DK0qkjiEaScYwFYOOmJgGv+ODzZb58KxMei+c89alBx6UT80P/0WAKls3O5cTrBAuV2v4i
        fPzY4MkR0ThX48q70WaikFLJYSyX6pU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-7EfD78TCNjqeyahDmGOXwg-1; Wed, 28 Oct 2020 19:14:36 -0400
X-MC-Unique: 7EfD78TCNjqeyahDmGOXwg-1
Received: by mail-pl1-f200.google.com with SMTP id v4so625818ply.7
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 16:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xlF6OroCad+FhuXUcHx97jSEANkEUs2pPxpIDjuCo/0=;
        b=mlGYzWrOdfJ6Z9zfYNa3kiRR13L1spQuZVqe4cTMHCzTAzPK1mVU8pLp8B2ElSnaOi
         T22s1MLoAhDeBZkVppHVoABN3f17FrauT6Bu6KA+8eQm149LP9l1sz+onii5q6Ytp7Vs
         u5LKDcvwjKe29FGYq2wmf+csx24OazTnjSRMP/htwkiqMApMyGTJk7IclRIz16Zi0PkG
         mOegnfd9KZYhk+qSznV4eoWoN32hJt2kCO3JMMoxEZ4Yb7XLur2ZVMqEoY1g3Op2Ru2E
         7nqNXXGM3nlVbeNGrgFoIvj0GxhDtWOVYIy5qs6iubdAErgJ8zoGIl/98jkk2yScHBjb
         tDyQ==
X-Gm-Message-State: AOAM5338QsuqlkgqqDzBn1P0iiAGH43MaHYvBTmKVX4VDS472b1l4QTU
        uCBmfQ4TqWz+ZnK139574jP9JMzbnkqFDwSCLCev7I9nou8RbX4+vToeiHLOuyIwxYVNljxphvO
        iG03SdBpFIGb9EuyENddy
X-Received: by 2002:aa7:8bcd:0:b029:160:cb7:b639 with SMTP id s13-20020aa78bcd0000b02901600cb7b639mr1287845pfd.78.1603926873898;
        Wed, 28 Oct 2020 16:14:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjSmeFcpphxoe7igr5rQdV/h65MHjxc4x8/gpQpi38dUKk/+Pa93I24I6zSjVLCcGcwxVvgg==
X-Received: by 2002:aa7:8bcd:0:b029:160:cb7:b639 with SMTP id s13-20020aa78bcd0000b02901600cb7b639mr1287819pfd.78.1603926873555;
        Wed, 28 Oct 2020 16:14:33 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e7sm635365pfn.180.2020.10.28.16.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 16:14:33 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2] xfs: support shrinking unused space in the last AG
Date:   Thu, 29 Oct 2020 07:13:53 +0800
Message-Id: <20201028231353.640969-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At the first step of shrinking, this attempts to enable shrinking
unused space in the last allocation group by fixing up freespace
btree, agi, agf and adjusting super block.

This can be all done in one transaction for now, so I think no
additional protection is needed.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
RFC v1: https://lore.kernel.org/r/20201014005809.6619-1-hsiangkao@aol.com/

This mainly addresses previous review/comments/suggestions from Darrick
& Brian, hopefully I don't miss or misunderstand something (even though
some suggestion are slightly conflict, e.g. seperate 2 individual paths
for extending and shrinking..)

changes since RFC v1:
 - omit unnecessary internal log judgement (Darrick);
 - remove the preallocations before allocation and re-establish
   later (Darrick);
 - convert unencouraged
   "if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))" (Darrick);
 - never support shrinking the 1 AG case (Darrick);
 - update trans data reserving since removing 1 record won't
   cause a spilt (Darrick);
 - use xfs_alloc_vextent() instead and if allocation failure just commits
   the dirty trans in order for agfl fix (Brian);
 - s/new/delta in xfs_growfs_data_private() so more readable (Brian);
 - move AG initialization mechanism into a helper that we only
   call on extend (Brian); 

Also, I wrote a preliminary fstest case for this,
https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

and a simple xfsprogs change,
https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com

Kindly point out any strange / misuse about this patch, Thanks!

Thanks,
Gao Xiang


 fs/xfs/libxfs/xfs_ag.c |  72 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   2 +
 fs/xfs/xfs_fsops.c     | 149 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trans.c     |   1 -
 4 files changed, 173 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9331f3516afa..bec10c85e2a9 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -485,6 +485,78 @@ xfs_ag_init_headers(
 	return error;
 }
 
+int
+xfs_ag_shrink_space(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_extlen_t		len)
+{
+	struct xfs_buf		*agibp, *agfbp;
+	struct xfs_agi		*agi;
+	struct xfs_agf		*agf;
+	int			error, err2;
+	struct xfs_alloc_arg	args = {
+		.tp	= tp,
+		.mp	= mp,
+		.type	= XFS_ALLOCTYPE_THIS_BNO,
+		.minlen = len,
+		.maxlen = len,
+		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.resv	= XFS_AG_RESV_NONE,
+		.prod	= 1
+	};
+
+	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
+	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
+	if (error)
+		return error;
+
+	agi = agibp->b_addr;
+
+	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
+	if (error)
+		return error;
+
+	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
+				    be32_to_cpu(agi->agi_length) - len);
+
+	/* remove the preallocations before allocation and re-establish then */
+	error = xfs_ag_resv_free(agibp->b_pag);
+	if (error)
+		return error;
+
+	/* internal log shouldn't also show up in the free space btrees */
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out;
+
+	if (args.agbno == NULLAGBLOCK) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+	/* Change the agi length */
+	be32_add_cpu(&agi->agi_length, -len);
+	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
+
+	/* Change agf length */
+	agf = agfbp->b_addr;
+	be32_add_cpu(&agf->agf_length, -len);
+	ASSERT(agf->agf_length == agi->agi_length);
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
+
+out:
+	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
+	if (err2 && err2 != -ENOSPC) {
+		xfs_warn(mp,
+"Error %d reserving per-AG metadata reserve pool.", err2);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return err2;
+	}
+	return error;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 5166322807e7..f3b5bbfeadce 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -24,6 +24,8 @@ struct aghdr_init_data {
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
+int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
+			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
 			struct aghdr_init_data *id, xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..1c418c4bf94d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,49 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+static int
+xfs_resizefs_increase_ags(
+	xfs_mount_t		*mp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		*delta)
+{
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
+	int			error;
+
+	/*
+	 * Write new AG headers to disk. Non-transactional, but need to be
+	 * written and completed prior to the growfs transaction being logged.
+	 * To do this, we use a delayed write buffer list and wait for
+	 * submission and IO completion of the list as a whole. This allows the
+	 * IO subsystem to merge all the AG headers in a single AG into a single
+	 * IO and hide most of the latency of the IO from us.
+	 *
+	 * This also means that if we get an error whilst building the buffer
+	 * list to write, we can cancel the entire list without having written
+	 * anything.
+	 */
+	INIT_LIST_HEAD(&id->buffer_list);
+	for (id->agno = nagcount - 1;
+	     id->agno >= oagcount;
+	     id->agno--, *delta -= id->agsize) {
+
+		if (id->agno == nagcount - 1)
+			id->agsize = nb - (id->agno *
+					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
+		else
+			id->agsize = mp->m_sb.sb_agblocks;
+
+		error = xfs_ag_init_headers(mp, id);
+		if (error) {
+			xfs_buf_delwri_cancel(&id->buffer_list);
+			return error;
+		}
+	}
+	return xfs_buf_delwri_submit(&id->buffer_list);
+}
+
 /*
  * growfs operations
  */
@@ -33,33 +76,44 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
-	xfs_rfsblock_t		new;
+	xfs_rfsblock_t		delta;
 	xfs_agnumber_t		oagcount;
 	xfs_trans_t		*tp;
+	bool			extend;
 	struct aghdr_init_data	id = {};
 
 	nb = in->newblocks;
-	if (nb < mp->m_sb.sb_dblocks)
-		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
+	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
+	if (error)
 		return error;
-	error = xfs_buf_read_uncached(mp->m_ddev_targp,
+
+	if (nb > mp->m_sb.sb_dblocks) {
+		error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
 				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
-	if (error)
-		return error;
-	xfs_buf_relse(bp);
+		if (error)
+			return error;
+		xfs_buf_relse(bp);
+	}
 
-	new = nb;	/* use new as a temporary here */
-	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
-	nagcount = new + (nb_mod != 0);
+	delta = nb;	/* use delta as a temporary here */
+	nb_mod = do_div(delta, mp->m_sb.sb_agblocks);
+	nagcount = delta + (nb_mod != 0);
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
-		if (nb < mp->m_sb.sb_dblocks)
+		if (nagcount < 2)
 			return -EINVAL;
 	}
-	new = nb - mp->m_sb.sb_dblocks;
+
+	if (nb > mp->m_sb.sb_dblocks) {
+		delta = nb - mp->m_sb.sb_dblocks;
+		extend = true;
+	} else {
+		delta = mp->m_sb.sb_dblocks - nb;
+		extend = false;
+	}
+
 	oagcount = mp->m_sb.sb_agcount;
 
 	/* allocate the new per-ag structures */
@@ -67,51 +121,34 @@ xfs_growfs_data_private(
 		error = xfs_initialize_perag(mp, nagcount, &nagimax);
 		if (error)
 			return error;
+	} else if (nagcount != oagcount) {
+		/* TODO: shrinking a whole AG hasn't yet implemented */
+		return -EINVAL;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
-			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
+			(extend ? XFS_GROWFS_SPACE_RES(mp) : delta), 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
-	/*
-	 * Write new AG headers to disk. Non-transactional, but need to be
-	 * written and completed prior to the growfs transaction being logged.
-	 * To do this, we use a delayed write buffer list and wait for
-	 * submission and IO completion of the list as a whole. This allows the
-	 * IO subsystem to merge all the AG headers in a single AG into a single
-	 * IO and hide most of the latency of the IO from us.
-	 *
-	 * This also means that if we get an error whilst building the buffer
-	 * list to write, we can cancel the entire list without having written
-	 * anything.
-	 */
-	INIT_LIST_HEAD(&id.buffer_list);
-	for (id.agno = nagcount - 1;
-	     id.agno >= oagcount;
-	     id.agno--, new -= id.agsize) {
-
-		if (id.agno == nagcount - 1)
-			id.agsize = nb -
-				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
-		else
-			id.agsize = mp->m_sb.sb_agblocks;
-
-		error = xfs_ag_init_headers(mp, &id);
-		if (error) {
-			xfs_buf_delwri_cancel(&id.buffer_list);
+	if (extend) {
+		error = xfs_resizefs_increase_ags(mp, &id, oagcount,
+						  nagcount, &delta);
+		if (error)
 			goto out_trans_cancel;
-		}
 	}
-	error = xfs_buf_delwri_submit(&id.buffer_list);
-	if (error)
-		goto out_trans_cancel;
-
 	xfs_trans_agblocks_delta(tp, id.nfree);
 
-	/* If there are new blocks in the old last AG, extend it. */
-	if (new) {
-		error = xfs_ag_extend_space(mp, tp, &id, new);
+	/* If there are some blocks in the last AG, resize it. */
+	if (delta) {
+		if (extend) {
+			error = xfs_ag_extend_space(mp, tp, &id, delta);
+		} else {
+			id.agno = nagcount - 1;
+			error = xfs_ag_shrink_space(mp, tp, &id, delta);
+		}
+
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -123,11 +160,19 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
+	if (nb != mp->m_sb.sb_dblocks)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
 				 nb - mp->m_sb.sb_dblocks);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+	/*
+	 * update in-core counters (especially sb_fdblocks) now
+	 * so xfs_validate_sb_write() can pass.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+		xfs_log_sb(tp);
+
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -143,7 +188,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (new) {
+	if (delta) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
@@ -164,6 +209,10 @@ xfs_growfs_data_private(
 	return error;
 
 out_trans_cancel:
+	if (extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
+		xfs_trans_commit(tp);
+		return error;
+	}
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c94e71f741b6..81b9c32f9bef 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -419,7 +419,6 @@ xfs_trans_mod_sb(
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-- 
2.18.1

