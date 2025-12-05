Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE03090DC
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946917; cv=none; b=UHwCtvmlfnKo8PsWGDkQ6/WOqKkiD3fkuJvaUB1d1WggHm1kFWEfOpqEbUW9/5qzMvjjf1AMuVW0SK1n/cYZYDMTzya+6NuWReToP1I2ipwBkwsA79+BN6U8ywOIWoXVhkiJwn/7LZ7kYWgRirS2mI0zixbPSm+z4wIMrvMtCP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946917; c=relaxed/simple;
	bh=kn7X1I/uw6UHHIqwc09FdqIHQ53ZUfQrHAGfSut99iA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p33hHAY3bsMnx2g6n7Kjp1Grh92Rh+b9Odb6T524Mb0dKlpTWOXTD1oV4aX8/S5/mD4KZ0rX3Jlo+L5NhQU8DnwOEp+RYmsGkigTMBloo7iK7VV00oEFP/XwZMyunFSF5zTc5shkEhktdzoViBdzVryRbvY21IDOW+1Db45jjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TY3tLz9v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXQ6krzx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TY3tLz9v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXQ6krzx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
	b=TY3tLz9v0MrnaV8YAUANzmSgJ8kaHcBSylm4yPQNX2x1bYrB0ZtInDgOi1TQqk/VURaDMr
	F6cMZTXp5GRsPDMbmmZ2UfCqY0YfEN5QcaJZjMfoBSfwdMj7tx0Bj3xAZqUVbYWhlogUNZ
	TfoKx+qo8DAVflptB2I+OyKlDLYlypo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-cDPBUbJ0P9a5lypHGbOcBg-1; Fri, 05 Dec 2025 10:01:49 -0500
X-MC-Unique: cDPBUbJ0P9a5lypHGbOcBg-1
X-Mimecast-MFC-AGG-ID: cDPBUbJ0P9a5lypHGbOcBg_1764946908
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so17972415e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946907; x=1765551707; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
        b=fXQ6krzxdgdlxoXMnX0oY/Ckh4xUyUKMalx5/6GnX/zBe1jd/W3tzH7tLyd+qCY0qG
         CDwyd3gXdrHtEi4r3mz4UgInjfL9xxeLHdjtVO5fYiWrYSeL0sXH9+capDsGXAluENPS
         MiENn458n2VXAgqCLWy6sp3EKD9BP8bJw0bxyM6nO7kgxMjSp25/ajX/dZ8uXhbQz4ze
         EnX9vvJDq0l0VoRaQbHzMIeayh1RYZCS0LHoJ+C7lK0N0dc2Jvo7CiIaiZIs6n8hv8Jj
         vkoJCd9Zb8QErFG1X6G4vMTeZG8w6lzfOkHh9cT8/d+sGUY6XlQHTtDl7iGVWSWB1dvR
         3eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946907; x=1765551707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
        b=Uas2Tl8X72XKxEx+7El59waO9DfzeW6neYWMg306wxEhJPvAQk/qWmlR+d3sWc2Nvt
         qYtPcXnku+ze6PL0ldCuFmOmiDKjK5Tl4DEyZndPG4UkLTNSG+48pqN1h4VtDt/9Wyd9
         BP34U47fVIAfDKfDDVE1U9gy1hLkPYnI8/GQOvEg3TGzpPDxKjNuIdlyAkx4kEgEGHqb
         xVa6f2wlHWefCEy5/0L6odaqu89mhblsMO+5mbBvdB3khSHKuCMpjNTRcOXcrbja4ovl
         FxJSRJO4ZzznlzptuuKDC67A46OMGuyTfPcc8Jf5Dpfseu4lEYQ21nhmc7HmymjTDq1c
         5POw==
