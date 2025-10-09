Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA38A15CD74
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011829; cv=none; b=g3/wgM9HJYHY81JX25BLz/BK4EsNIg0tnS84I2EgwTEHkUW1SMDVyuUvKWQg4HKlGAs7b8D29HO3Sv2jMG05wJrZOEup8eOk8vNgLl2gddcm+m6ZkpJk+XynBbSVMi2AtFCEBeF9EMARihk9qZbPM+U64F2lXd9QfCY2RTbbA3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011829; c=relaxed/simple;
	bh=HlsqtVW6iLNLlW0wOFJtUmX5OMOIhNXfK2YxfFUlHwI=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3K9p24MwJfNWTAkAV6terXXqPim1qEx3tub+9lwzBA3RUIQVlQPpZUfy56XryoJmKLk8pF6Q+MxEFQLg6odYa/2n2SLikdF3eG3GTEhJ+qo634hQ+OrrjnWufSQd6TKtmICo9kB9zlSIPIGYYlV8XO96yYezdnuAT7A42NUJSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LzTq+BoB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzTq+BoB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760011826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x/aKMmXwvrrUnhlR2t0qfVgJ1DsePpzGraUDiTNEoOc=;
	b=LzTq+BoBq04AYrEiJR9TOiQOMgZuTAmPX17sNpY86JZfDBSkK15kOtmStG4h5l4CEygQw7
	Eym9n/t02PtqdtLsCHjQGbcGvXKG2IDcW15BhQ1OPSfNzbf2gGPQ9YiMckASh8IQblw+DQ
	deDegfpj1jdP7x/8TUhlXHItKSrDG1A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-VLbFMfEaOkiZa3heGoFqSg-1; Thu, 09 Oct 2025 08:10:25 -0400
X-MC-Unique: VLbFMfEaOkiZa3heGoFqSg-1
X-Mimecast-MFC-AGG-ID: VLbFMfEaOkiZa3heGoFqSg_1760011824
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3dcb36a1so6138975e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 05:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011824; x=1760616624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/aKMmXwvrrUnhlR2t0qfVgJ1DsePpzGraUDiTNEoOc=;
        b=M42hGeARnWSgZKorha6d/Jory2R1wSt4A1gE6pBFzEgUEFMHukDneEhwGbafN2HA6G
         TAtzxwqyck5/5A4CnqEJPRWxhVXfLGhODjDp+uRt9rWg1vxFng/wIhgxENfLV/jdQXUK
         StwbAc6NigaAOPn5xvzq0ClabrypgT7UG8uLZidTwp/h94JVEtw3O4sOSVfaNqqj0chn
         r7phlyoWhbkGZP6EjGjJwhMe4WtUVjCC7272jYpSJi0g5fM8Qi4UqQAzftEpWbfb94qp
         GixxidYDEFV2x8ST/qtFZroDXrDyfAvMWWIIdrV+yomlLxqKfe2Znipmn69Z/ANR5pAf
         xmbQ==
X-Gm-Message-State: AOJu0YxFrkzkT7sfI5iKeXimnWemNWOUcST82yiKRUQ7LS+aCxQJOUjL
	FM9yKZoQsvtfArVwYNjlvuHaFT6LDw/vO/zr7lanVaPb1IBe5EqmjIz056iFZTL6CenNZJw+Zau
	A9UHu+lE0YRWaJpCqK0uY53FnhDZ7ZpQt+WSny7EZI1TbHyJ6BSk7+qKCzdF4hbR7Tm4upwc7eP
	lfYdg2dB/Sofjx6BfF+6VXit1rolZb1gbZNva2FXArjs4a
X-Gm-Gg: ASbGncuolA3SeQdBATYJD/Fivqv8demDBXdLUxG0NoDcKjsxSuXmjIIuvub9hrOzNmY
	HVtQlNIUcdXnbXt6D8xf2otvIWOGikmoAh1E3b0kpTEYD1u2B2pU5we0Q8AI0Ryu9kXbAvOoGtp
	0JTbXaiwY9oHYwreEJqq6SSxBQqYKtjgrAUdfeD1OHAf2DmrAl7PCbItZZbnUcCkQmV+Blht/BH
	HguOK7LBKuwUs7jKTLx65sOyNrkf+69u99mWOw/E4h7a5Npp0cknTvl3Ws4E2pW4WycLm+VH6l8
	/+czxpebyEbCOto1g9VGNYsIUPTAMSAlevB1Wuk/yRtBdh+vkBvKqA==
