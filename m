Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4D13D60E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358789; cv=none; b=GBMcO6yv+T/ibn9UnIG0T60o+iJ69J/A0RzmJZuK3ij8oHprqCrDAN5jXj+BeLGo4guJR7p0OG/7etur7raAz71OnSnwppsvKzwq9NWm/8pRZ2OojHZAY7FDvUm5HLIUz9k+OL674r6K1WvNVBEyY8FDKDGaM0V5XJ19FPkXxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358789; c=relaxed/simple;
	bh=P/zr1bm4lHa79KAEZ5p+CDg+y9znvMI3untO6KB1ruQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of4av7XqQ/nIWw26Zlr9pYNlnqhlrkRHWNjDjAHvH6Og9VD+3nmqjcSaewChtSKuAc+E7gSjKfqTCy/3/s+JZJjwQCtVxLDZppW24vpYxZSe9EfngopE8+1ot+eoiRy6QApjvdMcRJrFhGTDRkH0N1UmvuFz5rj4H2MsvFyQVlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KsdTjItD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KsdTjItD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uEg4xBBqpeCcsMV92BDVzCp9dpU/ax645khbqXi1Yxw=;
	b=KsdTjItDnVDfNqDDoC4mHNX1n2g79wdIA46B6E/K6D5EsRP+0eKkD1v3+ONJLNxxbtzo+E
	C4tyumxA5jnirY205rv8kD5PdjdgLKYKlagFGu6GbIRenxXNTLcQNL0uNG/YPSnAmHJdjg
	Htt8Yo+oYLC1O+QelXstvB7Ih6V8yRU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-Ha2nM-2QOMKnMPbS7xBtzA-1; Wed, 17 Apr 2024 08:59:44 -0400
X-MC-Unique: Ha2nM-2QOMKnMPbS7xBtzA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a51b00fc137so428321766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358783; x=1713963583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uEg4xBBqpeCcsMV92BDVzCp9dpU/ax645khbqXi1Yxw=;
        b=i+J1TD5waZD3MfudgaBZ9M06WbOpaUXpdPw5JYidnzj8v8XQf8POwu4IMWVdk6g5Ro
         CTR93IA6kvdI3X98M0W/zVrer969f/02eJ3GwRg2AMAKDgBv+xRFcZlu8v/iun2kqOnU
         KVG+JXJvnhA53c7zUJ6/62Xjyx1rHMAJNqliFuT7cYYJIV8UfwMLJZ4FRlFIV2U5YZLn
         73cD0OaN6mJcVQQGfwOwHFuZ5Pa5+u+8LWGw/YmVUS9PoJW/nRzNsBN/5/Kj+kbpLpYu
         kLH5xPU1advY03DIp3rOIuvn4Ss/p7IVY1/1ZqWSTq2ovWVeXuRE+v4SkAIhT4V8i5Eq
         46hQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvNRrTmwYkNrBx/fNofQnwSaEinX9CQpTBC77QIKW0vvq5WpZclgINd56bsRiPWyFXZgdfzjNkF+VETQB2a9lWtgp6uBoBQEVD
X-Gm-Message-State: AOJu0YxSNI1RpuAVVx6HHbUX/qonqckHvNLrqDltAAAs/HY4p8gVHo1Q
	pYypNLKozDNYZbqz4/r06gjMJTWQOGNiOPQx60YEFMpzUfajh4N+MjJxViK7TzR6lvllnKDjg1q
	slPGsskzXAk+JA71TpZ4cPNo1w+0TcutXYJV0NLpJCbQ59n0aIhpKwXdMppaPr3gp
X-Received: by 2002:a17:906:37db:b0:a55:6453:67f with SMTP id o27-20020a17090637db00b00a556453067fmr402072ejc.40.1713358782874;
        Wed, 17 Apr 2024 05:59:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5S1OylbUGWpXjQtX59vw661MbsWOgfEFU2ojQWASsQdfV76QXgQ4/qn4ZSVfeGwONchs6Sg==
X-Received: by 2002:a17:906:37db:b0:a55:6453:67f with SMTP id o27-20020a17090637db00b00a556453067fmr402055ejc.40.1713358782441;
        Wed, 17 Apr 2024 05:59:42 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id gc22-20020a170906c8d600b00a534000d525sm3330252ejb.158.2024.04.17.05.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:59:41 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 2/3] xfs_db: add helper for flist_find_type for clearer field matching
Date: Wed, 17 Apr 2024 14:59:36 +0200
Message-ID: <20240417125937.917910-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240417125937.917910-1-aalbersh@redhat.com>
References: <20240417125937.917910-1-aalbersh@redhat.com>
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

