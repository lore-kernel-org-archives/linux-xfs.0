Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AAC22A80D
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425016; cv=none; b=mY5V4x0gnnQPRrJe1WEKl770tlNMTgM6hX1D2LepCS2+uEJKgDEXHEUMtbitu9eWro6GkN6kuDJG3fymTysnVnesYeRl0JSL59W9jdpIqThiiieD7TnibhEwkBC0dYLpasbcZfbiZZ//h0d/mYbbhnW1nLo/J+NhXHLDizIjYC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425016; c=relaxed/simple;
	bh=siIDiLtehUViXnj0y1OdjIDPToMf//VbtWKbirCKtaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3RhLrebV/F+Ge/tvER7Wp0O9xWk7zL9QRdrPVCXqLR4ggzsqCzpZQd7xvUW8gckFyRMbmrBG7Ti1W/IPTRRcOIzib6gfyLPFjq6NJf37WZjYAKZtnUz/w2D0B0O7fFHf1SFAW3cfpr2677eCmZxrcCdYrumj/gtH6gQrf/QGkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTdZg9fK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYVK0F6X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTdZg9fK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYVK0F6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
	b=FTdZg9fKesHIm4k9P2wabDLSTe0GnwTkOo4tEXeszbTDkiaxddYTqXVNJGavoTj+VKbuie
	tzGGsKupdWsaq4wIa9QMVmzgJbmXnLgutOMv4H9ODjEEeVWDKzHk22OcOLTK3VTIHmeGpJ
	iBnRABWGyuZhgfQbsf/RZ4eeFsEIep8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-hcb-k2ReM5W6w3Y62O71PQ-1; Mon, 14 Sep 2026 18:30:11 -0400
X-MC-Unique: hcb-k2ReM5W6w3Y62O71PQ-1
X-Mimecast-MFC-AGG-ID: hcb-k2ReM5W6w3Y62O71PQ_1789425011
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-530256c61b4so79996691cf.3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425011; x=1790029811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
        b=GYVK0F6Xgtpah0+bWsuNCXicjyuJ4vFHHWS83pMU9pSntQdUrYS3rGUUrCv0DHKytr
         QKTxPfcFr0/5WSKJ5XO+nM8BekiHEbMY2z9s7ugirkWKh7aKnloFSmVd/rfU25Lk1btr
         REcFnZmu8xrjjLB/yJsN2enbde/yHPyf9S+ptuolyeuevSTVi0eCT9JENyOmfW0rrK5w
         AnFKV26HWELj3CYA7AUttlA72xyuGsIkClVcZ38RdMb1h7HTVMxDSq6GwyV4VXlR2yNw
         W6Yzqzbfm6cA5yPocslyASP2XerXVeLqI8dzVLiBcKq6BmyEnIxTWgEV0+mzj3q/kXGw
         YqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425011; x=1790029811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ru5e1lRl9m4tTPmIdTlQ205KdS8MxoV2jZJ0mGACtj4=;
        b=lTU/tthcgHfsib9Du3z+Yjq48/ts4KS+4feSQxNaEckQm7m3tAMgDQz20HBwRYNZcG
         Qh5P6uvcUPDaCBh/m7TXmaK+tsZRO097cr4QOKEHZyJODUXkec3UBiI20z24UIb8C9DP
         zKo1eRedaDeQV1eDeYhZCRQJs25jZBfDQ4agZc/EwDpPOG+UwygZ3hmmJ0u8tqJ0bcXX
         v2KYFQs3s5uduTMCWenzNH4o87p82Obfe8LXNuTbzv2ojOenbe7KK6WH4e4nwEELMSLm
         T5gIhK8o1K2z13efrnzHpQLJn6aXlpxhH6Iupi5HrvfBNSBcyOf0As3ik/IxiCmIemSF
         ZvTg==
X-Gm-Message-State: AFuF++m7/fyKBNMZ/UEbbL6nMtQH27zWWqFU/wezjyCjjPJBiE3UgwPf
	RYoSMudvq0hDDMAmA3xBNvGPhfye2c++LoGKkAirxJr6CFb2pnvp8cO0TdVzDdJSr4fv/g0NOkJ
	7b55G6/+saMbOBxz5aWohaej97f6g1+E1KgERdLGidwCaDhzpyE0Wo9/hCpeNIIVA2cJpiFVwsy
	avPBcPdxqe3zcTnoqodZIKjINTgWqCiU1XmQObB9YgXnwp8JM=
