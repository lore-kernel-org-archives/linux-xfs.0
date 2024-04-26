Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D433BBCE
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168575; cv=none; b=k5DLxdYc8XShxJ2jE+ROa0w0o/R5atDoBSCgMylUSH/CwOwdNSIGQljTaYUDrDvBf+9pEk2NpWn4gteZWWvApnyoPeRQrKOghVU34Hf2kMX0+peJYFAbbWNOfgYc5H8gBfIBGk8FGNMkpPs3Y8d4oWVHnmreVhIf0uwAlKXpjto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168575; c=relaxed/simple;
	bh=1YuqOdwvzMl0EVMwj7Gm8Bkf0PIGwIDvNOLZbiF4ves=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8ChcwBaW04CijjA9hM7VjDDbTE07hA+PSoRaE4KuYqIBGXjIgEAwKkXmY1rb/BUnOH6Q3yzWGs8zE1iB74VlREzhabtEIXWb3SO5ZeEPmagg1fBSDUy6Oo7pxUKCi1ghS/4+RMnLiv2ZczGg2kBz5jDSdJ7vbI4o7lqXOUSnxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UUOOKv4S; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUOOKv4S"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1eab16dcfd8so22467735ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168574; x=1714773374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dURvlKO6Os+021+tFsKCrIur6UAEiS03EpW3sWHq+k=;
        b=UUOOKv4S7yL/XTvgK15MTqksrzGGr+6QPWmhPe/6zcFmiu7r3WwX/D8fIXOHTktF2g
         ke0rP0pxOFDWLxpVM0YE+Lyo65XLwEGngBXPXL7HcWz60JQYU+U3kyRMk5oZGJoz6Np9
         VOoZH4jFP3aJcTaxIdIdFcsA6q7Nn1eJ87PRwNTXykmDiJOKUwoqSych+a7viIBmwG82
         0p0+xzIa6Gvjg2Qgs945BRvq14Uw0wdaioC60Ofqmx0RfS2EV9XLVthIJevY0+Qdsdyc
         RBDbuzmC0O3/A/KgZKR4EDpQXBF7wYVkR3+nSOjCiVq/M9q+uwQIfyYIPHBHJFFDVs4S
         bH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168574; x=1714773374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dURvlKO6Os+021+tFsKCrIur6UAEiS03EpW3sWHq+k=;
        b=XDRffZqffFAl9HzCs9cB344kl2HXlNYuAXyGY5AaojXWc73r+zpDk/GijkFCQLZo9e
         LiU2mc5MTBx1PG5odkL8F6yN1cGzKYxAcaaiUNr2e9NEtZIz3eSY8+7cuOlMIvzYAriW
         jJBGOs6pNr+t9mYTAhN7aus+NRInpaiw3tTqgkYrc5vjeVZaaLvuwqHgLca2mfAnSK0W
         F3EiI3GMsWMD2T7fn5PDOuBttucRpVmSoEOjpQabMFgAbObu7GgdIp24zke9fmCvljhc
         ktQ8zq5lt80qpAAjb0oxUMIiOyQ46VuMy6cuU+xKZpkn3jcKvtc2aj/BEOSRTx1w/nNT
         H1iA==
X-Gm-Message-State: AOJu0YwySWenCO+YTwBLcsRbVdbx0EgWTEf2FzNF3b5FKa34B1gdIN/6
	ev1Rlw/bm9AnyCoFz0r5HX+sem6qp2aJ5ft0c7zlYWlexro6Jcg6gOkEsKBG
X-Google-Smtp-Source: AGHT+IEz5/RaNH+Z/FJOeyZ6b81DJoolPWpmWQU0/fPuRCaD8nJoUzzBANa9gsNjECco7gnMtU2Syw==
X-Received: by 2002:a17:902:fc85:b0:1e4:9ad5:7522 with SMTP id mf5-20020a170902fc8500b001e49ad57522mr935891plb.21.1714168573883;
        Fri, 26 Apr 2024 14:56:13 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:13 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 24/24] xfs: short circuit xfs_growfs_data_private() if delta is zero
Date: Fri, 26 Apr 2024 14:55:11 -0700
Message-ID: <20240426215512.2673806-25-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
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
2.44.0.769.g3c40516874-goog

