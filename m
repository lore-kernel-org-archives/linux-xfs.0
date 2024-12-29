Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C921531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479603; cv=none; b=COK8h0I26DQM+XVpyWNxIKbCY/9VpA4i05P1Tvpg/Em21ZwvV12gyT1QquGAKG2m+XFNJDu9DZ8o+980t1LfwqrTOohsPZEqm7N7au5xK/7DWBHKaMMu0lHaYfS+pdibExSpmqf4JVkhDp6S09+UVaZ0wFvqinye8CYVR9Ro9gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479603; c=relaxed/simple;
	bh=XNinaXSPJmgYTh8AdPTPO7bMbduUBu+jJX7rkFAtKU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuq1Lcu9fcWFjgowMJst91nEo7JYWUJT/IHFKzWo00JT85zRmQqXzSvHZ2SQjBWcwxo0DejSxeI9zS/j4og1klv6KV4GaAhUcA7/O9d0dAndiEjflJqJAW7iPVHdmybncHegUM91HplMC1O6br2Fp7nFmXpicGSpmg6AZ6rYY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fWPpw8AY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWPpw8AY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUyQ46j7i3FCz045BQwP8r/HtNpQ0SxbbrN/t47Mnls=;
	b=fWPpw8AY4c47W977pRc09TLeK+OEJVnAxK9AnppUAWWugzvpf96TA3A5WM1id59+6srLyK
	zT8laLt2BHa2ckNvwWbRhdSqPu+MxTh5SreJRShsD8fOi1gdvWo8W89gI8W77JTf2pvo+s
	L2mi8jo/4XragUKI8dBeJyzEZDcf04Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-zp0oWYEEOACSidp1d8zs6Q-1; Sun, 29 Dec 2024 08:39:59 -0500
X-MC-Unique: zp0oWYEEOACSidp1d8zs6Q-1
X-Mimecast-MFC-AGG-ID: zp0oWYEEOACSidp1d8zs6Q
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa67fcbb549so143091166b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479598; x=1736084398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUyQ46j7i3FCz045BQwP8r/HtNpQ0SxbbrN/t47Mnls=;
        b=qSHsbJdHTOYVRFBfekKxTnRwVgtCV2vmC8phoDDiFg04l8rHMe/YWhJvQKMTExNSaa
         iQvk6VnmwRUyBCYluGyJ18UusVFRsOngQsCIz5AHEVscFkOl/g9VLnCxuGzi8M7ReVvb
         7m+9BGP0iWgANBPoXjtP8iOsYqyu1MZ6njKirTCbv9QpOmQHqGDeVtxIFx/DuSUopRe4
         ONFqequfaIfgF8g3mwI88/2OYNCnD+y+3yUHWTZfaoG213Q4mqZoHW4yz8pR7q/aeGmo
         ZyCPyi4k/0kDC5ziBUAEn7+MV7H6GqOOih7SRCCfDEVF6CJdpOlVDH/gzXXMXitgzy72
         HMnA==
X-Gm-Message-State: AOJu0YxhHKVSGH3AJDp6bB/9P0SFA0ed8E+kboJqPf0AnWvrkk8L/lO7
	OCwPv5NfsuskivKEb/29ahN0f8t0mUwrG6JMzrlYkjUWuDDCcsnsaFu54CLeuIXTVQPYl8gcq1K
	8T+Oc4/20PrM6n6opz9vbRG3IL3uP1qekCf3sj0+SH6JEAzmhN1phA3z7Ry/VxqL97oAmCSBjaY
	QEUAp/S3nvQaLLYlhyoT/4av03EuhNHlMxovi7o4GH
X-Gm-Gg: ASbGncvKms3bfow74G4+GN5j59u4d57M2CEnZltJFoDrC44F4PwwAJTCaWVn8sG9rzX
	oOf8dpZusdGtcUcfvoHGRZS5fw0vqegF266ocEGP25LrJU2LQGtMRmX0I+H5IsgO0yp6aHiccw0
	YwDZ/V83Drz5nv9a+iiBNn6n2I193JAaM1Zh8NUgrqMQGyo6qK0Z9gWEDa9XeizRV0cF827UJFY
	CeU+3Cc9WvVKWhDHtJe5/TwsbvHmGJRvrYtMGoDkozA9GegCs3fUR4uGmSDBeIg5x/3JgDB/5ZQ
	k+1TF4pOOsAKZmc=
