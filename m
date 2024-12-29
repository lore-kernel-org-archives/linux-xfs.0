Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354B91531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479541; cv=none; b=Cy1aV5WH31gSxrJvmojLhGeVpAPYT7+M61DeReSD7gfn9ys0sqeYHGuvDy7+EG8JofL0H2j7tAsQhvAeVUOiqHeULPPXLjF60/jHpMCriiaXMEhivYz+eM2Uum1C5PvdYSaIbFwjVeSOwJ0NYr1mZjNpSOjVGjNi6AI0zYLEtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479541; c=relaxed/simple;
	bh=KqjsI219C6GjkrjMjjigvRewv+6ofD6AgBkRPmS6qvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRTyUXG73zNGy51NVFo4HWvQGdHBPI2ooUDiangkDU9YlEZpMzhttC0bNQt1ShoCAhYLfjLBPxylqw3eJC542cGd8nDbFomzv6ha0Q1S4BWAQ6Hv87+ZGmQq0ZOexZwC2f6KM7adH9oLpEXn5sxXAIm7klHD/s36qaeV6mUYEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2q534H1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2q534H1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pubKZOCFDh6mOTbFWYj1+wMeYj2AkCLgniK7fmSb0=;
	b=S2q534H1cOPZpzynjCdKZZLqGJJt/eNytvGd9BYYoWUfVwLDzCfpqLTvvMeT4hnz2CLEuQ
	gTLfKLaqLrfLDViY2L0K2yPVXTNTl1YZ6x8PNQqvOGmLdDcvt5eZfES/3dJFNLYfKjNpdX
	AQ+vFqp5tPz9QXhy23iO9H1w+d2lz5Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-Ca_8u_r-PhKqt84Znf5FKQ-1; Sun, 29 Dec 2024 08:38:57 -0500
X-MC-Unique: Ca_8u_r-PhKqt84Znf5FKQ-1
X-Mimecast-MFC-AGG-ID: Ca_8u_r-PhKqt84Znf5FKQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so67625295e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479535; x=1736084335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5pubKZOCFDh6mOTbFWYj1+wMeYj2AkCLgniK7fmSb0=;
        b=ti2vpws8X/ObwPgajVKMK0pydvmuHJ+LYB6VM/YHqaZAKOMfsbSbfkqbw7zJ8379/c
         W2JoBFURLsuJaRDNIDznmDaLTR95cbGCxdqQPJKKcB845+f2ZhnvBsEwNKJcEGz5NWLB
         T09KxrAcmD+uTE35LUet7XoKf/criUTrJ66+oO8ZjJVb8B97yFPfFhBJ7zV6yHxYkcKE
         smOMTZ5bRpMiU4KXw/Qler7DOt3YxKl1uxQHunuPV6RLIs8/6QOUZfDSxEAgVDiTkeVS
         hOEJGWdSiRpBlOaDJBhMdjLNz6riC1rZeWYNXRi0MCNvmaefJPRhZiCPDId+t/w0chlq
         DxBA==
X-Gm-Message-State: AOJu0YzfFuPH5jMhSnrtJob5+CmigJh1QCcwgpSbd9wMbKdcWh1P6cRM
	DTRhPWw6ATuz/QUcFyt8lKBkM0W27NTvqJu5C+aRKKm0FchxsEXpjtyVw0umkhC14yZv65/ZF0C
	1ss7BHsIJGsnaAd2nyctwX4RSUEWvgnsBNQjnt6fx9j288FuykR9ND03uxio9IoG7EuSnU3qO3p
	ipVcthFOkJtkT2rmVkdH8IahaZIywvEvVELj72Pz4t
X-Gm-Gg: ASbGnctvzKCzsLK9QkPOYxoPIAkPCRPJLGLofJu81s2xBL/FjPiXtTs4TPqCzABCoJN
	sDh5gMO1qTDw4AvS9u+UKmAFN2YaTmJsqWE3PlGqxA+bqzzqs5WRjN+JfdoqjdDdkEpQL0VX2wb
	0vG3hjNMvp7/kPfEIH+eP+rPWdJ+cho2RWPAQfv18BGf+rV203lGTL40i51lRD70eWkYB+Hp6O7
	7lxVILv46FOk416Jh+ts8rZs95TxCrYr+hMXIM38JQS8dV64gdtnDFVsDFuavQ2BzOb+wxGDxSz
	gtMgR71wzXdPjzQ=
X-Received: by 2002:a05:600c:3ca1:b0:434:ff25:199f with SMTP id 5b1f17b1804b1-43668b480dbmr253567025e9.26.1735479535142;
        Sun, 29 Dec 2024 05:38:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfYQFaKwIKOfgY9IN2VZZmVUkG5U6ac/rvBSPyLTeN8sxNqOxWlXduq7Rq7AJuWExc6rR5SQ==
X-Received: by 2002:a05:600c:3ca1:b0:434:ff25:199f with SMTP id 5b1f17b1804b1-43668b480dbmr253566855e9.26.1735479534734;
        Sun, 29 Dec 2024 05:38:54 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 04/14] xfs: add incompat directly mapped xattr flag
Date: Sun, 29 Dec 2024 14:38:26 +0100
Message-ID: <20241229133836.1194272-5-aalbersh@kernel.org>
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

From: Andrey Albershteyn <aalbersh@redhat.com>

Add directly mapped xattr through page cache incompatibility flag as
this changes on-disk format of remote extended attributes
(xfs_attr3_rmt_hdr is gone and xfs_attr_leaf_name_remote gains CRC).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4d47a3e723aa..154458d72bc6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -395,6 +395,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
+#define XFS_SB_FEAT_INCOMPAT_DXATTR	(1 << 9)  /* directly mapped xattrs */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
 		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
-- 
2.47.0

