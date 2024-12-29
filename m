Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BF317B50A
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479549; cv=none; b=Guo4fNPr7m4LvqvYxUpDvwxi0njreslL2fR1lDZCEhFKD80/FaTnqeJZppDaP8IVOs+XZoJoRiEzFegemtBtuEdDlMNhk/up4mVjadlXMnr223aPVjSvno7rLvUK1PKqzWQCDib9XMVwnCjFkrNWy/e0GgXrylJmsdOsgzuSRAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479549; c=relaxed/simple;
	bh=84rmwROxFNCB27hZX7A0P/DgwqtM6C41teUViZL4UAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA8R5LnL2CwMT1NuN2ZBXwUyJURrWidNwuUcAeXUn2EqfR2VDrw6JEhD5ZjE/gXyj3VkyO/y+CBVq/R9vgHQ8u10+Pv8J4GUQLtWnYD9/TRtidlsFPVqsPiJHdlR0ztkNtucwiV9t/yGILO/1JTf6zRwEMR3ZuxZSFpYQZUJ66Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWlFOVOT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWlFOVOT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ewOKMuYK43WJG2ALaY5n3pXvxddbNuZFCxaX4PT5PsA=;
	b=DWlFOVOT6dSlk7OUQnxVgzczEM5tXM0M7w6v/EZvNQ4Hn+59AEzVdzqPrd/ovyks9HHk8f
	0JXZN+DmNgUxdl5voG3gKJgGuK8eYUrtb0+KIQX+RqF6LL8mWukJVKRJg3wac4j6/I0Mrv
	Gzh/gFrnHz84C8wfcAxRQGEVg551rac=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-CYNybj1fMdeZNZqT5GEs0w-1; Sun, 29 Dec 2024 08:39:04 -0500
X-MC-Unique: CYNybj1fMdeZNZqT5GEs0w-1
X-Mimecast-MFC-AGG-ID: CYNybj1fMdeZNZqT5GEs0w
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385d52591d6so4009139f8f.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479543; x=1736084343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ewOKMuYK43WJG2ALaY5n3pXvxddbNuZFCxaX4PT5PsA=;
        b=rVkXIrZTIqMYyytfYjVzKPoiVfezqZKkT7V4IRheGUtC5Jn6irDNvRZ5yZPUfXhVgu
         +WRlOBaedwExYbZ8jZB3B7ElHH4l2DHoxEqVkMLje3klBa8Ndiez4K3j/2q8VwfzWD1r
         vAe/9TYyxhapIzMt2yyc2pyW3QuBwZSS4CBLSF5cUHzwewBBzzCkrAFhWU1/w20RfmBc
         KTavMrPQvc9lq7p47PTxiNMjVBXCkThBS9/9iKSQfq3WCzOtKXK/9HJSORAY3pnz9NkW
         +5VDotXu4oEFwQukWvHiFTgIzNfrk/OBiByq038XcimdGx+ac/3+o6o0/ifBCrnDv+y7
         9e0A==
X-Gm-Message-State: AOJu0Yz8A5+cXKxiCTqFHVRNXk42eH2rhFXOGH0FxcuTGqbAWBoTQYU3
	PBq43cdloPrNvE3ukVl79wlxQG6pD+Ad6+GQSuN+ZURCq20wCf27SzvaXohTF1CrWjwb0Q0Yn/A
	YakcwQzuAjupX7Yqy4MCZerhPlymdYJLJxqIgqzjVZXgMsvI86UyD4lWjVgT4CGa2S3DTq6vV/y
	OPcXUsVIlUkPiRoop8qBaEkVL9oj2ZO9jmnYx+YWl6
