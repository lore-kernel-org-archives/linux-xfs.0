Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4423FB38
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757223; cv=none; b=Di2uvEih7CjXauE1YVXE/JRvjrR+DBeBAdu9qjPGqrJlzz++VsehvLFxks0041YjMFBG583wfDW8Lb0oX+bsFB33lMGcfejbh2gvqH+WUp/ljrsjZ9yJcLpa6tdX0CFmdgJEyS8651JAgHVtSFRGaewc7trY7cmxWLHIBRsSBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757223; c=relaxed/simple;
	bh=5efDprULe6taPXbMIbssh9R9ZTvpV1+LRg5VBOs1ncI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pohK08IAHYIJkn2DqSfiKGebpp3dTyrBOOkYZN9CjumAcJii/+yyIM/8ppTUeRz7Gf4GCMR0yZRxGlka6343eHOZ+Np0ND38evRLMvPygJR7S1qlpN1Ov1mcxX/uVz4nTr8TDeFrwH/x0C0+ShSPHf/aOZjJ80oYNMw1JdSNK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ysb3ajjK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ysb3ajjK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JU0n6o39Qx9ylv78PJjsl41s62AUUJ55j4stQvjouKk=;
	b=Ysb3ajjKo3S+Iqnowizd6q9R1/Npbvaqw/82CFyPo68yjEQ1RulhGtnzQDyBWNhR070B6V
	BBoY+6BkK/fWD/5qEJuqK+FIzLD7B/uFVy+6WDrajp26xNhEKEZGQVAhWczpNNZk86ypu7
	WrV1dzy28BPhF1FNjhGP/xoakFsny7M=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-LgsQzD6jPuONEOOMpTgrxg-1; Mon, 12 Feb 2024 12:00:17 -0500
X-MC-Unique: LgsQzD6jPuONEOOMpTgrxg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-51151b8de86so3093976e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757216; x=1708362016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JU0n6o39Qx9ylv78PJjsl41s62AUUJ55j4stQvjouKk=;
        b=O/VXJFMzpUTlF+fTSTbaeO7beoqnQdLzb40vpTSUcxhqxyitqp+E6y8j4oofhU5d08
         bL0O6Lx1DdsEugaJmDLvfStCYWd2SK+Nkeg3AH1czwv/d3rQ/OEQ2D1PrZ5pvs77tm3J
         vxnJKlIdW294yTcdkv+WLjsA+WDk8YoD2AT26iZcGMCybffi/3r2od68mTw9StIetZoU
         sC2On3XepihGesAFage4LuHimoaBk3jsy1xANCTfF5vhgRb5LLVXxroQUkFG1vFs8CaJ
         gPaS2dSR4uoRpdneeI0/T5UPdQIZdxhJlKTA32wzZLZFy7jNoy5e29yq8wH3iQR2mpKu
         HYDA==
X-Forwarded-Encrypted: i=1; AJvYcCUxe1caXdRiPaBpaE6Ki3i5yI/YKAtOSbtRQLyMYHYnUl9cIwCpoP88td21vjwZpUF4e+MQygTn+oZUKUBnZFlU1SBV2FR5Aqz7
X-Gm-Message-State: AOJu0Yzwl3Uk85S1pgcIHf1hSJXePUMCH2k6AGTisv+czwqu8ra6+gfk
	eTumjCCfa8EpCV6fVlJN9hFTNwPlNIhnPIE5od2JjDeymlUa832Opyc4f6k03Wo9W/kcoy4fQbN
	CJjV2+IGjmEtLph1yI1KTOxuXkwdvhUiQglcwyTZuwf/ewrYSo9SaDfLk
X-Received: by 2002:a2e:a586:0:b0:2d0:b758:93a5 with SMTP id m6-20020a2ea586000000b002d0b75893a5mr5900126ljp.18.1707757216126;
        Mon, 12 Feb 2024 09:00:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWfgm/7xQWafBoXVO5m9B2+ecerqMNgmsVK2YVSO0I9LtMY6feCLDnkZOBYsU2n0tsoz4y0g==
X-Received: by 2002:a2e:a586:0:b0:2d0:b758:93a5 with SMTP id m6-20020a2ea586000000b002d0b75893a5mr5900112ljp.18.1707757215872;
        Mon, 12 Feb 2024 09:00:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVn/DPoAemeqvTkQ5zPfLy0hfJFjk4TKK9KhFtVG/UOJ0tl9rOXnZCBL8KZ35eC5xFC6HRbtaADDRpp9DzBfnmNOnXh/NJJ2tH4savAB+mNHahiaMS1HqsVSp99kIhOulubeOW05Q8flG8Rj8GTfbLcvB7+d6vIzEk3qyIoCg29wS/er+jC/w7fwJlPStbzeOShAmMTlvX7WCihOqzG7zVA6CevqmamhlIf
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:14 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 18/25] xfs: add inode on-disk VERITY flag
Date: Mon, 12 Feb 2024 17:58:15 +0100
Message-Id: <20240212165821.1901300-19-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/xfs_inode.c         | 2 ++
 fs/xfs/xfs_iops.c          | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e36718c93539..ea78b595aa97 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1086,16 +1086,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
 #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
+#define XFS_DIFLAG2_VERITY_BIT	5	/* inode sealed by fsverity */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
+#define XFS_DIFLAG2_VERITY	(1 << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1fd94958aa97..6289a0c49780 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -629,6 +629,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a0d77f5f512e..8972274b8bc0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1242,6 +1242,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
-- 
2.42.0

