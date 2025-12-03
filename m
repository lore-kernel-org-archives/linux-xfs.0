Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E9D303A1A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789074; cv=none; b=GkHYK6I4NIzObzUdf8YJ81jj2Eb+3skxL/8LpwnOv6VY78qgvHiGDGysZiXlPM4LMb4kjqDbYUYHAsWen0cDSGqXV2Nnicp+iwmGRI5SnqS8TCM6gxSSk6GPQsRMxzJ9qmwsoxulSXkHRwbD0T/2KudCFOnuzQkPFPoM031XLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789074; c=relaxed/simple;
	bh=7jzFRfVs3JHds9sFjDq/pICjKV2QinhYbNIykzoOTwA=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTYvzQ4DpizrMIvszLuFot/StphOsr6Y3lFCWxNRE3kRJLqpn+yguyfW23RaA1GMFzqNWC0Gdba17Sxuo5KUU3Qi2xZFZoulQh3vbku0oyjJ2PsGW7dOdEsdm8TlcaL7/KK2Sr2SdUxlTsg21egXibHT1XslrHADURhcqsi4vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AxPy/bhh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rd7JL3lM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AxPy/bhh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rd7JL3lM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
	b=AxPy/bhhAI+XuqPkABYXHksB1hf+/oo9bWMFufFDJ+NFuDHciQJTQs87Z9xIPfVpPFboei
	iQqdPzRezkVZjxLYUj444EIODARAZLWiiiUmUU7emfDETx8cZYjDuA9ECgS29qHmQksYP0
	lhSZJfpSXszKHx2E/uCXDQIsg7mJecg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-cMefVzPIPjiU-vgYe7REzQ-1; Wed, 03 Dec 2025 14:11:06 -0500
X-MC-Unique: cMefVzPIPjiU-vgYe7REzQ-1
X-Mimecast-MFC-AGG-ID: cMefVzPIPjiU-vgYe7REzQ_1764789065
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2f79759bso73923f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789065; x=1765393865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
        b=Rd7JL3lMDyZwduR4myMVd+HvGN4V8rG4Iy/Rbvea27X8wIZs2lgAeg8TG8T6U1BFhn
         m6nYPjNShxelnWJzh39ta5fHeSZJkHeAcLax5mI58scmuFNQkWm0mGI8le6S260TtDNs
         jvg4e7BQGyHyHBsLX/kyfCWapTXrt/XzuSosvtfxIexmVpZ/LUDirqIAkHYZusXp79Gj
         KAoaukYFJWKzVSSFjAvj1YL5cP5JxbhVhiScEsV+zJUFlZtf87+axDf6EIvC+7ghHexe
         BwyYflYkvEkAyWj9h6vC8GHEBJ7H/OhDPbXKOxqSEezhNrJGOWFZ2y06R2pa31tKqS0r
         UIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789065; x=1765393865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XkRDtY6pvQ3qJ9XWvbvb76SJ9q5MbCo6ppVxJHYsJpM=;
        b=ITzhFPkWNFiZrTX3fR51jYzYUqzXIlIifw9p/LmzXp9swCZPO6dmbFcM5ZhaReY1GI
         CiXlrozHdLrQstR6vmxpUoVY6qJAYBap0nwyqJfzm41rq5+ZvLxBoDmtzWafvxSknKmA
         ykK83YSuUoIMiNzm8inKOx3NXZ5ND2DRMiPTfMROtFS8Pjpn9lB9sF8lII46fPw/Ey/W
         BUj73nBcKexYbnWzDRsHicfhQ80C7Wmvv8bTkXX+5vikj96uaCauvTThS1QTUsz4yWHT
         ETes/vr9319ENOqthvMKggJD5AuG0jOj6rJKQD6EtAPJ4Q+OW2SxbBPzeNg9uYdJWfpM
         H0pg==
X-Gm-Message-State: AOJu0YzBzNzafQf95P3zoR5vE/Y2ZGftghb6uUXiApEcGoWHjfgC6H/Z
	FxBaOEg8/eHm1hHQxmJfUuCv7vsibjTe2VKo7sn0wMpZsOIpkpMVHETiHJPy7Nk8Epr6mlsOi2v
	Z3alTgzvL8Apm6CxPWdCj3knkJRQvXlI0stlwTikwYg2TQ8xs8axsARRR/KDwCEn1S4g1qro+C+
	roDK+Nd8VimRjd5pCRYGj/Yx3WUU68M3HEj7Nza+JKi0RS
X-Gm-Gg: ASbGncteFMW3H962zZ8qIfMVpl6Gu6oAYWSffQ7C6DHy1dXHBCtW/rszQtOjG5kKW/c
	xXBjSxwmnCPKkHfoa+Of9IrmY6dS7wAtsVfkjv/QQS30LEXvGnRTq9GurSupQ/37GKBHaVR2mNg
	HYaexDoS8ZFedWWkEIL3wfULvtCJ/cqrTkmD5pn51thAhvk0WxM1NmM5nEpvCf8cmXQf6Rp4XB4
	luCvnL1q70cpmCipmr5XNtwguzpsorbim6tJ9s+HeDODPFAs2x47nIzpV4m5A+HQMHT+uig0yhl
	YhgFZ/WL0Mg9ienIlKfgMDA+0j1660FqKXHAtAs+yH8lgU2CCc8ryPCLmpaBYpeh+CW5BXiJWho
	=
X-Received: by 2002:a05:6000:2011:b0:42b:3b3a:5e52 with SMTP id ffacd0b85a97d-42f731a2f31mr3961986f8f.39.1764789064923;
        Wed, 03 Dec 2025 11:11:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYXToh7QhlIPhTJv/Q5437W6MSb6YCdIOgCyvN0KM0Ytq/22I1TYJ6vFRFzo9j44+EmXesGg==
X-Received: by 2002:a05:6000:2011:b0:42b:3b3a:5e52 with SMTP id ffacd0b85a97d-42f731a2f31mr3961940f8f.39.1764789064316;
        Wed, 03 Dec 2025 11:11:04 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca1a4bbsm39466997f8f.21.2025.12.03.11.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:11:04 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:11:03 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 32/33] xfs: convert xfs_extent_t typedef to struct
Message-ID: <eaheytfuhezbj6alp5y4rgzu3rwkt4xn4pejdcasjqq27dkjnw@in7i2jhdhmw5>
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

