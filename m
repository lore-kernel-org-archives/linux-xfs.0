Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DB7132803
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358383; cv=none; b=ljHxgc7R0GtFRNGN15c1lvpTqmCaFUIykdTlBqP5P8oRof44tKO+xaYfVRsgPLIm/YJ2joNIMyTwTwStoOjNO1rStnBD8/GU3KZV4zgDiG1H1Ohlcy4YlxgLVE6dSd2L7KfvBCFJPFqqfYGDpEBOHAPBHBir6kqR+MKaM5v5zsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358383; c=relaxed/simple;
	bh=BXFADOllrM1UVBKYRuTMUGphNwRYGkcECWf3FM7Nekk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrTpPP3i//OeECtF7oQfg4DqvCy1NVTvnC6/7N2PZRIubM4fVh23AEM2fBKyVN0T6FDxMKEU2mFpa4RbW+/b+a3sc7HIkSDZLIutm0xcQ2Xrl7ePoa3D3dvan5cV0HpXkZ/reCyiZaY0JuVjYNUuzV+RxjVlPcwpXF8S3yx2wCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SbzVZQQl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbzVZQQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lSe+S7OK8mtqrgnzypf5LaiZywQ+Xf+tz3DhSkUCjo=;
	b=SbzVZQQlim5s58VScOtVsgWtULL5R5QupndoNbx6EeT7by89OFw0DylfaSzTFsVxSCVEbQ
	vYp9RJY2px4SlUzb2JXXbzcgiFhBXRxhL03yjEnxoCfhiuznzZRAwPJvPKdWQHvcBVr3Ea
	4vL5id6Rrr0tm6N7LtQVZ6/uMHg9aRc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-WZrgp7irMziG9I4NguEhjA-1; Wed, 17 Apr 2024 08:53:00 -0400
X-MC-Unique: WZrgp7irMziG9I4NguEhjA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-516d6c879c5so3133091e87.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358378; x=1713963178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lSe+S7OK8mtqrgnzypf5LaiZywQ+Xf+tz3DhSkUCjo=;
        b=OrSKdrtuLTGccP5TL0QshHg12eLo0FBYq4m43D6XL8dXoANa81AcEDsrsplWh1NWuT
         eUqR2j+/vpYk8K+spOKh9t7jxPMAOK4M2AndAMsAd8u3eDVIhY8pCBt3IUJ/l0hqOHgY
         VqWClSwXSp4ZIbhs68+gR4Xv1E/mFa1TuN9inXtDY2Nv5uvD1gOo3KmFGMSLILKSC0vh
         CaM/YZ08j4+MGfRxm8NOC2nY49+2PIsqw/je4XAlZBAHPgT5wi8l4ijO/cM1P3P9eh1j
         VewkobF6ISimvzgGlgkFUtRiP2+jxJLCZys7XbpayZoW1ZUsiZSwYV4nLj2o7bFxpGuM
         BOjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu9aVIK9XZjAzkNNjqCRlgORIh3KQAYcZStXJoGUqJEYI/JomJ7iu5SUwph1C0XYL4r2YLYTxpgTCbCfc3Jz5BdxbAgTI5CagJ
X-Gm-Message-State: AOJu0YzP8R93O+S/0aWpnEwYZCJnXFpudpDsEbfA5ESPHrst3+rcyR1V
	o5DHJ0jOHWCDIc+ntXdsOdIwa0THvvxOxujhpmvkdPwJ4/IjcSH2Or+FnGggi43VUARCl53O+y7
	uB+JnlgHcpYfkM/MrVxKRaFjxY+SNkkIoLZ1Z9/M9w1ultEGyFeUw/tiNrJAsZCKx
X-Received: by 2002:a19:740b:0:b0:516:bea2:5931 with SMTP id v11-20020a19740b000000b00516bea25931mr10263698lfe.23.1713358378274;
        Wed, 17 Apr 2024 05:52:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRScuA2VAP7ngevppA1bCXvDvhNpTMhkk2Oams0lo/+fWB3VtzFnlY8GdAlsDUJLArpl73aQ==
X-Received: by 2002:a19:740b:0:b0:516:bea2:5931 with SMTP id v11-20020a19740b000000b00516bea25931mr10263678lfe.23.1713358377697;
        Wed, 17 Apr 2024 05:52:57 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id en8-20020a056402528800b0056e2432d10bsm7258169edb.70.2024.04.17.05.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:52:57 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3 1/4] xfs_db: fix leak in flist_find_ftyp()
Date: Wed, 17 Apr 2024 14:52:25 +0200
Message-ID: <20240417125227.916015-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417125227.916015-2-aalbersh@redhat.com>
References: <20240417125227.916015-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When count is zero fl reference is lost. Fix it by freeing the list.

Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/flist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index c81d229ab99c..0a6cc5fcee43 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -424,8 +424,10 @@ flist_find_ftyp(
 		if (f->ftyp == type)
 			return fl;
 		count = fcount(f, obj, startoff);
-		if (!count)
+		if (!count) {
+			flist_free(fl);
 			continue;
+		}
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
-- 
2.42.0

