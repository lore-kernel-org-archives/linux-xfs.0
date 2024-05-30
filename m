Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FB181315
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108712; cv=none; b=kjI97sGa+KW/+LSJpsdzXtXOvtdJCwjaqGzf8Kk6QDb+4L5+tZb9qfG3MxmDzZh/DS7hINEMP/atjKxVI3kakVhx9porW6FCTvTVM3nsrKcv2078cy7bwYp1ajZQO6uEDQXUBQ1xQzAHYKQvMr1oFDZOSm1mo+FJ960uRC9jA6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108712; c=relaxed/simple;
	bh=1mDNaQtRtZjqq3cguAIsNw7oJL2/n3m51c2V4Uh8vQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfwCYEe/5lAXxkFEAuIdvGN9McjdDx32cJIN+uRfGKX6Vpqa+1nQ0ikyHnYeVSBXGl7ZnYNQ2KrKReytJFH3bEhJ3f8sSQjbOSiRjACnFbMsQQM3CWYtHCcl4btvPHd+noVu1EO/jCu6sDRopDebbwSisgrz1lrZ6Xrjf6J+LHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ekOkUBvP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekOkUBvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717108709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9tiitZFJDzvK5qQMds5jEIzliYEPVTcw0FA9qQCPvs=;
	b=ekOkUBvP4Bgn7ieYNlM/Rjc7tW6UrkPmeJAMx1YinFmKH8VCIh5lx4utaAzMymithN6klV
	OGmqIAl5BNbbXpbNd45zdEgLHcip2gbwux3kqm8oPVmXPvuilzUZxcM6W46aTb+7tiI73x
	MqVNXTW79lDvNjubUyJ4oDcJwgtGaX8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-Kf4EW9pRMAqr9xloxBkp3A-1; Thu, 30 May 2024 18:38:28 -0400
X-MC-Unique: Kf4EW9pRMAqr9xloxBkp3A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42128f7b5fbso8543975e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 15:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108702; x=1717713502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9tiitZFJDzvK5qQMds5jEIzliYEPVTcw0FA9qQCPvs=;
        b=W0G7vuHKWmjRMyOvzQKog3BRRGXImeNZ1YWsopvxJ4lvNA90/s0fp4YNlSsbAQE0SH
         lJrQDKBdlawIjAO8uyFz7uIHvCCWAClGoXMljwry3BrYkTj6ygvNGMHNBThjDpwE+oYF
         rRzEGXq1AIGPvF3kC91MBaDhG5FhkXxZDXU5qk2w9E2t9D6owvOptLBiytL4ZMjDbZwO
         h6/Ut61Zu4ZAgj6Ls9WUGRR3/S9zFxwAk3Cat2MBlbqy3w+1DBpO8Qz7VvFPx090hpst
         PTwhB+BF6V4r4T1RHUdLpz7hb5Jh6bK6eBqc9wUTHACnLl2hV2mY+nVptz8IufjGRB0L
         OMfQ==
X-Gm-Message-State: AOJu0YzmIcd2pOcK828wvAN9WvlEbZsU5urxr5jTep0B/T2/01iIa7FN
	Jub4CUw6pbqxJ5L66wDL2wrNZUuYPqwQc1EXYcddadvjRkVtct/LAB7QooLsL0RqS6pPTeJKnfK
	xnvksbDP/CoE/TA9CRqqKp7orC39+x7Zsk4LDvHtZx+77jrwoHC70iHq1a4TgNeUyzz1/EIdWq5
	uzvtLxG6wv84iSmPbhUpFWP3c0/Vl8jHAl91WDghqv
X-Received: by 2002:a05:600c:4684:b0:420:2a22:bd3e with SMTP id 5b1f17b1804b1-4212e075641mr1063235e9.18.1717108702029;
        Thu, 30 May 2024 15:38:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBZ0jyZJBDyBkBuqrx6xyw/T5Qb55jqqd6NU0n1pEBwX8uXc3drCTlS7eYHsb1Ks2P8FfU0w==
X-Received: by 2002:a05:600c:4684:b0:420:2a22:bd3e with SMTP id 5b1f17b1804b1-4212e075641mr1063105e9.18.1717108701581;
        Thu, 30 May 2024 15:38:21 -0700 (PDT)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127062149sm36053675e9.14.2024.05.30.15.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 15:38:21 -0700 (PDT)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@redhat.com
Subject: [PATCH 1/2] xfs_db: Fix uninicialized error variable
Date: Fri, 31 May 2024 00:38:18 +0200
Message-ID: <20240530223819.135697-2-preichl@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530223819.135697-1-preichl@redhat.com>
References: <20240530223819.135697-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To silence redhat's covscan checker:

Error: UNINIT (CWE-457): [#def1] [important]
xfsprogs-6.4.0/db/hash.c:308:2: var_decl: Declaring variable "error" without initializer.
xfsprogs-6.4.0/db/hash.c:353:2: uninit_use: Using uninitialized value "error".

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 db/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/hash.c b/db/hash.c
index 05a94f24..9b3fdea6 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -304,7 +304,7 @@ collide_xattrs(
 	struct dup_table	*tab = NULL;
 	xfs_dahash_t		old_hash;
 	unsigned long		i;
-	int			error;
+	int			error = 0;
 
 	old_hash = libxfs_da_hashname((uint8_t *)name, namelen);
 
-- 
2.45.1

