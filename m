Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C914C593
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370783; cv=none; b=ldr7bg5QFQ1vvRygTmVrx4THBLwBw9rVYLceEkeE2qUA0kVnUClctBaZYIBOtJcDxxduWzkm7JLkIwzC0b/ZhwCo1+d+aGwbpvjz6Cy3z5/BcN+uBY124Vsy/BYpFImJimfLnHGAfKbttEXr53buNQNrkJdktyFYIN9c1h9aYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370783; c=relaxed/simple;
	bh=9pfcxXvEU84XGfXaK4kwguLfHinxiloT0phRNBgdVds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0GU6ALqUHv4oC85PYJGRq8Bv/WpVOexFvgQgmW7UwxAw3pKaMCbBLiCWMthitJXNd1p3NCW15nVnWYp2jzSPmdC3uFkp3NrZBrVipKxzEIHMC4pz14MsXvCJ4tafjcJKwgdKot+TLs1iEawb1M0r5N8YrkOb9pDbYhvTdfgHAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crHKWFOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crHKWFOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UE0+TY5xZUqmmHDZUeCm/+SX8krdCbBz9YQdSx7A4ck=;
	b=crHKWFOwZRe1vkag+a/pb+LcWLtAQ1HyeIgl3Qa8oZP58D6saw+wEzQu8RK6gs2gcKMsBs
	qUjRtmtLCmSYxRla1+Q1NzzrMBIm5TY++iWTCekVPGU/S/lVun03v6aoH6b5Wh5uAWG4uQ
	xHnX4+YlXbxEOngQUSFjVcszTQvEfeE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-3NvFP4T1NG6KpMTAkf9brQ-1; Wed, 17 Apr 2024 12:19:38 -0400
X-MC-Unique: 3NvFP4T1NG6KpMTAkf9brQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2db6fbc1dedso1098261fa.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 09:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370777; x=1713975577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UE0+TY5xZUqmmHDZUeCm/+SX8krdCbBz9YQdSx7A4ck=;
        b=clBon7j0jRZ8yo181hF8dz13VFfXTEtYAWBPdS6r7l6G2fR5iNrZ+3++lQp/4Y8UGU
         IlT7A7zyLgINQExfNNDaz4qNvB6gmxTes3fBGavPvJflRLR3/3lovdPlkiH+OQUwOrZ6
         RbD1UqpBSOhejZxHlFU7vwvau9a9k2dYZoNKK+yWvKySF4FqL+XaZ74GwRf3KjRM41dM
         D5KXkpsi8U64uy+EDGEoe+AP6bDiPfYTt2n44xVqTP2bw/5+a8zeWBktfzqlHFnofZ8u
         vsTgQAemAbMNavy4pEaFz6lQ0OJ/lxt8PnO+AAYQ6gBisIfAqu+8Jj4VRJqZgTK/2VKW
         Aa4w==
X-Forwarded-Encrypted: i=1; AJvYcCVRNqasUwTwMwevFzROQXii/AYMkC0684UBPkk8t9kwXgfS6PXn6WgyL1bHhApFf9tPeATF44FITCsMEICPa7RWFMu2No0F4COc
X-Gm-Message-State: AOJu0Yyw503xOZnfd9MRm9p1HHmikoYfDmRdn84QEfUYvOcfGwTV/hkZ
	y0Gxx4xbhNzt20y7oUfMNtq28Z6Q0SHu4Kyql+u2oVzF7lTpnhNAVFmgXF3gpLL0vaeLu+V9Xan
	tTzw65EPVT/PKKPx0N9R4/2cQV0dsVyJTfkt9dSdcQ4r6uQeIQ9akzj9d
X-Received: by 2002:a2e:9916:0:b0:2d6:f5c6:e5a1 with SMTP id v22-20020a2e9916000000b002d6f5c6e5a1mr13417925lji.12.1713370776971;
        Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9xTE3bSEYur+3GkSe/swq6fD/fC6KtG5fQWUyYknO7sj6fCON5d6Df+WVtTYJf5TFGqQSfg==
X-Received: by 2002:a2e:9916:0:b0:2d6:f5c6:e5a1 with SMTP id v22-20020a2e9916000000b002d6f5c6e5a1mr13417885lji.12.1713370776348;
        Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id q23-20020a170906a09700b00a519ec0a965sm8243334ejy.49.2024.04.17.09.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 09:19:36 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/3] xfs_db: add helper for flist_find_type for clearer field matching
Date: Wed, 17 Apr 2024 18:19:30 +0200
Message-ID: <20240417161931.964526-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417161931.964526-1-aalbersh@redhat.com>
References: <20240417161931.964526-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make flist_find_type() more readable by unloading field type
matching to the helper.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/flist.c | 60 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/db/flist.c b/db/flist.c
index 0a6cc5fcee43..ab0a0f133804 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -400,6 +400,40 @@ flist_split(
 	return v;
 }
 
+static flist_t *
+flist_field_match(
+	const field_t		*field,
+	fldt_t			type,
+	void			*obj,
+	int			startoff)
+{
+	flist_t			*fl;
+	int			count;
+	const ftattr_t		*fa;
+	flist_t			*nfl;
+
+	fl = flist_make(field->name);
+	fl->fld = field;
+	if (field->ftyp == type)
+		return fl;
+	count = fcount(field, obj, startoff);
+	if (!count)
+		goto out;
+	fa = &ftattrtab[field->ftyp];
+	if (!fa->subfld)
+		goto out;
+
+	nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
+	if (nfl) {
+		fl->child = nfl;
+		return fl;
+	}
+
+out:
+	flist_free(fl);
+	return NULL;
+}
+
 /*
  * Given a set of fields, scan for a field of the given type.
  * Return an flist leading to the first found field
@@ -413,33 +447,15 @@ flist_find_ftyp(
 	void		*obj,
 	int		startoff)
 {
-	flist_t	*fl;
 	const field_t	*f;
-	int		count;
-	const ftattr_t  *fa;
+	flist_t		*fl;
 
 	for (f = fields; f->name; f++) {
-		fl = flist_make(f->name);
-		fl->fld = f;
-		if (f->ftyp == type)
+		fl = flist_field_match(f, type, obj, startoff);
+		if (fl)
 			return fl;
-		count = fcount(f, obj, startoff);
-		if (!count) {
-			flist_free(fl);
-			continue;
-		}
-		fa = &ftattrtab[f->ftyp];
-		if (fa->subfld) {
-			flist_t *nfl;
-
-			nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
-			if (nfl) {
-				fl->child = nfl;
-				return fl;
-			}
-		}
-		flist_free(fl);
 	}
+
 	return NULL;
 }
 
-- 
2.42.0

