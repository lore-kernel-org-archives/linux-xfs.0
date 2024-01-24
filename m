Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B35218037
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089275; cv=none; b=ckRaYXjTTWGOSgg1xc5tq6/PE40TYkMtYx3xoSz/4rDV1EhYvPutSg7l2a3l6he04QYZSDgLvNJ01B7q7jyxGH2Q71ncBfBdKwmt/Ce1CUDVogzN2v4O/fv53guIlNUIsw92xkCajHHa1QolyWgkjXxsaR2UoYvaKLVfTFdAWxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089275; c=relaxed/simple;
	bh=jsKAGpVyi70/CaTywcDyTHUQ2ZX1tU74g/mcwBY95zg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WblDAdNusfsICz0G8lWkJonIECNfqThS2nn1haZ6u7iPv4yY5vcjwCSiKnV0iK6G20IaxZoiAFak5GM5CN8nVKvFAVkm1TQnNf8D63VVjWzKiC1eqURAW68/m/H9isIc8F+0mUzvM6U0nkyZ35I007OnPyECSZ9E9IloiLJ88+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H1OvH8LY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H1OvH8LY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706089273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sw4+VqZXyj2o6JjWATQKebAUbrbfIIJFZxDkqunx64s=;
	b=H1OvH8LYN4lZo7XoDH5pV28LO4HI8LDARkp9ybCAyEJv+mk5hB9EoSiwf/+Qq8+iGihmLY
	hFE4h9kuX5ZyeMW8B30iUK0IracR8FgDyVlNU+uRHmNEzqFbsUcMvGCnWi2fJxipboJkJ/
	JGnqhky5mVlYSevJlYU3B1npm3Spmcs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-g-1PNRrMOQaCOlZIOL6ndw-1; Wed, 24 Jan 2024 04:41:11 -0500
X-MC-Unique: g-1PNRrMOQaCOlZIOL6ndw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a29bb25df84so234425566b.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 01:41:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706089269; x=1706694069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sw4+VqZXyj2o6JjWATQKebAUbrbfIIJFZxDkqunx64s=;
        b=hxFLaneG+rP5WnCkmdtMvNIbwOa/wX0rqRN8HXe+Ga2Y92SvXXEdap5fAD9t98I9yr
         QRrdtVMhTICSysbZ7Jf5c8WxVzDhtSE3oMK9cezQSkiulks1kTSCBgMOpdp15y0DXs3R
         kHUN7aosqindAwA0dsmMUoxj94tCAlEiY+dL2hDJY5oeyvtG7A5StQ22i4DIuIO18hJY
         L1FBA+J9OHGtaKgh23SWfGbUNt2zAqQe7HlGZZJJrCrQuibnPLLQeyoJUNqAgnN/Zkc8
         gojcavyPX5yfRb7TngiC/z0QRPksfIzHYniqlFiyNJ8bWk7UkNiBbruFdEw0v9aqVkfU
         nTRA==
X-Gm-Message-State: AOJu0YzVCOtcwMMxdB6tPVT/Gcva2Uo72Z0HLIVXtkKoDTtUN55Oa0qZ
	9MMKB/sT5vR2uUyuyDOCLBf9lbFjRSVgq4IGoWHfPUWCd5iDdgzqIJYE6xAF/B7F3J8nBB32No4
	FZIPa24Tl3KL6ZT/dUNN6twNHE7XIyOQrq9eiUZXg0MEPUyUP0VizVVXj79AcmlB2YdSFYzafNJ
	rt/F5yCtyPw+1Fp0bp6STG4NObBz0Q5gIUZqB5usHw
X-Received: by 2002:a17:906:b39b:b0:a30:e04b:cbd7 with SMTP id uh27-20020a170906b39b00b00a30e04bcbd7mr627751ejc.64.1706089269699;
        Wed, 24 Jan 2024 01:41:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqpdVrT11bMaratZuDq/IoK6RGt1HKfpde3o2UpQ4F3pivcFmo1CBMMVeFxnBN0gtMOWIvCw==
X-Received: by 2002:a17:906:b39b:b0:a30:e04b:cbd7 with SMTP id uh27-20020a170906b39b00b00a30e04bcbd7mr627744ejc.64.1706089269296;
        Wed, 24 Jan 2024 01:41:09 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id e13-20020a170906c00d00b00a2a1bbda0a6sm15406050ejz.175.2024.01.24.01.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 01:41:08 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandan.babu@oracle.com,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RESEND] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Wed, 24 Jan 2024 10:40:33 +0100
Message-Id: <20240124094032.1150014-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9976a00a73f9..e965a48e7db9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,10 +421,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 
-- 
2.40.1

