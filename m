Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F971AAB9
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706092193; cv=none; b=Hp/s13HLM69HoS2kUAeMzL5RR13p3NxBozepafvz0kBK5uyvkbgi4H4J8Apr2JLLQ55EY0Lmh0staBwwL5xcCwamx+k7zu2rFGkG4ULXn//z5tFjzvXrLMA9pEI8qbOX/rQvTEDrAp0a9vkITSbxYS8UBSw/BHfEGcNCFrHccrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706092193; c=relaxed/simple;
	bh=SxCsdQ6su1xn6yekQQy1UWIJ760PIzHbf3xdpELV+bM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c6z8KFwi5N5ePrLSqQKwMxkC55c+qSBUPpPIJqqF4ecEwWBH5lQLhNl2O10GcPAEj59tdK+t5JCj9fxu7H103mugZBjUO+1vTuCICicweOtl8CffBLYG1OAuO915bdCLQ5ef5sGKoKUrCmZaKRLItt8QmBTVN8FpLGC5stiL5wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJKj8IFs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJKj8IFs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706092190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CrNKUHi12qO7yaLltVnwebSdUAS62xA5uPyJPs/Y8lk=;
	b=gJKj8IFsDJIS79v9nnIR9i+YZVLg1Zh68YxUbnyZI8gqkwsoYI3xkt2+OWVUWWXkNfMYnO
	Konaw7gDajEo6BoyYR3Kh3cu1Ozs5udbjC1Q+Dt/Sw56uL7dndUFwbkaFw0DrYb+eJBpQ5
	6Bz7LxoYGUAikBc/kqSqqmpI4Iz3SoY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-q-Q5U7miPFutJ2HXlm6fUw-1; Wed, 24 Jan 2024 05:29:49 -0500
X-MC-Unique: q-Q5U7miPFutJ2HXlm6fUw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2cddf459c36so36160881fa.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 02:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706092187; x=1706696987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CrNKUHi12qO7yaLltVnwebSdUAS62xA5uPyJPs/Y8lk=;
        b=VfrT8n+nuFLBrnc+429uRc1kx0Wo84HjN9Ehqz/F6PHVMBr9ElRSOcPMCg1WnVfVzu
         YuTjcLn55ykh2I07zr/7c13h/WP3Su1lTELYIMp/BaCSHs3/A3+VF6KpjVekpLBeR5MA
         aF3CQPr71SjLKe5JeTMhuiVR9BIKznHV3gBoAP6GdRPDy6Wi8+iV6FbI23anJlT2Ku6y
         MO5xPIwHJg1VGWwtBeeZoAQQFnZkGXAOcFLn6cFv6fM9qPdpcBXRQeMri9B6sZQAogWr
         R7ogeI7kALOYUQ+CfkbiGR7bZTy45bER0coUVivWGx4NX4oOEnOfEHVNpaB9m9INnSMA
         8uSw==
X-Gm-Message-State: AOJu0Ywk2uBQJdc35FmJDW34ZpBFkwYkemaymeBNVxIJup6Mc8bVZb/c
	ksga58ar+ZqcjMvtXVnrgUAwAARN0SuHZzfcYFAipHAC9NFXL3weCWJ6pHIPNsT2NGT3QKRe3Qy
	LEJr96Wb+FowdgQFcb3IMgbcQ5bX/zEvSFUprh7TL/bKtMCFFP7PKpxDFOeGD27lsLIlZ1xuUiq
	xcoozKpoNC89MhNlzVecrxso48OZKGTzey1bMtxvkJ
X-Received: by 2002:a2e:96d7:0:b0:2cc:e3c1:19a1 with SMTP id d23-20020a2e96d7000000b002cce3c119a1mr720633ljj.26.1706092187304;
        Wed, 24 Jan 2024 02:29:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGc0XiR7HFKgNeNs4i7FtNpomRYTyXAbqSo5OVmCwKvKCtMrvyV2ZJAFcSNovMIz1ULT8Mh0A==
X-Received: by 2002:a2e:96d7:0:b0:2cc:e3c1:19a1 with SMTP id d23-20020a2e96d7000000b002cce3c119a1mr720622ljj.26.1706092186882;
        Wed, 24 Jan 2024 02:29:46 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t34-20020a056402242200b0055823c2ae17sm16432789eda.64.2024.01.24.02.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 02:29:46 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandan.babu@oracle.com,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Wed, 24 Jan 2024 11:26:44 +0100
Message-Id: <20240124102643.1164019-1-aalbersh@redhat.com>
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

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

Notes:
    v2: add Fixes:

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

