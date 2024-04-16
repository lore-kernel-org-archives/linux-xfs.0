Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEE812AAD9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270937; cv=none; b=SoLSoCqWebI6pL6eymrxU2r4Sqj4WiBBzDp9/Dn1+I7WtYLnVvmpxZcsckIYfs9xi7wfKq9ntivDfTAlzwOB7hY8ZVrSxu6pQi0jzABr02Rfk8Xm/O5g7FZnBOXpGt8PourgZPU76xEsnuL8arsSVoxA6W6IP/WRCMKYN+rjJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270937; c=relaxed/simple;
	bh=obms2tf5G9Su3aFrkpeWOtyVh9+9YwXfLAuAm7eTUCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ4Hm+2EljlOjI7cdbAQn2rBHZeKbqCrqmMiN7EK32elA2tm08fB7E6iPDWdppIH14d7FKHjPC3bBvmfEhz3M/sMNMWfJMFtES+bB4Viz7pA6/LiDLqs575BqKwProaMhHFmQXpbR6XxaE3sEDCq4ivSxvzBgs+ROA55occO0BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G0NoJGaY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0NoJGaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713270935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m04wGvEXmRMGQB+gacFFhoDMjkcqIzA8DcuF4Ekeq2Y=;
	b=G0NoJGaY/yZPdhi4Wl6r5CVp/Vg+gpbmA0BtGIAfYjMeOm6GDiNLqv/nkddyXBxSI5yzMD
	hyKdNM2fX4jmbqWHyn7TvJjRlTje5QtSfT+aJk9+pDcoR6i/GgKrXRjbu8OGMZ4Xss0qXs
	E4BPPgSOeLMXxT5bux6x5iFN/ba1sgw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-_MvlGHsKMCSZhsyrW41ugQ-1; Tue, 16 Apr 2024 08:35:33 -0400
X-MC-Unique: _MvlGHsKMCSZhsyrW41ugQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56e40f82436so1746022a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270932; x=1713875732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m04wGvEXmRMGQB+gacFFhoDMjkcqIzA8DcuF4Ekeq2Y=;
        b=MaDMEYGAFqIpkmXSg67jh6VTwYU+Ynv9GMJ3qbWBf2PWc5dy6jqtWrBWhI7vgI2DHA
         W8klV2OPru6J552/fr6SLQkFQwW7creSNitJuInD1o672jKBXUIbRwyB/USDlh+glomF
         6c9pwpPY5vHz8ikxhenpC3AktTEcNkPCip5js0xgS0hlg93eHoyYHo9ITpkqUyE0Mj9M
         bxzjscj+WZ3Bwvwtz25rQ8smuy9GJ72C69pJkbbBKUYMi6b1G3grL9itJWHsdfWNvTA1
         5HcPR0uFR6AEsr+uKUcXK95JkGoJi2nTpV136cR8TzvNY96Z/GDi8Cuh1PmR6wX3P4TW
         l8zw==
X-Forwarded-Encrypted: i=1; AJvYcCWJGTD7voQl+ORZ+tDv+hmoqkxcN3dRC7kuL3XK7GyqN8dO4cuQgGUfBCGG8bxPKBURUBqBfqb+9aorGrPifZ3tVYfPzjXamDbq
X-Gm-Message-State: AOJu0YxPr3UsSVkHeGpiqOqI4ewVnycDZIodzc1Xkj2QyH6SojmD7GgL
	jFnsV10Y2JmzcEa0H959byt/2rsFs4lBqzjZSqKsafuQdNc2cisnFX6GnEm3Wzf6Xuda39vShSd
	ZKdvwNvpIvWaegvvQJ6kFMBU+86YFhGpKhCmSJFrpmqyV09UdQoREQJ+N
X-Received: by 2002:a50:c05a:0:b0:565:f7c7:f23c with SMTP id u26-20020a50c05a000000b00565f7c7f23cmr11508213edd.3.1713270932420;
        Tue, 16 Apr 2024 05:35:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXTcbsr8MNsmrxBMfwtBNNLbu46ZQPaxLYhyyNLifJXpBP7mnvxngt0PusRTcF93Sd32wH0A==
X-Received: by 2002:a50:c05a:0:b0:565:f7c7:f23c with SMTP id u26-20020a50c05a000000b00565f7c7f23cmr11508184edd.3.1713270931858;
        Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005704825e8c3sm465584edu.27.2024.04.16.05.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 05:35:31 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 4/5] xfs_scrub: don't call phase_end if phase_rusage was not initialized
Date: Tue, 16 Apr 2024 14:34:26 +0200
Message-ID: <20240416123427.614899-5-aalbersh@redhat.com>
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

If unicrash_load() fails, all_pi can be used uninitialized in
phase_end(). Fix it by going to the unload: section if unicrash_load
fails and just go with unicrash_unload() (the is_service won't be
initialized here).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 scrub/xfs_scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646ba..d226721d1dd7 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -631,7 +631,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
-		goto out;
+		goto unload;
 	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
@@ -828,6 +828,7 @@ out:
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+unload:
 	unicrash_unload();
 
 	/*
-- 
2.42.0

