Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E132E14E
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789031; cv=none; b=ozhFbmfdP3Y4KjDEv1W3Yw0B9UGJVV7n+Zri9xj8/nhyxrDvDOkJ8QM0E48JeLXShSXudHSkbj1YqEwzrTmweM9irinLfcVjacRzT0Tj7Hv4BPgQGYiXt8GfHa+B69UrfjwbZIrJkCSo//aX3XbN/ixHgZZreYOpdN+AuNL3pns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789031; c=relaxed/simple;
	bh=K1Iz7a6IzcSmFU4qHNJzT3jvEKg/B/hP9owZVs45JRA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/xrFb6lKroo6OvkZhi2/+sn13LQzZ8z66F7lmIIjTf+/Uq8t+ZVQHXdAV7bGNQkh/5T5ig7qIoXGpGP4+Fcmadtk402rJAhvF6bHNqvRAPxduQ7E4QC8fai9/8ojmaMd6lMEOlu8j5WM7/e3PoXFGxF5kLvtQBUULxVKWW2YJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VwGcNIze; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I6ORIE7x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VwGcNIze";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6ORIE7x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Q59j4TRV0/ZJLGnJ5dQDHOc6QDyRmhRuLzJL2RFHzs=;
	b=VwGcNIzeHTLQldekmfeg1il3y/UWYurp5XT1rhUnrxy6LwVSBpTTaYxMsh9hzz7iN2k2Ga
	Vzg8aSd1uJmuOrWJPiv2LhS7GCwtWgl8XL5A/Pdg3lexB1Kq/r1tr/sZrKMbs3bz7X6+3s
	ldltr0m46N4PXLKPoKEl9YwSuhjLLuo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-42eDB46ROGyCSe0oWMWcyg-1; Wed, 03 Dec 2025 14:10:25 -0500
X-MC-Unique: 42eDB46ROGyCSe0oWMWcyg-1
X-Mimecast-MFC-AGG-ID: 42eDB46ROGyCSe0oWMWcyg_1764789024
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so666285e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789023; x=1765393823; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7Q59j4TRV0/ZJLGnJ5dQDHOc6QDyRmhRuLzJL2RFHzs=;
        b=I6ORIE7xVaSdSeiEUZ/z5wH5EKcV3OX2tVAFJZkxHFwvC325C36cQYHqhISMCCeCQU
         VWWGEEHcCFssqd/dHey9xpBwQGG4aE5MqfYmlxM+jEZniFeGIGIhniNb40ugjA0iT+xm
         aMmU6gK6X/7Kit8ClIaQtbmOx0G72YTYDTyWWY+7aOpwvy5nZ7f24wpbVDmi0HrMhtkP
         DFfr7xOpLAFam4fxozfujX7ZzCXwqOq+L12pW6CngtEQJUi3oLQ/PWo6Jvzc7FMC00fZ
         yub+g1vX5UBu+iF2RFRIlpykcH+8X8/eWetFVk43BabSIHjad4CalDbzKM5nBPoizZCA
         +RkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789023; x=1765393823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7Q59j4TRV0/ZJLGnJ5dQDHOc6QDyRmhRuLzJL2RFHzs=;
        b=uuGCHI5GcOGnSO9/b9aYqb1b6D/T9ZUlVc6pQgaXe3AE0yhFHkjfGtfmrsL2irTNb9
         O7Hfv6mOSyYXLXSyYeorRAvTrTe9WXCuTtmAGZvYIZC19DeH15pJTkbLDKxGhQUk6N08
         7He4zgEI/gw28+um15GgWe9r06a3iElPFWvhbvPI57+6/9TMvaCV+LoB3zV/mBbax7MM
         7lg2tuwD2g17Uo9xQs4YulXBOgGKaNAo3G+rhnoJ8UWXmoA95xErM8bUXdZgZL4eWC9Z
         AY8vTfPDOp+NlcoozrFhG7Zgc8FwIkaJyXKx9LalwvDux9zM7jemZXwSLoac0P87vh9d
         aURg==
X-Gm-Message-State: AOJu0Yy3IyE3UenaG0rhi6kQREsWNjHrPxYWu/+L+dwrI+fhD7yoly9i
	Wz02GXs0ML+KF3iyTP6DB578w/yJjk+fHuPq+j8V6hC6LTUCyX7vl+ROzkKzBYf98Vi61WQZCr0
	9cetJpojCXxDTYq3XBf6WikIqVn0j1LFZJPydf6GDoGbyAD6CCju5RGNglf2MhKMgeg8iOlVNvh
	EO+9d7//xaFAC61BY3kzoVt2X0btUYFfDTLwt7Fv82F9Lw
X-Gm-Gg: ASbGncvbastXkSW7+t4OoIR+bDBsJSLdv7nZCLAxWpRyz/wudD6HvqIQ0krC9Q+fqnc
	Ac6jjo9Wi6xZd8m1/vrqHSRipv6LXGycdwVo6P2sPF8DvBUlNfl5Ce2+fzUDRgKlJafyB5XnnVd
	FSy9kaLfkMFt8wHLXKBDb5B7OxuSh1BgF4CSbNxte9VsEGHcYMJ1BTXSqsawJgm7VcdaNb7EBNC
	ByqJ1kMG7dRsyOp3LGDpTT+2KIgOiFSdLmMhu000evs/4Mxj4Nk/jCyVKWt18PVGSHRRLqVoH5c
	2k2ms0/ovlZWBh5r5mKuxBo33AilVW0aarSMq3mwj1L6+SYOZQC96qzfqepmRT6oHEhwOXtEk4Q
	=
X-Received: by 2002:a05:600c:198a:b0:477:5aaa:57a6 with SMTP id 5b1f17b1804b1-4792aef1c83mr35838715e9.10.1764789023603;
        Wed, 03 Dec 2025 11:10:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHT02jvPsiYlG8XUPBXtvJN+ruGFg3tpF0GoX9UhKovMYHTSdtm3+J8apxCd3t+WMGUJJaSnQ==
X-Received: by 2002:a05:600c:198a:b0:477:5aaa:57a6 with SMTP id 5b1f17b1804b1-4792aef1c83mr35838395e9.10.1764789023137;
        Wed, 03 Dec 2025 11:10:23 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7971c7sm66190505e9.2.2025.12.03.11.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:22 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:22 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 27/33] xfs: convert xfs_qoff_logformat_t typedef to struct
Message-ID: <nqzi2xc6oi5724wzcutvjd4ak2n7tzfm2nklr3vvsmb5ea5him@nalqjcbpg2ui>
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
 logprint/log_print_all.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index bbea6a8f07..49b2e0d347 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -181,11 +181,11 @@
 
 STATIC void
 xlog_recover_print_quotaoff(
-	struct xlog_recover_item *item)
+	struct xlog_recover_item	*item)
 {
-	xfs_qoff_logformat_t	*qoff_f;
+	struct xfs_qoff_logformat	*qoff_f;
 
-	qoff_f = (xfs_qoff_logformat_t *)item->ri_buf[0].iov_base;
+	qoff_f = (struct xfs_qoff_logformat *)item->ri_buf[0].iov_base;
 
 	ASSERT(qoff_f);
 	printf(_("\tQUOTAOFF: #regs:%d   type:"), qoff_f->qf_size);

-- 
- Andrey