X-Gm-Message-State: AOJu0YyFzDH5+0RsRToQjKxb1xwnTH4HdjrXNF+w5y+kEv0Rr7wstSkl
	GpzsA92QSLbZN8LuJhb883nagnLOft3QS9+12bDDjVKAmql2E2mgFtqrTXv16BWY9XGTm00+8kD
	Q3xdZdbtvbGr4NZlSL/w2zpPgUW1hUil40XMRpGYkPFsobP/Twgjg/6tDWuCSUCumBRAntHvCTW
	Fpk0Gq749ji/01vajGldU9WQr3rNyy1OgZGXLFYVxOOUQ3
X-Gm-Gg: ASbGncuwp0GICMlEalwkvlxREqhdLNlFkb1Zcbw6ghCikGM7KBq04cTgvSv2ghztUw2
	jeYVTTNf4AtkqCtSQgX0wK0LTCM/T8mPQGEilny1rSAqk5upyMA+NOQmMuWRlgze+ts9bW3W6Ck
	HYtSHPJ64D7UXlw6dkW3zzPn+Y73GMkNuBWkZM17uDsIzjgGWtA9l6JI/Ts97MFndMqcyHSDlaD
	fzRb1n2JNn8AUuvO3XfWPQMyy/wgRjj2LlGPY7FJYZoH5ozn5AwEOSvWJCUSmgGRGkbSLNdt1jm
	NoPlA7oPVjGxQlqALwN8ZSqLYnTpuWIadT22yFvI0jfraany1W/2RqXZpkwVumSdDt5zVFpCJwY
	=
X-Received: by 2002:a05:600c:1c27:b0:477:6e02:54a5 with SMTP id 5b1f17b1804b1-4792f387211mr62921995e9.18.1764946907109;
        Fri, 05 Dec 2025 07:01:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCsR/CkBPYjMf0+3MoCf0FW3lP4j8UaT8BfOUE/ZvVTiU+9PIAOMEh3RVm31rBCrz8YVBhiQ==
X-Received: by 2002:a05:600c:1c27:b0:477:6e02:54a5 with SMTP id 5b1f17b1804b1-4792f387211mr62921475e9.18.1764946906457;
        Fri, 05 Dec 2025 07:01:46 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331e62sm9617091f8f.35.2025.12.05.07.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:46 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:45 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 4/33] xfs: convert xlog_op_header_t typedef to struct
