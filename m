Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A136CDFD
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222911; cv=none; b=F9W4MpxGaesHVfEQrOY6Y1cuFdcfVlztcRByg+xihyL2omKNh4hsgh4quiNjQ05AsCxsFVx3ni6Qhns5dD/F1EIK9cAUJwtTtzlAsF6mXcCjdteDBKx5weseccxiq51hPvNCo/yNoR1giCA/CoWVepGx6i63DVdDgNdjTq0vk/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222911; c=relaxed/simple;
	bh=2zYyZLHp4D2hgXiAAGibRc45yLHOvZtgp5B6E/34V4Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N551aA0kzlK5CrL7skVtOX2lg1lUV2MItPnnXLXGfQ2mKDzjEaNHYDJqbyn0c0yI/x7abUhIf36bIla100lCN6JXevPbZ8VQ5Ye1mDPRPLtzhs9OL4Z1k1M0yPq2DJZBW2Y4WSLh2p4+LC8aFMlL9XBD75L9Rqd6tm/xEa4oEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=QBarsf6+; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="QBarsf6+"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e953dca529dso2444266276.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222909; x=1756827709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BE//YinxPgmUWE8hsLrFsv2AZQscov+biNx5LkG7S88=;
        b=QBarsf6+5qFf4TdDe0d3qJt9CTe1q6JApaGKRCFwzUvqQhRcE9umkfMdU6tSTYB1Ly
         GyJk22XkSTXTcDGh1XJ68x443V+YkvJ6DKF2a9rrHJ5Lot6vOpDb6hBi3SSNTy/gSECR
         5oBpg8tsiQDbgCnT2T7fqUskT3VWmcRtnRFbHtaYgxpCcTs7a++Ns2teQByV4ZWl0jkF
         9frRsgDUa9rZSfVwfXTisE2TRn4LhviWcCf5OVux/cGUZ53/Eig9dLl1C3kdZfHzaHo/
         nLRjQxJ0q5JpkChLXLguhoFUs4UH/gaYr29tmTm0AnuPxTIUZ9FlbQC23zS4V8eGcpmg
         RbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222909; x=1756827709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BE//YinxPgmUWE8hsLrFsv2AZQscov+biNx5LkG7S88=;
        b=on4re0VyEcqs+JHyeOcu1Pan1Eob1rFtynAqED9KqXvTH7+IVQWPw1rDM9H6VT/obn
         0hOeCxWbQA0TDKt6BNC0Xz8bYKEjEK03+PJNU54AaNCvmiAt/HINSmfRsGkHyw5qEce8
         Jp9DYvohr6V0G1seI+O08LVfMYDjc4yjNceqDklsIpb5K8PHt655zq+yCPBbstVfg990
         g9OfCgegUQ/FWduwGaiMBxSrsLKUmn8ZzkF0wAPcoORgvp9Tzi5+gCGjLeuUGgf7Jax/
         WfVtL0IOwOZoK8aCmrzim+k6JyNPzAKqeWAKuS9eIVIltTkQ+utXtumR2Z0ouYnnl9r6
         Mejw==
X-Forwarded-Encrypted: i=1; AJvYcCU5rZQ4YAcynyPNRhs3Yxp6Ge9gZpIm1yp8VrOB/AWhTOlzlIT2h2dkog0JgG3hYbe9vNN0dgNTz/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3EK/OVIkN+JApo6fkOmxfQnXLLcCkzVc3PF0cwUT6x80rpAh1
	1n7cB/ZdF07bBfUjq2xiFccBR/+bTzIgvMo5ABxGj5f2j+RWjISQ9cAFZbD2ZK5/kWo=
X-Gm-Gg: ASbGncsD84Y504BKfUlra/nuhL4BvvhDpjhmQRUmPTIYXFH/VjUxRllz/MeEOy/YG3H
	2BxhfPgejJUDiINrGZoslLnyHVjIpbo+VVA8NjicP2TSiLHOGM+RSF/iNL11ueWfwHhFPPxBOoR
	kE7LMGBE2cutwx7hv7/FIN+NQpPbBGIAHugTOH+YZZuUF9rhffdVDnkjPjdhr4DvqgyviXUxlV3
	2gaQD0dmI1sYrg2TQVO8GvSY/jvGWmJF+x4BjcsbDGV6+dfZMCFpiTfMVuUzAVzqSn5UOL0oGco
	Hm0vjTH2LLDPEmwyFvu0PoSj5eVckWVIX9+sHzAzIo8PBpGnKtTcZHJ4fXlqcWLTCdMx6nzZVIg
	qq5CbPe7Vsqn6nhK8Bv1eAuOQrn2EzYexLaJsqL6MUcsaCXJVLZlbDQRYJlY=
X-Google-Smtp-Source: AGHT+IF30GxXzt31jHcfNUoY2pUyBatIJtVlXY2VZDYDljhQelnzFVQCaalCRl9Yu+PEcvaFlg6PNA==
X-Received: by 2002:a05:6902:2b10:b0:e96:c754:b4dc with SMTP id 3f1490d57ef6-e96c754b6f1mr7345665276.18.1756222908777;
        Tue, 26 Aug 2025 08:41:48 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96c38c8efdsm1865626276.14.2025.08.26.08.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:48 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 41/54] xfs: remove I_FREEING check
Date: Tue, 26 Aug 2025 11:39:41 -0400
Message-ID: <830cf8502686e1bafe75ec6fa7e87c68ed49bd54.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can simply use the reference count to see if this inode is alive.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e43..cf6d915e752e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -514,7 +514,7 @@ xfs_can_free_eofblocks(
 	 * Caller must either hold the exclusive io lock; or be inactivating
 	 * the inode, which guarantees there are no other users of the inode.
 	 */
-	if (!(VFS_I(ip)->i_state & I_FREEING))
+	if (icount_read(VFS_I(ip)))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
 
 	/* prealloc/delalloc exists only on regular files */
-- 
2.49.0

