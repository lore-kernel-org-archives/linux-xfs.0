Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6951B5BA
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hXNe6su+"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28c7e30c83fso5594818a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359679; x=1705964479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWbtG64sD6BzeK2zveN6cjdFiuTvAXGzco6ErPoMl4w=;
        b=hXNe6su+Yk5kF66MFGkE1WmExqeISpg0LCQM0vHOPGAJfg3VifIzW9KeMDt+C3au8S
         zuKLeDwkhpl/dwpoDajS/0wesC68wsCtbl4JKxOw2g8qdXomnmD/HgMkeTfiU2ZqB9AG
         I6DUqN7UWxAsAqkIbej/ZqRhIZSqTm6yZDGn2RdRBI0nJ2RPHNRFqwdti4kQtEKHYB6d
         UpCjmZoTxkXE7hoRYMV0mIVuNboT4dVStA4znoPdyrTeLdR9TGRJajQP9YQ6e8oLk4EC
         5G9AeGXV8GI1T+ekDpD/soApXsVP7PUNz6/2/KTfqkODHvKrk6Q52UO11TFk5H2nxecd
         yfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359679; x=1705964479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWbtG64sD6BzeK2zveN6cjdFiuTvAXGzco6ErPoMl4w=;
        b=QFiuy4I2KwImGnvS0QrxjCSxXeRoDeketu7TokczaS6+q+6/ZJtuGIeLDvWf3A/QOD
         Nr8HqSEqKgANHNOB2MhlBP61KvQuUNEeNtyFjLtiNgrr+hRG/3VeTYl7erSZATSi818S
         W3gA5SVck8MV8hPE6giALcFRIT4OMlDtjyv/mc1aF6y32hmhQSoe0F5eegr9QhEJlqgN
         Mla0BjtEo7h+jmzc7TDAip+I/jKv9HjVv/g43/qo7QtMlF32lxLq8TsDeVnYTkRuC/MX
         j6QUW4MKZY7c5EPrf3p9k1DNFdIBrgs+HVUmAHj4lKglrqPRA8SDUp9D9nw6fiyTUIhq
         a9AA==
X-Gm-Message-State: AOJu0Yzvad4GSy7eDdznQQKwnvKv/1xaoG/DsH8hJdmwD88x3DeColkd
	8mX6uZVFoRlHpbBbuKW0NIG5+vQcy00kL9CCxnA9Guxczls=
X-Google-Smtp-Source: AGHT+IHzvuZoaCbm5eSl7ojpSx8vkAcqHRsJMQCe+3FzNo0z4XkzqCyZoYBxmeRqTLmj2IAwHX2Rug==
X-Received: by 2002:a17:90a:fd0a:b0:28c:891a:48f8 with SMTP id cv10-20020a17090afd0a00b0028c891a48f8mr2722876pjb.17.1705359678611;
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id lf8-20020a170902fb4800b001d5b2967d00sm4882658plb.290.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtJx-0B;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8fX-2Ebw;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 03/12] xfs: move kmem_to_page()
Date: Tue, 16 Jan 2024 09:59:41 +1100
Message-ID: <20240115230113.4080105-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Move it to the general xfs linux wrapper header file so we can
prepare to remove kmem.h

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.h      | 11 -----------
 fs/xfs/xfs_linux.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 1343f1a6f99b..48e43f29f2a0 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -20,15 +20,4 @@ static inline void  kmem_free(const void *ptr)
 	kvfree(ptr);
 }
 
-/*
- * Zone interfaces
- */
-static inline struct page *
-kmem_to_page(void *addr)
-{
-	if (is_vmalloc_addr(addr))
-		return vmalloc_to_page(addr);
-	return virt_to_page(addr);
-}
-
 #endif /* __XFS_SUPPORT_KMEM_H__ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index d7873e0360f0..666618b463c9 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -269,4 +269,15 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 # define PTR_FMT "%p"
 #endif
 
+/*
+ * Helper for IO routines to grab backing pages from allocated kernel memory.
+ */
+static inline struct page *
+kmem_to_page(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		return vmalloc_to_page(addr);
+	return virt_to_page(addr);
+}
+
 #endif /* __XFS_LINUX__ */
-- 
2.43.0