X-Gm-Gg: AYBFou1oXnIeCbC/z0okjib5nkyym3kVG+l+vT3Lt2+5uRpUj0KdsokSnbnn4heV1iq
	LueLWp7cRng6Xucjhdf6rO6c4BoKWAt2QffFZoRORQUpigNH1DJX+1kf88csBgv2pEao5aYrwT5
	u2LbMgPDApGtKA1r1uw25S6e5DUtCQ1nmdWGXSnxlo9f2OUezAZOvVuOiTR5o1oic/yXlMdH3UP
	b9dsqNWiOteeHprnEVPxIpHq0D4FT5VWZIUbaBtdaJvmen2+y7HTSR2jZyA7Q+ALDlemjrsuhTt
	beJNkw7GTJ+x9pfrR+NCYNKTB6gOVeq1dLXb5ga3I7yVmjqUmJfzz+PTlRDWVVd4h5inTgXYSO9
	NmwbfmfN5SBoKQbOKmMqZIZxMdVVkEGM7G8MsOg==
X-Received: by 2002:a05:622a:5143:b0:52e:f66:f1a4 with SMTP id d75a77b69052e-5310cff8e49mr72081231cf.38.1789425011223;
        Mon, 14 Sep 2026 15:30:11 -0700 (PDT)
X-Received: by 2002:a05:622a:5143:b0:52e:f66:f1a4 with SMTP id d75a77b69052e-5310cff8e49mr72080411cf.38.1789425010610;
        Mon, 14 Sep 2026 15:30:10 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 01/14] xfs: remove unused args argument from xfs_attr_node_lookup()
Date: Mon, 14 Sep 2026 17:28:47 -0500
Message-ID: <20260914223007.1587017-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b3f7b2c34ad7..8fb3adc3dd2d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -59,8 +59,7 @@ STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 static int xfs_attr_node_try_addname(struct xfs_attr_intent *attr);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_intent *attr);
 STATIC int xfs_attr_node_remove_attr(struct xfs_attr_intent *attr);
-STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
-		struct xfs_da_state *state);
+STATIC int xfs_attr_node_lookup(struct xfs_da_state *state);
 
 int
 xfs_inode_hasattr(
@@ -709,7 +708,7 @@ int xfs_attr_node_removename_setup(
 	int				error;
 
 	xfs_attr_item_init_da_state(attr);
-	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
+	error = xfs_attr_node_lookup(attr->xattri_da_state);
 	if (error != -EEXIST)
 		goto out;
 	error = 0;
@@ -985,7 +984,7 @@ xfs_attr_lookup(
 	}
 
 	state = xfs_da_state_alloc(args);
-	error = xfs_attr_node_lookup(args, state);
+	error = xfs_attr_node_lookup(state);
 	xfs_da_state_free(state);
 	return error;
 }
@@ -1386,7 +1385,6 @@ xfs_attr_leaf_get(
 /* Return EEXIST if attr is found, or ENOATTR if not. */
 STATIC int
 xfs_attr_node_lookup(
-	struct xfs_da_args	*args,
 	struct xfs_da_state	*state)
 {
 	int			retval, error;
@@ -1417,7 +1415,7 @@ xfs_attr_node_addname_find_attr(
 	 * to where it should go.
 	 */
 	xfs_attr_item_init_da_state(attr);
-	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
+	error = xfs_attr_node_lookup(attr->xattri_da_state);
 	switch (error) {
 	case -ENOATTR:
 		if (args->op_flags & XFS_DA_OP_REPLACE)
@@ -1588,7 +1586,7 @@ xfs_attr_node_get(
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	state = xfs_da_state_alloc(args);
-	error = xfs_attr_node_lookup(args, state);
+	error = xfs_attr_node_lookup(state);
 	if (error != -EEXIST)
 		goto out_release;
 
-- 
2.55.0

