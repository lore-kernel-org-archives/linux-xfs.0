Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C31DED65
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393158; cv=none; b=PWwCFjT2rLanww4QNBBod/MomQXb3pjxxYb8mb9xLc8M3kumIxcYoij/8749yJnJF6MDCdx1m8qkVMATBYYYJG+xlo1ESUpVjYJGSQjizPu0qwHW3DIm5jrS8DfIeZOvt7wbZlWRegPpvRNzTPyKLQtwGP3QGoQImrWcVww1GpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393158; c=relaxed/simple;
	bh=hUeN7W92QOM2EraopMPkibTQIShuHhxsbs8KiRFPiao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyeTJsATLsHTuT/Dppc5GztcUcn66vFH+kyZjCctcaB8S2y32jBxyynC15bYPpV0yNb8dA7dFXqU4D7RKjZ+UbD1vk4yDqiDMxF8whIHpMm0gn3KsAfIWGBpzkAYQSe9RxTY79ZCTz1X4PCOFHzasa2bpZFyw7uPdEetk2i7GUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5GiDe2M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5GiDe2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sf6PcHqbetRJQw90eD6WUXuq14rI51/uERSOmCHGjqY=;
	b=g5GiDe2MT9mizTKNECrX9tCHjiTLsp4+seT83mLAE+rmcGqkPvW5DRPqodkkH0QEfuu1uT
	fCMHis5wfUqnfMOyjMiq6uHr71m6WdMSbMve+got6i8cDQhQ9o2xTjHl5UWuHxuIvxIOqx
	lYIBmaFu618ZFd4RNeLb1/SNRIkllH4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-x0YtL9jAOHmBTaNw_yhMDw-1; Tue,
 08 Oct 2024 09:12:35 -0400
X-MC-Unique: x0YtL9jAOHmBTaNw_yhMDw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 076821955D4C;
	Tue,  8 Oct 2024 13:12:34 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 296BB19560AA;
	Tue,  8 Oct 2024 13:12:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFC 2/4] xfs: transaction support for sb_agblocks updates
Date: Tue,  8 Oct 2024 09:13:46 -0400
Message-ID: <20241008131348.81013-3-bfoster@redhat.com>
In-Reply-To: <20241008131348.81013-1-bfoster@redhat.com>
References: <20241008131348.81013-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Support transactional changes to superblock agblocks and related
fields.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_trans.c         | 15 +++++++++++++++
 fs/xfs/xfs_trans.h         |  1 +
 3 files changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 33b84a3a83ff..b8e80827a010 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -157,6 +157,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define	XFS_TRANS_SB_AGBLOCKS		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bdf3704dc301..34a9896ec398 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -433,6 +433,9 @@ xfs_trans_mod_sb(
 	case XFS_TRANS_SB_DBLOCKS:
 		tp->t_dblocks_delta += delta;
 		break;
+	case XFS_TRANS_SB_AGBLOCKS:
+		tp->t_agblocks_delta += delta;
+		break;
 	case XFS_TRANS_SB_AGCOUNT:
 		ASSERT(delta > 0);
 		tp->t_agcount_delta += delta;
@@ -526,6 +529,16 @@ xfs_trans_apply_sb_deltas(
 		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
 		whole = 1;
 	}
+	if (tp->t_agblocks_delta) {
+		xfs_agblock_t		agblocks;
+
+		agblocks = be32_to_cpu(sbp->sb_agblocks);
+		agblocks += tp->t_agblocks_delta;
+
+		sbp->sb_agblocks = cpu_to_be32(agblocks);
+		sbp->sb_agblklog = ilog2(roundup_pow_of_two(agblocks));
+		whole = 1;
+	}
 	if (tp->t_agcount_delta) {
 		be32_add_cpu(&sbp->sb_agcount, tp->t_agcount_delta);
 		whole = 1;
@@ -657,6 +670,8 @@ xfs_trans_unreserve_and_mod_sb(
 	 * incore reservations.
 	 */
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agblocks += tp->t_agblocks_delta;
+	mp->m_sb.sb_agblklog = ilog2(roundup_pow_of_two(mp->m_sb.sb_agblocks));
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
 	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f06cc0f41665..11462406988d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -141,6 +141,7 @@ typedef struct xfs_trans {
 	int64_t			t_frextents_delta;/* superblock freextents chg*/
 	int64_t			t_res_frextents_delta; /* on-disk only chg */
 	int64_t			t_dblocks_delta;/* superblock dblocks change */
+	int64_t			t_agblocks_delta;/* superblock agblocks change */
 	int64_t			t_agcount_delta;/* superblock agcount change */
 	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
 	int64_t			t_rextsize_delta;/* superblock rextsize chg */
-- 
2.46.2

