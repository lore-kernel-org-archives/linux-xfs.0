Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005E5215055
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229477; cv=none; b=s9xZx/1VZsdpo/9NS5LWJnpA9zEFr5nZSCphcQelkO7UINr2IdctcLvg8B+bU3ZQKZ8WvwLiJopAHeUrWHl3FeknpvvHLTOUR/RiC+l81OuPGBD7bbqsHlgiiFfqgQJ/0B9BdTzPgXkUNEwYWceqPOFPoxCSbk1EcTRUUj6mjb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229477; c=relaxed/simple;
	bh=Ui6S9HS3D72Dvt607rkAeRvO/cjZeK06ykAfQjo8x1Q=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfxUKP4SxlVthmdcI2PblZJu3dvJG66p45llzyTBnnKldD7EHRJYLCk0pmvJ2VmK6Tec0ul/tpiWAgv6L9r/iP/sSew6d9IyJkl/u6Fzi9C0eM0VNxTdtNlZczbydta8KmZvQiQ5XAsrr5bqnNvH3AGIyRl0uy7imkl9fj9U6JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VO+K1/RO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lDQHUxPA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VO+K1/RO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lDQHUxPA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GkYVW08k0HM8Mu7wCr7O7tI/HJOedcd0CF4Vxrv4g90=;
	b=VO+K1/ROl+MWUQWiNn/g/uL6NvYeCFxyL5hAHCBF+sjllVoOewv4JjqQnz6GKcojUjrUHx
	hzsoY8Sk4lh9lJV8vI7weC/va8mCIUIxxJWzz12GIJJWwFtDD4L5JYq4Ifm8mzkZPDV696
	uaqGDmnf+y/JfcBmS7x9WHSi9TZtGXw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-4CPSisi4Mq-uwj0xAg0EHg-1; Mon, 12 Jan 2026 09:51:13 -0500
X-MC-Unique: 4CPSisi4Mq-uwj0xAg0EHg-1
X-Mimecast-MFC-AGG-ID: 4CPSisi4Mq-uwj0xAg0EHg_1768229473
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-64b4b64011dso10993026a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229472; x=1768834272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GkYVW08k0HM8Mu7wCr7O7tI/HJOedcd0CF4Vxrv4g90=;
        b=lDQHUxPANfydzZOUGK2nZuKbf5M6x1fGzt40YirfAMSvxnIzQ1/eyirLxOlHSDxHiz
         EkC0h6+nviKgPYLfksCbotB7MontMnURDPEhcgq6gDj0XMAagOtJ2KUPOV8bSxaR4n/t
         sFQPVbwa7wrIk3C9FgSFk2Va1IpWF2Fqsb9q+W6nOGCQ07ESsBStXvjQS08FuFL/JyXo
         ssDg7yzIekeYjhwgjOOq0LJSU6v4V8x8jProVCLgaQrSTkJZAypCnKZVm7shBKwnUdQz
         iP/I0fdQljrwt2PS6DiFBC2AjhFVRG+V3mKNk0044mTH3qb53Fekj3lNKIB3Vp/qikaf
         A6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229472; x=1768834272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkYVW08k0HM8Mu7wCr7O7tI/HJOedcd0CF4Vxrv4g90=;
        b=toEu55RYe4gQ6ShdEfcBED63zo76xwZDU28tjV95VMWmqrbWhGj+4fudqBhfz8t6Oq
         f1D7zmwwKUnXMjrOUhZMRBRUeIOdOcMj557YdTXlNkKVxxLh1XQMokGhKcDZshFGHJDB
         kAZ89SEK7P8YknIsfUi3ARMkUvUc0c34ckn1NXb5s+7ShGpfdjO5Y6KicWpjzXmQBJVv
         HYJNvNnJaY+P7FRaKMMJTmOh6Glq8mKpEZlDRHgYm3R4FuwWg+WIVSUJ0fUh/4h5h+1A
         T447n8HfWsYyaJoGgHqaEtqumIxZNlNfsKdnI+fSbEYAn/MoaDDBZu5/SPB1ZBNHEirc
         mBIg==
X-Forwarded-Encrypted: i=1; AJvYcCVCE2UnqDfkF2AANGL78y1Ece4F/HMkb2ujJXXB6ybpGRAsZ2UmTQUHrhmMsAGCS4M/7Gshrz+q7cQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw32aaV6wRQNtrgNxbqo22z6Fgb2/zUdWeAk6ouCJmBNrYuYlPa
	UZSD5JI8zsMuQBdN23ybRKRdWwrCOkZEFgoDMT1NRUP7CJxtSB+DJL9VNP3ob0kHqUpQq26Xid2
	lecEmByRV0LuvDF4pUB4UjVdPe2jNf6qbgBHuG5yYgnPaURnhOkkT5eT9jU3zukoL/uCn
X-Gm-Gg: AY/fxX49XR4UYPZtT8u6Nzpx/gixa/yPIgPzZiLC84+MDX1SYU8gjVSldEjIZvXXhOt
	Jf1iZd/GKEdZ+Hjnz+qxbg6BxhrVdJR++ZsETWZeP/+ikoJ4fc/lSYbMcnmKT6WjJD6Qq2+bQ6M
	16awxs1HeJcMCYdpCRy3i+Dw7SAxo1CiPamDXQmC9368yM8qOoEIFcBoFYk/kS6IhyDCLKSqFon
	l2Gq60+5aG7+ROiYEXspgCbhCo3I6pgKkLjeyxKrqHCYK0SNEqkcKj5AnUCPfexU728YDbqN3J+
	uoLTZsDpQvr39rGU0UYZazcu04xUM3Smh2wJ2SApBvL/0xIaigD94zKEPUmG+c5QqfCHbc54O8Y
	=
X-Received: by 2002:a17:907:3c86:b0:b7c:fe7c:e383 with SMTP id a640c23a62f3a-b8444f2399cmr1908210466b.22.1768229472361;
        Mon, 12 Jan 2026 06:51:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQ1ZUBBBfOOPZZu6PAvc2nvhedv6mbNuX/r+QasAtk1f3qnZVL9hQtJxfwvPp4FpofexbIuw==
X-Received: by 2002:a17:907:3c86:b0:b7c:fe7c:e383 with SMTP id a640c23a62f3a-b8444f2399cmr1908208166b.22.1768229471737;
        Mon, 12 Jan 2026 06:51:11 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a4d1c61sm1897676066b.35.2026.01.12.06.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:51:11 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:51:10 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 11/22] xfs: add verity info pointer to xfs inode
Message-ID: <7s5yzeey3dmnqwz4wkdjp4dwz2bi33c75aiqjjglfdpeh6o656@i32x5x3xfilp>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Add the fsverity_info pointer into the filesystem-specific part of the
inode by adding the field xfs_inode->i_verity_info and configuring
fsverity_operations::inode_info_offs accordingly.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_icache.c | 3 +++
 fs/xfs/xfs_inode.h  | 5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 23a920437f..872785c68a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -130,6 +130,9 @@
 	spin_lock_init(&ip->i_ioend_lock);
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
+#ifdef CONFIG_FS_VERITY
+	ip->i_verity_info = NULL;
+#endif
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d335571..f149cb1eb5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -9,6 +9,7 @@
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_util.h"
+#include <linux/fsverity.h>
 
 /*
  * Kernel only inode definitions
@@ -99,6 +100,10 @@
 	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
 	struct list_head	i_ioend_list;
+
+#ifdef CONFIG_FS_VERITY
+	struct fsverity_info *i_verity_info;
+#endif
 } xfs_inode_t;
 
 static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)

-- 
- Andrey

