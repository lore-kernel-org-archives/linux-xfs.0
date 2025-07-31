Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ED91DE8A8
	for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753981673; cv=none; b=jqQrMOuelRBkwLikkZetgbi4TaEiAL24dUpgrwrDA84x4Tjy4j14xqFdn7JvmP8Jd8j8V2w74wgFA5ftWzazhHW7BVXZymdqSBiU3hf+WebV7sZcP2VQB/eRB8u0cCwE0vZmj2EGZDTCKU5nXo8ySoobT8OcUmexAo1ySejhSa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753981673; c=relaxed/simple;
	bh=+2WEWkxO2XBNPcVgfr9midutx7eBQLn7Ih+Z6y/lz10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PZQHhfDjzSZ1JMfA2x23HFUjwwrWUd4l/IWXr4E+oBF0+Mcyvdxmg2mhbeb+8BshLScZ5plzxR7gJE09oeXa8UMOz6OFXehNGQxC+5z2oQnT2zwkQhh97wqPLfxZIC1T332oz6gsx69HzfV15xDOj9cKIcinBpjetLlTbcZRbT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ehjSL/jn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehjSL/jn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753981671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W95fwcngNFVN7Dw8Ifafjvzeu2sGcCu0bDX4W6mcjRc=;
	b=ehjSL/jnEkOhFSGEL46+HjAHhqs+9MLdeAWO0ILX7RBV3Aof4BqWwZukhI5LRv63rGVpXJ
	4y54gaTkkX54tL0hwM0JJ0XbY/JAs09iFB9YF739/rian9VNS2pKgAPl74rfVKiciF5m/U
	1G3fhy5F9XJs0T+WplYipQJw869gNVg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-Jj5ggmmgN7ucrTqviqd1QA-1; Thu, 31 Jul 2025 13:07:49 -0400
X-MC-Unique: Jj5ggmmgN7ucrTqviqd1QA-1
X-Mimecast-MFC-AGG-ID: Jj5ggmmgN7ucrTqviqd1QA_1753981668
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso37445e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jul 2025 10:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753981667; x=1754586467;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W95fwcngNFVN7Dw8Ifafjvzeu2sGcCu0bDX4W6mcjRc=;
        b=UaVl2+q3f0rMORXmgNcBhTtk2FtEg94t+EprkO+Vg1Y1mfaJTMAabAAVq/YKMb9uZ4
         rHKP82NXWFq1jfTeOpglDF3OAMQuSBeJQZJSTU1AIsXrziRVuLuqTFLReuHeN8vgGYOX
         d2belUNc0FYidWwUER2AYUbgg9D5W/9o/pl/9NKJby8Yt/m322MxlX0c9FzaqBa7U5Ap
         yis4hVCVF4NXXUZvpq/ubksvy85jHKR/nipuHbtyVQu6E/VBa143nMXzHZ69CN22yfNn
         TrlPd2AhxwImQXn+2peIyYUYfys/xDyqYpymXqWHkFLy3zGpzaxkm4tlpl12uhQIEjP4
         vjhw==
X-Gm-Message-State: AOJu0YyFtACJ0Ve3XuTkOj8AKMeoBeqoI1AeTweYbiLVn6Tn+OYHnajA
	U0GEYGjN7bRspKHmfeTQeFZG9/vUOqEypMINyYJte/XTQUuuxS+EvNGhwTM7M5HKsyDtL9aeCjA
	H+tvruG0laWcAnY82vYpBHYW7WygaVbtwKyxsVP8zkER5CzRWNBblUvA6oIywcnuM855pGMGQ5h
	lhdEewqpP1VyQkZ2l2pt4eTN6THBiW+/33wWVdVvTlC7vw
X-Gm-Gg: ASbGncu+wGiKy6h5jkeI0/f9/IFiI6cdTHdLzOyH4nOYv3p+tfrE6P9dY1whyPlfdj0
	xDWMhbPDQ37x8+l6B7M3e1WyWGfbFJbuFwrsigWgOBUxgk8htlp4FNzNdRX2crxnaQkWpD9PIOy
	SIHgCnA1yq03uYo7PCHmQsiJMWnsSh+W+tFKHvDz3+ExiQY4vY0i5HUXYkvwC8ieVFo6ExcN/Jp
	i6++AGsYtpMhLLxGKSNsclxKd9kM3+drt0MSJeBrDHOMYT9GTNIwX7MTvvbCrCskHup/+HYZQEm
	8hj9FMk/jRMxIjdLEZQDnIplxRPgqdp5Xy4Oo1C1mYqn/H+2M+aFKho5MSU4GL9rmafcs7doxP+
	Q
X-Received: by 2002:a05:600c:a345:b0:456:2ce8:b341 with SMTP id 5b1f17b1804b1-45892bc48e1mr78580165e9.17.1753981667551;
        Thu, 31 Jul 2025 10:07:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF6o5/vv6lNd3QYeNpO1xKq81HEgcr1sVdbp0YqpyF3awQbNrbMJ8dFKmysleE1fre88AIVw==
X-Received: by 2002:a05:600c:a345:b0:456:2ce8:b341 with SMTP id 5b1f17b1804b1-45892bc48e1mr78579815e9.17.1753981667058;
        Thu, 31 Jul 2025 10:07:47 -0700 (PDT)
Received: from thinky.alberand.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfcadsm76942415e9.18.2025.07.31.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 10:07:46 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	cem@kernel.org
Cc: djwong@kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix scrub trace with null pointer in quotacheck
Date: Thu, 31 Jul 2025 19:07:22 +0200
Message-ID: <20250731170720.2042926-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The quotacheck doesn't initialize sc->ip.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/scrub/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1e6e9c10cea2..a8187281eb96 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -479,7 +479,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 		__field(xfs_exntst_t, state)
 	),
 	TP_fast_assign(
-		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
 		__entry->ino = cursor->quota_ip->i_ino;
 		__entry->cur_id = cursor->id;
-- 
2.50.0

