Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42F15820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479545; cv=none; b=ingF7L153jgmvmjg4KLeaWOLUKAaIq9HCu0ZhnMMSZfIIxyZuxDkgcGE2/P2um7QA8GFWSrzyKt1XZQMnCm4uU6SnKW6NrHIXmVGMuCrQPhleOkzmHZFV1vqkNR+8NBfM62RP8Id/U5XFa6e13JeubEyPn+7yCAo/B64tAvItlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479545; c=relaxed/simple;
	bh=yB8EB0fN1wRruFNo1C107zY4O9o5wnt/8yS/iA3u+Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIqrjIrCxV2oDtIyFtZQwwU39TsZDQN7HugODDT1Q3jBLAybCREb7zPNzqQzb2omU32QPeplIXvdseJ3SoAvJ3wCJAAT74p0dQ1DdGyNUx5GZ2jv/Pf0zkzSoHS2uXOwfdRJpenMTsJNTkEhsHTggd2VH/r4zWYZqF5hYF3UJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cIg32JTt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cIg32JTt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cl5eoui1m9xBBlR6Fd0q3sI82yIiCIQr7B7+qi3Qmd0=;
	b=cIg32JTtsksEvH5AnpRCBippGFgFVdB+1szvavD4VckE+Q1RLOrO7GXtt0ejSQCSA4Pv4g
	r/HfuhNPKvDUWI8OHsB4c4n+QTyNbrLlg1+BcawJBP3f+wWUdvP8TlsTDXGf1RuHT3phtu
	pMq68T9STlmAJ1Mj+ulsrM1uH5Ix5y0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-t3Ek5ujGNHO3PGS3bwCBtA-1; Sun, 29 Dec 2024 08:39:01 -0500
X-MC-Unique: t3Ek5ujGNHO3PGS3bwCBtA-1
X-Mimecast-MFC-AGG-ID: t3Ek5ujGNHO3PGS3bwCBtA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso63262385e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479539; x=1736084339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cl5eoui1m9xBBlR6Fd0q3sI82yIiCIQr7B7+qi3Qmd0=;
        b=TqBzs1cjwV4oCVrG3qTfeAqgai5YLNboAYpt6vwXeBiElE8uF8n7nSXx6k5K1/tU8a
         /ZgMYFgtrE8waRtUQ2MW6IPLChoN9Cnz8GuhvjUzOc5wcHP8i61v/pwytp7hbtINeJZg
         UjHb3r/HwAbJ6ZfKbZZR8FPDQE3URWYaBH/PVTcHypQJYDVh0Xta1T9Vj1lF9SQc2qNA
         9z3HS7VVgi9azIeEAQwXe053ti3G+JCJ9dF0Vuu3evtrgj5EZkiDVHEZMN2gY4aThrmX
         Bipf2GzGwugo5G5HLm4oB/RJPdZg3WFMgx1t0aClBsO3w5KQIGzOJXExopHtP40EYGfW
         CckQ==
X-Gm-Message-State: AOJu0YxgG9t5SMMUd253YXluJDolnYLL3nNV38MWw4D0GAgKJiK/cC0k
	OeM85En08Ts//LexmNDD+iF4rLyFqVpPMGImsF0IChUkPWKHzc5y5u3SuWq3PJ5VvCWeKLo3aSD
	6P703EujcqgxodiZVvuB9NNnfJG5Bqb4zqsVXnLyIAGPpyPjbdayNEZDCAj+qSjjk/Hfa7joQj1
	pGw16dSd6CNF1qc0es0cWPn8IGFEUavvP/xCP9pibi
X-Gm-Gg: ASbGncvjkosHL+2jpVAz9yyxOrgROPgfiHJstIibQmxZXZRbYuT9FfvKN9zOyYmJ4M2
	NmciDwfCFdgQkXTBjA3a9g7w+q/qM6B9JRbJLU0u6pKzquVU0o8bCpfQYIC4mu+nfG9VYb7tFMi
	l1XXf0qMnFinV7TrE96xvJ9tpYuCYtaRkcuZ3FupacBq7QgT8TmuzXhoXfGMPTyKTdbzrdYfrYt
	t+9VovSYYQdE3E/ulFCUbjzY8ihx+9Z5Z+Ib1zNJkVAtsWJQs/6hNjEbF97FiFfwRhZU0jAOaBP
	eAaw4D3rlm7E+yA=
X-Received: by 2002:a05:6000:2c8:b0:385:fb2c:6034 with SMTP id ffacd0b85a97d-38a223f830dmr27785531f8f.47.1735479539348;
        Sun, 29 Dec 2024 05:38:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsn59qw2xT/PqoXMyd2l1Hc9hWlAf4OMIuRFsPza5/Aqg5pAfN7+d0UhgyVJ4J4UUS9LOVTA==
X-Received: by 2002:a05:6000:2c8:b0:385:fb2c:6034 with SMTP id ffacd0b85a97d-38a223f830dmr27785514f8f.47.1735479539006;
        Sun, 29 Dec 2024 05:38:59 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 07/14] xfs: introduce XFS_DA_OP_EMPTY
Date: Sun, 29 Dec 2024 14:38:29 +0100
Message-ID: <20241229133836.1194272-8-aalbersh@kernel.org>
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

Allocate blocks but don't copy data into the attribute.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c     | 8 +++++---
 fs/xfs/libxfs/xfs_da_btree.h | 4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 17875ad865f5..5060c266f776 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -642,9 +642,11 @@ xfs_attr_rmtval_alloc(
 			goto out;
 	}
 
-	error = xfs_attr_rmtval_set_value(args);
-	if (error)
-		return error;
+	if (!(args->op_flags & XFS_DA_OP_EMPTY)) {
+		error = xfs_attr_rmtval_set_value(args);
+		if (error)
+			return error;
+	}
 
 	attr->xattri_dela_state = xfs_attr_complete_op(attr,
 						++attr->xattri_dela_state);
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 354d5d65043e..2428a3a466cb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -97,6 +97,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_RECOVERY	(1u << 5) /* Log recovery operation */
 #define XFS_DA_OP_LOGGED	(1u << 6) /* Use intent items to track op */
+#define XFS_DA_OP_EMPTY		(1u << 7) /* Don't copy any data but alloc blks */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -105,7 +106,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
-	{ XFS_DA_OP_LOGGED,	"LOGGED" }
+	{ XFS_DA_OP_LOGGED,	"LOGGED" }, \
+	{ XFS_DA_OP_EMPTY,	"EMPTY" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
-- 
2.47.0

