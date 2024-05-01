Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425FA160792;
	Wed,  1 May 2024 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588904; cv=none; b=uE911LV6n06MOHZj1FoJBKxsJO528ve/9viVVDVJm8fM6yAgGazawpvNDDmbkQrxaYHlfPi1V5BXfneXGQYyZDiHPVq9A9pA66l1oQWYPPBhD+uNf5aAlNY8dbAbq0JjmRs9NNSsntYvEPvtoXeNyf+rMS669mUiHwFlrEdTXPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588904; c=relaxed/simple;
	bh=ldV6eqjMHkA7pnDuadciUlUSR7uxTFbU+t6uj07W7eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUFq2BiMncagHybSrplF9aV8Ug3Q45LI1tv9i0T0iIYBqZcQmZ9fXiSEaPEcxfBnp6Z1jAoVmQTn+sJy/qiD9Oc5t3xBwSYouptU07TAuiyERX3aXipUDNS+G+XwFFNgVIqBKRpokybr0xxQbGWfe46YyEgOwQEGF/+Z/rqAz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nn2/p6Vz; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nn2/p6Vz"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-6123726725eso2977214a12.3;
        Wed, 01 May 2024 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588902; x=1715193702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DW1VTdjf59OCmHwHUuv17YshCq4zF3bx4JUMK1itBpU=;
        b=nn2/p6VzblLgXXveAXmuM0GZ8ttbYKjHzy63+rD28ppn8EYxjwUWyJ3dJwGu8n+9ZJ
         ljW7tu1v1PduOD28NVqdYnFOkabSEMVnRyFFi00J+XCWv66VJ+jsxnacTLvr/8iMP/eu
         o+Xeunin/pEMAcZPti2BcLO5kksb5EGc0qdmNlGiSlkjimGH/lAxPDhiPLO5029QWz5K
         vz6UxFUSP5MSD7Du/i+zVK4JxT9iVi4ZGRxUP14wU7Urm9/Mu+BP4X+g5k9MVKnGSxoX
         v+EObKtvwHGVu2Tz0+UHhmaM/XYviw1XwxM4870tcpCHYsHd/IyspgBi/aKHuqcHBiNj
         N5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588902; x=1715193702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DW1VTdjf59OCmHwHUuv17YshCq4zF3bx4JUMK1itBpU=;
        b=p57jEICib/mwbZsb3XdrTYz5kadffPzIIjCMIby/hGa520siF7ZVJk6Pxg4QYZWEM2
         Zm+A1EwR23mOyeEX5Ou7nRRUXSP0rOrNPVjMK1PMQunDJ3FV1PWA4EYVxPWaBCwsKPBN
         +ij4CYe9Nz2qqIxVakGdTF7riQtFjfy7MqiMbsK2l6JNCI3PZCQKv3MA8Xs7w3QBgTMl
         15xo9jt+m5skBuj3IvqpmJX1ZA4wW4ugMfbX28ObZ8+nsx4B1xIWqjCmOvAyJU+phyDt
         mcTCdqXJ/18IPej9ByVUH8s31Ika7Ks0szFIHjPKtbp8wtY2QQiU3n5XCsm7DepHFOch
         6W0g==
X-Gm-Message-State: AOJu0Yy0cktKt6vPsxUZ4iqk/OAj27QCKv5SJLlz9WrsCi7dth3IoAYe
	KQwIYxixKGtK8a6yhAU3Xg1R72swpcVXkMIFiStwCcnQOf1HqGhuu95nMnoU
X-Google-Smtp-Source: AGHT+IEe6HTzKvI9UWjzr7vPnrxNNtOLX4Q0TvBSE7akpFkhvXqdirUiJuGHP958u9owedhTPdHKzA==
X-Received: by 2002:a05:6a21:31cc:b0:1af:4e95:ff3b with SMTP id zb12-20020a056a2131cc00b001af4e95ff3bmr3253982pzb.39.1714588902504;
        Wed, 01 May 2024 11:41:42 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:42 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 24/24] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Wed,  1 May 2024 11:41:12 -0700
Message-ID: <20240501184112.3799035-24-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 84712492e6dab803bf595fb8494d11098b74a652 ]

Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
further massages the new block count so that we don't i.e. try
to create a too-small new AG.

This may lead to a delta of "0" in xfs_growfs_data_private(), so
we end up in the shrink case and emit the EXPERIMENTAL warning
even if we're not changing anything at all.

Fix this by returning straightaway if the block delta is zero.

(nb: in older kernels, the result of entering the shrink case
with delta == 0 may actually let an -ENOSPC escape to userspace,
which is confusing for users.)

Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..332da0d7b85c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -129,6 +129,10 @@ xfs_growfs_data_private(
 	if (delta < 0 && nagcount < 2)
 		return -EINVAL;
 
+	/* No work to do */
+	if (delta == 0)
+		return 0;
+
 	oagcount = mp->m_sb.sb_agcount;
 	/* allocate the new per-ag structures */
 	if (nagcount > oagcount) {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

