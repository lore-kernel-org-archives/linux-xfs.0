Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FB7341042
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947053; cv=none; b=opLwwpV+pLvScdTL7EV+wTgIHSaCiTXtwtSxyRmTEWMvNs9AIBkgvGuVdOVn2Xu0/h7112wqMmHIApoOglzDJAVkJnQm2vj28gmjCfjpntd0UmUbjVKR7/vttzlY1udS9I4kqBe3pz8BoMmlr6WuR+oPivsrX7vyDJmON61p2pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947053; c=relaxed/simple;
	bh=PIe66DJrCPzrSjteP1RgMiFN6yBqMi0Ni5ja4SKUDMg=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJ/dUGL5ucgg3ag7fNNl1g2OURDJ8cLf+m6zRA4D0KizEJVFmt0zZvjl7SkBev8VafaQMLBXps2+MEPIiQchRmeSItMwNr7Imb38/4wdkHQjhD3VbJGJCHMsajRKEbIlBi77IqG6Hq69IwuFN818waaGlRrPk5Hbd0T/mM/yP3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvSYtK/0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CP3LrGT+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvSYtK/0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CP3LrGT+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
	b=PvSYtK/0Glu+wuKMy2KcdgzHx88GgzbmvqKgEXUm9QmdosKX5BvXZ2dJoawDC8NbtywfBx
	wrYM3mm8luhLA7n38HhuXzYH0z99JfZ3j909qV9aZQZx1lwrh68FtRauq8Sy5vTuzZBHOv
	QSOKfdshGdAqh9GXRfIvG/DPbIUZtwU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-d48Z4wE-Pf-ABhbmWD3SgQ-1; Fri, 05 Dec 2025 10:04:03 -0500
X-MC-Unique: d48Z4wE-Pf-ABhbmWD3SgQ-1
X-Mimecast-MFC-AGG-ID: d48Z4wE-Pf-ABhbmWD3SgQ_1764947042
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-333f8ddf072so8857771fa.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947042; x=1765551842; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
        b=CP3LrGT+aZpWN5J4k2P8txwTKUdZCxdaLveG0ZvoCWDMcvJg3UGI+4iK4rfegAhbTS
         1gLRkIvtTVNcPQEBZ4nDcuIam1A4CwdNo2IRwCSkyUgDHKrC9sMna/Tbl9lxj9YGRhM7
         tiDMz9Y1BZBbKW8nTju0QgUFMV5HldS+U3CGohMJo6TBqOoKvBshzEB7Ayrnywwf9eIl
         F8+6uSH92Vh+qCrCdLBjRR8jjSjm1XxFTDMlwZU/hXekRwpy5P3TcZd04db1qwJ1o5oZ
         eTyINi22lgWf0tLq6ZTMcZMKqAK6e9zBUUxvRtBKpoFoPYGdaJGGYQly3s4LotmBR1I1
         Qw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947042; x=1765551842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=87cs0D5p/ixizK94shR9dHgSSkz9P8GxsJkfC1/J6vw=;
        b=doVn1FeHh4Jl0xhYyj7OYGyb094CeNnJggsYeEhe+6grPYYma5lnNvnJf11GE0fMUW
         u57GajITxCP7PgVI4WHfkpsS0JqL19vTgAFiAfH0Zh9FQneHEH2r4W6SRYgkAJ35U/Kx
         PV92IJ2VEmJQLU0PzekVfaflUttf8IBP1w57PadmE3WytwkmbdzyC4exytuBpqkwIFa+
         onbzGtomeQcHJs8RpP4Db8GGfMmDfF35s3IA+BFbuYkJxHFArtRw64mxxdBgmEB5k1Em
         o3UZsaECywmd/fiv2Itq74deXk7K0cQ8h5OhA4nZMM9zLSEj7V6/q9LGgDit+qvZjtSx
         E4oA==
X-Gm-Message-State: AOJu0Yyny2+MAGXIdSp10NH2L6EOXSBKhORgjxqTpkUd+nVVA32GuXk6
	CMlob2aA0k2JEranxq9MTQKMe5xnUcIZtKvcg5BFfnpFHEFh0qzKOEYnAM3mwPI7G9Ukwk5iUGP
	ZsGNOn+w9nQ3W6J61G8h+xS8sh57shfYo3ZIAjxBrdWiKhvoUNHfNc/I5qQFUPCm9utgMxvDg2I
	v0cvdMmbmWeBKqwMil8fs7SPxfAS684eF0knqYWsmlgPpw
X-Gm-Gg: ASbGncvIQUJsxJQXsRIw3XxfslhqV7K7+QCtvb4Ajtmj53bM67vfnFuMqVcyoi55rlE
	FplNjrfbFEJcUHyRaKbVzQn7T8ODgyzOr+DW44RGQ0Isskd77JMUJ2Sy+eXU/9XRSBHBwssXO0X
	tZ1eSd7c6OYVhooMcvwnkvKMs+M2ebP5XYdDcqsbFQ2Z4kQsRObMJH2r5vg50RygUARUftHCY/z
	JY2No7Ld4O/K9cQqeNxA5LdYYRhDoTn2Wr6PsLVbX7op6qorMcLunrbN25Mne2EYtnNcirm1f4u
	n9RZZ3IzGrBgYiK/dch8Rnpz4ZbZiLCI1dC66j1QdrqpiLPiKsaI0unUY3T2L+zgBz/eTCm7Sf4
	=
X-Received: by 2002:a05:651c:43d7:10b0:373:a465:292c with SMTP id 38308e7fff4ca-37e638e7840mr25855601fa.21.1764947041678;
        Fri, 05 Dec 2025 07:04:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEg+eiLs26ZnIqex53JrFBa2PdhcSOFz4r+TxcneFRV9X2Qh9cBsTFgGcMr5SWvibE380cxTQ==
X-Received: by 2002:a05:651c:43d7:10b0:373:a465:292c with SMTP id 38308e7fff4ca-37e638e7840mr25855331fa.21.1764947040983;
        Fri, 05 Dec 2025 07:04:00 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37e6fe6beccsm14635731fa.2.2025.12.05.07.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:04:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:59 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 29/33] xfs: fix log CRC mismatches between i386 and other
 architectures
Message-ID: <qyyytgqzbzrnv5hgc63vwqb6yfgsmpifepjb3u3ndmoazvf467@rlqsaqlrrfzq>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

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