X-Received: by 2002:a05:600c:8b4c:b0:46f:b42e:ed86 with SMTP id 5b1f17b1804b1-46fb42eee22mr1145095e9.39.1760011823370;
        Thu, 09 Oct 2025 05:10:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfEHoRjTuhwnUGSLqHI9YPlvlqY5VxlocCMcJ6JL6/8kq8Lc+mvQduS4S/KxNadTt7UOFeEQ==
X-Received: by 2002:a05:600c:8b4c:b0:46f:b42e:ed86 with SMTP id 5b1f17b1804b1-46fb42eee22mr1144695e9.39.1760011822693;
        Thu, 09 Oct 2025 05:10:22 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9703sm34885692f8f.30.2025.10.09.05.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:10:22 -0700 (PDT)
From: Christoph Hellwig <aalbersh@redhat.com>
X-Google-Original-From: Christoph Hellwig <hch@lst.de>
Date: Thu, 9 Oct 2025 14:10:21 +0200
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, hch@lst.de, pchelkin@ispras.ru, 
	pranav.tyagi03@gmail.com, sandeen@redhat.com
Subject: [PATCH v2 10/11] xfs: don't use a xfs_log_iovec for ri_buf in log
 recovery
Message-ID: <fnq7xbfnfoxwxjpkfvcvo7xnfgfqrayz3tsl7x6xxjkng6woyu@36qfiyo7jv5m>
References: <cover.1760011614.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1760011614.patch-series@thinky>

Source kernel commit: ded74fddcaf685a9440c5612f7831d0c4c1473ca

ri_buf just holds a pointer/len pair and is not a log iovec used for
writing to the log.  Switch to use a kvec instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/platform_defs.h   |  5 ++++
 libxfs/xfs_log_recover.h  |  4 +--
 libxlog/xfs_log_recover.c | 14 +++++------
 logprint/log_print_all.c  | 59 ++++++++++++++++++++++++-------------------------
 logprint/log_redo.c       | 52 +++++++++++++++++++++----------------------
 5 files changed, 70 insertions(+), 64 deletions(-)

diff --git a/include/platform_defs.h b/include/platform_defs.h
index 7b4a1a6255..da966490b0 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -302,4 +302,9 @@
 # define __nonstring
 #endif
 
+struct kvec {
+	void *iov_base;
+	size_t iov_len;
+};
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/libxfs/xfs_log_recover.h b/libxfs/xfs_log_recover.h
index 66c7916fb5..95de230950 100644
--- a/libxfs/xfs_log_recover.h
+++ b/libxfs/xfs_log_recover.h
@@ -104,7 +104,7 @@
 	struct list_head	ri_list;
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
-	struct xfs_log_iovec	*ri_buf;	/* ptr to regions buffer */
+	struct kvec		*ri_buf;	/* ptr to regions buffer */
 	const struct xlog_recover_item_ops *ri_ops;
 };
 
@@ -117,7 +117,7 @@
 	struct list_head	r_itemq;	/* q for items */
 };
 
-#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
+#define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].iov_base)
 
 #define	XLOG_RECOVER_CRCPASS	0
 #define	XLOG_RECOVER_PASS1	1
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 275593a3ac..7ef43956e9 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1034,13 +1034,13 @@
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
 
-	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
-	old_len = item->ri_buf[item->ri_cnt-1].i_len;
+	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
+	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
 	ptr = krealloc(old_ptr, len+old_len, 0);
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
-	item->ri_buf[item->ri_cnt-1].i_len += len;
-	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
+	item->ri_buf[item->ri_cnt-1].iov_len += len;
+	item->ri_buf[item->ri_cnt-1].iov_base = ptr;
 	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
 	return 0;
 }
@@ -1117,8 +1117,8 @@
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */
-	item->ri_buf[item->ri_cnt].i_addr = ptr;
-	item->ri_buf[item->ri_cnt].i_len  = len;
+	item->ri_buf[item->ri_cnt].iov_base = ptr;
+	item->ri_buf[item->ri_cnt].iov_len  = len;
 	item->ri_cnt++;
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
 	return 0;
