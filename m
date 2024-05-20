Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEFE7C6C6
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223606; cv=none; b=ZvkzhI2Y4eth1RgE76HClQZLN05EwAJy48RcTumTM7chuxpyeEkz4icZNVrW0cieTCuk0lrsLzn7YY1TwGtKTGhTVeF/283SkDV3aLqH5RlD4sKSPrdZ4WD6125Ntm8jRku6o2sGemDmEPgLVQcu/dmq7Yxh5UvK4OEpCUIn9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223606; c=relaxed/simple;
	bh=ugfIve/MBoJ8lNXTtpo8ReL0nr2qmk5vFiPzMIYkrC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcnzLs3GJgDAwTt/Tc7z6cn/sl0fvSOV8bmTulqjRyuv4c9vE3W4JAElUc4bqBeq+J2vO8S53gtuFMMKJgduqicmkz6/Wv+AadEgMLWsa9NLvg7fZRFhuGuWsN0DF5zSyMUhrCI/5xPAZo5UN0TItxOH68pZK+QuPj7MzAFPi8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JRDvbVFm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JRDvbVFm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716223603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=30mOQiH4aadYmFiJ3Era8Nm22mVGbDn077f7QuA+8e4=;
	b=JRDvbVFmZDKUIviWuiPH2nzsf3WmhHitnFp/sZNDaBruk9MP+5R2KDZ8p+cTZ+OSi7FlV8
	iQCfcA3Fu3IF5ZRsOJspLMoVFvU2jP/iOc6+X/Gwk0gnG8FQoqr54ZO30k+/cjhIrbcRDJ
	7Yy91STpsnsJcJq6f7cxORVCnWzxAjs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-Pp012shrNFiRD9OrDXOojg-1; Mon, 20 May 2024 12:46:42 -0400
X-MC-Unique: Pp012shrNFiRD9OrDXOojg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5732229087bso4172237a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 09:46:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716223601; x=1716828401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30mOQiH4aadYmFiJ3Era8Nm22mVGbDn077f7QuA+8e4=;
        b=TynHWAYWgNc+63KHFO5yov3BVdMBZxokx7k1/J5Ps/AGJ8I0tBeqJkYuJcHCWcRWrG
         o/a9Tm8Udj6nPVYmoSanM+hAnNiZ4ItoRQxOkj52hIoiS07kiYeMTqdQBcNES1/RXc5g
         5hu+ah04HB4iTD6SqHckgjEy0osO9AXqSnwdlfzpoIN3FEAEYr5nuCEDcU6KV94rpSv0
         nJtBGawVKkH4s3FESVDRmxfP/l7KzIoZ2cAC8AcoGGpo71bnREf6n+eBjUGYLi6DTefI
         Fu+Dd6xmMeGHhrOhwtBYckJ3aIAOkJ4d+qlDMCHhB+nfJkGc6hbUIREVF39T5Q2PXpSG
         vuqg==
X-Forwarded-Encrypted: i=1; AJvYcCU3iivkMejxWWpxs0gJRcNBdrdQ791Yk5gipzbdgvoVC3LmAutMHnxFWFRwtZ6sUj8GlUnGafo8+tiPAEjGwLTvi6cclrbe8wnI
X-Gm-Message-State: AOJu0YwnAGB4flY0DayJzNutH76wCkv8jlriP+65VCXLqcp+Moi2/2c0
	OyEzJAzu1ru6coXqteUm5Fw1da8JDKKi078PVvkgf9rn/njIRljt+h4UXXAukzqHT9J7bH7hlmR
	ml12bjaJ9iySH7Z6AlYZgDBM008fnI8c1HPsVdM4yr0PQQONV4OLbqiTn
X-Received: by 2002:a17:906:528b:b0:a59:cf0a:4e4d with SMTP id a640c23a62f3a-a5a2d55a730mr1978883566b.12.1716223600817;
        Mon, 20 May 2024 09:46:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzQqgrZX3g47bHdERLya0zMK+/mL6vVJ64It+2IF6hpe95OUqWP3EskbV2iavRJuetYubLpA==
