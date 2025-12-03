Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BC432C95B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789016; cv=none; b=MqrNiImLLa12sYpOxYl63Cvkh0p98TBQi22/sDZu1LVLkXG1Awbzq3qqgl5/94wxS27KawEZkMikPL1Dw3+I42J5cmCwSLxLIskziLj2/hodFslIin8XR9nZeHknkmb25YDKSq4Xv+cVJ+Fw908zpPyobulTPUHEPYvuveVuTbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789016; c=relaxed/simple;
	bh=QSISyS43uiodKW55y0A4zJy12XqGbRyo3nfKgDoTz1w=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kstptU7UDdD0dOZrd7HR6UIy5YEGFLU5WeuPxzWV+rSQA2j5/VNoyxfE1VfGL3C12w5cZiKImeIzEgDi3pTO6CUWLlGhwwEZSb0CdfKf4W0Dthh3rXwPcpo3zfOfcZE7DRWesPNM61JSMZavNFKPvC+rlvudIxWJCAFHojxIzwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXbXE7By; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+PU8MWP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXbXE7By";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+PU8MWP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
	b=eXbXE7ByRbHGKgFPP6dzv6G4pIVksK+tcXlpMqoahhS53GpRmuOGQOLIO7JiZUvQd9wAPc
	XLxg2FV8zO68T25cRJmlHgk3C2bET6xf8uOOp7GAc1bAfB+NLXIy9bKBf0tsUjPIBYaW+9
	+rNi05Mr1c939CDn7pvw/4W0rq2Es40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-cFOyi_ACOhWycliHT--1ag-1; Wed, 03 Dec 2025 14:10:11 -0500
X-MC-Unique: cFOyi_ACOhWycliHT--1ag-1
X-Mimecast-MFC-AGG-ID: cFOyi_ACOhWycliHT--1ag_1764789010
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47777158a85so978485e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789009; x=1765393809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
        b=a+PU8MWP3TNafQ+h9z+B+1zYQ6AKsTZF7R/3+rD+b8vRhbICQhXcIj0DDIFozu0gAx
         LqmecmMYVO6VIFyHFl2njQtt2ormaXNB1ApwJ+xSLmjvri7ARNQKgiB86DiySVJkkxaO
         2qfTm0zlbjV+cHbSJox8lXxT/h25DnRmhki+XjKc9H3o1vbgv123fXYKzzOTHkOpifAE
         sRZeJzIQ6ws/9CL4b9rqV1Gj6b4JHoigTIlr3e6GaxyhiY4ep1gug9JmNa1PC11bPzwV
         iXRYjJAgJVzkH9pJn1k5LFHQXtf7OhWoK4AqYa2nPazmbWxQJ9HLI+xlqLDb61FX7YEy
         KmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789009; x=1765393809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bl5Gj5NXnNr8xcBo4q+mWeMYRu1rgZV6hfh5U0rIP8Y=;
        b=BtvPxBm8LIB8JltuEnLiekgVZdWqviKtKrowBd5WoPR7+HlnY82R4MoyCD4qLrTIo7
         BqsXiCnyQprdKLhypCIBtYVrtvlkBSJGX4mtCaCWo2a9/lvkE8yynzo6z58DK0eG+GRD
         sbNV3X3ErSqk5PCa5PLR21hba+utKyW15XY+WYEKv6CGQL7E4EkHuILSPMcBcPfFuS6e
         FWQuJ4OWxiL7M4uZSjl9NX0ihwYxCCDB1nVgDoHS9YD4WxMj/5OTr07MlkzBpe4wpAGo
         9Wl+QhtacppzczORBrziObOXjSI2RKYMMqjir7Ar6K4LQsWhw8WD26Ea5W7D0s7fNBrw
         chqw==
X-Gm-Message-State: AOJu0Yx7M06Xs2UZJPsU3t0v4ri1BlgfvD1sDccH+W5uFGhkdifEepuY
	bt/PZbfn88Dv3ziVrmfyWJ5igMmqDsaL0mDPtkeBsI40xsix6403QMl+eZ7/1vNCXZBgWpj3SDE
	XHf8OUikVFWX8xWbVVSfQzLXtDmsO8OMx7DDRIw7tFiDiXNf1f0o0g0uCQmidp0NSmEfLV2nQD4
	zrUbYblnogUDaebgm61bzYJjxYMSKY3idM2eRfVbCMsScF
X-Gm-Gg: ASbGncuztk2fN07bAv/irpmk4YuUyfYPjx08rgT8ZGZ1plvxg9dnzHIT4kkgFYSWYq9
	TkN6mCYyHHTa0N2mS049Ovyb+T+SHhiiTQZXojsf8WSCmvvekbQRHBgb48C8TlJIoDioI2Zahjy
	X8t5mZwwWJmQWUZFQ+/x4LLaBWX9nAQsRF1HyH//REc+VH/z1JHyK/CcecqSekgmpaC8q8Cq7+N
	7hkGlnbJIxaI/fGJ2o7tgm+OeITrGJlA1Yk1i4XWkpDz3Jn5CcEPcL81Afwg07etVxiy277Awug
	zKhw7sE8CAvhSl29/GTDZMUnMtGvJJuhcGMC/pAUOOsrUz3bgyf5IiPjKiC8Tg2UxI9c3UEpUJU
	=
X-Received: by 2002:a05:600c:35c5:b0:475:dc5c:3a89 with SMTP id 5b1f17b1804b1-4792af48738mr41877265e9.34.1764789009387;
        Wed, 03 Dec 2025 11:10:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErO5qZ925rvmRIAnRUCkFcENdx7+lcu8OTsxcz/yOX5mPPAWlkWBgvZT9QAFRpnTY7DWL14g==
X-Received: by 2002:a05:600c:35c5:b0:475:dc5c:3a89 with SMTP id 5b1f17b1804b1-4792af48738mr41876865e9.34.1764789008910;
        Wed, 03 Dec 2025 11:10:08 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a79de10sm70404675e9.4.2025.12.03.11.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:08 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:08 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 25/33] xfs: convert xfs_trans_header_t typdef to struct
Message-ID: <3qewirejhytoqses34lsyem25pv5hmhv5mthwgaajz5tdabxfb@7frmakuhdrin>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/util.c             | 2 +-
 libxlog/xfs_log_recover.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 13b8297f73..8dba3ef0c6 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -86,7 +86,7 @@
 
 	/* for trans header */
 	unit_bytes += sizeof(struct xlog_op_header);
-	unit_bytes += sizeof(xfs_trans_header_t);
+	unit_bytes += sizeof(struct xfs_trans_header);
 
 	/* for start-rec */
 	unit_bytes += sizeof(struct xlog_op_header);
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index f46cb31977..83d12df656 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1026,7 +1026,7 @@
 		/* finish copying rest of trans header */
 		xlog_recover_add_item(&trans->r_itemq);
 		ptr = (char *) &trans->r_theader +
-				sizeof(xfs_trans_header_t) - len;
+				sizeof(struct xfs_trans_header) - len;
 		memcpy(ptr, dp, len); /* d, s, l */
 		return 0;
 	}
@@ -1079,7 +1079,7 @@
 			ASSERT(0);
 			return XFS_ERROR(EIO);
 		}
-		if (len == sizeof(xfs_trans_header_t))
+		if (len == sizeof(struct xfs_trans_header))
 			xlog_recover_add_item(&trans->r_itemq);
 		memcpy(&trans->r_theader, dp, len); /* d, s, l */
 		return 0;

-- 
- Andrey