@@ -1140,7 +1140,7 @@
 		/* Free the regions in the item. */
 		list_del(&item->ri_list);
 		for (i = 0; i < item->ri_cnt; i++)
-			kfree(item->ri_buf[i].i_addr);
+			kfree(item->ri_buf[i].iov_base);
 		/* Free the item itself */
 		kfree(item->ri_buf);
 		kfree(item);
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1498ef9724..39946f32d4 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -78,7 +78,7 @@
 	xfs_daddr_t		blkno;
 	struct xfs_disk_dquot	*ddq;
 
-	f = (xfs_buf_log_format_t *)item->ri_buf[0].i_addr;
+	f = (xfs_buf_log_format_t *)item->ri_buf[0].iov_base;
 	printf("	");
 	ASSERT(f->blf_type == XFS_LI_BUF);
 	printf(_("BUF:  #regs:%d   start blkno:0x%llx   len:%d   bmap size:%d   flags:0x%x\n"),
@@ -87,8 +87,8 @@
 	num = f->blf_size-1;
 	i = 1;
 	while (num-- > 0) {
-		p = item->ri_buf[i].i_addr;
-		len = item->ri_buf[i].i_len;
+		p = item->ri_buf[i].iov_base;
+		len = item->ri_buf[i].iov_len;
 		i++;
 		if (blkno == 0) { /* super block */
 			struct xfs_dsb  *dsb = (struct xfs_dsb *)p;
@@ -185,7 +185,7 @@
 {
 	xfs_qoff_logformat_t	*qoff_f;
 
-	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].i_addr;
+	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].iov_base;
 
 	ASSERT(qoff_f);
 	printf(_("\tQUOTAOFF: #regs:%d   type:"), qoff_f->qf_size);
@@ -205,10 +205,10 @@
 	xfs_dq_logformat_t	*f;
 	struct xfs_disk_dquot	*d;
 
-	f = (xfs_dq_logformat_t *)item->ri_buf[0].i_addr;
+	f = (xfs_dq_logformat_t *)item->ri_buf[0].iov_base;
 	ASSERT(f);
 	ASSERT(f->qlf_len == 1);
-	d = (struct xfs_disk_dquot *)item->ri_buf[1].i_addr;
+	d = (struct xfs_disk_dquot *)item->ri_buf[1].iov_base;
 	printf(_("\tDQUOT: #regs:%d  blkno:%lld  boffset:%u id: %d\n"),
 	       f->qlf_size, (long long)f->qlf_blkno, f->qlf_boffset, f->qlf_id);
 	if (!print_quota)
@@ -288,21 +288,22 @@
 	int			hasdata;
 	int			hasattr;
 
-	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format_32) ||
-	       item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format));
-	f = xfs_inode_item_format_convert(item->ri_buf[0].i_addr, item->ri_buf[0].i_len, &f_buf);
+	ASSERT(item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format_32) ||
+		item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format));
+	f = xfs_inode_item_format_convert(item->ri_buf[0].iov_base,
+					  item->ri_buf[0].iov_len, &f_buf);
 
 	printf(_("	INODE: #regs:%d   ino:0x%llx  flags:0x%x   dsize:%d\n"),
-	       f->ilf_size, (unsigned long long)f->ilf_ino, f->ilf_fields,
-	       f->ilf_dsize);
+		f->ilf_size, (unsigned long long)f->ilf_ino, f->ilf_fields,
+		f->ilf_dsize);
 
 	/* core inode comes 2nd */
 	/* ASSERT len vs xfs_log_dinode_size() for V3 or V2 inodes */
-	ASSERT(item->ri_buf[1].i_len ==
+	ASSERT(item->ri_buf[1].iov_len ==
 			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
-	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
+	       item->ri_buf[1].iov_len == sizeof(struct xfs_log_dinode));
 	xlog_recover_print_inode_core((struct xfs_log_dinode *)
-				      item->ri_buf[1].i_addr);
+				      item->ri_buf[1].iov_base);
 
 	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
 	hasattr = (f->ilf_fields & XFS_ILOG_AFORK) != 0;
@@ -312,22 +313,22 @@
 		ASSERT(f->ilf_size == 3 + hasattr);
 		printf(_("		DATA FORK EXTENTS inode data:\n"));
 		if (print_inode && print_data)
