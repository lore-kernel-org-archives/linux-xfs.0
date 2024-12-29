Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1BB157E99
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479604; cv=none; b=fD/jeqCgC1V5J89vSQS9+p6MLcnqYt4k6O4g9moaux+oAIiySu05N6+ZcOAfaLlJE6Lx1/dQ/Qfg5ErWQtmbcabM2Q4YG+e/azGPTyjFInAjmMrGAs/3l9jETzxCxxTaXk5hlkYfq+fo7ZiZnJlrjEeFz3jp4AtnRvJZxj0WXtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479604; c=relaxed/simple;
	bh=mL6BYOb9iVJUkzRLLHSVvoCKeUjA4pvkrdDQ5LOTecQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDRDaguQD95rOyGGTO3Zk+Q5LR6/WqG3Cvrm0mxOQKqUn9QFSi/aaOxeIeN2lXnV4NluMHcLuFNekdxqNyM8RhI/aYIVMwU4OFhreRto6pQbk2iT6snXsBG89zKFbvR7ArRI62gaJxi2+4Tp1zXA6kNhRZi1hqxbQU7Vlbb7UUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdvfNroZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdvfNroZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fbfZtBhFstrJOsIWM9Coj0Xnd2Pgk7XzR+tJsEUgMS8=;
	b=YdvfNroZKT42/jMeorVHS7v4TE38Bq77mCgZ7BRk3dYfFeGp/9cQOpLgC4ysUhqq1wq8GU
	qUnXUlQShaY4b12L61os0KCmFTHRb29ammtFULtSEQQ/K7ZpUKWAmnsjq5GgEkAi06TnpN
	KRVpZ6PHiux5PCGu5Fm3npxqTBBcrYU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-heJOcLq9OE-Zqqyh__x7Yw-1; Sun, 29 Dec 2024 08:40:01 -0500
X-MC-Unique: heJOcLq9OE-Zqqyh__x7Yw-1
X-Mimecast-MFC-AGG-ID: heJOcLq9OE-Zqqyh__x7Yw
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3cef3ed56so6378833a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479599; x=1736084399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fbfZtBhFstrJOsIWM9Coj0Xnd2Pgk7XzR+tJsEUgMS8=;
        b=qrpUbQaCZ8eoWFjf0q15/MBB3y9AR/Tw9rHdyqhV+Q29sWlAmOp3jUnb/FgW5jYX4c
         D/ol3KF1MWUna9nKk9pkGy1IqLy3DeOv3y1DeQ4oyWSffthfp3dKH5Ojc66opIUWQ71B
         o2bXy1D8zoF3USsD7oYoKGuDUAInmRvCzuh4mWxYvMEX4L+pASJnkg8/2DuvmthOAMIw
         dQFrO7c5FneKRdXgsGSW1YdLRmZ7V82+pGa4x/I84tLbMj4gIIPc/8wYFVynpGgvTHzi
         UnDTnpULbAsSEtDapJWOa+95plDGAGju1QyI3SJ3OR9449BliqsnY3fy1k8yxTYWDMCh
         F+xw==
X-Gm-Message-State: AOJu0YxdN8l91k1662HoVnxj+foc67uE8ATPiJiecJH3xy0Bf5Wp9K/a
	mNVeZYprJlzfbwKSdHmAaKxGR8xHhfDyqYZibbFKIJcfknt2KVtgHdJhpAAToWX/nF1aSNhqWrj
	kcmVkC/nEcRd6oKXGsnxgr8sCi1r+fRivawwbKW92Tn7/C8yH0n+Gdq7dahJMmZjuvAWpDYGTp/
	CXOmVwKAXOMH5TYP5E/3D5i/PU1B3w3vMs/xrSyan5
X-Gm-Gg: ASbGnct0ilr2ukhbHKC7xBDSLgw/jleQL5LjCC2GeU/wWET9tGLeFnKTe42xIHHwhRh
	9jZ5+aShwJ4QYvH7Dt0S1TiHv1SpP9ZUkG+Ib7Rk7kGLO09cF43U4e2esvgdXEOkpHVLzrHyk1B
	LxKzJ2+XXSXNc3kGku5bUcBYkB72xXpX1J7Ek9vWomJsbJstdbVGGisfgybagL6GEug9RqKZQ5f
	ZqeaL8VQCwZz+5rRFyetpzJwxtDfFxYAkCwfILBlcvJ7e/Dm/7JzzBsbTYtvSD3yTHiG1wrcXKU
	Y4kaAX3zQ7aIhgQ=
X-Received: by 2002:a05:6402:210a:b0:5d0:81af:4a43 with SMTP id 4fb4d7f45d1cf-5d81dc797b5mr26119239a12.0.1735479598742;
        Sun, 29 Dec 2024 05:39:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFAd2c3Tuf/USZ3PhNWqa5OfWKOEIf3A/R+h++d/6gJ9DEQPd+56BVel1TgJzir5EEkPBmdHQ==
X-Received: by 2002:a05:6402:210a:b0:5d0:81af:4a43 with SMTP id 4fb4d7f45d1cf-5d81dc797b5mr26119214a12.0.1735479598427;
        Sun, 29 Dec 2024 05:39:58 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 09/24] xfs: use an empty transaction to protect xfs_attr_get from deadlocks
Date: Sun, 29 Dec 2024 14:39:12 +0100
Message-ID: <20241229133927.1194609-10-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Wrap the xfs_attr_get_ilocked call in xfs_attr_get with an empty
transaction so that we cannot livelock the kernel if someone injects a
loop into the attr structure or the attr fork bmbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e452ca55241f..3f3699e9c203 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -274,6 +274,8 @@ xfs_attr_get(
 
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
+	ASSERT(!args->trans);
+
 	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
@@ -286,8 +288,14 @@ xfs_attr_get(
 	/* Entirely possible to look up a name which doesn't exist */
 	args->op_flags = XFS_DA_OP_OKNOENT;
 
+	error = xfs_trans_alloc_empty(args->dp->i_mount, &args->trans);
+	if (error)
+		return error;
+
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
 	error = xfs_attr_get_ilocked(args);
+	xfs_trans_cancel(args->trans);
+	args->trans = NULL;
 	xfs_iunlock(args->dp, lock_mode);
 
 	return error;
-- 
2.47.0