X-Received: by 2002:a17:907:971e:b0:aa6:b63a:4521 with SMTP id a640c23a62f3a-aac2ad87883mr2724412466b.15.1735479598223;
        Sun, 29 Dec 2024 05:39:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhe4W+8MgIFqP7mP+EhFQ3NVA3G9sIteQmQT2SstQkWQK2JFRqG7oQE5wgHUnHyLnHQ3Jehg==
X-Received: by 2002:a17:907:971e:b0:aa6:b63a:4521 with SMTP id a640c23a62f3a-aac2ad87883mr2724410266b.15.1735479597829;
        Sun, 29 Dec 2024 05:39:57 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:57 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 08/24] iomap: integrate fs-verity verification into iomap's read path
Date: Sun, 29 Dec 2024 14:39:11 +0100
Message-ID: <20241229133927.1194609-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

This patch adds fs-verity verification into iomap's read path. After
BIO's io operation is complete the data are verified against
fs-verity's Merkle tree. Verification work is done in a separate
workqueue.

The read path ioend iomap_read_ioend are stored side by side with
BIOs if FS_VERITY is enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix doc warning]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 30 ++++++++++++++++++++++++++++--
 include/linux/iomap.h  |  5 +++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d6231f4f78d9..59c0ff6fb6b7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
+#include <linux/fsverity.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
 #include <linux/uio.h>
@@ -23,6 +24,8 @@
 
 #define IOEND_BATCH_SIZE	4096
 
+#define IOMAP_POOL_SIZE		(4 * (PAGE_SIZE / SECTOR_SIZE))
+
 /*
  * Structure allocated for each folio to track per-block uptodate, dirty state
  * and I/O completions.
@@ -362,6 +365,19 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 		 !(srcmap->flags & IOMAP_F_BEYOND_EOF));
 }
 
+#ifdef CONFIG_FS_VERITY
+void
+iomap_read_fsverity_end_io_work(struct work_struct *work)
+{
+	struct iomap_read_ioend *fbio =
+		container_of(work, struct iomap_read_ioend, io_work);
+
+	fsverity_verify_bio(&fbio->io_bio);
+	iomap_read_end_io(&fbio->io_bio);
+}
+
+#endif /* CONFIG_FS_VERITY */
+
 static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx, loff_t offset)
 {
@@ -376,6 +392,10 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	struct iomap_read_ioend *ioend;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 
+	/* Fail reads from broken fsverity files immediately. */
+	if (IS_VERITY(iter->inode) && !fsverity_active(iter->inode))
+		return -EIO;
+
 	if (iomap->type == IOMAP_INLINE)
 		return iomap_read_inline_data(iter, folio);
 
@@ -387,6 +407,12 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 	if (iomap_block_needs_zeroing(iter, pos)) {
 		folio_zero_range(folio, poff, plen);
+		if (!(srcmap->flags & IOMAP_F_BEYOND_EOF) &&
+		    fsverity_active(iter->inode) &&
+		    !fsverity_verify_blocks(folio, plen, poff)) {
+			return -EIO;
+		}
+
 		iomap_set_range_uptodate(folio, poff, plen);
 		goto done;
 	}
@@ -2176,13 +2202,13 @@ static int __init iomap_buffered_init(void)
 	int error = 0;
 
 	error = bioset_init(&iomap_read_ioend_bioset,
-			   4 * (PAGE_SIZE / SECTOR_SIZE),
+			   IOMAP_POOL_SIZE,
 			   offsetof(struct iomap_read_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
 	if (error)
 		return error;
 
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
+	return bioset_init(&iomap_ioend_bioset, IOMAP_POOL_SIZE,
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 261772431fae..e4704b337ac1 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -326,6 +326,11 @@ struct iomap_readpage_ctx {
 };
 
 void iomap_read_end_io(struct bio *bio);
+#ifdef CONFIG_FS_VERITY
+void iomap_read_fsverity_end_io_work(struct work_struct *work);
+#else
+#define iomap_read_fsverity_end_io_work (0)
+#endif /* CONFIG_FS_VERITY */
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops, void *private);
 int iomap_read_folio_ctx(struct iomap_readpage_ctx *ctx,
-- 
2.47.0

