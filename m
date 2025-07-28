Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9355C265281
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734697; cv=none; b=nwzDrsfR9eFJ2qb4LdJ3P+O48XCZa+YoXV8jmBi8JL+sdwYeLE4GjOBeRRs1xQBtjeq3jFb7zZcHTTu/avzfAHWmGXnbVmEgbjQ0nXbfcwrDTQBUGS99L8RpyaigXgQ5eUSQBB8PmCju+cm7F6n7yYUQ5pPv8624uXoX4BPZkZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734697; c=relaxed/simple;
	bh=YNyZSYIBFJ1w4feKF//aic1Pa6JAduIDo3IdHQgUxNM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=eN1qyQzIP9vjl19ddYwgkYNu0SRi+rMx4mzhoMDbrVtMisYRWsqGqzxoZvp1he6c5xCrjY3KJ46S5fnIrqCtZhHk9FUA2FJvFLnJzSaKW47xIW0dmxEcGkNMbgGZpgMpRMRnvCQfmG+8aBEGPSZzTs0Fsh/IRvj9RuiaGtZi5RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/lxNWhp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/lxNWhp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wzkb/NVAkTBakvI6MpNnn+id6RW4IMwHyuQvB6ou1yQ=;
	b=A/lxNWhpHzXLuXlOz51+TEM0RuT2x9H4s0wSonsoM0pVB26xSr74xEuymqQf7MuE8zSMqD
	hehqNtN3ykXAuHfFD6/10NheSwkUnXflBL2fkG3Y8KXGeBFdVZR7KohFRYWhuO+YHDTqof
	7+LWVVpWYwZXxbkpdywmeF7pvPmTxW8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-PIZtgZHyPI283hh4xHRGww-1; Mon, 28 Jul 2025 16:31:33 -0400
X-MC-Unique: PIZtgZHyPI283hh4xHRGww-1
X-Mimecast-MFC-AGG-ID: PIZtgZHyPI283hh4xHRGww_1753734692
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-615145b0a00so1382621a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734692; x=1754339492;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wzkb/NVAkTBakvI6MpNnn+id6RW4IMwHyuQvB6ou1yQ=;
        b=qqpc96ia0bd302pyarZ9it/cRdxLv6puqhyg9Rul0AopFpxqvlNzdosymlVFjGtiIC
         9QkomkaT/8gU6z5/FGaYqrWplEXFom8beqHMvGS+rku2ZBGUOuvVh4r51CWRqt97hfQf
         vCV+49LLMy4myOIJV46Wf40Mk7BqxJXhvQSTcItLqwraD2p2Mp/ldSy8c+wGiOhNTpDa
         A2uVOBjyNdGFuVGdcyj6U1bTPjE8PPpxHtFEN8hHTOnW/FIdl2FkqjZSKRMHVIbeKOfm
         4j7tdFUwxFAkSks1f5A7eHvzZXhhAE1ONC5Lm7dVbEP52spshcUFk0NOHFWjAahh8Etl
         pznA==
X-Forwarded-Encrypted: i=1; AJvYcCVzZO2/dH9oOzMlqIoB6TUHAJJPhECDciww2UJ/sackCMeuPhTe5g9JJUpWftaHysBD0c5IWuzEuxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxewCfbCFW+iqPZ/euH3xXT+5IgIGiP8Do0M8kMPdTecjGYdW6Q
	3V8IghyDzYLPTR7ctQuGzrBpkTYpx6zu0fYwHjjEvJUVSfIxggV3yKri2tZRHQg5uohQq6R89Lq
	6rwZtrdIZ86fqLXEptR2KXa7kKa3wOJ0WpZasDKC7WD9z1a+GueLE079PRGAu
X-Gm-Gg: ASbGncscZBwX/63HQY+O1AIfXQSobIfyd4xXRI4/RoZ2Qc5W+pFPsF6WS1nSJxIPZIU
	32eCKy5564RuRBGA1EQn6WccV9knQfwLEXgLKDEFlMI8sMBo3IHpLGSY+ETHcex0y1BCkLloaKf
	cuRLMOBNWBbfqbOVTK0LXyzk1gtRNUbOEJXn4Fmga7hT5olf8pnXl/JeAFD8U3Mw1DZ6hh9MSiV
	bigLbNxGjO8wTy87DNfEwOODWrfWV3ur43ITVhd29Gf3me4rxaFwVs9Sl9Hk7ktIPMms4qKjKVC
	R3fDsUqe3XUbaRe0tjp/6ZqUpatksgPFxK4NuAZ7SFBv+w==
