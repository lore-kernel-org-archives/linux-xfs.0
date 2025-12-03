Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6BF32C932
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789010; cv=none; b=SdinbpjH23baRrM7PBk6H7pyNeYpV+YG9O5KUPg5ePBLgz+iAwGKC4mIZZXckFsN7WrZEjYe+/Hq1baZ2QvZ10IErx5T50x3GwHLKSPu7hFDd+tvyvznL1GjBlQZhAxN4Bb7sdQ4OiFSl7vf15rgn5p6ELHyxws0oiff1+h0SxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789010; c=relaxed/simple;
	bh=kn7X1I/uw6UHHIqwc09FdqIHQ53ZUfQrHAGfSut99iA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avGpGt79pF6kbEfRAbb9JrA61mFKa6KAXPtMBeyKn0oskwi88rF1zhpo8JrpIkFGcPgl5xqzGS/aBxEg00tlcTcAMfwdGa00eRT6TC4XoUCCOKanF6KM4kyl6dfAk/lwELtED3kib2NqjkWVXAVWZekViW3nldkJGRSE36nQybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LA7yp+3o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6vvDgmA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LA7yp+3o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6vvDgmA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
	b=LA7yp+3oUMtCpTK+2RIs4tl9nR8rYDxrqZJUPly4MDdDaaNbGCd4sKiQiN/5IkrQgTvjdq
	HZ0/jXjlKrI2Dv+CmfE/ga2fe8LGbPIC83QRnNl01UWZPYKkgeDCRI8ECgneKKR6Jm8bsy
	XYf8710L37LIYoQHr1JimpuFaqvzdWk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-rEsDgXJHOnaJW5QUTw0ezA-1; Wed, 03 Dec 2025 14:10:03 -0500
X-MC-Unique: rEsDgXJHOnaJW5QUTw0ezA-1
X-Mimecast-MFC-AGG-ID: rEsDgXJHOnaJW5QUTw0ezA_1764789002
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so663165e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789002; x=1765393802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
        b=V6vvDgmASI5sKPjLeQinvg6R2Rd1lUfSVfTC/kkTZQf8JsEnKCMIqM5pFEKcrwaqDU
         NFb0n+p4pHicQ15VJuVfZmZGJ03WoSwWpf/7KTvNJzAZd8dauqrLzrajUkfUHJHggFAk
         5s6udPkdq40DmO/ZtpFSTUV/QY/Lu4e8CVQGy0hpjIbaAaW1E2Xadsx1XhX6UR3XDJ3i
         Ld7xDgJy5uo+W9+QC2TuEHt9BSxgJnI8WxgFVabHRIQIFKAY6UhXv8TZ0JoaOIBfRLIx
         VgKRlNZgwkiLtAk39K7c4ofOASUxYh90pEcd0H1PIPBO463+aVZwUur25xAJyHwB2zjR
         1WLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789002; x=1765393802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jEA5SYoJDu8UKqwurax3Bmf53eqHmABdIYa+yah+NmA=;
        b=a+4rnzJFBnkVHUKDDDO9EONSWwbPOQgnp4gvSXQkRXOH2bmLSI/Q71fGAf9Mvksx1J
         v0E104uqFPAxeuO0uAQGuKMhgvY3PAiS1aNduF/3XNsOHRYt/iLgtZ5vuSFqVmMUudhs
         AhQc/nV8xrjt0FecwT6Zw/oItc8LVW6dG8ziPK1dWXpmQx5wExc72WVYBsoz4pbm901F
         GOZWVjDPmQgmwXF4teSC/mwoV6Uvu4Z/ThtunH/Ob6N9rXI+SnJvXKWXm2Veq+ahEKgm
         KfxXZ09azrmyXnrjLdBuS19yzBtbNxEAAVJ5v8kqTsBH/JMhgkCN4WdOcc+AeQ9AMjKl
         +y4A==
X-Gm-Message-State: AOJu0YyB1LGe5z8et8wH7rC8jCwE3V0cG+EmdkusKGK3TnxPXI1aENBf
	PmJfL/PdfYtewkra6ZUdSusBsnMLioGhKI2DmUNcBV+3FXiwqeTFCX6xWIMGhRb9iRlfx6VK+ud
	aC4qMdlVbiDwOg1Jn71wSv80NwzfbcjquCf+8+tE8jh/cxdY+vxnp5xjdYX9y42paco/Cd/aYjs
	rwmkE1ut5x3xqUuB+qo7ePscPbmRNkc+6uLJ6Dj67Pf08i
X-Gm-Gg: ASbGncsgYd6iFlqRK+YfXdXqZctI5ck5bw5nTq+6c8KT1XfeChQv7NywZps3JcUf2c9
	trJvtQC20nDjoMuw56y4N+eCm+jrfKCM505oE/ggKPbw/S+e/hnPlF0IQL+rPmZ8Bl0/IpM90yq
	Xpl3Iu0ewbPMSAMYyy4658KfZjYAaS5Jw9ejrvv1coZ2A/frDuX2ynq2jnmZg9c5uhZg2VV4ipq
	nIUSQmIMyJY1tqjKO+XSvdcyLouNfsnJwcTCWEbAwn/oBinhgd+ui79M1xha4AKx6N0QvX+dMHj
	JeT9+QbrLozLkqGWfCJYIYlW1vCDuVHoEfRGSRj2N74G5XJMh0qFG74aqNwZM6F175NVw7QcesM
	=
X-Received: by 2002:a05:600c:45ca:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-4792af5e38emr38488135e9.32.1764789001733;
        Wed, 03 Dec 2025 11:10:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECMRxjVN7ZCjl/V7pCwKU6l9HCEBUY8yiB0zc0LT0wHu12NN/pYMGF15ScAmShSYUQac7UhQ==
X-Received: by 2002:a05:600c:45ca:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-4792af5e38emr38487775e9.32.1764789001188;
        Wed, 03 Dec 2025 11:10:01 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a8c611esm61914325e9.9.2025.12.03.11.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:00 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 24/33] xfs: convert xlog_op_header_t typedef to struct
Message-ID: <oxszmdfx2fqcbsi22lqnfvriec3fhkazakxma34msgn6j3b7ad@27hx5rsjvgiu>
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

