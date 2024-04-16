Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8712BE8C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270938; cv=none; b=UPB0GU8W5aQ+hUKgXlPf5+OSBpUiD4rRDuTSlmzYfPcBydKaQXeUijMnAJ8HaK4URvLQt8l+fcgvPWg0XjCUp6Ih8DgsAbian82TvhR7AB99GCMYURV91nw/FV1FM0+AyzYdrL0Dqd2YY5kWllYMV8Q8s/r0Qva2b2hpIeXrTXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270938; c=relaxed/simple;
	bh=NOemmyi1Zimduf+3um1VtLLHUTHg0/WBIkeaKNQJnbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKgO/rOmE1XgSgN2dlJDK66s2uyT6ScuWdLIecU0uSvT+sqZpvhp73gQknGTf21HB6QWvthnMN+RH4++chQtwYl4iy4KmVu/w8zDBKAWORYfNBsJ+W/sqwGg3AMWfB2rrYyxMqBib5mk8Y3scdGVGiABeQmpzbN2akrVqRpPcrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IW6wQppj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IW6wQppj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeW15D5Q9ly8ujGfc/WJrwAVLFOjE2i7KfYN8G7cFUU=;
	b=IW6wQppjMest5X1fagzgf9caYXxlp971NYDx/ZwdlohZ8Wpo8CZl5aDw0BnYj/qVxmw4hA
	lOl8KkTc8DxBfcgvZ/rjc0kSk4BSv6mdDYbKpYeaKtprQz8dsvQ1uKtKIV/VpM90Y8Urzt
	ZwdNNjUpaBJcaLHtvYdymmUqpc/44yE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-CguG4aAyOlKWLndWFCra1w-1; Tue, 16 Apr 2024 08:35:34 -0400
X-MC-Unique: CguG4aAyOlKWLndWFCra1w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56fe8be5474so1445136a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270933; x=1713875733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QeW15D5Q9ly8ujGfc/WJrwAVLFOjE2i7KfYN8G7cFUU=;
        b=YqhyqW8CsQ/7YohXZ+8qliOLgynPSXpmz4PKGRla3WaBK0prKncavo4pIh0ZHmirdd
         f+CbXrvUyS5woHyBgqdFs7btfCdZRgYVXpvGEoZSewU2GqYhYvazroLeMny1WxkYlUc5
         oenXt0k97DBA9gDIYrOQdRt5TOGYbrUnPtJje7zschtTwurJdCRKaeK+eDqUJSu0e9EA
         qH5f4hSNJmSbeN+fx5xTklNvanGp+xffSc/mF7tNEd4KqDMZDpQcQUTYPBh0X7oFdv/U
         T0gh5F+qdmAHPE/7gx7hDqHwUhbpgNtMgWjSSrhW5lXq6O4Oi8oP1O92RcZ2EyHGyuIJ
         I+vw==
X-Forwarded-Encrypted: i=1; AJvYcCV/zYPTr/zVmk3z6GTH5y4wLS6ttY/wFqFrvSZMAGkphAmMKdpJ12nfHRAnKiBC7xMTPVAOkiyosO6el0+B1VhVAAuSfcgezP5Q
X-Gm-Message-State: AOJu0Ywt6B1IcElgwAJs0Zp5jaM7A26i6b9hKXPuwPLGPgGSxbM0pEL1
	FpFWiH+hsBZiuwI6qSF9uGSBVTtrMMZ4eAITKjGocwb/nZ1jCTEvZK/UXzzVld2REGBj99Wm9PS
	yxm5ZU24T28xg6FUYsaxdJboaauP3T17n102TZXFTSwby+Ec0b/I02RzF
X-Received: by 2002:a50:8e52:0:b0:56c:4db:33f7 with SMTP id 18-20020a508e52000000b0056c04db33f7mr12110317edx.10.1713270933091;
        Tue, 16 Apr 2024 05:35:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiJEWa2QWkHzP25cP4FxG9kmwHjHGMjJt9Qb5+waOGNZfZ+hpABkZ4PyT5Yu/QIiwANg9YGA==
X-Received: by 2002:a50:8e52:0:b0:56c:4db:33f7 with SMTP id 18-20020a508e52000000b0056c04db33f7mr12110291edx.10.1713270932459;
        Tue, 16 Apr 2024 05:35:32 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:32 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of int
Date: Tue, 16 Apr 2024 14:34:27 +0200
Message-ID: <20240416123427.614899-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416123427.614899-1-aalbersh@redhat.com>
References: <20240416123427.614899-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert howlong argument to a time_t as it's truncated to int, but in
practice this is not an issue as duration will never be this big.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fsr/xfs_fsr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3077d8f4ef46..07f3c8e23deb 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
 static void fsrdir(char *dirname);
 static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
 static void initallfs(char *mtab);
-static void fsrallfs(char *mtab, int howlong, char *leftofffile);
+static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
 static void fsrall_cleanup(int timeout);
 static int  getnextents(int);
 int xfsrtextsize(int fd);
@@ -387,7 +387,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(char *mtab, int howlong, char *leftofffile)
+fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 {
 	int fd;
 	int error;
-- 
2.42.0

