Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFB217C77
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946962; cv=none; b=MoZ8H8wno+8F3rrZdpg6TTeZxgp0pTk1ilPaHn0yqLTO3YXkT4b+rYQP6oeccQxOcKte0NiE++NtnPenIo9MZaMGPsacSzmUxm141qvKj3ZVLUQaFjKMXbHeNrWaz3GvrwLQfz2swyAoX8BOB+akFpycjyakeHXiTciDB67AahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946962; c=relaxed/simple;
	bh=7jzFRfVs3JHds9sFjDq/pICjKV2QinhYbNIykzoOTwA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/lzchT2o77MbHiFaNz6swPrRtAwlETCIFluGfvh6cNIMlPJSwJ8K+o3rMTlEFPesacb3xXLqRcqidoehYfid6+j0ymIh5ZZ4UHs7J+ASnXfjdHsR9gC4uFW+gOByjEuzS+Dq812J5eLMePXCbISBUyCc4HIw8OC//w2HcGGF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAs5qn5K; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWn/L9xH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAs5qn5K";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWn/L9xH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
	b=XAs5qn5KZkIdkjaj0yPwQ7ySpRP6tg+NBLyJwpFcQIpcSbpfhGxqm+h6NphcsFu6jsJrLQ
	mBt+dVzwFOeNpaOBWdT1feJTgR/yzy69DlSYDp2w8H0b4b8LkeEVFRLyGqSBokHBpm8lUy
	EVOlGWkL8aEWWzBAw9e86ugKfPDEkbQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-nC_WYD7dP6-QeyGD27YDAQ-1; Fri, 05 Dec 2025 10:02:36 -0500
X-MC-Unique: nC_WYD7dP6-QeyGD27YDAQ-1
X-Mimecast-MFC-AGG-ID: nC_WYD7dP6-QeyGD27YDAQ_1764946955
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b478551a6so1208706f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946954; x=1765551754; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
        b=hWn/L9xHY/zezBg/K1kdhAej72Z1U7gCQfTYoaOt3lgswFlp7EoUoUYJ4FP7X8//ur
         TXsGQH4qwYWEt0KcGUk1A1rMGC5Z61djD8U6oYl8uuPMvllgFCPT6bQ2K1M6pE7Dzwgg
         ci/3UbHUexwrXQCFP5j/swf1VKdjhqHN6Mk5IDbgGSKf/SvvK7mwk1+UtfX1TvzDjRST
         F7m8j0AJ4X9CpL3/Fd3fE+9VfQcKg8j+YEit3P7jt2cI+0FLE1pLCzX8EfTwqXGC5jBs
         ln6euzj+seHijd6bbABXxn5Uvj/wzWiNfeTBNb4RSwE8F2gCo04fDqq8EXXLij21y+Ud
         8rqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946954; x=1765551754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
        b=YP0ElVlFZPk6vv/4GdSn8B2pO0FHpylqjZy2s8SU3hsU08Zh1bsL6O8SpScFBGEVU2
         IwHCYw/hStwFSHlRG3OLD76a3YumPL1iP5oBaInKyauCM00+keTVaKKpxqoN4kjg53AG
         s0AEr6AzMJ1Bhya1rVrYmvLtHZfGXjZl98f5UYOsSIN18qIDgKm3wu5IIf+Xy8YmMBU7
         3it3c7gXH6eBW2WhhqYZi0AQiW4l2NAd1tEQgmeDoduXLuo8vLoWarMMv8lRtXCAx9ni
         /jRFa7HB+VfRW0exgdPwJKmMoog6RMQM+FG4mHyAL7WfVCJzJVelw/nqVmY/VKMOfUQd
         Kqyg==
X-Gm-Message-State: AOJu0YwE4yHzpenpwLk3BP4HwGyE3Ddk4rxSXXULuddPV87DZkkiR8j3
	S47B/UvLLfPi4sa4eV1RG8zs9A019bx1rreFRkt45xFzH+d39hqBtCaT50CFzqmFycTifqxGVsE
	a8z+ciatt7g1IoaDXpHcgX6gEcIOHnLNlvRF2C8ZuUF3926lNqG6Hc9aHItSFb9pAy4qCxt3EYP
	vbMyLpyH+jOgtVX5s+eapaVMcCuwgULVRvHJM3V73x7+Rf
X-Gm-Gg: ASbGncvwpFg6wVhUYLn1UyTHorgdGzXnD27V0SD3vAN3Nx3zfHYqKUay2PoGCJVxLDd
	gT1Uo0mdfHBvyDeB0XWE6hNXNwv0raNgQvgUfy2s+BRLUF+8CiMNttm+NCKEJjN++/gG3ihxPKI
	14yZsLkpQB9uxW+iN1DwKD1Mwyg9YvirkLF0JVkcKWbI65zflf4Od2Tgn9RBXcHbkf/suGxhhpU
	3Jyuxa90+YAKO/9mVkVFFi5wkP0rwiNmOmKWaC4pYq48DCnr3Wcw/MBj779td7YtD1N5JqYxXLE
	qdQpc9qa1izdiXh3e+3NVrzSN8nzTHWGNDD7B7wlVEJyKILkAYTRtKSJwfB81+r8gCWHdTlW+sc
	=
X-Received: by 2002:a05:6000:1868:b0:42b:5567:857f with SMTP id ffacd0b85a97d-42f731ced45mr8945394f8f.50.1764946953704;
        Fri, 05 Dec 2025 07:02:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8tO7ZqdOe2keuKn5MgHZLi4+SuTtHcM4PI1lT17dsblGi77j0z8eLgeqgCIJMyksAg85MMg==
X-Received: by 2002:a05:6000:1868:b0:42b:5567:857f with SMTP id ffacd0b85a97d-42f731ced45mr8945335f8f.50.1764946952983;
        Fri, 05 Dec 2025 07:02:32 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222478sm9103920f8f.20.2025.12.05.07.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:32 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:32 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 12/33] xfs: convert xfs_extent_t typedef to struct
Message-ID: <6rjslpkxq73hh5rqgutct7wfklwq6c2gs3kmeoorm57bp7lqcz@gvgkzk2k2xv2>
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
 logprint/log_redo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index cabf5ad470..cdd6e8b763 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -71,7 +71,7 @@
 	const char			*item_name = "EFI?";
 	struct xfs_efi_log_format	*src_f, *f = NULL;
 	uint				dst_len;
-	xfs_extent_t			*ex;
+	struct xfs_extent		*ex;
 	int				i;
 	int				error = 0;
 	int				core_size = offsetof(
@@ -141,7 +141,7 @@
 {
 	const char			*item_name = "EFI?";
 	struct xfs_efi_log_format	*f, *src_f;
-	xfs_extent_t			*ex;
+	struct xfs_extent		*ex;
 	int				i;
 	uint				src_len, dst_len;
 
@@ -154,7 +154,7 @@
 	 * Need to convert to native format.
 	 */
 	dst_len = sizeof(struct xfs_efi_log_format) +
-		(src_f->efi_nextents) * sizeof(xfs_extent_t);
+		(src_f->efi_nextents) * sizeof(struct xfs_extent);
 	if ((f = (struct xfs_efi_log_format *)malloc(dst_len)) == NULL) {
 		fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"),
 			progname);

-- 
- Andrey

