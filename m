Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814B931AF25
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788940; cv=none; b=aVao4hxTHUZ0kX2Y0CVBBhvSkkKdg8OOQ3e7rXkc8k+GophTcPnKrtI4comj9MxNR2O2KPuS1RCt96ooogjddLvhhWYRPTeU5F3UpYeJXbLlU6bhkoV0gK12By0Tp3XN5Rje9Q+RFN8UNsWehBhv+ImTsxdx+ceS9S44ca4yEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788940; c=relaxed/simple;
	bh=PIe66DJrCPzrSjteP1RgMiFN6yBqMi0Ni5ja4SKUDMg=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMSbFz1vukYpWmF3c6Z5X1Ok1ckcvElAGet8xfnhZPyGetO9NEUO8phNN9/8ngjAfzIYRkp5G3cTql3v072jr2hbJipui7uW/Q4IBzQklx8LoHtMYqu2zQvUfOw/cFFOkcgvA458IWl/79oBoKlFKDOAe7Md4+vef5kIgxDsDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IHI5M8rq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cH6e3jRl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IHI5M8rq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cH6e3jRl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
	b=IHI5M8rqtr/+pMH8TUbIPC1wI73yLH9IBBnL0E1pNUnGDSBvksaVrPI+7RClTA5yRS2I9a
	WOK//+y9+Hw7cfy/T2XVvO3jHK4sDUtLh4K+L+Wp38YB+PawdisYTpG+oLNYoZwmZoib0R
	TgmBttS7FQgqASxNqoae8UGhGqF2lj8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-44frKxNLP3qFrJjSJb-OUQ-1; Wed, 03 Dec 2025 14:08:56 -0500
X-MC-Unique: 44frKxNLP3qFrJjSJb-OUQ-1
X-Mimecast-MFC-AGG-ID: 44frKxNLP3qFrJjSJb-OUQ_1764788935
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42e2e3c2cccso68536f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788935; x=1765393735; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
        b=cH6e3jRlNxkNjmcg5oUBDko49tDxseKwxtngnqq+65koehOByQ0rcerG4yTX/Z7ACo
         suKAz9bJl3Y5MgZ5r1mDOZtEBUQ+o1d+PpjkZfLDXfq1ykDydU2MncLKx+vEnXpNI+RU
         3+7OqPVrPB9ANeiRZ/+OrwrrNgCrkoGUGhE3VqKj1WgviN0FtAKcLpURuQwtXhBH3Sj4
         nZ2MLR8hW5k+wYKHLiZDokiRuSRZAGvtNqrVVNmSAIZ5Z14WGBrvuFIYhFLmBu28bvTX
         HJf50FWulnO4Zzouah6PkH5FPSF5UJMvTLZzKI7VBG8oY/YsCedCpl4xXufSbiY6tu4W
         ggkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788935; x=1765393735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
        b=qeHZ0SwoJE4R0/w754WlsMuBjsgOGnb6a23E8os+MinZOn6JUucktkjUyQk3Lp3yzd
         bcLJRmBs3AhoxCx9GjlxmANWtufToJspKYz/g1Q3lopmWB8qr8SRwlz5Ke2ICblnHPSQ
         LNqNRaINozB/gDlcHT4Ex+7XU051GnxICPWvkrol13GZ9m/8x79W04Jh3EjCc06PIcyk
         hN/rhMVNtYisf3v02wpS5k6g7zNmk1BspQNal6JmvCWeQeGdOSy1led8gTYsJP/3n09F
         h4bNJhrRE/lsIKm7Z9SXQYm0q5YyFZ4W/9CEF5ZRObCctc2U9kUtYhPDHFyRLuuRwWWL
         6i2g==
X-Gm-Message-State: AOJu0YwZUiB+sYHNtDlqybA+Py0QwPjCsAvcr7VenHaxecSNritj2+9N
	vbGiwDDl6aIuoSkwoW6fm96NHkNajN1lHW8xFZhq+SkpG+ABXok+9kQlLSSHC37CYBRw6GlDzPY
	FZyYmb2kyRBCGwYxwiRCNQ3g0TSSvtIohEQUc3vCh2RRWijf+Pew7+9tFGMUnAeulLeif8fxAPn
	gdqy2KVmV/WbJXzNDWfMzkxZ4DeIEeA6IoM5tW95lWnWdW
X-Gm-Gg: ASbGnctpe0TWTgk0ksPjJVRA06teFMRKFaRnbGYVfj8Wn9DoasW0/Ba9sB2h/cYXkee
	MUq9Ys6suqmrvGzc2zOrh7LIH8a6qSDnNfxstnFfYP0yt+A4EEIKN7LicKt2XiGqrdEy425swUb
	NFAPQXqAukuWgOSY3XtjZR0CewVElRK+f46safgMEtnRY8HSCh8VCRgb1B5C+8OdIEHWipUQaNG
	n2Eoe9qkpD3IE4N16UAJTrql0HxgXLs4+vwr/38eR2t5MqhOhhZ9wDfLJp21FXO0W6YhrdkqH6w
	1PqRhWgZgolas2J8vOV4MOZCgg3U06Q2w/TrHmxUnLLe51W7ahuU/brb3jn4Xyd1UJV582DqdrA
	=