-			xlog_recover_print_data(item->ri_buf[2].i_addr,
-						item->ri_buf[2].i_len);
+			xlog_recover_print_data(item->ri_buf[2].iov_base,
+						item->ri_buf[2].iov_len);
 		break;
 	case XFS_ILOG_DBROOT:
 		ASSERT(f->ilf_size == 3 + hasattr);
 		printf(_("		DATA FORK BTREE inode data:\n"));
 		if (print_inode && print_data)
-			xlog_recover_print_data(item->ri_buf[2].i_addr,
-						item->ri_buf[2].i_len);
+			xlog_recover_print_data(item->ri_buf[2].iov_base,
+						item->ri_buf[2].iov_len);
 		break;
 	case XFS_ILOG_DDATA:
 		ASSERT(f->ilf_size == 3 + hasattr);
 		printf(_("		DATA FORK LOCAL inode data:\n"));
 		if (print_inode && print_data)
-			xlog_recover_print_data(item->ri_buf[2].i_addr,
-						item->ri_buf[2].i_len);
+			xlog_recover_print_data(item->ri_buf[2].iov_base,
+						item->ri_buf[2].iov_len);
 		break;
 	case XFS_ILOG_DEV:
 		ASSERT(f->ilf_size == 2 + hasattr);
@@ -353,24 +354,24 @@
 			printf(_("		ATTR FORK EXTENTS inode data:\n"));
 			if (print_inode && print_data)
 				xlog_recover_print_data(
-					item->ri_buf[attr_index].i_addr,
-					item->ri_buf[attr_index].i_len);
+					item->ri_buf[attr_index].iov_base,
+					item->ri_buf[attr_index].iov_len);
 			break;
 		case XFS_ILOG_ABROOT:
 			ASSERT(f->ilf_size == 3 + hasdata);
 			printf(_("		ATTR FORK BTREE inode data:\n"));
 			if (print_inode && print_data)
 				xlog_recover_print_data(
-					item->ri_buf[attr_index].i_addr,
-					item->ri_buf[attr_index].i_len);
+					item->ri_buf[attr_index].iov_base,
+					item->ri_buf[attr_index].iov_len);
 			break;
 		case XFS_ILOG_ADATA:
 			ASSERT(f->ilf_size == 3 + hasdata);
 			printf(_("		ATTR FORK LOCAL inode data:\n"));
 			if (print_inode && print_data)
 				xlog_recover_print_data(
-					item->ri_buf[attr_index].i_addr,
-					item->ri_buf[attr_index].i_len);
+					item->ri_buf[attr_index].iov_base,
+					item->ri_buf[attr_index].iov_len);
 			break;
 		default:
 			xlog_panic("%s: illegal inode log flag", __FUNCTION__);
