Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23F31283C
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788995; cv=none; b=EIbKMhoWkEDGjCqDts72GIVjkR25CZON0waMMYmbBAPubyoMt+jQ4fxPYMjczNhCdhB0buC9Y1SxuoxLC0TV8pPl6ZQCN7eVJXw5X5LDsSHNVLcggf2/QMhjYkOOepZVbAkkcjEkG3FS6HA/GOAbXLKPXRsFPaGmwGHRcHCZ81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788995; c=relaxed/simple;
	bh=2Op9lNi4/6itTpumlZII+ClIS18aN0Lb9uogRFmwVD0=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYE+5EHQ1zW+qYLGbikC2v9Xz5HORxtF+85aqxgBS3WxYxavj4ixwtqBLL2vKjgXKYGLbfYv5Q2WhpY4aFi51mXg6iSruyfeLcQUOUnkU6s+FjewOlrTLykb2PJzyCs5B3IOLmsNwxcWuLeYQHucfDtV9ut+v9E4TN3f9odjp00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T7ARq9X8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uAk7f1DH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T7ARq9X8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uAk7f1DH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=88shvhwcWddCVfCAs/CdseMc44co1C2x0Eii7rp7kCY=;
	b=T7ARq9X8i2pDvHfcVEHnPlqbZAbWqP653vZxikHmfnl0LRGmVpvaYLDlTNBvnXYeuZ2/q7
	XwfYM0NzuFQxIKgLsgEehvNsmZ+hGmrJuWUTaRoAqe9852insiYEXx4aueMi2nFzLrb89F
	kwkzqKZ86p56feEdtGKGQWBCer5z26s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-ff1ujsXmPVa_qKmTRslZ9g-1; Wed, 03 Dec 2025 14:09:51 -0500
X-MC-Unique: ff1ujsXmPVa_qKmTRslZ9g-1
X-Mimecast-MFC-AGG-ID: ff1ujsXmPVa_qKmTRslZ9g_1764788991
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42e2b9192a5so56218f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788990; x=1765393790; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=88shvhwcWddCVfCAs/CdseMc44co1C2x0Eii7rp7kCY=;
        b=uAk7f1DHwl7hlCYUH1Ukp92YFDrVTq5pXTh8mrJipFMR5BOCHuY61m5aNBLCKfcyrr
         g8ze20TDuQoyHliz3ksQTPx/WT0LYNEsQROChA3I/ue/5y3LAD7PP7rpSnCaMsBpCOf1
         +HCMnO3yG3b5syP727XYNGeHPBu82i2EYLuRFmLic3KwJIituASeSOTx/XmtvxY18o+m
         RX3Ar7Cm8M6D6qae5V9axmSTzl5hJjvfqAZ2t4GrJdJjl+/bBf5xXauLbmZCUj0YsOu8
         e0iy0fhZ1a4t4Z8//LJ87AzHs7Lh1ZhH+jqSR4ybKfhYZz3aPGDowOo/ju2rnYWRi357
         s5cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788990; x=1765393790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=88shvhwcWddCVfCAs/CdseMc44co1C2x0Eii7rp7kCY=;
        b=rkV7zD9DK7WeiHkhMNXmWxlMXmu3QYsqOqA8g4qm/JrM1efh0MDD6miV/1mpz6MBVj
         ms4d7lUdw1rVRHuxA6wHMvwtivDH3FlX0Jw207MngFdl89i5Lfs1xuKCdexGnjOd0ixU
         sB+pj2qeIc/qvVJXWgMxMaiGNzel1s1KxBVblnYE3Fnk/WzoHnUbE1A7miZoFY/yGGxF
         ybNq4rlDaqt1Q4NnDiAC5HUDk6frACyOrQ02DnP6xfCaxDx4g9NTjoVg4Sjeuv0wOfQT
         8Q0MObIAOIPHU84crDCnNb2mS1cI//JYu54KohGvwNuF+PXIMLvasxDUoguhHs4LsxPW
         4y9Q==
X-Gm-Message-State: AOJu0YzBz4Lew0//oMBVVf2uWvXci/lV2Rgd/VwUlHzqTNa+YPesqeQO
	GeA3G/LqUZVp0kZb959PNkh46aOho/aY81WTxfSoeSuxOR3Hm93AWH6ZFOvendm7tGbwpWYwYHE
	F48qGYsuFlvnx20VNKpwNFxJSzimJMNTVdMSSUbA4WIfyUIU+ERk/NKFRq97FGKK6C+uIoC+iCK
	umlsIVqq7eGsNmqGCeWAYbGQ2WTdtoxdN9EGB959KGgauD
