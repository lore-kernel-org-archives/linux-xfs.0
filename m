Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF941DE4CD
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393158; cv=none; b=FTXeF3hXu5E6qNv/LoKIxQU+4+bDoWEc8A0JU4vy41ptszVi8mQcb/rAL4QGZMGye8RtcGW/3rPIZgYcuVeZPFjWdBXHSyjUetKH+wRU8j7QDR+93Udex+S/aaXQ9mbJ2k5scXuoC25AK9ZLfTTKhEdKBcGjdwMO1Z3Xbn3ty2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393158; c=relaxed/simple;
	bh=DxfnP8Tq2FkudB8MQ1drux/s/hk/PCoB3cj3ooceqzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bZK78y04vZkCkUbp8WXZVQ/xi+vwNT78P2WyHF3JiMRMX1rlaondgwr8NxiQuL+4nXN1bjRbq90XL5jKRbrwAcho4YQER2C6uKBSGCrYYGMMljr5x/JNQL36E8BEX5fXBrNacW1aRq16hbO09/d9n+yPAQpX04BpQ7ZcmG06rdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rf0xZthe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rf0xZthe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728393155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2UyOa3sW+L7ha2VZPRbst6MP4MQB/o5VXQ+lhWLrAA=;
	b=Rf0xZtheiSgDhN3uQ6J6OBpvZk2tbOvkqIwneVvbzLsd9uC6kKAJzzvBS5Dn8AEsj/TKkz
	dhRK3fx2ZgM0WaQ+lQfXKWJHKupJR87fPZL1Ri4s/iGMxuWT9LRKlvlHTmA1gNXOdWuuai
	z4iJdXggv3JiORY9ZbH5IihnqkpBt0o=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-ClAS8xtJO0S3R0OzvLalsA-1; Tue,
 08 Oct 2024 09:12:33 -0400
X-MC-Unique: ClAS8xtJO0S3R0OzvLalsA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D72F21955D9D;
	Tue,  8 Oct 2024 13:12:32 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 12C7F1956054;
	Tue,  8 Oct 2024 13:12:31 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	sandeen@sandeen.net
Subject: [RFC 1/4] xfs: factor out sb_agblocks usage in growfs
Date: Tue,  8 Oct 2024 09:13:45 -0400
Message-ID: <20241008131348.81013-2-bfoster@redhat.com>
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

Factor out usage of sb_agblocks in the growfs path. This is in
preparation to support growing AG size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fsops.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3643cc843f62..6401424303c5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -38,6 +38,7 @@ static int
 xfs_resizefs_init_new_ags(
 	struct xfs_trans	*tp,
 	struct aghdr_init_data	*id,
+	xfs_agblock_t		agblocks,
 	xfs_agnumber_t		oagcount,
 	xfs_agnumber_t		nagcount,
 	xfs_rfsblock_t		delta,
@@ -57,9 +58,9 @@ xfs_resizefs_init_new_ags(
 
 		if (id->agno == nagcount - 1)
 			id->agsize = nb - (id->agno *
-					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
+					(xfs_rfsblock_t)agblocks);
 		else
-			id->agsize = mp->m_sb.sb_agblocks;
+			id->agsize = agblocks;
 
 		error = xfs_ag_init_headers(mp, id);
 		if (error) {
@@ -89,6 +90,7 @@ xfs_growfs_data_private(
 {
 	struct xfs_buf		*bp;
 	int			error;
+	xfs_agblock_t		nagblocks;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
@@ -113,16 +115,18 @@ xfs_growfs_data_private(
 		xfs_buf_relse(bp);
 	}
 
+	nagblocks = mp->m_sb.sb_agblocks;
+
 	nb_div = nb;
-	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	nb_mod = do_div(nb_div, nagblocks);
 	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
 		nb_div++;
 	else if (nb_mod)
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		nb = nb_div * nagblocks;
 
 	if (nb_div > XFS_MAX_AGNUMBER + 1) {
 		nb_div = XFS_MAX_AGNUMBER + 1;
-		nb = nb_div * mp->m_sb.sb_agblocks;
+		nb = nb_div * nagblocks;
 	}
 	nagcount = nb_div;
 	delta = nb - mp->m_sb.sb_dblocks;
@@ -161,8 +165,8 @@ xfs_growfs_data_private(
 
 	last_pag = xfs_perag_get(mp, oagcount - 1);
 	if (delta > 0) {
-		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
-				delta, last_pag, &lastag_extended);
+		error = xfs_resizefs_init_new_ags(tp, &id, nagblocks, oagcount,
+				nagcount, delta, last_pag, &lastag_extended);
 	} else {
 		xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SHRINK,
 	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
-- 
2.46.2

