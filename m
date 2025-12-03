Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E9332E74B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789072; cv=none; b=kjj/JnPmS2I5/wohj3D2e3X7SH0Wm+spZb5+ztiewrSHSk6NsdVdQMLU6zucXbrNS/A2q2nrYS4mCI8jaLLmMpVkhWkleyDpe3nZgZZaCLv5JZ/+0uZMmUfSmQbZNGh5JwX0kYQpaaEgyDhrOZkQnlIOFc6CDRClxHLjH7n8/B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789072; c=relaxed/simple;
	bh=5aUbd8uf5XjYJM70XH6qz2dvQ+Jvc2K0PjqtK53wIPE=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIRQwWzLHbVFFuuRqaiWGN/7/0vdIJB/vwIxjYtOugHsX/6Uy6Ms1972uOf1z7LgxWiqBDeMzgGmkJvp2QN/zkszMfXbRSWWmmsoDvGebLrAGmJpr6ENStF7t+Q6Kt2iWOqjQFEQXYeffxcTfOyH5JtrukztDjNf/NOoyAfgRq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfRL4aK/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sF9T87TR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfRL4aK/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sF9T87TR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
	b=dfRL4aK/2TKk0XEzmmbxV5l45lTDKKzFUmakGqMnfvjX2JkUtco35k8kttpBz9ng/r/cAl
	Q5y54Tl8IL2ot9yVCWH1qQYHs3PJWlTsQZINszXKvo5LvSi52fRzRlb0WMtFa9wGhBpxfv
	oaoPxX9DSuwztGcZueEwJk995Lv62SU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-n33Ix5kzMLqeacpNuWNZPg-1; Wed, 03 Dec 2025 14:11:01 -0500
X-MC-Unique: n33Ix5kzMLqeacpNuWNZPg-1
X-Mimecast-MFC-AGG-ID: n33Ix5kzMLqeacpNuWNZPg_1764789060
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so488575e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789060; x=1765393860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
        b=sF9T87TRM1lYuBmF/kOr1iL8mKkBGuB8yD5GXRZzO8A9NTv/0w+ZXqnCjQf7veFqt4
         lErA2tiZQAPs8zgMhYmJxaDSVNjqGqdOXFyc/oVF5ElYhdmXPEdZriLzuCK3+tTacSrK
         e3XyWgXQ0GUMr0j8qT4WcSxvtvN8Ej/PCXuuboHPv8vvK07VW/IcNnNi8dXKbHggj0JU
         eumY2qAH6aMrenFENNyt7N7O2l0bKuT/CIp9wEelKrCueG7asiH5yU+dXomLoHK5MsZ/
         NYLSrLfoRxYFvl9EpmtbyF04CdlK1KDDEPqS/uXbVuEuArKYpS3X2V52GsonKRGwlCyJ
         K7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789060; x=1765393860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=efZRdx4ZQLXz3OLC++pAwrom0TtNXp7VSb4ff7FmP+w=;
        b=Fh/75dM9fzs6Mdu0mgqPsY7Xm0jTb2bTcBqHLPxBp/7ZuXrmUrYvoR9BgqxeLA5PDo
         ajrupXt20HkcPRCgY/N2Sfm/RMKCIqfU7KrtTLr4/rJ8FCvGiqZJCXbqHf8O4Gz5RCQv
         8CAEzxBg5RKdjFdTsgPvMuBqgA5VteSdq0AXbQg+3J1m2SlJPewNmRk4372tLO1N5cJF
         rMTWv6XstObD/hDJHIT/1bZNnz0addTZnB1r0bv9XuRiXN7bTUsOrCQc5tDmdKIF7Uu2
         qHbuoiwafwJa1E63FPC0psZvVN/uJ9E11DUdWtry0L+223aUaBfgipzDe33bZcYNtJdi
         c03g==
X-Gm-Message-State: AOJu0YxGG/uAi3nA4ZPyK3N3cPo1MdQ6kWSgr8D0jkD9LINoVqqS6pMF
	iZuhY8l4peZG+GHuavmoT5al4v6v2hXos+qJMh0LeYdiGigcuVZcIX4+AbWQuXQvrL3J3wM1R4O
	VN8qPpuzd1cnf8l76JorJdt3N0wqkhbs6Ss0muucOlt11+3eAmYNI3kc5l4TuZIrVBd8eiGy0nq
	LgSfeM1+KYSxmYYWJF2qyntVMFub6QgIfEed1HSuXY84gh
X-Gm-Gg: ASbGnctx240BzltW/XR2Vj5wvl2zFXWsyuHZXLE5YW/E/5Ur+LDtWR1nH2LhjTFUcXK
	jHkFgWfU87je7lYjHY2ZlFm+3vmy3AszlIZlQXKIh9jHO922dKAeORuHY/Z9FnLdQOzeIR0OQjT
	AnE1VNSWG7AtytQ1Fk4FTSRp9AksDIENDql9SupohbtOOpXVIQfISndK74PC399Q7KHVBTH4jVx
	fhXzf7Zcas3/anjKJ36JFTXl91AYlA38aDGi3ACd0gDnlEO06ioa23Vb5t3XovdwvNdp56CbmW8
	iidViLrjSpvcmyok+uvJa6cBCstejhdQIFGH0z9YAEasvMcbZpngU0DsqwSNl5HF5NR3i8WqRUk
	=
X-Received: by 2002:a05:600c:46c4:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-4792af1b19dmr36443165e9.18.1764789059842;
        Wed, 03 Dec 2025 11:10:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnY93pNLMWHkFXIfZblTeejGGJqcrt4MveB5buyb25CiSLQ8Z2ISSvaGG2nBtNMJix1lIRSw==
X-Received: by 2002:a05:600c:46c4:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-4792af1b19dmr36442735e9.18.1764789058894;
        Wed, 03 Dec 2025 11:10:58 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a8ccdfbsm67382045e9.14.2025.12.03.11.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:58 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 31/33] xfs: convert xfs_efi_log_format_32_t typedef to struct
Message-ID: <2lgvam3kjpuz6gjdb3rekdwxtmsas2rq6xmdca5m3re2stmkty@57xes7xe5fm7>
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