X-Gm-Gg: ASbGncsjIkbNDKcSaTF+0hGdf2NIBz3uRmIIkmQlr12GfDZrC2WbfvlvdmwUXkvoSyC
	GqVCTSirmqBlItrpAAEnqKU7I8cQGd4ae+7tyhV9mobU3DPv0BF+CjHg0xqUP/mh6ZN85y5yJAH
	Bpvznm3snCX06tPsf1sfDqPfc+b+iBBuv7vhGT8EvZk3adJOkfD+b2Jlc+eT2XOe/dss8njkd+k
	cqLCkBUSe03583WirJ/Enir+Fqi8bU0wdQjya1vgEmL/rCxm+u+pkCFS3qJhIRlYuWqO4EXCckv
	7mNq8P2xSZzHc/8=
X-Received: by 2002:a05:6000:1785:b0:385:e2b1:8fa with SMTP id ffacd0b85a97d-38a22a65256mr22353478f8f.30.1735479543057;
        Sun, 29 Dec 2024 05:39:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEm5DDYozxGhUMPYHO8RuhpKMMVMKCSWHaM9IC0inmAOFweYXzYwTqh+zNOy+uWW0YRkpIXww==
X-Received: by 2002:a05:6000:1785:b0:385:e2b1:8fa with SMTP id ffacd0b85a97d-38a22a65256mr22353460f8f.30.1735479542722;
        Sun, 29 Dec 2024 05:39:02 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:01 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 09/14] xfs: add interface to set CRC on leaf attributes
Date: Sun, 29 Dec 2024 14:38:31 +0100
Message-ID: <20241229133836.1194272-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With attributes' data passed through page cache we need to update
CRC when IO is complete. This function calculates CRC of newly
written data and swaps CRC with a new one (the old one is still in
there).

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 50 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  1 +
 fs/xfs/xfs_trace.h            |  1 +
 3 files changed, 52 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c657638efe04..409c91827b47 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -3035,3 +3035,53 @@ xfs_attr3_leaf_flipflags(
 
 	return 0;
 }
+
+/*
+ * Set CRC field of remote attribute
+ */
+int
+xfs_attr3_leaf_setcrc(
+	struct xfs_da_args			*args)
+{
+	struct xfs_attr_leafblock		*leaf;
+	struct xfs_attr_leaf_entry		*entry;
+	struct xfs_attr_leaf_name_remote	*name_rmt;
+	struct xfs_buf				*bp;
+	struct xfs_mount			*mp = args->dp->i_mount;
+	int					error;
+	unsigned int				whichcrc;
+	uint32_t				crc;
+
+	trace_xfs_attr_leaf_setcrc(args);
+
+	xfs_calc_cksum(args->value, args->valuelen, &crc);
+
+	/*
+	 * Set up the operation.
+	 */
+	error = xfs_attr3_leaf_read(args->trans, args->dp, args->owner,
+			args->blkno, &bp);
+	if (error)
+		return error;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+
+	whichcrc = (entry->flags & XFS_ATTR_RMCRC_SEL) == 0;
+	name_rmt = xfs_attr3_leaf_name_remote(&(mp->m_sb), leaf,
+					      args->index);
+	name_rmt->crc[whichcrc] = crc;
+	xfs_trans_log_buf(args->trans, bp,
+			XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
+
+	/* Flip the XFS_ATTR_RMCRC_SEL bit to point to the right/new CRC and
+	 * clear XFS_ATTR_INCOMPLETE bit as this is final point of directly
+	 * mapped attr data write flow */
+	entry->flags ^= XFS_ATTR_RMCRC_SEL;
+	entry->flags &= ~XFS_ATTR_INCOMPLETE;
+	xfs_trans_log_buf(args->trans, bp,
+			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 589f810eedc0..c8722c8accb0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -66,6 +66,7 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+int	xfs_attr3_leaf_setcrc(struct xfs_da_args *args);
 
 /*
  * Routines used for growing the Btree.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7b16cdd72e9d..5c3b8929179d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2189,6 +2189,7 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_to_node);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_rebalance);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_unbalance);
 DEFINE_ATTR_EVENT(xfs_attr_leaf_toosmall);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_setcrc);
 
 DEFINE_ATTR_EVENT(xfs_attr_node_addname);
 DEFINE_ATTR_EVENT(xfs_attr_node_get);
-- 
2.47.0

