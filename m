Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EC7281358
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734706; cv=none; b=foKPFwCJImZ8obNM1FqTrolebhfosB2dJIj6xgY3pZL3VOzKIuBrLSpiCC/yXaD3QPuRR1AdB1PqXJp4bC0D10+1NnZy/pUmzAlSYfltehVNgRL+aGJZjZKIaEHfGNjZ9ER3OKzrDsi8UHgevn8rkswiN/erlu8YAMfltYt5VHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734706; c=relaxed/simple;
	bh=pEsdBsP++Y85G6aS7bR9cTIxDhq123OG0RgfqhdTNOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tDx/p9L08cau3+DPvPm5qC6WMZaZp1X4GkLy7ggdBipRc85x7d4sfkTbqc2GfsGge8hVPiu7Ridttx07gB2KqoB5wn2jF9QHhy+NwDUJeFnQ7MfTD4kxP+K5M3WeQ/Ub9fe8uaXNJgMCVut/mBj3Z2lDFzwCdCnhflpD/Mkn7BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLcT1N7K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLcT1N7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvsKU5ht1WKmP/gTh8rNGT9sMvO2NAzg8uCQD7oEXFQ=;
	b=PLcT1N7Kbny7lptvmax2N4jtScSgSOqcEKwtfa9EKf+vyiDLo33x4OtPg94it+ppmNOVez
	eVLN+nCxWEFfObwkdy1+xGgfpECCqupksq3MA4uWa917OQl4wCW3Lpk8ie65xkBM/iVItP
	YmNZ+fjy3Qavqn9bqee2XGOUvDoTTcY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-s5OtGy4MMGymWeJ5UMNVaA-1; Mon, 28 Jul 2025 16:31:41 -0400
X-MC-Unique: s5OtGy4MMGymWeJ5UMNVaA-1
X-Mimecast-MFC-AGG-ID: s5OtGy4MMGymWeJ5UMNVaA_1753734700
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-61543f038dbso853020a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734700; x=1754339500;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wvsKU5ht1WKmP/gTh8rNGT9sMvO2NAzg8uCQD7oEXFQ=;
        b=WpedCOSG7JUXV6dqxmuZyLpobPyjJ4RE5CEIAMyWUsi6ki2qVMdVhqDO/YYA6b0RM+
         Uby9p+JH1AdhlSSPCM5Bo3rK3PDW0Cpnfs5Xs3j2bVFRcbikFZ+Xst2QFOEGTFVdgvq6
         mzYy2WMgFrZJ2sODd+1nQX4BAaPyof/5VkgigOJBDaR1K96iBd74HeCJtuk66fKtg81m
         SuCpvoUX2FDTlXUbt+3Rikn9vH2wpgDaJ92F9dqewy31bnTuLTcyg6PBQxP4FtMR/2O8
         RqiqyAK99k2heLJsBu3pheShAiqlX+qe+XUjRi9XdZ6ABBDJ5Rx/KMglmZzoXwof7CCl
         UhSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKIV1bI+50Q4G6zl+VnzRJusxKUigSc7f8BpTjfeowqJ+hJMPK8yQ9ORUFG57oT94pFZ7qT8OH+48=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyQxQDSuvhbuXkaYJQc9Mg59HhRH8EICVzY956RWg8ITyGy4rO
	onvrRr3/LUEEJ5rx0FI1c+l/FcYOJTw5T5BX4n0s9KsM2995tw6brCoxNhezZYFOSfVCkHP0tbB
	8gG6xGkIEW21iotO4axIwPyGc+RUZd9qWnWlDTv9YxqjQXOulzrqf/nSGepO7
X-Gm-Gg: ASbGncvWRzifIBvYmiziuQNhA8gMukrd0PSbKiZGuKGx+4P7DddJT/sAxKvIlbi/9He
	3ti1CQyCfeTv+whRsJHcRhZntO5H/y5eYiYRr1VRjhU/xqIxmae9HXPo+BkXSf7BV8h2avcKym3
	+ZxoWhfKsB7SJD8x+V/5LUNtiDvWlOyCqs4opsf6IznSczLnwhKFXxWzWHkwKYGk72AcxhtzzeZ
	tGypEu3tQO85PJTHkSVDuukOYh3Gjg8mzZuQSTDfKmaHQWHbs4319+XnRTle67yxqEGGNj7CSqF
	8LAHf31KhjrnsBrZ9KMNKAjNbyYdvSRJmr2wncrvAfJP0g==
X-Received: by 2002:a05:6402:4301:b0:612:3d0c:a71a with SMTP id 4fb4d7f45d1cf-614f1d1fb27mr12150577a12.14.1753734699800;
        Mon, 28 Jul 2025 13:31:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAgVdoNTEBJPqNHsQOHuT9fwO/DO3qMlfW/S4s3Osuit2xlyTjHHaIzxM7/XbZcrxj7z3tdA==
X-Received: by 2002:a05:6402:4301:b0:612:3d0c:a71a with SMTP id 4fb4d7f45d1cf-614f1d1fb27mr12150558a12.14.1753734699371;
        Mon, 28 Jul 2025 13:31:39 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:38 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:22 +0200
Subject: [PATCH RFC 18/29] xfs: don't allow to enable DAX on fs-verity
 sealed inode
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-18-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=898; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=VsEwWloIYSoJV3t10dMO/UU69MLyJpIl83HjhawNhNE=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSaSauInrBJydPPWKkpFKI8MDeYdw853hsVkzN
 /I8trh34lVHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiSRGMjJczTb9yi05r+xl
 4rdFa1eLfF/6KK25opvb576Gyvs9l9e+Z2T4luqUMafv5KawH4qnzDbxLM48f8iIf+313i8mWQf
 ON7ziBAB2pUkA
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix typo in subject]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 83d31802f943..2d8ecdd0b403 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1365,6 +1365,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)

-- 
2.50.0

