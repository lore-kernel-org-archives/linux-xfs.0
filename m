Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E7246BD1
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 10:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752748372; cv=none; b=C8lW0Ashw469jexg7q8xJoyr95s/QL/p2Pq1Y54luY8Ddwq2VlxAJrlSCwts7guCRwz1B4yOkCY+/qWDnpWbDvK3P5BqshgZhd5iJXQK7mOae3ImXPWuq+R8/Roo7vpkX8fG5HD8kU+UISoQA+kbiwvpZWTGOCJWAlkW+EkVD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752748372; c=relaxed/simple;
	bh=NtY1gBbcJ3iWQwCUT+QqDaNC4fzi5+xYEhdMK279RxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URyBlis2hvAxfQhED7bxzB0YjDU1vI/IfSK8tUsY2zlaSk1S3wpStm+ZgIkg/PzPrMhiL+6b5JC/7fs5N+dWvrdX7KNRVuL8a6G57vX1qGbSD5vtyR+Zcz8gaiOzAPTkfows361tAWhrYPSAWRX9JBPUl2aA9t3J+l3BaXa1P3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hgl4bwzB; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hgl4bwzB"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b31d489a76dso635885a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752748370; x=1753353170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhXI2GuNpDRboNlSyRg4F2i9gjfLNYXIma2dDARTN6c=;
        b=Hgl4bwzBmvLrARUVEMraMzy7qSRF2kDFA3B3OcLvfwxINDGrks2YTvNroHJfFTqkJ0
         OYMdQSuZHi+auXX/gGhyOPQkbgbtydYLWKVJ8mMS2cytdWv6fVlWhev4wUaWuPlxMsIJ
         Tb10o1rX/n6ZszqubBPhwkvlASa8SxgKJPC/P/s+GNAdskpwIJvkYmsSnCZBFS2ew3Le
         tRD2bJNPhIyrcrrfXKMvdi9p0Du8A6nA/XCFjw0JPkzm8xaJXYosB2+03sBQTcu7lvEE
         yvdZWg+Sfg+Mz0T4rF4lyqS3ouhfUmuASpFLgixSor4+Iqz88RRC5rzT/ufhEO3XbBt3
         cP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752748370; x=1753353170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XhXI2GuNpDRboNlSyRg4F2i9gjfLNYXIma2dDARTN6c=;
        b=MPDA1gMjXp5mAnCx6FMIiCiUPG0HH0Xu+9IjG+UnrFICEcKI4t+QjcBXSR9s4MGjEB
         roGwC3kuDpPVxvMRSEI+/BxIWvgADTnlzU7uabsP1iL9xjIYzG2g1/b2s4NRM9gVnDvy
         +b9HvP3ymq973VZ9d6hpf6QDuAUUItP1NPg7F0bxL7iGpgF4Dd9Ka3O7corsp/T39993
         8HnQEiMBGJZn94Nb/M57C/VqK7hcONjxbh56S+26yPuuofk1K6JZqmlBHWzlU4olxSWP
         2KOXjqceHEM3W6wbMtWFHmyXSLgSCeIcXYi4zEFeq0ysylTeiAXp2xndIaMYVjB3I1zM
         FKuw==
X-Gm-Message-State: AOJu0YyRQUmby+pKlRF29HRxkthYaLnCh5UdFvREUZPYSGC2eV8yc+CH
	U8D2/weNghJH10PwwYxmShybe+21DnDXziaStt1J7Sn23IY+wxHTGtgETb02lA==
X-Gm-Gg: ASbGncucSwQHy/WvV/oQMdM89qlakPLgXArk6KoPhY+5fXXY8CTGpNi10N4VvWAHsVk
	nIWo03DxMOrC5AbWE9vH5iPLa/0lBxTP474DM3Oz77BTWcWxqfyZ3E4wjKalh8mg1bdx/sxteQe
	SWOXbXVGsfP0RpK4lhQx48E0w0addMpqmRz392OCwYCasHZZWJgnCv3kpQTUJgcUUWO3aFB4Z21
	IfPTmA//TLqfhfQ9JIpfcGCt6fVDtG47/u92ZCIlhNSZqrGwMDy1yo+Hk3+TDxSebCfDkvrEqNB
	iDeUwyDtNHCvUZQFo7t2JZCdMkLc468OKMJreUt4UpNe+p5y+XoHglr/eJVe93is/BYk7JCQ9k/
	0ehH6U4BtFeIxYXBSErOei0jd3c81AUpE1y3WpZkYnsqINbNaC/iLACBCGrXeMv6ffDt/TMTrkX
	Cm
X-Google-Smtp-Source: AGHT+IGgBwRicQmDy2UicxEwZpxsD9CmCT/CbT/S6VEYV8waebW9eM/z1vLNskmPwOMFBry2j6dwnw==
X-Received: by 2002:a17:90b:254d:b0:31c:3c45:87c with SMTP id 98e67ed59e1d1-31c9f44b592mr7536995a91.13.1752748370003;
        Thu, 17 Jul 2025 03:32:50 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.in.ibm.com ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31caf805069sm1275145a91.32.2025.07.17.03.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 03:32:49 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC 1/3] xfs: Re-introduce xg_active_wq field in struct xfs_group
Date: Thu, 17 Jul 2025 16:00:43 +0530
Message-ID: <70c065f02299e09b1569c3bc45ff493c9ac55fda.1752746805.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pag_active_wq was removed in
commit 9943b4573290
	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
because it was not waited upon. Re-introducing this in struct xfs_group.
This patch also replaces atomic_dec() in xfs_group_rele() with

if (atomic_dec_and_test(&xg->xg_active_ref))
	wake_up(&xg->xg_active_wq);

The reason for this change is that the online shrink code will wait
for all the active references to come down to zero before actually
starting the shrink process (only if the number of blocks that
we are trying to remove is worth 1 or more AGs).

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_group.c | 4 +++-
 fs/xfs/libxfs/xfs_group.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index e9d76bcdc820..1fe5319de338 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -147,7 +147,8 @@ xfs_group_rele(
 	struct xfs_group	*xg)
 {
 	trace_xfs_group_rele(xg, _RET_IP_);
-	atomic_dec(&xg->xg_active_ref);
+	if (atomic_dec_and_test(&xg->xg_active_ref))
+		wake_up(&xg->xg_active_wq);
 }
 
 void
@@ -198,6 +199,7 @@ xfs_group_insert(
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
+	init_waitqueue_head(&xg->xg_active_wq);
 	atomic_set(&xg->xg_active_ref, 1);
 
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4423932a2313..dbef389ef838 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -11,6 +11,7 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+	wait_queue_head_t xg_active_wq; /* woken active_ref falls to zero */
 
 	/* Precalculated geometry info */
 	uint32_t		xg_block_count;	/* max usable gbno */
-- 
2.43.5

