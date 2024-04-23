Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0EE130E5B
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875845; cv=none; b=TD9ywVJNrP++Vxq6ewzbPZanVUR9Eg1GjCh69zGpBhJ8mxG52awtomk0fzXDndowgDUqHYLsqjqM42pFsr35kSXCD8nY203ZPDkTrr7YG1tgn3NIP5SYSvoIdauU10o8H8QiwCDFgDujGFYgeFx4Bn6/IgFPHRwV2/xcuBU01q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875845; c=relaxed/simple;
	bh=ZjIlsppbSM+2+B8SuNJOGFUPsxt9o9ur2mn9oYk9b5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMf7NvO6HO/EumSX7put2iEe8V74KXAG73dxjMT80oZgv9ThOKCqu8eFXD2yZVpg4faEYZEP6HVE6QCoif89WUoKZ3nd2eBlIhXOXPkHzudkufhKpSRbXmC5PLMVptGzKSuBhtv2apFsIhPvQvZvwH7tZlO1VEwbUcUItVUj0u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XfZLks0E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfZLks0E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R0LxgM8QvLELziwrlN72LAzWTDKmOBhsQQZrCdm0rvo=;
	b=XfZLks0EFeBlT3lyY+MudcLzTFitl4ptyTTB1CJbVFfaION63hmoowJoUD7Je6ibBAOYGP
	2jH6Rp1lvCN32Zm0JsyfHY0qh4owzB2PN2XIQ7AHubqWwx178fMHy6etjhU4OnL8oJIrQO
	dAqReSo7catntHGIh8Ppz8Q8c1rtqMY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-ZhQwYkgYOpKW5n0Dl-0cwg-1; Tue, 23 Apr 2024 08:37:10 -0400
X-MC-Unique: ZhQwYkgYOpKW5n0Dl-0cwg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56e67c53f23so2002184a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 05:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713875819; x=1714480619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R0LxgM8QvLELziwrlN72LAzWTDKmOBhsQQZrCdm0rvo=;
        b=lgqBRJSShDN3DjoPV8Nznn4ay71ZDFep59c2CJBB/q6Qtbh6IkwXKCc71ywxHk1i9U
         WqwEwsVVA6AMUhBTJ7V44vQL6Wr/HIYiTWY9/xoaCwLDWMNWIrfSLYuLu55zN5Ezyft5
         GLdCb5fhSPH4nsydGCLVf570Ik2oyrJeiskQ+Aq1uRoMBQxtqD7wJ3tdZcRIUzYUtpMQ
         9X+ZiP1RsXO5weAs5bMhqNBD6Q7tXQxdmOa6wH+HMwP4CiMm+wNdAF7FCjiCgC0uGieX
         rNkaWmuIUhaymg2+7Qci9OM2nbuNfBN72uPvWzineKmrZJVIWGWvc1ksZSslUaJKvOpM
         t7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUyqtSwP3uuSUo6Mvo7nXFUBk8n7iOakl2cPi6/xHsI+DudMZ8R55VukdKQpxVZwRYSCmdThYuTCdIQzSenRhArXkg1Aw1ufGqq
X-Gm-Message-State: AOJu0YwgKEocz7/csKnypm7weKCNO/3EsVshI3cRK+lTUX4lfZxjwsso
	o6ZuA4iZv6LQL7hoWE6YXmpN7Q0BXT3SzAxHIAm9obk7w/nv1BQWZCxyWkf/C6l37ssXLvM1+eB
	+35yaSKs3O4H0peeRW34BPREoTp+0G6CEkBxeZvRpw9rg5v0vHCbRJKcb
X-Received: by 2002:a50:c30d:0:b0:56e:6d9:7bd6 with SMTP id a13-20020a50c30d000000b0056e06d97bd6mr9000645edb.34.1713875818749;
        Tue, 23 Apr 2024 05:36:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdc8PXEEu7IPBFWobjoCgVpuInycnus/1iRSGVSOqkjJCKC5wn1z9uy7L9Z1oiv/FM63JtaA==
X-Received: by 2002:a50:c30d:0:b0:56e:6d9:7bd6 with SMTP id a13-20020a50c30d000000b0056e06d97bd6mr9000616edb.34.1713875818115;
        Tue, 23 Apr 2024 05:36:58 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id et3-20020a056402378300b00571d8da8d09sm4783170edb.68.2024.04.23.05.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:36:57 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Bill O'Donnell <bodonnel@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 3/4] xfs_scrub: don't call phase_end if phase_rusage was not initialized
Date: Tue, 23 Apr 2024 14:36:16 +0200
Message-ID: <20240423123616.2629570-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240423123616.2629570-2-aalbersh@redhat.com>
References: <20240423123616.2629570-2-aalbersh@redhat.com>
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

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 scrub/xfs_scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646ba..50565857ddd8 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -631,7 +631,7 @@ main(
 		fprintf(stderr,
 	_("%s: couldn't initialize Unicode library.\n"),
 				progname);
-		goto out;
+		goto out_unicrash;
 	}
 
 	pthread_mutex_init(&ctx.lock, NULL);
@@ -828,6 +828,7 @@ out:
 	phase_end(&all_pi, 0);
 	if (progress_fp)
 		fclose(progress_fp);
+out_unicrash:
 	unicrash_unload();
 
 	/*
-- 
2.42.0