X-Gm-Gg: ASbGncvVOswLZCE8L01NdGdx2H4oKK/gh2KZr1Dvzf1T58Ra2aVlrMJ7/85irwPf59c
	3A3JsonBggeMsduhx+ICUBUfdRHryD1ChSHhy5KGgHzrrJA9Qz2a4UGU5Vi06X7YlCSJWkrzOpQ
	vpztAs4vHF1ngxhp16DMG3xN4sfHWvEnWGp0AJ5IM7DbZOiou8gpNR/UgkTO0UeDf7rg8LwInrL
	s6PZBuOxl9DoAmSrELAp0baJuuwOE8sI6aFs7qJkPf7wr8mI2xQnLpEYjuoWEv0mm8n5WnwilJW
	T1GGT1XQ7FvywtnbYCLGJOAujXSb0QQYsmBVtIJT0tdsCrdI/tKDH8UAcOAb/mwVWKpA5ji5+jg
	=
X-Received: by 2002:a05:6000:40c7:b0:42b:2e94:5a90 with SMTP id ffacd0b85a97d-42f731a4ddamr3851893f8f.36.1764788990024;
        Wed, 03 Dec 2025 11:09:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfIOezb9bfuBySq+PStzDZFOznqlCueUbP/C04dou213vM3BlB2WqCv7jrqy2y+dXcxbBNwQ==
X-Received: by 2002:a05:6000:40c7:b0:42b:2e94:5a90 with SMTP id ffacd0b85a97d-42f731a4ddamr3851858f8f.36.1764788989494;
        Wed, 03 Dec 2025 11:09:49 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca1a38bsm41786916f8f.24.2025.12.03.11.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:09:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:09:48 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 23/33] xfs: convert xfs_buf_log_format_t typedef to struct
Message-ID: <qptxxayqxie4vwryddds36sofs44zufqo3wes6j4dfehl2jxoq@3ioxr4fnyynb>
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

Convert xfs_buf_log_format_t to struct and retab arguments for new
longer type.

Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 include/xfs_trans.h      | 10 +++++-----
 logprint/log_print_all.c | 18 +++++++++---------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d7d3904119..a3e8a000c9 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -46,11 +46,11 @@
 };
 
 typedef struct xfs_buf_log_item {
-	xfs_log_item_t		bli_item;	/* common item structure */
-	struct xfs_buf		*bli_buf;	/* real buffer pointer */
-	unsigned int		bli_flags;	/* misc flags */
-	unsigned int		bli_recur;	/* recursion count */
-	xfs_buf_log_format_t	__bli_format;	/* in-log header */
+	xfs_log_item_t			bli_item;	/* common item structure */
+	struct xfs_buf			*bli_buf;	/* real buffer pointer */
+	unsigned int			bli_flags;	/* misc flags */
+	unsigned int			bli_recur;	/* recursion count */
+	struct xfs_buf_log_format	__bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
 #define XFS_BLI_DIRTY			(1<<0)
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 39946f32d4..bbea6a8f07 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -68,17 +68,17 @@
 
 STATIC void
 xlog_recover_print_buffer(
-	struct xlog_recover_item *item)
+	struct xlog_recover_item	*item)
 {
-	xfs_agi_t		*agi;
-	xfs_agf_t		*agf;
-	xfs_buf_log_format_t	*f;
-	char			*p;
-	int			len, num, i;
-	xfs_daddr_t		blkno;
-	struct xfs_disk_dquot	*ddq;
+	xfs_agi_t			*agi;
+	xfs_agf_t			*agf;
+	struct xfs_buf_log_format	*f;
+	char				*p;
+	int				len, num, i;
+	xfs_daddr_t			blkno;
+	struct xfs_disk_dquot		*ddq;
 
-	f = (xfs_buf_log_format_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_buf_log_format*)item->ri_buf[0].iov_base;
 	printf("	");
 	ASSERT(f->blf_type == XFS_LI_BUF);
 	printf(_("BUF:  #regs:%d   start blkno:0x%llx   len:%d   bmap size:%d   flags:0x%x\n"),

-- 
- Andrey

