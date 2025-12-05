Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA606287256
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947018; cv=none; b=AsnbPH8cTZJsXycbCfUD7+TE7QaT6+L/MI69fW01NhOA1a288G4J7e6DYCQ71qrYlcPOStrABrMAZ5luzXzcaAbFnW7F1OAPHz+RF6H5Jr+27zOoJoXt2/qNpdNyyp2KyRzz6XyNmyRVc/4cPRZTfhRXdaSSGwDuPJfT70cskOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947018; c=relaxed/simple;
	bh=d7Fr8AowKYXvBaJdq+h8MDuoesfQWwSTfkw09kdWTKA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjnFHsYX48si1y1MbpAR13FL94psK2z8ftqWsiBfnUFVN6IlE1suwbX7wOsI+itiYB8Vuzk4Nwah/WAINN/YlXqTlXB1cR0vJax6cnjYfu4GfjKdJou30ZcAggt65zsd7g1FdFtC/i+qkWeKqBHlrJTZSGDXZ2vKWrt+ggFbow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ltawg1lR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+VJd4jn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ltawg1lR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+VJd4jn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
	b=Ltawg1lR5F/FG7EvHcr5sNfCpfmSkU7ITpbwM1kxaG8NZVl8x/fuFpVZzoF00wuz2rRTIR
	cFNkntva6Oc9YScjMFpMdvcSUrDzgxVzu/FIFnLrka8oCGdMd6T5UNKbwsKcNqHRIODGaN
	H4xPcMpSkjplS6g++wHQGBzw7vvJqwg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-EORrZgC6MXSo3gd1plV3MA-1; Fri, 05 Dec 2025 10:03:31 -0500
X-MC-Unique: EORrZgC6MXSo3gd1plV3MA-1
X-Mimecast-MFC-AGG-ID: EORrZgC6MXSo3gd1plV3MA_1764947010
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42e29783a15so1452749f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947010; x=1765551810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
        b=e+VJd4jnPrHsyDyvR+36EBM7kzIvIyS4P9qYC8OsBni+sDym6gjBxUimdAhct2840g
         0DaRzo3avPovseP7WbMs9ieCMCW8y43qHKRKetjVKR4yQuadYRSX0zO2sm/zO2jTIRJR
         R0Lm5uu/qVfP1X6Zcl4qt/TQLKUcD3xCtpXS4BVlQkeOqPmXKHtTggHNpSwwd36ruYWM
         QoF65DL94CcEueJPjC5ODRaNUd3yE0VJ1KkqeWCzczv+patUi2G+K2UGBSflIV6n1qFg
         LvnwcBZiTsYAEdKNcOmu96OusQCoPhCDAK5BTfU00fmnBck3AnX4DbpwPtzO+RSttRpb
         phhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947010; x=1765551810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O0gDHqVMMcE+VdX7Gi/rWrDUwIx6goXcTBQRlv3UhbQ=;
        b=upCpZUTg9ACnhqn7mWfJNMVe6aqXB2t9h8OO2kdKMPPMsouBrZlbBshUkTsTmZz2va
         Xh1gBaXsuqHOyza0a8k7SqPRRXUyZofiCC6n4PQFtnsdFpllwi3Pvu/ZO7WrODa3ZPl/
         jzafwF+IjyfvdDBkM0rjm0Jx9OX2I7ye7Xq0h4bsFIFkfnLF8fV9nI7VHWIIS1Qgdhed
         2L/t1HfAfhTDUqZV7NvMQDozlPBQsEEMYqS7tJjtkWnjZGahrkb03Hmygknbn9QCYz/S
         127YIl7RrxJQCEPy3vPfB8rbGt10VKLQax1kODytXX4ND7eI7eURRJCxlNoiyoo9XnCz
         YUsQ==
X-Gm-Message-State: AOJu0YwfkDKnO2nql3lj7Mm3W2dcstzOLNTo6JVt4S0RnG4unT/0mNue
	jdt23CAgTlDxZtoZaBhg5ng0pnQaYEX7BaRL32kOtqhcAiCTMHcLM+6xLAjuKdUQ25Qcj18cqGQ
	dqUuhC4bq614MGWLcjgFFBclnWwyGJO/9CYAdRtuGX0oKtbLvh9nky/og+VMZoKveLm1OroSoib
	ONZpVo7SEgN0Oyi/723gJ9d5+KnoQ7ajd6vwBRdZh9DZZP
X-Gm-Gg: ASbGncszfHi3gaDpBZJKj3pAU1bSjasFpBxMXAmePH1JCRuGM7FMKH6qsghW/IMREUH
	XduhVVdUgR86W8Gdad2bEAlLVh8cOoZm8nwe3ZLJWBQuRC0P84tbA0c7UGLV9dWYscx9n3JapUn
	tG8T9IpfqhuTtIV1SdzsuK812Mw25k5OjZgrmG3wRaXs5MLt9MMRSnO5JyIjraHuJNr9W6sqLP5
	YQ+qM7tLeynU9+Hf/xi+PIhsASDXq14zeW+gqAG2WeHTQJr6e1ZOADWSBBy6ta3/XUZvPtZ51hn
	OCZlKCThVJZ8FwpfticrU3o2D0d9brENTByP5AmjneEg9mOZgXQIuqKk7T+SyjM2PobNgNbGtkA
	=
X-Received: by 2002:a05:6000:258a:b0:42b:2a41:f2b with SMTP id ffacd0b85a97d-42f7875ccc2mr9386648f8f.7.1764947009871;
        Fri, 05 Dec 2025 07:03:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0idiCN61vwRsoRnmaji9TtKZvd8k5hCqzS73zSQNrHciQ/e/dm0qh4b2ZIvCeAT5riZg+Tg==
X-Received: by 2002:a05:6000:258a:b0:42b:2a41:f2b with SMTP id ffacd0b85a97d-42f7875ccc2mr9386586f8f.7.1764947009310;
        Fri, 05 Dec 2025 07:03:29 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee50sm9273362f8f.14.2025.12.05.07.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:29 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:28 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 24/33] xfs: remove the unused xfs_efd_log_format_64_t
 typedef
Message-ID: <q6kjao3xt3vqetpslunnjxof6qzlnjbbbeblgix373j6ayhekn@2nj5maosg4d4>
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

Source kernel commit: 3dde08b64c98cf76b2e2378ecf36351464e2972a

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2155cc6b2a..aa8e3b5577 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -718,13 +718,13 @@
 			nr * sizeof(struct xfs_extent_32);
 }
 
-typedef struct xfs_efd_log_format_64 {
+struct xfs_efd_log_format_64 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent_64	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_64_t;
+};
 
 static inline size_t
 xfs_efd_log_format64_sizeof(

-- 
- Andrey