@@ -385,7 +386,7 @@
 {
 	struct xfs_icreate_log	*icl;
 
-	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].iov_base;
 
 	printf(_("	ICR:  #ag: %d  agbno: 0x%x  len: %d\n"
 		 "	      cnt: %d  isize: %d    gen: 0x%x\n"),
@@ -549,8 +550,8 @@
 */
 	printf(_(": cnt:%d total:%d "), item->ri_cnt, item->ri_total);
 	for (i=0; i<item->ri_cnt; i++) {
-		printf(_("a:0x%lx len:%d "),
-		       (long)item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
+		printf(_("a:0x%lx len:%zu "),
+		       (long)item->ri_buf[i].iov_base, item->ri_buf[i].iov_len);
 	}
 	printf("\n");
 	xlog_recover_print_logitem(item);
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 89d7448342..f5bac21d35 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -143,8 +143,8 @@
 	int			i;
 	uint			src_len, dst_len;
 
-	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
+	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[0].iov_len;
 	/*
 	 * An xfs_efi_log_format structure contains a variable length array
 	 * as the last field.
@@ -229,7 +229,7 @@
 	const char		*item_name = "EFD?";
 	xfs_efd_log_format_t	*f;
 
-	f = (xfs_efd_log_format_t *)item->ri_buf[0].i_addr;
+	f = (xfs_efd_log_format_t *)item->ri_buf[0].iov_base;
 
 	switch (f->efd_type) {
 	case XFS_LI_EFD:	item_name = "EFD"; break;
@@ -355,8 +355,8 @@
 	char				*src_f;
 	uint				src_len;
 
-	src_f = item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
+	src_f = item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[0].iov_len;
 
 	xlog_print_trans_rui(&src_f, src_len, 0);
 }
@@ -406,7 +406,7 @@
 {
 	char				*f;
 
-	f = item->ri_buf[0].i_addr;
+	f = item->ri_buf[0].iov_base;
 	xlog_print_trans_rud(&f, sizeof(struct xfs_rud_log_format));
 }
 
@@ -516,8 +516,8 @@
 	char				*src_f;
 	uint				src_len;
 
-	src_f = item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
+	src_f = item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[0].iov_len;
 
 	xlog_print_trans_cui(&src_f, src_len, 0);
 }
@@ -563,7 +563,7 @@
 {
 	char				*f;
 
-	f = item->ri_buf[0].i_addr;
+	f = item->ri_buf[0].iov_base;
 	xlog_print_trans_cud(&f, sizeof(struct xfs_cud_log_format));
 }
 
@@ -667,8 +667,8 @@
 	char				*src_f;
 	uint				src_len;
 
-	src_f = item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
+	src_f = item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[0].iov_len;
 
 	xlog_print_trans_bui(&src_f, src_len, 0);
 }
@@ -707,7 +707,7 @@
 {
 	char				*f;
 
-	f = item->ri_buf[0].i_addr;
+	f = item->ri_buf[0].iov_base;
 	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
 }
 
@@ -954,8 +954,8 @@
 	unsigned int			new_value_len = 0;
 	int				region = 0;
 
-	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[region].i_len;
+	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[region].iov_len;
 
 	/*
 	 * An xfs_attri_log_format structure contains a attribute name and
@@ -996,17 +996,17 @@
 	if (name_len > 0) {
 		region++;
 		printf(_("ATTRI:  name len:%u\n"), name_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
+		print_or_dump((char *)item->ri_buf[region].iov_base,
 			       name_len);
-		name_ptr = item->ri_buf[region].i_addr;
+		name_ptr = item->ri_buf[region].iov_base;
 	}
 
 	if (new_name_len > 0) {
 		region++;
 		printf(_("ATTRI:  newname len:%u\n"), new_name_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr,
+		print_or_dump((char *)item->ri_buf[region].iov_base,
 			       new_name_len);
-		new_name_ptr = item->ri_buf[region].i_addr;
+		new_name_ptr = item->ri_buf[region].iov_base;
 	}
 
 	if (value_len > 0) {
@@ -1014,8 +1014,8 @@
 
 		region++;
 		printf(_("ATTRI:  value len:%u\n"), value_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr, len);
-		value_ptr = item->ri_buf[region].i_addr;
+		print_or_dump((char *)item->ri_buf[region].iov_base, len);
+		value_ptr = item->ri_buf[region].iov_base;
 	}
 
 	if (new_value_len > 0) {
@@ -1023,8 +1023,8 @@
 
 		region++;
 		printf(_("ATTRI:  newvalue len:%u\n"), new_value_len);
-		print_or_dump((char *)item->ri_buf[region].i_addr, len);
-		new_value_ptr = item->ri_buf[region].i_addr;
+		print_or_dump((char *)item->ri_buf[region].iov_base, len);
+		new_value_ptr = item->ri_buf[region].iov_base;
 	}
 
 	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT)
@@ -1065,7 +1065,7 @@
 {
 	struct xfs_attrd_log_format	*f;
 
-	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
+	f = (struct xfs_attrd_log_format *)item->ri_buf[0].iov_base;
 
 	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
 		f->alfd_size,
@@ -1156,8 +1156,8 @@
 	char				*src_f;
 	uint				src_len;
 
-	src_f = item->ri_buf[0].i_addr;
-	src_len = item->ri_buf[0].i_len;
+	src_f = item->ri_buf[0].iov_base;
+	src_len = item->ri_buf[0].iov_len;
 
 	xlog_print_trans_xmi(&src_f, src_len, 0);
 }
@@ -1196,6 +1196,6 @@
 {
 	char				*f;
 
-	f = item->ri_buf[0].i_addr;
+	f = item->ri_buf[0].iov_base;
 	xlog_print_trans_xmd(&f, sizeof(struct xfs_xmd_log_format));
 }

-- 
- Andrey

