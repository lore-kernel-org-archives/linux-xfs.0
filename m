Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B264148830
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370621; cv=none; b=papO+OVD7UMtL9TijcwI9tsHuh2n4UHnupGtYkxu1hUQ4liLjN74Lres8rU0dVemyu+rdfv0bFGr08lbIgaHpLUYbYkcNaLF6EistKXgccoiJlcUsdu+M1yEI0qXhqAu2BeUJmY0dNdLnUmceuktzu4YeXXZr35oLZoPraIYXdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370621; c=relaxed/simple;
	bh=jmZs/Rr2TbNGy6bBvx9C8vRsEg9yWJsR7UB0d/WoXME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHw+4OCiJVYT70tZnys9YKm8CaQz5zLG4IHGNDJ2SWruv7wcvaYF6tzVYYAzJVErm5uo2mU8VHD3fB+5DAlOje7VwVZt5YLgU946ugUBzddBUzvJwY/dp677mwBhfSkG3z9F5rKxhND3VyXJouYNgGtCT5jHIfsXJxq1Ug2/Blk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JPuT2GF3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JPuT2GF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucrPlEEwO8wLfQcM1iZ0iG+ppc3j8g0VWITOSvUHp3o=;
	b=JPuT2GF3XudHzzbxqW95KcmDDtS27Te5FmKA1noaYCCLs7NBjUZwbUOJHXRQ+aoX5qsM7O
	v3zXSSzmRGORTZSbujYhGtoQSE20P11Yvhq91FrW27dOvNd+b+jKDcf0D+JmC/VzjszYAN
	9aKnqSOwk04X0T/ULNMQJxCML0Z+H4I=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-9s9yLXSOMFyRGmIV3vrm8w-1; Wed, 17 Apr 2024 12:16:57 -0400
X-MC-Unique: 9s9yLXSOMFyRGmIV3vrm8w-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a51eb0c14c8so270008866b.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370616; x=1713975416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ucrPlEEwO8wLfQcM1iZ0iG+ppc3j8g0VWITOSvUHp3o=;
        b=uBYvE9ksVtClCexJuVPSwWqnvWnkBdrpVdI1ZXWesURB29xeqAwk0E0cVZjweAsxS+
         l7A1PPxnkMhb3Ft6pIqBbdEAfUwjNpHT99mdUIJhWIOvjVVetK66tXMSVipCGKQ6YeEG
         8CyQqYXFIfkYGdh0SMDfHhFNa5OeOdzChs2Jz/lne8yOBVBaU7rFjriQtpim3bXWftrL
         ZIXwBd19hTf/WYMagKDja4Y8ej3zxex3PvutQ6sZN2s+hDIprsopfH8Yn969xPbljCtU
         3XOREHdnEa0xWt8p2wKdZKLbXoUe4uf6+kMTFFhgxZdiM92i+3omO7ME6Y5py8Vxy6/S
         X3ng==
X-Forwarded-Encrypted: i=1; AJvYcCXisJHTERRKMPACx5ZAUI2aDD9XYFHrEZjL0cHRnxAVJJsAL3s+Dlb34P4wFNKEL+1LzrOD16GIuS9GBuShPRxnxwB4/XuVTPLm
X-Gm-Message-State: AOJu0Yw+wVNM33m9JQJHTKtZ85LIHLdZFgUi9Z2fihGjoYneM8rDIMIn
	bZhFmpp0UjLKC2X7AsfSyyuvA5Htv6lhlGeG4S6M0EG7vWbjo0rgXgguDV3J6Fq5yTtD9rUYxyV
	xXm3ItUrrHBWM0VVChJ5Tgmz5Eu5UsBEfb95M8Y51ynRZ8azxXB0tOKnf5hhlcNAN
X-Received: by 2002:a17:906:369a:b0:a55:5504:6f7c with SMTP id a26-20020a170906369a00b00a5555046f7cmr1546514ejc.20.1713370616065;
        Wed, 17 Apr 2024 09:16:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFqS0WkbefE2CShW5ylUzUj5B+6EJs5cK3L/Y9ErakLDFZkWdv8w3XXKDVGLErHuRDPK09IQ==
X-Received: by 2002:a17:906:369a:b0:a55:5504:6f7c with SMTP id a26-20020a170906369a00b00a5555046f7cmr1546490ejc.20.1713370615494;
        Wed, 17 Apr 2024 09:16:55 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090635c400b00a4a33cfe593sm8272427ejb.39.2024.04.17.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:16:55 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Bill O'Donnell <bodonnel@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/4] xfs_db: fix leak in flist_find_ftyp()
Date: Wed, 17 Apr 2024 18:16:43 +0200
Message-ID: <20240417161646.963612-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417161646.963612-1-aalbersh@redhat.com>
References: <20240417161646.963612-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When count is zero fl reference is lost. Fix it by freeing the list.

Fixes: a0d79cb37a36 ("xfs_db: make flist_find_ftyp() to check for field existance on disk")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/flist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index c81d229ab99c..0a6cc5fcee43 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -424,8 +424,10 @@ flist_find_ftyp(
 		if (f->ftyp == type)
 			return fl;
 		count = fcount(f, obj, startoff);
-		if (!count)
+		if (!count) {
+			flist_free(fl);
 			continue;
+		}
 		fa = &ftattrtab[f->ftyp];
 		if (fa->subfld) {
 			flist_t *nfl;
-- 
2.42.0

