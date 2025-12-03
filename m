Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DC72FBDFF
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789062; cv=none; b=WfUAxdGo04xh4I7RdpxtwDDfXYIWZcfxypTVQRl/0iYFo1paxOe0WVAtk/JxGO+4h32iHOaxb5zurvqss5SKpa8Lur2iMjHHFZLdBhpscEeKP/oOVPIQpxrUssvqiIo5/sSdYJSTZrkRWFMk+EEVCZ9kr4ySaNlFsdclCBtzzeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789062; c=relaxed/simple;
	bh=Qe5NgPCn8hnxRDBtRW8+U5DYr2lkTh3ePKzUCIMdQvc=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9QT6jSRBYUzvRVlkcwmEKjzFqLsy4Ka7XRwYhdQhQBhE+qszK3QBQpoYPxFfmDO4tnxCDc0K36THGwBAG1RQHH6U4lVRbntCzl28I19KG6prSaDTJWIdU4XRW8u1jyAHogxApldaBqyUwSp0SmQd3fLgn+kIQ0MoD2iakSwgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sg4LixXU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cN6lBOO+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sg4LixXU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cN6lBOO+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
	b=Sg4LixXUAUiKRBM25X/loSu8FLtYUPEg++wIzROeSPhu5zrqiEt0VmbIrJygeyG+7mk81N
	NenrcyEecxE7g2Q5mXQ1DEZjWV7cHW0I5lb1mF3r9ZqRzZ/BkzmnYQLBnqc9TyD1Tx4NVR
	Hml5wNSS/9xXNZZjAiGV2RPzoAax87M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-fHhhDJnIPIOXJuOCoTYmlg-1; Wed, 03 Dec 2025 14:10:54 -0500
X-MC-Unique: fHhhDJnIPIOXJuOCoTYmlg-1
X-Mimecast-MFC-AGG-ID: fHhhDJnIPIOXJuOCoTYmlg_1764789054
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477563e531cso701555e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789053; x=1765393853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
        b=cN6lBOO+kbpJstNUslz3o4eQEvRBNrpNJFA8RJ+hEQaOo6x5OirhBfkdqHXj0RHwpy
         cltvNcTP6IQkrZT9X8ozRjUsC8O+ugSg7+oHnG2CN7/xk+OioisvemrIvWyZELD+4axD
         f0omWW4IyLHpq0/jwV6rqllYr344uxN6gyCe4uOKUGy3GODVcZaXJ7jystLLwXwGcGWM
         FcaNykcLUSx8DEeqS7KYOYU7Ldg+iFQD4IlDnxAjmeFKobcKVxrjsdSb/vH4li3WYrvL
         DNFOFuy+ZPC/abYBsL3WhecAu42FK5hyQp/uK0izi8e7tLpb/gtY4Fyd0e3yeOplZ8LF
         sN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789053; x=1765393853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
        b=vorZPbucCga5d/jAGXTQVlGpCvK9EVkZZ55Teo/Rd50TkKBoKgJgILGKptTvzA8Pv+
         0InivPEZjOi91IacMiNEdiaVhLzeLiykFB7r1Q995ur6HaLcJ+8rK+7Khe/4BGXC75hb
         4n3BgX/pqg3WgQK2dWkNKjDg/x0TfXQhFSCLDYvBdU0VhMl/KRXQSgsBu39gEEUjsgm1
         C/ZkrqvRYi+w88YfQhJLxTiI/Li19Gf8DQMx5cvkDu94uKmhgE8TtvjXJ+tg73NuUXMq
         nMb2HUjK8jGGmsPnd8kTuYm87CnBTM8uBuHoFJzD/IS2h0XT6x0rKmnPfAzlzhZTFcQz
         msyQ==