X-Received: by 2002:a05:6402:4602:20b0:614:f03d:b990 with SMTP id 4fb4d7f45d1cf-614f1d60968mr9214062a12.22.1753734691848;
        Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcZe33k0BLoG6A+mlDJXqoo8AHPS7/tq95Z/DmRgYYP6h21kfw89TtPwVRwazuXA7cJjvTow==
X-Received: by 2002:a05:6402:4602:20b0:614:f03d:b990 with SMTP id 4fb4d7f45d1cf-614f1d60968mr9214046a12.22.1753734691478;
        Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:15 +0200
Subject: [PATCH RFC 11/29] fsverity: remove system-wide workqueue
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-11-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2492; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=/JE2Dbo4OAeZtzIugw6Qkxtx4bvySBi5Hu03+/rIzv8=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvif+1/lXlf9L82YH5PuHpW+7ZzHrhvf7VHA2FT
 6J7w9pu/PnaUcrCIMbFICumyLJOWmtqUpFU/hGDGnmYOaxMIEMYuDgFYCIaSxn+SqXwzbMS/D75
 adgaAz3HDIHkvpJfVTz18V+W7fzByrqJnZHhmX6ryLK5bnOiH1mzP1snpqS+e9c+5h+G6hcu75R
 Ye0WXBQB8tkhu
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Now that we've made the verity workqueue per-superblock, we don't need
the systemwide workqueue.  Get rid of the old implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/fsverity_private.h |  2 --
 fs/verity/init.c             |  1 -
 fs/verity/verify.c           | 21 +--------------------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 04dd471d791c..2de28be775ea 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -152,8 +152,6 @@ static inline void fsverity_init_signature(void)
 
 /* verify.c */
 
-void __init fsverity_init_workqueue(void);
-
 #include <trace/events/fsverity.h>
 
 #endif /* _FSVERITY_PRIVATE_H */
diff --git a/fs/verity/init.c b/fs/verity/init.c
index d65206608583..b252493496df 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -61,7 +61,6 @@ static int __init fsverity_init(void)
 {
 	fsverity_check_hash_algs();
 	fsverity_init_info_cache();
-	fsverity_init_workqueue();
 	fsverity_init_sysctl();
 	fsverity_init_signature();
 	fsverity_init_bpf();
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index ef5d27039c98..0edbf514dd31 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -10,8 +10,6 @@
 #include <crypto/hash.h>
 #include <linux/bio.h>
 
-static struct workqueue_struct *fsverity_read_workqueue;
-
 /*
  * Returns true if the hash block with index @hblock_idx in the tree, located in
  * @hpage, has already been verified.
@@ -371,23 +369,6 @@ EXPORT_SYMBOL_GPL(fsverity_init_wq);
 void fsverity_enqueue_verify_work(struct super_block *sb,
 				  struct work_struct *work)
 {
-	queue_work(sb->s_verity_wq ?: fsverity_read_workqueue, work);
+	queue_work(sb->s_verity_wq, work);
 }
 EXPORT_SYMBOL_GPL(fsverity_enqueue_verify_work);
-
-void __init fsverity_init_workqueue(void)
-{
-	/*
-	 * Use a high-priority workqueue to prioritize verification work, which
-	 * blocks reads from completing, over regular application tasks.
-	 *
-	 * For performance reasons, don't use an unbound workqueue.  Using an
-	 * unbound workqueue for crypto operations causes excessive scheduler
-	 * latency on ARM64.
-	 */
-	fsverity_read_workqueue = alloc_workqueue("fsverity_read_queue",
-						  WQ_HIGHPRI,
-						  num_online_cpus());
-	if (!fsverity_read_workqueue)
-		panic("failed to allocate fsverity_read_queue");
-}

-- 
2.50.0

