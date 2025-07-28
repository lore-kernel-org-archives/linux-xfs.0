Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE058279DD6
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734695; cv=none; b=DcBBZu2vkeV6B+LO/yCzfh/GfxDuSMvyHyEM7wuvwSihVSCqCBfrDRkEUCtUFZgpVA4X5uwHFvX9k+Mz7IiMgxueebblW44gh0uij0C+HC7qKrTj57135EqUsJLlczNuNPawi09KM3H7a/twWccCkCGro1zM74LeSNVRL8ISAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734695; c=relaxed/simple;
	bh=oywUNdy9SXNgRvU0YoeafcjM/3VIs70znQ1LmSPU2B4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=YEl9YDVw9KF6lz1R7exHZv1L1FqcZx1SBX2vgJjoUJaL0CScUzf8Xxm8THM21yn79/ssrTK43JkGtoIVepJZ1OzzHhn1atcyF+ULYaWT0ru8BB/h3j2Pt+IHBbh5PmthF7MwAfZ87FBfk0t7EymYDeG7CHNWx5f3/EZEUZXDKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpJcShfa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpJcShfa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Why2a90OOR2KPUrmkOK42TjhIsW0VoTnCqJDDVQ6oe4=;
	b=EpJcShfa57FW4xofjSUQG610BOU51qaUUHiWF2ki2QEbOTXpIcBg0j5KlN81MiFdWxT2kC
	mCJzv3eAjakoJvkI0sbRmQIrVQIo0BuZlNeYZpei4tpw/dMUpWOvWcUXpwXayeCZY2r8L1
	smSuFib+FckI8VfF+Oib23uj506+4Ik=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-MUpsdRb8On6MRwPmxzSfVg-1; Mon, 28 Jul 2025 16:31:30 -0400
X-MC-Unique: MUpsdRb8On6MRwPmxzSfVg-1
X-Mimecast-MFC-AGG-ID: MUpsdRb8On6MRwPmxzSfVg_1753734689
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ade6db50b9cso507518866b.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734689; x=1754339489;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Why2a90OOR2KPUrmkOK42TjhIsW0VoTnCqJDDVQ6oe4=;
        b=OByNUSBTkoezeyhOrKLkSfsGYvF9RV718Xrq+vfuxeYe78WK6YgecwruzqvyKsNCxV
         Y07uBRIRoXKmEkz8MAuyWKD8dkisFPrl63KCbN9UZGm3OUvG1xLDBo+jawIG+Nz11xIR
         xeT//tUtMT3+FbCY9IibCF0QOt2k/zoK7hToJw+SybcuFON87aqU0u/DjZrTY+4VQpjg
         UJ6mS0qZEP6USO71Q6ZI5wepE2wuKAKelq+3O4Ii6592aTa0nWl2+Sj3ndSgJyjCZpAr
         S//3rNPikMAKfYr9Lcft8YrHqvtPlwvnj7/zD2RIE8HPhnGzBej0R68v/3KV9PGQucn9
         p7Qw==
X-Forwarded-Encrypted: i=1; AJvYcCUycMMF/NvZOrLVSMH9VLEzDuow/iGwuF8EUt3HSn5es2+WUNYjSqlBPBnj3wFdIciwjP0X0HWEa0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNLXgRtUM/zmHi/O/K7ezqr6oKGM459uERSWAaVoTo+CJ7SrxQ
	ZwtP4U26p+wJkIWwYTSQ/c7XoDZJ1H0+E8S6CMEiVRFwjqo4Usm70aLaSEB/qtSMFieeMFlSkN1
	MTIsBOFqxCPfUbR67OPuWWMnuNIHxcP0q6tLPqWVL9MEJ9R/2zsx0XLGHStwD
X-Gm-Gg: ASbGncv9Bby9yaukf3UwG18EuntBg0yxPgHEsHHtZGpcLEuIhR9dvHvINPRlOjd9So2
	j5gmvkHkPdN7GM8SJs5slLd383WM9j6JIwrzr0aWPN+9M6ybji4TavFCg2+9GC3sK1DR+z4JxbL
	5zpu1jCxh4h56y5+vnzVkiG6uoR2hokzjDogzkt2fF/HkjGcoIV8t8f5+cLXMCWlp5dTZS75e8P
	/Sj7ya3aVhqd6jlowAmJSePp5piSbxt7OshhSVfh0ULJGMYeTv6OqzudVeMCqzyJ/IG4oUBUTwr
	cdNQcKlKrmWF4oLL3IpJ2D8Zso1l22GX+jx8MI7+D72JLg==
X-Received: by 2002:a17:907:7f0c:b0:ad8:9257:573a with SMTP id a640c23a62f3a-af616efc71dmr1429829466b.5.1753734689310;
        Mon, 28 Jul 2025 13:31:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElqLNNpMpUzeIxl4kr/PFatnBAKdgVdcL/2FQoChJ3mBvf5eeLG5rjoJQ3gDbaVWDOhBqS3g==
X-Received: by 2002:a17:907:7f0c:b0:ad8:9257:573a with SMTP id a640c23a62f3a-af616efc71dmr1429825766b.5.1753734688875;
        Mon, 28 Jul 2025 13:31:28 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:28 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:12 +0200
Subject: [PATCH RFC 08/29] ext4: use a per-superblock fsverity workqueue
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-8-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1033; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=8eioOXLwKFbWQjOAzR05yR6o85tqQ9fD9/ewRMN73qY=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrviStxfr8V+zzu88HeFq/NhRLCl9kXnNFsPcB6e
 /qJDIHzVtkdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJmL/guF/6StJt4ZHu6Un
 uucKypWZSByuXP24xklOeHFOkcuX5k+VDP+07MNvHDm/Yo/UfNu9K/zj3jfwikiapM5v9Wv/+qO
 iei8/AGH0SCI=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Switch ext4 to use a per-sb fsverity workqueue instead of a systemwide
workqueue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/ext4/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c7d39da7e733..dcb9d1933c2e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5373,6 +5373,17 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 #endif
 #ifdef CONFIG_FS_VERITY
 	sb->s_vop = &ext4_verityops;
+	/*
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
+	 *
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
+	 */
+	err = fsverity_init_wq(sb, WQ_HIGHPRI, num_online_cpus());
+	if (err)
+		goto failed_mount3a;
 #endif
 #ifdef CONFIG_QUOTA
 	sb->dq_op = &ext4_quota_operations;

-- 
2.50.0

