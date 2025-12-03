Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1356A32ED5F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789084; cv=none; b=cG03c971lMxtFOmGI2PbKIJbVVSsWfHgf1AxfwR1EXAd51yEmBYeKvux23WJh8GMXOxotW4tTeCiwA0r1iRinFLJHccv5IQiHEfFqfoLGKTCyonDR8ErkDSzgDIhIMqxmVKuNFRexaIVfhgyoCi94EfrakQtwtvZulvndYsdYBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789084; c=relaxed/simple;
	bh=zAPrLrp/nZu096eNSL/tKAj9KjbzJmwXHOQGy1Ebrx0=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxZSpc7K6bE3ugTxj/zm8Ra725DPCw4/PKirtcycSoRC8whX/JVjvyHSUIzokcgkTN8TYKdFkfbnGKlm/mdDE/U+GmaH+H7sARs9t7/UfgQkSdmu2loQvqjRdleB74hfSoa0sD9OIZGtWjUo1NLTbTLDRKC3pctfvj+44dRZWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtwrM/5T; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fK4BW44e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtwrM/5T";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fK4BW44e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
	b=CtwrM/5TPJPg1IjHRPZnvDn98rU0YL2xr5GC+S+MeLNEnf+s1UTxfXR/MwzbIfbEFK93Og
	P9m62MqzbTajIq/leaHe9peERsXDYv/8JVhcdP0bpdg97OZHr8v28t42YCRrrBla75D9yb
	sGFxBRqlZ98Cn4YUFaV7MRnEdEBc83w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-n23Uek4BNK-gcGPnrIfxEQ-1; Wed, 03 Dec 2025 14:11:13 -0500
X-MC-Unique: n23Uek4BNK-gcGPnrIfxEQ-1
X-Mimecast-MFC-AGG-ID: n23Uek4BNK-gcGPnrIfxEQ_1764789072
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso10638685e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789072; x=1765393872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
        b=fK4BW44eH0bJAjhURD87QzYYIR13eXRhrMb99YOo7iOfD4aEWxPsP/320vMEpLS6Oc
         eIqFF+BYW7o7yHfT7DwMZDfsRGC6jExMZftEeYQ8hlilDhA/h9OzhLOXEhyPqSUWAtz7
         8o93N8KTPyGkEY8nar2JsZ6bFuttC5my0z6JSDZ0Y6MWpo5QTaMSW6AiYTMmmE6wss2G
         KImo92KYAktAR2zOwfoCJz+/V2Hqy7bD0QZF3i5w7NG/x7WydIssAAlWc+c2k0woYcIw
         UBgnPfoEHcvMGVVvCfNnroqXafWE9q/yvAWpqvzZm39JMw8lZS17JkWsbs2ZzzES9zdF
         tmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789072; x=1765393872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RkXDr79WF7Y3PMsBfiOkflmYEk42gjxHVO1tHCTaoUk=;
        b=k//5LIPSwSGQqZ41aZR5S2CPGTgp1WlizXtuPy85dfr0hZBYBmVG78k3eD6xz0PAWr
         S2VepHJUyHUX2Z3DzoO5Ox4A5MgDMOFQazZusKoA/UJN7OR5PNfX0BSslTNIbhdEDjqU
         RI1rkBRxNnSjVbHH+cG7PL57+aIbQfB/1c7qakwolW0G/ziWydFc33CmhN9cCUoS2Epe
         8hNqr0nq3vSjL7tfPgmKaRq/8nWUyUd2qoI/gomVBmJh/NCMs17Mx09WAdwm1zbWh/Wq
         +QAgfIIMN/FPqeqbGo0H8AiPzYsEAii2fVsnvbL7SbDwujZ/FqrFCovVhdVgZQ0GBBlU
         FACA==
X-Gm-Message-State: AOJu0Yyxuz/m+wctwTUBgMiFpdrHLvcUQiwRoYhD5gxccE5uiCPfgMVx
	uM/xRzts2Jt9iYObFG5JmDG6vg1n1XQg8OGMnFDavvithywOP8z1Fffg5+ngDLt3jzggzqisMiJ
	mkP7HovaNrz4wf2LIBqdfFOK8PaItZXLyTzolLnHlrVBNQkNZ78jur+GlhdWhoxPqBPxtZF81dr
	pSdmCIvIH01vcsNG6EICL1/7K0gDajwAcGJ4geIvbA8VYs
X-Gm-Gg: ASbGnctlW2cyPbISiPtUowsp9w7faKBpgZnhtZ4+glY9CIw/S8r/5O/Fv5Ei6K0hESQ
	7bqHlh6Ow+75Az7j2kZ9x9eS7DbqBKRWSm7G4Nhbb4qgdCxvcJXDelYz8n6Hx4WD0Imf76tzLSL
	teuehFyNpfw/cYlrm5BWEBFisyj13KFmy83QJ3hU5qh2WclS9WFPIq7KwKVwzr1QHdl8Bz+fDhG
	/Ln3LllnoBJxwQ2sraqar+jHC4PKpfyzZrACKmQXGB4ghSjYgn+3NhFEY0R+c/x6syL+47BjXSg
	u7IeWZ/e92QhLSh4zS/+4VFAdGisbIBQJl+ozcTc1gTx+fsCnQqgkndrW/JU3oHhAfXhoWgLvz8
	=
X-Received: by 2002:a05:600c:8908:b0:475:d91d:28fb with SMTP id 5b1f17b1804b1-4792eb09576mr4548675e9.4.1764789071697;
        Wed, 03 Dec 2025 11:11:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnk6Ag991ZPNKMqCRRSGJ0wHkiGn01yHe5eZN4iXOfX1yrNcUjP2c7R2+qC7o0TMYmwcSztg==
X-Received: by 2002:a05:600c:8908:b0:475:d91d:28fb with SMTP id 5b1f17b1804b1-4792eb09576mr4548335e9.4.1764789071192;
        Wed, 03 Dec 2025 11:11:11 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f6ffa18ffsm10185636f8f.5.2025.12.03.11.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:11:10 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:11:10 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 33/33] xfs: convert xfs_efi_log_format_64_t typedef to struct
Message-ID: <tfksam6amcxjgo4yotgsaykkmnsc6lantmjbn2esr25neiyv4z@vqxhojzlpuje>
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
 logprint/log_redo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index cdd6e8b763..38caf5a25e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -43,7 +43,8 @@
 		}
 		return 0;
 	} else if (len == len64) {
-		xfs_efi_log_format_64_t *src_efi_fmt_64 = (xfs_efi_log_format_64_t *)buf;
+		struct xfs_efi_log_format_64 *src_efi_fmt_64 =
+			(struct xfs_efi_log_format_64 *)buf;
 
 		dst_efi_fmt->efi_type	 = src_efi_fmt_64->efi_type;
 		dst_efi_fmt->efi_size	 = src_efi_fmt_64->efi_size;

-- 
- Andrey

