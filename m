Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D41386B3
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299373; cv=none; b=ZuvU5BC5KRpx+FlkkgcoAag/fGPSCf4PqPt4gTKQ95mgzBT5Od1VcKUwMMS7VOuWE5hKgWhsQud5Sq2BZWxjvuKoLBL+6s5mU2CvE0se8zxmQ36t4Lyq7F6Uc75nPegU3ldfHS2xEp7GcGSpXGEd9TcUgBw12/t6psxej2NYFUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299373; c=relaxed/simple;
	bh=nXA8PlsknGlAHiafXUp1M6b9njTVEAheMx79C0InDls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQFstDur8/ICb/m8ecncuA1co+1giTNGRMk9dNVIvmb4dr2Rgv0nQL2Q0sAPRoY+38CtXV0pS0qENqzcoAKDlIpr+wVzMJlKe+Ky+jog2Wr0igh4VJKUcByAYnO5epLX93m1HIrXLwXYgI45Nvb3GI6l8+TNeMV+NsvLpk5kyeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rw19chCI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rw19chCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ii6cuQpofzPwFPNwG9djEe1GYPCsz98WmYuDmHx/y/c=;
	b=Rw19chCIzvhgW9nCaAh2VCC8LHO6O0sBmpCuLgfzBC6zXv4BYP2P7FHL3miIlKOX3TilEa
	W3G/CcnWLwdCLIgSy8pxmaMWmCs98ITKHfk2V2JznCwvZtWIHKNVsBDW/XCDoe7DmUl599
	7DCNwVy5zXQX/BcGNaYFHDFXZrxhGkE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-FCvC1AF2NH-gec9s9XuRQg-1; Tue, 16 Apr 2024 16:29:28 -0400
X-MC-Unique: FCvC1AF2NH-gec9s9XuRQg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5689f41cf4dso2782607a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299367; x=1713904167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ii6cuQpofzPwFPNwG9djEe1GYPCsz98WmYuDmHx/y/c=;
        b=SUdm5LpW/BbsCFUxSWEHz6q41jtlWzpZOKPTNb7rKQD0bz2T/03SP6NAV3oPs+XcRU
         iD0fhoE8sWBacuk99HgcWKNiRKBaS9HCxTtq92bYavDI/NwLn99Nwzh+GWbzNIQaV26u
         V8pwcoSfRCSthXIfRzDMmyM+s5qcDy/puFeMAq9Qn5uZ5AHBVIUwfHSH+5Kq0I0R5JVp
         spT2DDctVleSbA813AUFJq0+HU1NrPxLuYKcUUsBSYZvxkao/thBm/v2vPEj9yv+ABSP
         2+F2Kkp4i1wfw33C3IyfCMr+BSYvtlSxAqJGCa6x+Ro3GgdSmdYp35pDUStLPEo0YCkK
         nEsw==
X-Forwarded-Encrypted: i=1; AJvYcCWOa8mbcZASA3+tb3dHnVm31JVxuDUEXgptSKc7iDMeOL3GCgKh7bekzlMrFpW0o/fUbI6DbOYmbgGdr8e9JXP1GO2h22aX0a6g
X-Gm-Message-State: AOJu0YwaP4xAQ/K3dzilhxOhevetGMPJRyw8c06iypfSD6Fe2jAMTXq3
	dEJWexXXJ/wVBXkVRDLoL5RD0bs4ctqmo3nnEqDV3cI2OSdX5oNnMDc/XFUSxyJCeEZKoPHSGKY
	NEF4U4ds7+ZH3BW6oiIWpyECCIs1o5PcTDv7gHb8loOn7Wf1oP6xi5I1+
X-Received: by 2002:a50:cd9a:0:b0:56e:232f:e4a with SMTP id p26-20020a50cd9a000000b0056e232f0e4amr13204053edi.6.1713299367378;
        Tue, 16 Apr 2024 13:29:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCvhG8bUKbT7CE/KPIKBwugNK5M8aBGALv70H9VARwyThg/TzHpZYS5MmcXJ3/y0haev0VRA==
X-Received: by 2002:a50:cd9a:0:b0:56e:232f:e4a with SMTP id p26-20020a50cd9a000000b0056e232f0e4amr13204041edi.6.1713299366917;
        Tue, 16 Apr 2024 13:29:26 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id e21-20020a056402105500b0056e685b1d45sm6488423edu.87.2024.04.16.13.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:29:26 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/2] xfs_db: add helper for flist_find_type for clearer field matching
Date: Tue, 16 Apr 2024 22:28:42 +0200
Message-ID: <20240416202841.725706-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202841.725706-2-aalbersh@redhat.com>
References: <20240416202841.725706-2-aalbersh@redhat.com>
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
 db/flist.c | 59 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/db/flist.c b/db/flist.c
index 0a6cc5fcee43..18052a744a65 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -400,6 +400,40 @@ flist_split(
 	return v;
 }
 
+flist_t *
+flist_field_match(
+	const field_t		*field,
+	fldt_t			type,
+	void			*obj,
+	int			startoff)
+{
+	flist_t			*fl;
+	int			count;
+	const ftattr_t		*fa;
+
+	fl = flist_make(field->name);
+	fl->fld = field;
+	if (field->ftyp == type)
+		return fl;
+	count = fcount(field, obj, startoff);
+	if (!count)
+		goto out;
+	fa = &ftattrtab[field->ftyp];
+	if (fa->subfld) {
+		flist_t *nfl;
+
+		nfl = flist_find_ftyp(fa->subfld, type, obj, startoff);
+		if (nfl) {
+			fl->child = nfl;
+			return fl;
+		}
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
@@ -413,33 +447,14 @@ flist_find_ftyp(
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
+		if ((fl = flist_field_match(f, type, obj, startoff)) != NULL)
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