Message-ID: <wtfv75kgakcf24f2k44vzxbzasvzktgxrjviiuipg4iub53rpq@xmwhgtgcrgob>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/rdwr.c             |  4 ++--
 libxfs/util.c             |  8 ++++----
 libxlog/xfs_log_recover.c | 12 ++++++------
 logprint/log_redo.c       | 10 +++++-----
 logprint/logprint.h       |  2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 5c14dbb5c8..500a8d8154 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -120,7 +120,7 @@
 
 static void unmount_record(void *p)
 {
-	xlog_op_header_t	*op = (xlog_op_header_t *)p;
+	struct xlog_op_header	*op = (struct xlog_op_header *)p;
 	/* the data section must be 32 bit size aligned */
 	struct {
 	    uint16_t magic;
@@ -137,7 +137,7 @@
 	op->oh_res2 = 0;
 
 	/* and the data for this op */
-	memcpy((char *)p + sizeof(xlog_op_header_t), &magic, sizeof(magic));
+	memcpy((char *)p + sizeof(struct xlog_op_header), &magic, sizeof(magic));
 }
 
 static char *next(
diff --git a/libxfs/util.c b/libxfs/util.c
index 334e88cd3f..13b8297f73 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -85,11 +85,11 @@
 	 */
 
 	/* for trans header */
-	unit_bytes += sizeof(xlog_op_header_t);
+	unit_bytes += sizeof(struct xlog_op_header);
 	unit_bytes += sizeof(xfs_trans_header_t);
 
 	/* for start-rec */
-	unit_bytes += sizeof(xlog_op_header_t);
+	unit_bytes += sizeof(struct xlog_op_header);
 
 	/*
 	 * for LR headers - the space for data in an iclog is the size minus
@@ -112,12 +112,12 @@
 	num_headers = howmany(unit_bytes, iclog_space);
 
 	/* for split-recs - ophdrs added when data split over LRs */
-	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
+	unit_bytes += sizeof(struct xlog_op_header) * num_headers;
 
 	/* add extra header reservations if we overrun */
 	while (!num_headers ||
 	       howmany(unit_bytes, iclog_space) > num_headers) {
-		unit_bytes += sizeof(xlog_op_header_t);
+		unit_bytes += sizeof(struct xlog_op_header);
 		num_headers++;
 	}
 	unit_bytes += iclog_header_size * num_headers;
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 7ef43956e9..f46cb31977 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -674,7 +674,7 @@
 	xfs_daddr_t		*tail_blk)
 {
 	xlog_rec_header_t	*rhead;
-	xlog_op_header_t	*op_head;
+	struct xlog_op_header	*op_head;
 	char			*offset = NULL;
 	struct xfs_buf		*bp;
 	int			error, i, found;
@@ -808,7 +808,7 @@
 		if (error)
 			goto done;
 
-		op_head = (xlog_op_header_t *)offset;
+		op_head = (struct xlog_op_header *)offset;
 		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
 			/*
 			 * Set tail and last sync so that newly written
@@ -1199,7 +1199,7 @@
 {
 	char			*lp;
 	int			num_logops;
-	xlog_op_header_t	*ohead;
+	struct xlog_op_header	*ohead;
 	struct xlog_recover	*trans;
 	xlog_tid_t		tid;
 	int			error;
@@ -1214,9 +1214,9 @@
 		return (XFS_ERROR(EIO));
 
 	while ((dp < lp) && num_logops) {
-		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
-		ohead = (xlog_op_header_t *)dp;
-		dp += sizeof(xlog_op_header_t);
+		ASSERT(dp + sizeof(struct xlog_op_header) <= lp);
+		ohead = (struct xlog_op_header *)dp;
+		dp += sizeof(struct xlog_op_header);
 		if (ohead->oh_clientid != XFS_TRANSACTION &&
 		    ohead->oh_clientid != XFS_LOG) {
 			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f5bac21d35..e442d6f7cd 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -793,7 +793,7 @@
 	int				*i)
 {
 	struct xfs_attri_log_format	*src_f = NULL;
-	xlog_op_header_t		*head = NULL;
+	struct xlog_op_header		*head = NULL;
 	void				*name_ptr = NULL;
 	void				*new_name_ptr = NULL;
 	void				*value_ptr = NULL;
@@ -850,7 +850,7 @@
 	if (name_len > 0) {
 		printf(_("\n"));
 		(*i)++;
-		head = (xlog_op_header_t *)*ptr;
+		head = (struct xlog_op_header *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
@@ -862,7 +862,7 @@
 	if (new_name_len > 0) {
 		printf(_("\n"));
 		(*i)++;
-		head = (xlog_op_header_t *)*ptr;
+		head = (struct xlog_op_header *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		new_name_ptr = *ptr;
 		error = xlog_print_trans_attri_name(ptr,
@@ -874,7 +874,7 @@
 	if (value_len > 0) {
 		printf(_("\n"));
 		(*i)++;
-		head = (xlog_op_header_t *)*ptr;
+		head = (struct xlog_op_header *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr,
@@ -886,7 +886,7 @@
 	if (new_value_len > 0) {
 		printf(_("\n"));
 		(*i)++;
-		head = (xlog_op_header_t *)*ptr;
+		head = (struct xlog_op_header *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
 		new_value_ptr = *ptr;
 		error = xlog_print_trans_attri_value(ptr,
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 8a997fe115..aa90068c8a 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -65,7 +65,7 @@
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);
 extern void xlog_recover_print_attrd(struct xlog_recover_item *item);
-extern void xlog_print_op_header(xlog_op_header_t *op_head, int i, char **ptr);
+extern void xlog_print_op_header(struct xlog_op_header *op_head, int i, char **ptr);
 
 int xlog_print_trans_xmi(char **ptr, uint src_len, int continued);
 void xlog_recover_print_xmi(struct xlog_recover_item *item);

-- 
- Andrey

