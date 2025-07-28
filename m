Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1327C84B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734695; cv=none; b=ZZcljbcb9Zbqxr59DMKeRBVJSM1KZCAZeAz8R2WgUKP7oeTklhpCdY7M4x/bhhatCnm0Eca9vXMMtujtoEySEOPLD4xw8wI5SmG2hC16GY5SbHT1quUjo41JcV3Rr/7ITIjNiJf6cV9CBHvxIDEU9mOD52fZdpjfOXhwDOiVzHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734695; c=relaxed/simple;
	bh=tuQ8f/tR8bjNxLfdJGG+rXIm8Iltuw4mIWHpny+mKAw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=j3j7SPfFILXlJQDBVytb5zfqgyjfVocaK58Ke/nsLGnD5SQcQAkwsGHebCkgahClQEUMLMolbWquIuQZ5f3Vihh7cO3KH1Ad+Yim/7ITH5GHXtnyGtDZ6VsIvJdA7crVhRtZhs3gZEnTUx4QiFpOJL3aNg93mUuENHxzu8RkzWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IrnQIyCJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IrnQIyCJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NhSSjYb+lsJdO2qb/nLz5H47+MobT7klHyOkyC/1bzQ=;
	b=IrnQIyCJqVTbqqlzPS2Ya+l7YckNrQ13UmMQuVqCRa8SSVY0GDDgr+oWuD6bB6AI7C2sd5
	xh/7e9Og0fR/hypkrNHlMxs+EVoO3BxlDaZK9I3jDoJulWQKj1+NSMy6L2NzBBtkHCXx1K
	THT0joUSerIUTopK+vaNKkdbh7oukMc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-2W4CpMXuMI-XE28PNl3GmQ-1; Mon, 28 Jul 2025 16:31:31 -0400
X-MC-Unique: 2W4CpMXuMI-XE28PNl3GmQ-1
X-Mimecast-MFC-AGG-ID: 2W4CpMXuMI-XE28PNl3GmQ_1753734690
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-612b6aa7ed2so4639514a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734690; x=1754339490;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhSSjYb+lsJdO2qb/nLz5H47+MobT7klHyOkyC/1bzQ=;
        b=lgEv9kJYZuGDX3wVPIYrjP4eRv/O+Y84+4YzRHZu6MHAphRh8QrGnlqAqNkJGwEeeU
         FS278mE63j+r04UqRFkr7bAXUuXWiQW107Fiunlph7qZtoKxqqjrLPVbtcw/lpZlvcxT
         /MolEIG/bYIb4tI8GXQ9ADkbe6q/d6ZzhPderti7M7WKig7sD3wTKuUstCMmZeoSUU8J
         HRgE+OrJxDK0nUK3Vg2DAzJVTNOQD7JVuy3bVt4D14hrL/yBm2CgK+Yc5fYbTTIfBap0
         FmYuSxzaM9d9MO76bGJMe3RrkNRv8gKcwMtHS7UaiqgA111wu+DQBanmsFAqoay3g3QV
         CRsg==
X-Forwarded-Encrypted: i=1; AJvYcCWv+gV9M6cP/tveN+0X3UdQFMhinO4bHRsb6S4j+7s9Ud7CS0JTCWs/c1El8aMXECKvl59lg91fmkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCgo1lIpF9ZCQ1zq7ZGwA0h94z4VnzX876ErzwoIYxlvGE35Xm
	jT6P7VdbiwWrtbxUyszFYhR0jm9zL1yxGH4tgqECOCNlilViUcZhbuNCP7gZI8ZisH2TPLfcndj
	eCuruF4Sg8lp92z0w1n71gXA5fbbWmZJmDixcoAYc71Do0s5lMkK50fPo0DtO
X-Gm-Gg: ASbGncuSLjm2PJeVSt9qcMjqkVOTM9Ag/tOMPDRhkl9KO5FP3LShamvgf2KQdyRiFFw
	wmnx0QA/jaud7ww11eCpsLecE/oVt9l7NZS5QwrVWxpQb2tBblFM4WeQoVkAAdp1Rn/A2awkbHC
	RzJIPJ1MlhYOxiehyZB0XJOTg9TN42aHM+OBi/LoJS42XSoP9gdNudIVH43jn5BT5h4rTYJlL6Y
	vPxIp7Pcc8Vlzs8GpVBHTN89u02eVpkJV8pgcajPyWfO20QesrW6Kl0XAK53+zqsSssbCX7WMUe
	I7PxeGlZbbEhaSru52C82tpWO1yIerPagixHZd+yylPrjQ==
X-Received: by 2002:a05:6402:51cb:b0:612:b723:4d95 with SMTP id 4fb4d7f45d1cf-614f1f2e494mr11033332a12.30.1753734690307;
        Mon, 28 Jul 2025 13:31:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXBBqy/vXldtxYvrueHJwpZSvjKZbwQ5tpqwAu8FXFyHDjYlJYgONObn7uPdVanUULshRM+Q==
X-Received: by 2002:a05:6402:51cb:b0:612:b723:4d95 with SMTP id 4fb4d7f45d1cf-614f1f2e494mr11033310a12.30.1753734689864;
        Mon, 28 Jul 2025 13:31:29 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:29 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:13 +0200
Subject: [PATCH RFC 09/29] f2fs: use a per-superblock fsverity workqueue
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-9-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=x2fKAqj6yt8VbdL2CBtiIb5g4L/wAAI+BQgEGBHb3is=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrviU9w/cd0wMBlz8mjEoUXGhI+xnT1muzczC9Xc
 r5SfdImZ8GOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE9H+w/DPwCfpgdSX8PiN
 e6+ZROQZ9tyOVb66MuKFruz8jV1VC4tkGf7nfrzP47+oXuLCn38L324yOnHy1wvZTbMUfThP+Vz
 MsT3BCgB9sEqV
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Switch f2fs to use a per-sb fsverity workqueue instead of a systemwide
workqueue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/f2fs/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bbf1dad6843f..043e76b8efae 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4634,6 +4634,17 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 #ifdef CONFIG_FS_VERITY
 	sb->s_vop = &f2fs_verityops;
+	/*
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
+	 *
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
+	 */
+	err = fsverity_init_wq(sb, WQ_HIGHPRI, num_online_cpus());
+	if (err)
+		goto free_bio_info;
 #endif
 	sb->s_xattr = f2fs_xattr_handlers;
 	sb->s_export_op = &f2fs_export_ops;

-- 
2.50.0

