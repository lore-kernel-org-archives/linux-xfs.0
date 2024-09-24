Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC01AC45A;
	Tue, 24 Sep 2024 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203150; cv=none; b=n/4faGirtcc7bCN1qySVwAW3buV3B+Y5EdqVbuANhFktQ6/W+a5xs8H7SDE1SH8PI+IauhhMbkFKiv+DOJlR4UJdxv6sK/4NNp/myEvgKXZJnROEENSkHi7+IYec4czQGlCbX0vbAy82yxwmxbtXAWBu87KXkCSUf/rlJtbYhUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203150; c=relaxed/simple;
	bh=rmhGXfE3TQJAGDtwyY0FjUMILnUmNJ2ubfAfeNwHjYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Plc/mIsi3MQyybFRfuZY8U9ZP7pt/nwIjzwPb3a36QWzCbGEH3eogB2U8qK6PlK1D6+4X5gmDfZyu61gAhWUDDpweCDtZDxfT3zXdLSl7dbSREVgn1hz9cCLTkRUAbObhLz66IodS9qslAjLLRH/QjBl3gQsBNGfWnCCPacAW1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J5AJCctY; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J5AJCctY"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2d88edf1340so3911147a91.1;
        Tue, 24 Sep 2024 11:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203148; x=1727807948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfsYzXfCH6bQpdZPV3lPQevwKiuUgBW7XGe7rqea52I=;
        b=J5AJCctY1T5M4h8kXg8+Rj0WtUbJr4UI1xQ8EcVh19b2Bfj5ZHxv5q/Z7s4GsZxWT6
         7dOAh3JSx4EJWnOl6y9MNHt1SSTW1qWOL1cr5FnztYeBUc4mQ3344WMz2+gAhdWU3czn
         MBla+luPpXJ9yvpyER5dZhe/8ajP+QM2hwlpQxLhZkjKY5LpMeEvGDSqTZgDytG2AMFT
         edPjF8FJcr7DJvPMRToGSOPzrrnryGnmPuXvNF+phaU6t2SX2q9vBmYHKLXv6CzaFcjH
         6rxgJT+EjxRrX2AKHdaAHMctoOTAnfaYADDErJBVLlt4seK8cPGKfSmgqwCqvXhUmzOU
         x5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203148; x=1727807948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfsYzXfCH6bQpdZPV3lPQevwKiuUgBW7XGe7rqea52I=;
        b=WTf2XWOjPvdQdf4/YD8LJoWkQbxKazuEORfdIndGyOf43e8q5CDlxR6JFHhdsvFLxF
         Am2HBQF0i475+u+vCH3a1uIFeLl8thjgy5nVD1sDmgrG2FEnHETCdrunGxZQ+7NmLToB
         RaB/KOyczxXTRBBiv8b1hKJROHPzR2p4ZPW1iZBf0Z189a4+ce3r4cnXMkdOlbtoR64L
         h4cme+1A8dHSDSlgic8WIFOhPij9GTgDvHTn9Hje2Ojb5YpZTLQoXEfbNKhz6+YokyFZ
         Gi0WKZuy0k1RSGONif0+qseL34nGvJN5vuf3QWrLp1U1uBZPeS1/dVqIDdS/MJFbyjFu
         F/gQ==
X-Gm-Message-State: AOJu0YzIIRvYW1/zRpLZxDgmi1nJaGnT+mzghXMMp8A9NyzVvlLPT7Lz
	vA7x63X6YpSDIbcXdPjgd+MNHOdgs4UIgAxEQfAJmK7DTnArokST8xymlpqA
X-Google-Smtp-Source: AGHT+IFY4v4cUQuBzkFDB8f8lnlwErJEM6mUTvtRej1GwnPIlBhG+lodRZjTmA+qjDHx6axbHEoimA==
X-Received: by 2002:a17:90a:b308:b0:2d3:c6dd:4383 with SMTP id 98e67ed59e1d1-2e06ae4ca6amr96094a91.16.1727203148380;
        Tue, 24 Sep 2024 11:39:08 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:07 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 08/26] xfs: fix uninitialized variable access
Date: Tue, 24 Sep 2024 11:38:33 -0700
Message-ID: <20240924183851.1901667-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

