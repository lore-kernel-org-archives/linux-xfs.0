Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656171531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479538; cv=none; b=olfq0j13YzrhkeBzCkEW88Nsvwf7dNRrvzzznsfayBkzgP/F6i4LHV6ZMSpkHIGUZawOdQsyN+xQhrgsFC/X8nlUlN5KoPjp3NRITSYz+SdBU/zZZ4CTiikqcSdpH4Rxztai7117oWSBJBzFo/jBK4QTjPhhQvnnw4yPemTJE0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479538; c=relaxed/simple;
	bh=xmZB17e1ctO0w+tRaqjoeTT4ax83k4gqfbI9W8TxpVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a15NFjlJVwid1KP7B5dyib4/rPU4CtKGpSjy/ZyEiw2j/bgOu/UUi40cnAtd7o7ra4vwi3JYKf/dBh0zQ9GVa2p9NV930epTURxN+lVv6l6Cs5FLSJ3Xx9FZL/Y3Q5XVCx1H3XtXd/qN4HC3s6155GP7MmNea9hJaag0YQTVF8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XiWNXYgK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XiWNXYgK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlJE1BaTlse1OjGFNGszEZ9VdHnyKCI1Rx3qmWfoCOw=;
	b=XiWNXYgKXl/evGbQEObDJWFw0E3fngPMJSBvbGsBFBxNkHBYqQAbWRB0rQbY8SDN0PQssI
	qiTF2Z+YBRL+Sv7mbiNqldVxEYxmkp3OnSbbMKdxUYmx2q9c0UOs2Rfs3zWi1zFNSC9Jd/
	UX5CRBk4yUpqAcOvqzhfO6H1caFw1Mk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-WxqeeEhINsapv1Curuofuw-1; Sun, 29 Dec 2024 08:38:55 -0500
X-MC-Unique: WxqeeEhINsapv1Curuofuw-1
X-Mimecast-MFC-AGG-ID: WxqeeEhINsapv1Curuofuw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436723bf7ffso49567035e9.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479533; x=1736084333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlJE1BaTlse1OjGFNGszEZ9VdHnyKCI1Rx3qmWfoCOw=;
        b=Mpwao9ah7gjT6pRHXjAYGnXEj5mXX6SiSOuNjY1HeRafTYHDPfubabwgLOaL5NjVO2
         z6KnYe0rTexg6Oe4mTNV/aJiAXc3KD1ycqSmLAK8CEl6/8UjEgVWR0I0MhPFJtbmmLeZ
         WaPLzQqbBRbyAE7lpAXGBHAUWcfGx8uGouf7axqxje/BsIMGwBZU9bTvA24+Ji3ZYmY6
         VBh3xV9zJggdAYdvERdXByTOixPVr3f0S4HZir5DvXNXYBdcjXAYqY0P9aumWG6HmIgG
         F7ZSJ5H6eyrwd+ukBscIOyP20RiWSDjKWrPU6qln0g7CFH4sfszoz6Phmm5HE2l8Gkga
         W0UQ==
X-Gm-Message-State: AOJu0YyzhQLYcgS/3hQviiMbJx4O8DnqKFEcuYGtCaZ1iRQgctaSA9LX
	/d7jFlVkw4wA5mAsvPcmW5LK9sIohBBhAjY7xnubL7QXamD3kFPaYjgxEkC1k6GaRhmNBbXN2RK
	h46DcYV9mJBgQ4N8iig8fvCvcKP5yg6X7D4qNr+PVrN/j5yhK3ZgQOJZgAX8up/5owEoGEt+dEd
	1mUmDF7I7ekP8BdcfsHY8RGKs2eTTLekN9/HyBxYs8
X-Gm-Gg: ASbGnctbic3mWsELXGV7afsqhwZZlYoP3292K1Lan2i5x1SxgAmEGAMP1WCSMxvr+uC
	8tnXkaduDG2EInAjqqc1sOCCqUC8akpkZ2Z0XG7jhfN7eESehmJ4oDE8KgBlZGPC1/9DR6lFTzl
	cEMsRn1iBzvPPFmJmkrgRegiUwmUEBnoi+lCLmCEMVrlgUy3kDDnkc5r1NIQCWBf/zNe+03H0jz
	I7+Ge/3hzPqgiznAKqTS/sZKY2DVCEm6yaU0Lfpp5ttfk4Lhgl2hZ7i3B5YZXBCjxocG5PTmDES
	+aTUeDqkzPWvA98=
X-Received: by 2002:a05:600c:35cb:b0:436:1baa:de1c with SMTP id 5b1f17b1804b1-4366854c186mr272513235e9.13.1735479532675;
        Sun, 29 Dec 2024 05:38:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUXtCUFh8mSdGkZTOFcwXIdyMvofdws43jDP24o1Ht2UgYjrfXs+LljdB7IHFY1WRQHRQ6aQ==
X-Received: by 2002:a05:600c:35cb:b0:436:1baa:de1c with SMTP id 5b1f17b1804b1-4366854c186mr272513085e9.13.1735479532258;
        Sun, 29 Dec 2024 05:38:52 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:51 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 03/14] iomap: introduce IOMAP_F_NO_MERGE for non-mergable ioends
Date: Sun, 29 Dec 2024 14:38:25 +0100
Message-ID: <20241229133836.1194272-4-aalbersh@kernel.org>
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

XFS will use it to calculate CRC of written data.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 4 ++++
 include/linux/iomap.h  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 93da48ec5801..d6231f4f78d9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1651,6 +1651,8 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
 	 */
 	if (ioend->io_sector + (ioend->io_size >> 9) != next->io_sector)
 		return false;
+	if (ioend->io_flags & IOMAP_F_NO_MERGE)
+		return false;
 	return true;
 }
 
@@ -1782,6 +1784,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
 	 */
 	if (wpc->nr_folios >= IOEND_BATCH_SIZE)
 		return false;
+	if (wpc->iomap.flags & IOMAP_F_NO_MERGE)
+		return false;
 	return true;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f089969e4716..261772431fae 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -87,6 +87,8 @@ struct vm_fault;
  * Flags from 0x1000 up are for file system specific usage:
  */
 #define IOMAP_F_PRIVATE		(1U << 12)
+/* No ioend merges for this operation */
+#define IOMAP_F_NO_MERGE	(1U << 13)
 
 
 /*
-- 
2.47.0

