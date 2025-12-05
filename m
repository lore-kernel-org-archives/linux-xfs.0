Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3A2E0938
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946962; cv=none; b=YlwMlsnEezfX9uaKGSPVf96qBVk6uoXzuZmA/nMl4Lp6CUEhQruQD/B/4jKx5dEVAZFsXXvIm2mHvskpHItueOxmV7TM8CY1qOvzAP2CuMYdgl9UDCFQ3DHiOdNItfGcyGloZ0jFI/Qma1j3wFsJe1Rbraggn80SKa3LRwgfkgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946962; c=relaxed/simple;
	bh=5aUbd8uf5XjYJM70XH6qz2dvQ+Jvc2K0PjqtK53wIPE=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7/rUwXFNlNUj5GxZ/zXycF04P6ofutZwDi73kdCWMTYKAG3GBNlDhCLVEVMM6+VSz390ALHGO0BgnMQlx9l2lM9eqTwUNPClmsI0+HMv8oTpPf9Zik5d8pBBME+hxwwAFqPiTG2MmJmP2/5KD9o4FCi0RXnJU+kn0bmn6GXKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgvjLpZv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ht5IGyI+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgvjLpZv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ht5IGyI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
	b=dgvjLpZvOiaGwka+w0eZbqcf6WAX/vTFOtJnaJri/IcvzI9qFLzcv4Sh0i8JKXCdii/UwE
	oAH4pO7dZnd5uGF7mYDv0+gllJMxSoyRMy9sUgU1PjrVstRILTD8aAxgYxPYEeU+s6yB+h
	NbKpayHP3cILqXfe6CxTmqqBoI4e/7k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-to92zpTCM2iBDE9Cm8mD7w-1; Fri, 05 Dec 2025 10:02:30 -0500
X-MC-Unique: to92zpTCM2iBDE9Cm8mD7w-1
X-Mimecast-MFC-AGG-ID: to92zpTCM2iBDE9Cm8mD7w_1764946949
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so17741035e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946949; x=1765551749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
        b=Ht5IGyI+xpjBtRtSueVzAeKKtmE2FruC0olzfmnHxOalE4R2zBq1o/ovgxFL4G1DVH
         wEbUl4lR+sMllGgv7xVMmPau0A8+QEM+rJpQ2PyHfg7blS80XmBRtqYdlXj/eb+wO7sp
         t6UHPCp9iVqdTBGN2u4IOhGBF/w7BP181Rlv0/fX8i5iZxoiBYan74mgHuDGRsexvYYk
         vXCwfMRMk8qGrYwMOkYKaQHKMtu7k+pqV+qJ/IgH+apGAAsDtAHXgXHvgGqBamRpmDnB
         aIZa9QLRWvHJ/Ih69TOjgpLoqXS1aqlD0u6wU5j+RmTJm8EIwOIjgtGGvRQ5wmp01gcV
         J/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946949; x=1765551749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
        b=tDx8gywKB/QvgvRuWCjPZY5RriOyiU1Rj3rjYkayjtdj1QLIu7b6TzfQXEqn4zDqUW
         nLj20f+IUipkqNxHZ9iSXqEkWkUn4BfOjYSmx1tjmG3mTHhBOKsy3XqR7R1WJDAXU5lJ
         gWTtozwl/O7AUdKykNPItbsic0Ya2nmxCv0XErH4q9EOCJf0kGqounFNvxVBaxWaGvMD
         CLBajK0FvtWYi3fkMarsiTg91U8HETjn7FyeOFdc6a7CPZDTGQd2ZuMNLSCCBP+0Wv29
         JQRhLeLF0DVQYLhg1nn414yXdW12tjNSoSTn/TQfJCA6qdK8qylSHpQ4B0mFZJpWTK3/
         jWKw==
X-Gm-Message-State: AOJu0Yw/2CMy1XowUZs9laZl/oWKwHxI23j0eDLaW9YWbxYrjtA0XX33
	nw8B7NB9hS11CDl9IcMpa0FH6tDbRR5IzDCPDaIEgwsrudeOOTfBZzvxDzAM1rGB2MC+kT/L8QV
	azS7yRFN+yN9pQIId5J4+q4EVhWe5YIqJTNJkXefPXAhbfQPbkX85NQq3uZYFVcCrGxecxG67yI
	jgxoxscB/VOmF+DW0kVgotbckQtqurgdlftFY6ontN9Yzv
X-Gm-Gg: ASbGncvEbyno8f5XwtvYnd/Ib4RyDmxb82cQB9YDlocApkSin2RDh/NMMwbz1hlRMjv
	28zG4zKucj9sbFDUQdlRF0lPLbMWYMEm0oA+J3g7RdKC81EByDZ/2n50It8zudMfrfberZXcrPZ
	eNyKYSTZtFGny34NVJZab2rAr5x+5umVQh470bNuT5dL0p1aQQEKwNcERZ8zgeHziBcw8N9V/Rz
	Rou9P4gmLhSKicDJszRtQaWn24w+0Tr0Q0pZJNEFfsRmIt9s3QaqW82urPRUBRqLPWH62Huo11F
	vL9ToKnwcQHTAuQAQfyiW9oKxA7CtYpxbYz/Euds/xwCt2g9YeexQ4Tx8IKk+3n2gMBdp3lWvJc
	=
X-Received: by 2002:a05:600c:3152:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4792af3dedfmr94231725e9.23.1764946948766;
        Fri, 05 Dec 2025 07:02:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4pte4Nj6Ei6yf7Enuk8Q9XZPfuHrR6M/eDzk6DNUJLfPvuzT8TfdfvxSDtTf+FAly1TadHw==
X-Received: by 2002:a05:600c:3152:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4792af3dedfmr94231315e9.23.1764946948233;
        Fri, 05 Dec 2025 07:02:28 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310b693csm85868685e9.4.2025.12.05.07.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:27 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:27 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 11/33] xfs: convert xfs_efi_log_format_32_t typedef to
 struct
Message-ID: <offbmnhbrqimwq3damk62zdqt4omlye4mven4awvdboi72idsm@saf7fi7uplyd>
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
 logprint/log_redo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index b957056c87..cabf5ad470 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -28,7 +28,8 @@
 		memcpy((char *)dst_efi_fmt, buf, len);
 		return 0;
 	} else if (len == len32) {
-		xfs_efi_log_format_32_t *src_efi_fmt_32 = (xfs_efi_log_format_32_t *)buf;
+		struct xfs_efi_log_format_32 *src_efi_fmt_32 =
+			(struct xfs_efi_log_format_32 *)buf;
 
 		dst_efi_fmt->efi_type	 = src_efi_fmt_32->efi_type;
 		dst_efi_fmt->efi_size	 = src_efi_fmt_32->efi_size;

-- 
- Andrey