X-Gm-Message-State: AOJu0YxUMA3lKGzcjH/sgXrTsluESz9zScV1cfS/VOyylx61lvBqs/pD
	nOhpEvSZXxEHkbjNeH8wva3E8ekaemBXQHvCkG6v7PR0kHNBtXcvQfLTqGFtga178yqTtQA31hB
	pbNWvlFsePXPGavg9L8sJP0EtXmaevDynT38jFVmb+S8SJJ+H5e7W69b7Ro7pDI25GDRqZ5Xot6
	ayGH45gFrO7EgENG5FUZDa7SGAKPquAl+8lsHHhrbYExkX
X-Gm-Gg: ASbGnct7qZFZ9bzX5RnJmqB2z6jTsrlnGkC4w4Qaw8iSy0Aeo97m4U6c3fA89yztEKn
	g3m+rHA0047HlElWrhAVw4Nqq6Z6SBQRGPmKAC6SRVH+/dyNjuHe/nkXe9RHieKkFQIafp+K6ly
	V7aNgXSgNIDNrPPyq4aUBMbPuQeYsL7W/x2zd0d+7NIUKImLyLgM7XDQbDgIesssbhuJCU6UaU6
	213x2e2/wyAhbRpQt1Z0qv5+hAzZifh9WB8Iho5yOki5MG1DrNaq+mhSR0sy9jaJPSmTn9sinWI
	/o6ad/0MjfT0npzYX9kSQEKUE94YEkQ1ymo/DncAKBvdinud+I2hPVeMfKA0xs7Ebc3vBkQe9eo
	=
X-Received: by 2002:a05:600c:354c:b0:477:9e10:3e63 with SMTP id 5b1f17b1804b1-4792af4d4fbmr36112605e9.35.1764789053219;
        Wed, 03 Dec 2025 11:10:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgN8vbfBUCoepxygPQNa4vyDdeluQU7Tk9aVfa37Ejo+mrmCsqTPw2ZzjS/ndqw9fAA8rl4Q==
X-Received: by 2002:a05:600c:354c:b0:477:9e10:3e63 with SMTP id 5b1f17b1804b1-4792af4d4fbmr36112275e9.35.1764789052803;
        Wed, 03 Dec 2025 11:10:52 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a79dd66sm65814025e9.6.2025.12.03.11.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:51 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 30/33] xfs: convert xfs_efd_log_format_t typedef to struct
Message-ID: <svt6fdutwrz4s5bh7qmcpnfxrytiwqwysxp6k7cvh2rcqaqk4d@cxaxwt4dzl7j>
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

Align function arguments to new longer variable type and fix comment in
xlog_print_trans_rud() with wrong xfs_efd_log_format mention.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_redo.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 5581406d43..b957056c87 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -187,18 +187,20 @@
 }
 
 int
-xlog_print_trans_efd(char **ptr, uint len)
+xlog_print_trans_efd(
+	char				**ptr,
+	uint				len)
 {
-	const char		*item_name = "EFD?";
-	xfs_efd_log_format_t	*f;
-	xfs_efd_log_format_t	lbuf;
+	const char			*item_name = "EFD?";
+	struct xfs_efd_log_format	*f;
+	struct xfs_efd_log_format	lbuf;
 
 	/* size without extents at end */
-	uint core_size = sizeof(xfs_efd_log_format_t);
+	uint core_size = sizeof(struct xfs_efd_log_format);
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_efd_log_format_t structure
+	 * xfs_efd_log_format structure
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
@@ -225,12 +227,12 @@
 
 void
 xlog_recover_print_efd(
-	struct xlog_recover_item *item)
+	struct xlog_recover_item	*item)
 {
-	const char		*item_name = "EFD?";
-	xfs_efd_log_format_t	*f;
+	const char			*item_name = "EFD?";
+	struct xfs_efd_log_format	*f;
 
-	f = (xfs_efd_log_format_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_efd_log_format *)item->ri_buf[0].iov_base;
 
 	switch (f->efd_type) {
 	case XFS_LI_EFD:	item_name = "EFD"; break;
@@ -376,7 +378,7 @@
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_efd_log_format_t structure
+	 * xfs_rud_log_format structure
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;

-- 
- Andrey