X-Received: by 2002:a05:6000:40cc:b0:42b:2e39:6d58 with SMTP id ffacd0b85a97d-42f731bc534mr3396614f8f.51.1764788935037;
        Wed, 03 Dec 2025 11:08:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXHKlB+imTx9t7k6ogwpvY/OhhveOp5ZSu6ZG1ivXQFwzJUAKyRnDABWSj4p8gGUOyUUISLA==
X-Received: by 2002:a05:6000:40cc:b0:42b:2e39:6d58 with SMTP id ffacd0b85a97d-42f731bc534mr3396579f8f.51.1764788934441;
        Wed, 03 Dec 2025 11:08:54 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d618csm40140190f8f.14.2025.12.03.11.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:08:54 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:08:53 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 18/33] xfs: fix log CRC mismatches between i386 and other
 architectures
Message-ID: <7nvqfc2qtslcapcx2rdcq33jtvlkvd2m2v32rr5djnoc37gtos@t45qi2bsvpsi>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e747883c7d7306acb4d683038d881528fbfbe749

When mounting file systems with a log that was dirtied on i386 on
other architectures or vice versa, log recovery is unhappy:

[   11.068052] XFS (vdb): Torn write (CRC failure) detected at log block 0x2. Truncating head block from 0xc.

This is because the CRCs generated by i386 and other architectures
always diff.  The reason for that is that sizeof(struct xlog_rec_header)
returns different values for i386 vs the rest (324 vs 328), because the
struct is not sizeof(uint64_t) aligned, and i386 has odd struct size
alignment rules.

This issue goes back to commit 13cdc853c519 ("Add log versioning, and new
super block field for the log stripe") in the xfs-import tree, which
adds log v2 support and the h_size field that causes the unaligned size.
At that time it only mattered for the crude debug only log header
checksum, but with commit 0e446be44806 ("xfs: add CRC checks to the log")
it became a real issue for v5 file system, because now there is a proper
CRC, and regular builds actually expect it match.

Fix this by allowing checksums with and without the padding.

Fixes: 0e446be44806 ("xfs: add CRC checks to the log")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 30 +++++++++++++++++++++++++++++-
 libxfs/xfs_ondisk.h     |  2 ++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index a42a832117..fd00b77af3 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -173,12 +173,40 @@
 	__be32	  h_prev_block; /* block number to previous LR		:  4 */
 	__be32	  h_num_logops;	/* number of log operations in this LR	:  4 */
 	__be32	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
-	/* new fields */
+
+	/* fields added by the Linux port: */
 	__be32    h_fmt;        /* format of log record                 :  4 */
 	uuid_t	  h_fs_uuid;    /* uuid of FS                           : 16 */
+
+	/* fields added for log v2: */
 	__be32	  h_size;	/* iclog size				:  4 */
+
+	/*
+	 * When h_size added for log v2 support, it caused structure to have
+	 * a different size on i386 vs all other architectures because the
+	 * sum of the size ofthe  member is not aligned by that of the largest
+	 * __be64-sized member, and i386 has really odd struct alignment rules.
+	 *
+	 * Due to the way the log headers are placed out on-disk that alone is
+	 * not a problem becaue the xlog_rec_header always sits alone in a
+	 * BBSIZEs area, and the rest of that area is padded with zeroes.
+	 * But xlog_cksum used to calculate the checksum based on the structure
+	 * size, and thus gives different checksums for i386 vs the rest.
+	 * We now do two checksum validation passes for both sizes to allow
+	 * moving v5 file systems with unclean logs between i386 and other
+	 * (little-endian) architectures.
+	 */
+	__u32	  h_pad0;
 } xlog_rec_header_t;
 
+#ifdef __i386__
+#define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
+#define XLOG_REC_SIZE_OTHER	sizeof(struct xlog_rec_header)
+#else
+#define XLOG_REC_SIZE		sizeof(struct xlog_rec_header)
+#define XLOG_REC_SIZE_OTHER	offsetofend(struct xlog_rec_header, h_size)
+#endif /* __i386__ */
+
 typedef struct xlog_rec_ext_header {
 	__be32	  xh_cycle;	/* write cycle of log			: 4 */
 	__be32	  xh_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE]; /*	: 256 */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 5ed44fdf74..7bfa3242e2 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -174,6 +174,8 @@
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_header,		328);
+	XFS_CHECK_STRUCT_SIZE(struct xlog_rec_ext_header,	260);
 
 	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);

-- 
- Andrey

