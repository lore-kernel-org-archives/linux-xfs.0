Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C2187357
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560521; cv=none; b=VyTKOJYvJ4de0kwNheA73PK2SBssA7M0dyzMjF6NZVzXcVnC8ey0vOD9DU2/WU6XwWz0DsT7yXfHaxWF5wZ0JUOCo/4BkvRr+xGobJJfKa90MEyZ2IKQnuRh9r/X06xTcxprgA0keOcQThYnV4ElKfc3eHZkuZvzp5QPi/blSxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560521; c=relaxed/simple;
	bh=mS0Nk9qedVsrVvzemMpUVzwX/mfMQF94WPpvXDLExhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnUXNS4kMqswGy7RlSKEqsXmx3lAnZeNap+V5oJUdAm2PqlZzeRzkEMERVUOKkJwRedEyBSNFGNXdmLKEAzf43MCx4nTZPl/itzPpOFs41jFl0oyojTskQc3uhjzs8BaayG8vXeWnuiOfTsittDvezaPDV8yDRYtpxiJzKULrqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FuD69d/Y; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FuD69d/Y"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-201d5af11a4so10861285ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560519; x=1726165319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olcB0F8DHK4CDFU/f2CEsuVv4NsXmBIozmjDSFuNxmg=;
        b=FuD69d/YVtXqE+zpBMKCrgUr6+ujig2unJDjO5btpCmt0kEEBhDctVVXKb7paF4UNI
         PS+Eh34r/L1IF3wY404DdHC/s+ZDWrsX0rUl47lBQ69IBDXt4YAblCHZxgpfM2d96ipp
         kocSqw5ZRwkPoM54uYKdPLS2IDx9mMt5A/8zrg0akTobYes7jCwO1K9Iea6i8s1JPHrk
         y/E9ewmQ30Yfyuvn3A7hXDdnVmjuRiQs7SDoW5geEQF+SwLe7G3aloVEHwAR2aIUfiCs
         t3BJzDhjYKwG/CEVWHubTDE4gN08DmLhX+5FMclSmKHSVMnleNw7YQz54Zz8tvPDGe7/
         Xt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560519; x=1726165319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olcB0F8DHK4CDFU/f2CEsuVv4NsXmBIozmjDSFuNxmg=;
        b=mfF2ac5XzSnqSPAw2UY1FnJyQddBd3saA9s5TrQeMDfHKTmdDLpg6U6dyJ1GZoKlab
         zA/YX0TdsCh37TP++QP7nHCmxUtPOPTqTChg1DlUeNixsGOEjG0YoxZor+fZEaMdsu+R
         gYAjGmDZf7DCYPUOkIS+Y37lP7w3GsAFsBqBgEXcJlsP2g6o0aVFv70GAWpDdwNyI3vF
         51XaacVOJI6wosNz7EJ1/tQ0dxfdWQfc+Z6fjuNpJEqwPzC89I/AGVFfUjowH2lAXYgs
         LfTBuCCogCCkCQmJWmAbfGi8dP4dPAKr38L6p2fHvsOEhuR4ZWUkKuLi9FTecPjhbd8A
         zTlg==
X-Gm-Message-State: AOJu0YxnMeVbc7lbJo4hLeryajs0THwr6wu0qJponRitfWhL/smU/qHP
	9GIihKEvwjpV5rsFLL9opVQxVytnX06zDwqN1s1JYX9rSdAapXY383WtH2q3
X-Google-Smtp-Source: AGHT+IE6q94kM5GcVu/dON7eY0k90Yy3KKVlZ6Zgu4uvfzKm9M+5M25RYwN8aWIX9Z7niJx5BD6bEQ==
X-Received: by 2002:a17:902:eccd:b0:202:51ca:9823 with SMTP id d9443c01a7336-20546b35b37mr202720455ad.46.1725560519622;
        Thu, 05 Sep 2024 11:21:59 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:59 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 08/26] xfs: fix uninitialized variable access
Date: Thu,  5 Sep 2024 11:21:25 -0700
Message-ID: <20240905182144.2691920-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 60b730a40c43fbcc034970d3e77eb0f25b8cc1cf ]

If the end position of a GETFSMAP query overlaps an allocated space and
we're using the free space info to generate fsmap info, the akeys
information gets fed into the fsmap formatter with bad results.
Zero-init the space.

Reported-by: syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_fsmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index d8337274c74d..062e5dc5db9f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -761,6 +761,7 @@ xfs_getfsmap_datadev_bnobt(
 {
 	struct xfs_alloc_rec_incore	akeys[2];
 
+	memset(akeys, 0, sizeof(akeys));
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 	return __xfs_getfsmap_datadev(tp, keys, info,
 			xfs_getfsmap_datadev_bnobt_query, &akeys[0]);
-- 
2.46.0.598.g6f2099f65c-goog

