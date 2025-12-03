Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6582F5A10
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788683; cv=none; b=HPdDWboM5qQael6BwDBIiwd6Yo4sKPpTKLonkaUyUjrWsnwndPALU4inDXvZjGgx14cHR0DCOUAbVXVXOTysUVc+7E72EHxZpJ3hsrPrhs+5ark7ujnR7nlYqhOlPip6iQNVHM7VU+m7HLjRdVRXHiHeC0NRyenAyXneYpAFq2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788683; c=relaxed/simple;
	bh=bjmCQju9hFpv6PameSZ4+sJuOILpW+FNz7yOClEk/Ls=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azyg+TDi+3GuHUVIs3IpwiuvtstSxctKBtoLqkzw40wl28hFDzy90dBfiqc4fdYgO/vQisrvH5kBrt+MnHrjwnNDQuHPvXsbcn844gtjzHKqSLSJ734cQCsK+7eYeXuSVW8NUapyFr94ZgpC5YaFx9dLZpfxnlbKf4qkUK6SHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnIAWz7j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+1SgLeu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnIAWz7j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+1SgLeu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
	b=CnIAWz7jJi4TzYLJuWxscffdHrYixxtXnkN9yqGIbMUvkSRXB/Sgt2lINk78fKFTcqAuQ9
	V+PBcwuKIZJ/DfFLNfzmbm/4GWnLeV2LxXxWZeMrAJEPOraX4DzfAgA9OYO8rd2hI2Ay1p
	X4g5C5eKj5CSeITWrrJLTRDY5gi6OC8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-mMSyKLraPZiKu9hNsrGdmg-1; Wed, 03 Dec 2025 14:04:38 -0500
X-MC-Unique: mMSyKLraPZiKu9hNsrGdmg-1
X-Mimecast-MFC-AGG-ID: mMSyKLraPZiKu9hNsrGdmg_1764788678
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47918084ac1so507785e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788677; x=1765393477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
        b=A+1SgLeu1t98KFzH4pQUtPK282e1GKmTuXgFPciP4V2kSUzjCN0WDhA7c0yJDoxzXN
         TFPkk/7tJHsI0JDHgX9FGB3kq+8GQtgY+ntF742QPFVv4hl3WRHWRyiOluaRqG5z/Jp0
         A3MEOZ0cM5o3Qec0UsAu+BwIfkbk9q6f4pjlpw1H33TuuSMCmWTBds6JYKhZQWJVpI2X
         esbp5aNtE3hX32n0ZhDOJToQS/Z691k4RnX+pMHpGxS/v9RqgHd6gAl0nA5kxEV+WdUt
         rp9jGTllTk8aN4uenhkjyX7vmzwp43HeBeJtsZjXH0NPBV7z3Cf8I2QsyHSX4aK3n1Jj
         u0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788677; x=1765393477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r3vstktrxlALiDnoiLLjTZhUvoxu7dGqUcOK7OIAecM=;
        b=fanFLknSVp9V+yJfj+ttHyWoD2frlWHvdb9HgdwmSjTzgG/4ZR+ytOP+WKgPwgdZ2g
         LmAyP1P12d4b9PloSJsvLsh0dMvfszZLAVbdE6FzKgkdFpM6baDyKiiFZGC7ZvSEIf0S
         b7NdWBgZolzjQxtviRSQjnDWhOzcHuYkD+ua83C9vdv8ZQGL8plwREgsudFqPP0j9A1W
         e9dMD6dWPpMXeNjtcLZ0uVuLysBaBFjdWiFLo8jKVWDvYXjpJ7z2/xIfTHyxzol2sIHt
         2X3yG3nod8m6vrTF+kKgfI9rkGTu0E9XG2CaHuypZLHcuSQhynLvMSRBpqsLsNwQ4E9G
         lv1w==
X-Gm-Message-State: AOJu0YxURfdEi0BsmvaG+tXgIqy12zqHRz2jMqhR3oO5tmX45tvc2Mia
	19gs04AskLPWOQutr0K+DjHlEurleKdl3h7Zf5AZsigT1Zzz/G/39k0+nQcikeZxK2Xkbban3QP
	kryoDL2CoP98KYy8fpB1i+hLbi1IFq8kW/J+M8cOmeR2RFPYIyWzKhH7MhrTIXy3sdhU7e/hnWH
	/HZohEXocvF+k4VEBQSaoVenV8BgEiKsSj9VKZFQLlIjrA
X-Gm-Gg: ASbGnctpCDvofN6mdhXNvjihc0LtCIBnPiozxySn8cMBHCNgzsl6VeQ+O+xUqemRpb9
	rWi5z6mBNm2RKwdIej2nLArS65lZD52MMgY9lazZ7bisU9Xl7gXMW6hM7YHjuiLvqim6wXewHbu
	gLg66lMnS4Y8ueg0kZN+4Q/2P1PyZMSzyddgDR0Qc1KQFY+btNxk9gM8Jrmx5XKaILeWH8BCi0s
	QQDp9guWt4Z6GJoCd66XKl5q0JQfSOOcq+BAHaqv9YhOIskyX1c3Wl4tt2C7h/PH1fhxZsIwl3F
	8TlRlSD6kUGBkLojiL/IV/eI0/Cgc7dJxU5ITqloupDlZXBsoYloz48vsQ2ltTWT7CjkDcnzrF4
	=
X-Received: by 2002:a05:600c:35c7:b0:477:7523:da8c with SMTP id 5b1f17b1804b1-4792aef09d2mr47821275e9.15.1764788677172;
        Wed, 03 Dec 2025 11:04:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2je5ew69Nq0GYS/8LmYOMFx3IqKcU6QUPleMlX8UtSPvSFXlpXIZHiDmcUplWVuLSv3ttdg==
X-Received: by 2002:a05:600c:35c7:b0:477:7523:da8c with SMTP id 5b1f17b1804b1-4792aef09d2mr47820885e9.15.1764788676608;
        Wed, 03 Dec 2025 11:04:36 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7a3379sm64956785e9.8.2025.12.03.11.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:04:36 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:04:35 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 3/33] xfs: remove the xlog_op_header_t typedef
Message-ID: <imvre7eff2sz5qqwjcrf3u5lliifj5bv2jb777o46llkofgluq@k5himtjdist4>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eff8668607888988cad7b31528ff08d8883c5d7e

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 0d637c276d..367dfdece9 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -141,14 +141,13 @@
 #define XLOG_END_TRANS		0x10	/* End a continued transaction */
 #define XLOG_UNMOUNT_TRANS	0x20	/* Unmount a filesystem transaction */
 
-
-typedef struct xlog_op_header {
+struct xlog_op_header {
 	__be32	   oh_tid;	/* transaction id of operation	:  4 b */
 	__be32	   oh_len;	/* bytes in data region		:  4 b */
 	__u8	   oh_clientid;	/* who sent me this		:  1 b */
 	__u8	   oh_flags;	/*				:  1 b */
 	__u16	   oh_res2;	/* 32 bit align			:  2 b */
-} xlog_op_header_t;
+};
 
 /* valid values for h_fmt */
 #define XLOG_FMT_UNKNOWN  0

-- 
- Andrey