X-Received: by 2002:a17:906:528b:b0:a59:cf0a:4e4d with SMTP id a640c23a62f3a-a5a2d55a730mr1978882066b.12.1716223600208;
        Mon, 20 May 2024 09:46:40 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm318872066b.159.2024.05.20.09.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 09:46:39 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2 1/4] xfs: allow renames of project-less inodes
Date: Mon, 20 May 2024 18:46:20 +0200
Message-ID: <20240520164624.665269-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240520164624.665269-2-aalbersh@redhat.com>
References: <20240520164624.665269-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Identical problem as worked around in commit e23d7e82b707 ("xfs:
allow cross-linking special files without project quota") exists
with renames. Renaming special file without project ID is not
possible inside PROJINHERIT directory.

Special files inodes can not have project ID set from userspace and
are skipped during initial project setup. Those inodes are left
project-less in the project directory. New inodes created after
project initialization do have an ID. Creating hard links or
renaming those project-less inodes then fails on different ID check.

Add workaround to allow renames of special files without project ID.
Also, move it into the helper.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_inode.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 58fb7a5062e1..63f8814a3d16 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1297,6 +1297,35 @@ xfs_create_tmpfile(
 	return error;
 }
 
+static inline int
+xfs_projid_differ(
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip)
+{
+	/*
+	 * If we are using project inheritance, we only allow hard link/renames
+	 * creation in our tree when the project IDs are the same; else
+	 * the tree quota mechanism could be circumvented.
+	 */
+	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+		     tdp->i_projid != sip->i_projid)) {
+		/*
+		 * Project quota setup skips special files which can
+		 * leave inodes in a PROJINHERIT directory without a
+		 * project ID set. We need to allow links to be made
+		 * to these "project-less" inodes because userspace
+		 * expects them to succeed after project ID setup,
+		 * but everything else should be rejected.
+		 */
+		if (!special_file(VFS_I(sip)->i_mode) ||
+		    sip->i_projid != 0) {
+			return -EXDEV;
+		}
+	}
+
+	return 0;
+}
+
 int
 xfs_link(
 	struct xfs_inode	*tdp,
@@ -1346,27 +1375,9 @@ xfs_link(
 		goto error_return;
 	}
 
-	/*
-	 * If we are using project inheritance, we only allow hard link
-	 * creation in our tree when the project IDs are the same; else
-	 * the tree quota mechanism could be circumvented.
-	 */
-	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-		     tdp->i_projid != sip->i_projid)) {
-		/*
-		 * Project quota setup skips special files which can
-		 * leave inodes in a PROJINHERIT directory without a
-		 * project ID set. We need to allow links to be made
-		 * to these "project-less" inodes because userspace
-		 * expects them to succeed after project ID setup,
-		 * but everything else should be rejected.
-		 */
-		if (!special_file(VFS_I(sip)->i_mode) ||
-		    sip->i_projid != 0) {
-			error = -EXDEV;
-			goto error_return;
-		}
-	}
+	error = xfs_projid_differ(tdp, sip);
+	if (error)
+		goto error_return;
 
 	if (!resblks) {
 		error = xfs_dir_canenter(tp, tdp, target_name);
@@ -3268,16 +3279,9 @@ xfs_rename(
 	if (wip)
 		xfs_trans_ijoin(tp, wip, 0);
 
-	/*
-	 * If we are using project inheritance, we only allow renames
-	 * into our tree when the project IDs are the same; else the
-	 * tree quota mechanism would be circumvented.
-	 */
-	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-		     target_dp->i_projid != src_ip->i_projid)) {
-		error = -EXDEV;
+	error = xfs_projid_differ(target_dp, src_ip);
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
-- 
2.42.0

