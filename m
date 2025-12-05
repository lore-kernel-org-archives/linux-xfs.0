Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8079246782
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946936; cv=none; b=K/i06LLktVETeX31ITZnAtXIo3kOveSBbuLRduTX4qgHJhK2XBMv8jmjCzhgrpCImQYbWJZS3wnirD/BlZWaa4ww8sh38H587gjAMUFa/H7k+957cB5amix/pXDni8wqH/iP4804tM+mYzDxXmLJUX2c4WYFpYZSFyfUGrZQIU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946936; c=relaxed/simple;
	bh=pifI4awGNR1L3Isp1ApnbrAGiU+HEWUkDRf3TT+p4eo=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMflHJlH+JZbQX/HwTthA3+SieBEWhdD60hitAca0SAQIsZGhbwHQMS3HO1xGyMycJknHaYjL+BN28CWa0DbAp/ogE3qpV7DBRcNwRpJs5+wvfDZz0bE+pGGUrrY54eEXPed8GDlmcu5xxzME6hlRh9zy+QQ2cUaAHmFed+QpuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gcHwVOC4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fErfLBWE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcHwVOC4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fErfLBWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nwM3WIm2x1p0jjWY2I9X/VD27ZK3kvVY+RHEjCWOmM=;
	b=gcHwVOC4ls+iOABt8a2/6oupM2Jh5noT3Nb0lLw3uhtN0dFs+UdQUc9eA1K8cXgYCB7obf
	+WOxWipGrdkACiJIJ2RMXSa+k2FGH6O4OVzEQYTc2ZPLBYxzmRAKQ4UxsDEOa0TmUmBSE0
	3fqLbu3yuhGZff1QBSPDAlpZGD9P8vY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-ZARbBpAdOGWDO2ufMRxyww-1; Fri, 05 Dec 2025 10:02:04 -0500
X-MC-Unique: ZARbBpAdOGWDO2ufMRxyww-1
X-Mimecast-MFC-AGG-ID: ZARbBpAdOGWDO2ufMRxyww_1764946924
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b366a76ffso1265695f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946923; x=1765551723; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+nwM3WIm2x1p0jjWY2I9X/VD27ZK3kvVY+RHEjCWOmM=;
        b=fErfLBWEw1UGAM9WkevI8vL2G7HUzycQZvWq2Qj0Uf26SZmpkZJ/rToo7GuN4qQ3LV
         43WtIV8WVgVG8x4yFc/oPbytNJTgDy7kqTZoMJeXQUoqhVUtdk3jL9zIF5U78ZEbIszh
         YO5FZj6gDZwYHE67vAkXfElzLPL8tYGTJh0Vc60nxJC2E3WgCVUnRIq5L5ypaHEtijfR
         q3grML++HwJumTqZj9/Ntqkvavl4HzdZQFmHQU+qKGicM+do1gvh5qBxibdV4LszyEdk
         WngfsjbFkgCjh+NqRzMxQWnUfUE/jxhJK8GKMfgDJ9Nn5N7o88KjT8/DFxqlPNT3e+aU
         6dkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946923; x=1765551723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+nwM3WIm2x1p0jjWY2I9X/VD27ZK3kvVY+RHEjCWOmM=;
        b=ogxkXjE/q5duG54EIxBxbR9BFXixrs4+sQxfVUyEZLH1fVtMyfn5t81Lk5PyhCPHXq
         qFjB7sgPUc4SR1gq0NcIfwZjQHL5Hc2CffLk06ZLu3Hucsu7vOOObem7qEQk7Mz26JAb
         b+oC6OVCx/fE20WP5sbpoUYlAUJhfpglYQPigkBMDcxDLH3jrmxsN16iD6d8SfR9Vrjy
         2CIGapXOlCcXBSxWSFQt/MUGkcAk6Plkn41OGjlfEmBowsOJeex2ZwgMpai8Y0VlvBy7
         oNnPM0qPa7ObXCpst46aZR6CipqFAuYBGsFVGkRk4SEZNwgowKtbdXzQcTK3mU1+CKP4
         2AZA==
X-Gm-Message-State: AOJu0YyX2NBnGA/jYi9NR/PGCgzf1hQOlF8QTHABPzmi0DaWx3DcjaX7
	BWGTWxooDjHsftopojG/ailW+aY4vQDRX7TJ6WGIDY2p79fdVn+2vw3d3NWmVbkVFhmi+LNWu7C
	TW8FFVDcUHZXHp3G2ous8hCiDJGD3O2ECfGbfPu9xQQ7WhZAe+xdPROcC6L/bl33B3oQrAlH89e
	gJOMiRgqAo7A8zKH4eFZikrWdz4Ez3tNAhkGs9dvkg+2MJ
X-Gm-Gg: ASbGncv4zHQrmVnNk+sy0MhEoS35rtfI7rxbkVwkX2Kd5/Po3O0Bq0LLMQ8KfGhzPim
	VSdQY3IzXUQHPevmUI2t58yCWI9bNlJCEMYn67ttrpUxKV2SZx056rki9C0oFZwZ0CLbxYf6VCb
	cGLxKKI7NT4Fo/qBYFjvLjYbPI9n/dWkxo2t1ohUY4uOx+6smCJi1AV+DGRINVxgkNs969e4wj8
	pNuX3M/Nnu6yUeCcbVmx9NuL7VtXX9Gn40CWHyQ1tPlo5HSJh+OE9iYYOpyhSYyItXnN21NJrbH
	a0cjrJzVGrzgvFDgKP2jG9uoVidecpMPlZ6ZeoONvCZzgLyx6EKtgeXVcvnr7RRX/vMh4FtQxLE
	=
X-Received: by 2002:a05:6000:4308:b0:42f:8816:7911 with SMTP id ffacd0b85a97d-42f88167cbamr549819f8f.62.1764946923258;
        Fri, 05 Dec 2025 07:02:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+0iqAP6rbatEVoGaDWlm9IZmEJp+dHIczoMxWYWqbUfCX9awOwaCbP/KRShXxC+PTAK/HvA==
X-Received: by 2002:a05:6000:4308:b0:42f:8816:7911 with SMTP id ffacd0b85a97d-42f88167cbamr549753f8f.62.1764946922582;
        Fri, 05 Dec 2025 07:02:02 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee66sm9093290f8f.11.2025.12.05.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:02 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:01 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 7/33] xfs: convert xfs_qoff_logformat_t typedef to struct
Message-ID: <3ys53ywcdvrcmakwax4gudczafeoso4phnz7gaez4qawfc7odq@t3m3igm3rvio>
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
 logprint/log_print_all.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 0920c4871c..1d6cee99ba 100644
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

