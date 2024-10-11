Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54501A23
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607155; cv=none; b=JCECDrwby3yx1P256Kr189pnONh7oWrnIjEon/24/XmnLCoIRw/7q2hT2oonBy4zCbK91SG8ZQT17jWdiYDfvWAMBCrRenG/HgGJywJGuRI6fYKNS5ID+Td0QJO7eerrscFj+b6QKVmNWRdF4sErNGQRMWI/4Y16DuY7oc9CYQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607155; c=relaxed/simple;
	bh=XQpwjwbrUQE7yMTTfhGQZHyWtElP2OqjkBUmgEUpxso=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5/7EXX6NG7GUEp+ODUKkjVRZ/gkXs3Ul32wjZgfrr47JmsyLqSohc85n7+FJXHl6+UbOfvl+7Gbe8mDIiwo/B95MLdGEhoWgEAdcwSs54LaJ+hi7EFniPg2Nc4+162tEy03cIyC9eHoziQ5jYZ3uHQ5LpWgTRxoQoGbIHIb+ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1uUFwhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1uUFwhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D778C4CEC5;
	Fri, 11 Oct 2024 00:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607155;
	bh=XQpwjwbrUQE7yMTTfhGQZHyWtElP2OqjkBUmgEUpxso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l1uUFwhRsSKx6g22j4BWX9S4LbDlbd0aFIxUerJu+Io7yWJyQAzO0l93t53kmRgnc
	 jDwuum33BP3l5Z2Km+cXkEvqtgvkEB72G7ADY9sO9x4PggcLqQfRTNzkhwRtVWCXs/
	 oOrVMHdOz6Oa46AyWx/Ci/6xtOoLjpQ+wqp1kz+tJ7lRRWvkTmzqxivGnZT2BxOrvf
	 n7aPN1C5ZCiMn0g4sWBVFMjiZF4+8pwm1oejRyuiAi2UZBSjuNH89y4Z5cHjlTHuq9
	 vhcUqaT2+tOLMkzPgDuOpxPqWsdKBKDU00oCnm+SXmmsSG4Lz7Ingys9JYHUhtmo7W
	 /MNuSquoBrpQg==
Date: Thu, 10 Oct 2024 17:39:14 -0700
Subject: [PATCH 06/25] xfs: remove the unused pag_active_wq field in struct
 xfs_perag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640511.4175438.6868143047350054306.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
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

pag_active_wq is only woken, but never waited for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 +---
 fs/xfs/libxfs/xfs_ag.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e5efa7df623d65..1c478a5c43b72d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -107,8 +107,7 @@ xfs_perag_rele(
 	struct xfs_perag	*pag)
 {
 	trace_xfs_perag_rele(pag, _RET_IP_);
-	if (atomic_dec_and_test(&pag->pag_active_ref))
-		wake_up(&pag->pag_active_wq);
+	atomic_dec(&pag->pag_active_ref);
 }
 
 /*
@@ -312,7 +311,6 @@ xfs_initialize_perag(
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		xfs_defer_drain_init(&pag->pag_intents_drain);
 		init_waitqueue_head(&pag->pagb_wait);
-		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_tree = RB_ROOT;
 		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 93d7dbb11c2cb0..d0991ae0aa77ef 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -34,7 +34,6 @@ struct xfs_perag {
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* passive reference count */
 	atomic_t	pag_active_ref;	/* active reference count */
-	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	unsigned long	pag_opstate;
 	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
 	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */

