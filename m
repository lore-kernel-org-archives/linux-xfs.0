Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03402185B1
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694455; cv=none; b=op2CAfMqUp7An443d44kikEQ6cs1PcnZfI/QesNn7b7o4d2uFNRBs4B/C84jHXAVintSD6GIJ7b7VkMMt7krPl0YT4wonzMit8gcIfHCsVJQQxK/eJG/1H1uVoWn6WQAbKYS+VfLbB6FKWUAD+614lv+i1WNHtaYw9G/ax30rUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694455; c=relaxed/simple;
	bh=5aF4vQlX4IWk/A2NPCkx1AC1gg9EhefFpxQskvE/lAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spwH+ZXSvSEnc2ohseqMx+eoKrLvrLKIkFuYG3fR4vMvAtIbs3H4JccYhL8RIl1+6UZknISKhdMB0gxaXL13+B0Vw1qFd/u2zIraPpqZxyTVMI4M0igg/aalvI32e2JRSV40fDHiSS00JPopCKwdfh0Q4/jJEFbSzu3GcaAbDYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Sq+CrKOj; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Sq+CrKOj"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844e394395aso148763339f.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 10:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738694452; x=1739299252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqfbJ2Y6bpJkFTQHSruEAn+XekJDYu6xxv7Bd/Rc/lg=;
        b=Sq+CrKOjZb3KAfrhN9AA3bmywPW6k2gnoiC1iIza5f9qo7HdJF7DeG5YXrrGKGK9MT
         syL/qB0Ya0hv05BuoykqNQ8HY7LVvfFlkKr9fSrbMUQjf/poc/CKaZpF6QD0RZ7Hgaqe
         h4qR/CrouMSXHU+HvWYpIjOKUqRgTVbr55dCjbAyxz3q2ix5M/Tzezerw4q/qn5PBtSi
         uAERmAW8P+6fd7fxWb90dHtAQ3WCSsoiuxPFJJKskTUez/6SelGDKqQr9AughhvEqYW4
         aHpAtr4fQJHNsH1wa1DVUeUPuQQZiQkQWOdyeuZDBRap1QIAI+r8j7deiJqH7oGYrJYO
         ImeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738694452; x=1739299252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqfbJ2Y6bpJkFTQHSruEAn+XekJDYu6xxv7Bd/Rc/lg=;
        b=Wuyru+HuVPzojftdeKiVRfNqXGrx+qQgrovxpPndc8PB7CbWW0Ks5pw/PZCVwi33av
         n83ezQd+MH0b3VEVKzs6EheZpcpum9jbWoe1uAsGQ5YkmMJwgcIuyRDmmrNwBU5uHhcy
         /F3aEQezM2ehM+n0cA07MJQQIzNd6KJ/kdYrKxNtPAdlmrU8ixT5XTnI+o8A/bDJeNCZ
         hJeyasBkrGi2lYO9DSDWri9qz6cplNTk7l2MUOU+FGe/BNhZEbej5uEo2Ts45HcyCMDc
         9NvfOmQgeoRGQqWn+6narEXdfQ4qH3hGRdVLa2XRITz6+fR+21Ma/tnGDBu0C/O84lUH
         JxLg==
X-Gm-Message-State: AOJu0YxNSLe2xCok4xqUWMIg1eOVqvQK/Zh7YkwzaVlB7JEZ3vK0Jkez
	mYMXCZav5w5DpX2Cv52aKslSpBEnykYBinUb+Q6iZ7j3mn2It6HsDrEwawLPIKl/c9H2GebvM/5
	3
X-Gm-Gg: ASbGnctdYNJAItr+tDyBGIsiJQRdBiCgbVbOFQKfKDvoGKPozQJt6QQG/vMyPG74m+B
	ZOTrbeEHoXnNRZgMZZmtasdv6oHkTNgmWmhuUpT/35wobgVfftt2jC3hEFfGtC2nztTBgrfs6fT
	Il6y2Q/KSAggKrr7evhv2CmA0LuzI8KrbBWAUbVgVssDUv9EJtNlXH5qoBwOKiGcxII8bbTruOn
	3AifBYorRocszqeiWz24XqjkDt36D7XQjrRZ8mkwUB8fAZDStnPyRRSMZoU12y/CABESqsPj43O
	PLbdHJkHDDp/2i4XWlg=
X-Google-Smtp-Source: AGHT+IGO9Qcy8zKk41hOBp6xXwK5wohbxb1JF5lrhu6F0zQu4/dDGpy+rccVT6Eg4yBjCrhr/e6VSA==
X-Received: by 2002:a05:6602:3711:b0:83a:a305:d9ee with SMTP id ca18e2360f4ac-854ea515978mr7080939f.12.1738694451943;
        Tue, 04 Feb 2025 10:40:51 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec745b5054sm2843148173.44.2025.02.04.10.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 10:40:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: cem@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Date: Tue,  4 Feb 2025 11:39:59 -0700
Message-ID: <20250204184047.356762-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204184047.356762-1-axboe@kernel.dk>
References: <20250204184047.356762-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add iomap buffered write support for RWF_DONTCACHE. If RWF_DONTCACHE is
set for a write, mark the folios being written as uncached. Then
writeback completion will drop the pages. The write_iter handler simply
kicks off writeback for the pages, and writeback completion will take
care of the rest.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 Documentation/filesystems/iomap/design.rst     | 5 +++++
 Documentation/filesystems/iomap/operations.rst | 2 ++
 fs/iomap/buffered-io.c                         | 4 ++++
 include/linux/iomap.h                          | 1 +
 4 files changed, 12 insertions(+)

diff --git a/Documentation/filesystems/iomap/design.rst b/Documentation/filesystems/iomap/design.rst
index b0d0188a095e..7b91546750f5 100644
--- a/Documentation/filesystems/iomap/design.rst
+++ b/Documentation/filesystems/iomap/design.rst
@@ -352,6 +352,11 @@ operations:
    ``IOMAP_NOWAIT`` is often set on behalf of ``IOCB_NOWAIT`` or
    ``RWF_NOWAIT``.
 
+ * ``IOMAP_DONTCACHE`` is set when the caller wishes to perform a
+   buffered file I/O and would like the kernel to drop the pagecache
+   after the I/O completes, if it isn't already being used by another
+   thread.
+
 If it is necessary to read existing file contents from a `different
 <https://lore.kernel.org/all/20191008071527.29304-9-hch@lst.de/>`_
 device or address range on a device, the filesystem should return that
diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
index 2c7f5df9d8b0..584ff549f9a6 100644
--- a/Documentation/filesystems/iomap/operations.rst
+++ b/Documentation/filesystems/iomap/operations.rst
@@ -131,6 +131,8 @@ These ``struct kiocb`` flags are significant for buffered I/O with iomap:
 
  * ``IOCB_NOWAIT``: Turns on ``IOMAP_NOWAIT``.
 
+ * ``IOCB_DONTCACHE``: Turns on ``IOMAP_DONTCACHE``.
+
 Internal per-Folio State
 ------------------------
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d303e6c8900c..ea863c3cf510 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -603,6 +603,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
+	if (iter->flags & IOMAP_DONTCACHE)
+		fgp |= FGP_DONTCACHE;
 	fgp |= fgf_set_order(len);
 
 	return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
@@ -1034,6 +1036,8 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
+	if (iocb->ki_flags & IOCB_DONTCACHE)
+		iter.flags |= IOMAP_DONTCACHE;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_write_iter(&iter, i);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 75bf54e76f3b..26b0dbe23e62 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -183,6 +183,7 @@ struct iomap_folio_ops {
 #define IOMAP_DAX		0
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9)
+#define IOMAP_DONTCACHE		(1 << 10)
 
 struct iomap_ops {
 	/*
-- 
2.47.2

