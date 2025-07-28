Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E3D27C84B
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734698; cv=none; b=gEBixBzlVkGp0KkAkYgZoUXYRlJ2LenbW3tHCX+JMayCt53rTxvwZ2nfrZK48WXf9eQJ3ZfVSo5eONQMzBR3//Hw27T0xIE+N5pkit6CVEMe2cHLpZYLD7UsjuZKt0Hdk86iYTWRIZ+e5xPVdCewB+l2AeqhzPShr39KDTx3Q9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734698; c=relaxed/simple;
	bh=V8qNbzjsE4JBu1MhTEPPGAHCYOvhHUKvJ9SI0FfHYX0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=mUA3nFI1fFB9ZEF0Si6nIFML6IkXBa86FxJtA3YrqQsRaMnVtmpNnJ4rWKAYTDp6byJogCBJk2vzmE3n8M7WeF42nHSNGp14cFLQhs+gtWAamRzJbrfpOHLYeWeB9Xys2N1zSG8xwtseCIG+4Ho3N2trBTAzPQUWIvErDpS5X9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROpnCE+O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROpnCE+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPq7ioMuDIU1givclwrLOed+wUzgBQHM4Krd29hrZGg=;
	b=ROpnCE+Okg0mCUr4TdNYW4BHZrw5ulyfG98ErPQc8uJfi+UkvR6Qg1WC8YFFvuKhQYUi8p
	TVI0pHPNSnCQD+qTnUpfkdYGbNhKJIsxEpmPL71uMMMOdL5dzc4mxJSsF09i0pm5VxIosH
	EfRpLgUO2nXz0bLeLuL5ry2tj2qZ+mQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-_ZL81YUXPk6sc65afgPxgw-1; Mon, 28 Jul 2025 16:31:33 -0400
X-MC-Unique: _ZL81YUXPk6sc65afgPxgw-1
X-Mimecast-MFC-AGG-ID: _ZL81YUXPk6sc65afgPxgw_1753734692
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-615293aeea9so1803245a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734692; x=1754339492;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPq7ioMuDIU1givclwrLOed+wUzgBQHM4Krd29hrZGg=;
        b=S8lYxQVpChwNRs3Bq6Q81Jr/iOOWb4+eHS6++CLOvakaNGRMMyTONpPn6GVOgUNlvU
         he4GraVI7JDlKyJUM3RcAw0xRX11oq3C1gsWgc4YQeZNcDQXjpOCKomW5Jnd0/zpA4In
         3TWOBlJaeZWJBL6ziYCqz+1rZtHpkKfXApIBLom2OCUvV8PQHUMJ4NI0PFu7p9z8JAut
         8/keI8SUcRx6/mtXOw7cTHbO2XlbOvEcVZNzyg9kRanrWVo294pDnxXCdOaBRpsJfEar
         iJM0cgZ5LYvBrdIKBuyv2KXTYTq+zYKx8J3eRRfqDu6yeaiTy1hRvzjnpbRb6Oxz9/iw
         TczQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA6fBLpczcs8Xnas9mDwba67R3J90ZbN53f9LiwxKN2TwR+vXk7JMY75LKamzF3PZh5+87MBIhPyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGoamMmrIzXYHJJGbfs2LIzPY7ei/3fjJnLCFQL7tLOZW5DiPi
	plEA6mYXAcVClQF/niT2RhXcnpaWbAcBb6GG6mPg+gma9CGBsOuqYHz6o75anJP9dK5MAIXxKbr
	MeojZF1z4mc+wRyELxqUxb3Ku07bSnHuZkvYpy160338BNhVJyiEgCGU0ABI6
X-Gm-Gg: ASbGncvr5Av1PkPF7ciQxRuzE+7p4qPRUxM0X80jgtpxP9P9vrPJ4vc0vT2A0KC20No
	YxAcCPuM8NKzSw0i9NK5fwU+Q3SMNtZyEY5YDBz9/GgpW7xItt0rg4yF4sDCOYzaeekXzzdn00S
	n3TSLsCOkoDlR8xCtbCCR7GbzfYS7u0VVyhYycSwOTdmcHANPS1hEhztFil08GI3p1e5B10G4OT
	rtc2nbMyEz1twq8VdVwBIb7TxKSBDjkLY+fXNeTr51qOwdZGT+11EgXjJ4fZXppVcxmcbheZp9+
	4QCXVj87wF9DVKKCX+baRfs7bn9aAF7p2O6h7M9Iz/L+8A==
X-Received: by 2002:a05:6402:2807:b0:60e:23d:43b1 with SMTP id 4fb4d7f45d1cf-614f1df695bmr12503568a12.16.1753734691976;
        Mon, 28 Jul 2025 13:31:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJO8IlWhrpYESDaiCimQKB8ZcKiDQlQp927UKgU705UcobB9htySU5iKjsIwV3f3uW8HK5fQ==
X-Received: by 2002:a05:6402:2807:b0:60e:23d:43b1 with SMTP id 4fb4d7f45d1cf-614f1df695bmr12503495a12.16.1753734690764;
        Mon, 28 Jul 2025 13:31:30 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:30 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:14 +0200
Subject: [PATCH RFC 10/29] btrfs: use a per-superblock fsverity workqueue
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-10-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=kuOn1nMdlYjue/gx8Se2FoLjVY/GfmNvzXVoSFxJQLY=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrviQdOW/4+UExSWf7seuPldh/jPvRu3Mjtucsj6
 39LeJhNYn5HKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAibw6yfBPKy6t/d68ZbPT
 JxV8DZ5d7r6gb7Z+Us6O/f0W04RtCi67MjL07RM9G7V6tuLfTUuTPn9OjZ+/7kvtz7wM7cArTX0
 zDI6zAwBm2EpH
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: "Darrick J. Wong" <djwong@kernel.org>

Switch btrfs to use a per-sb fsverity workqueue instead of a systemwide
workqueue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/btrfs/super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a0c65adce1ab..cf82c260da9c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -28,6 +28,7 @@
 #include <linux/btrfs.h>
 #include <linux/security.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 #include "messages.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -954,6 +955,19 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_export_op = &btrfs_export_ops;
 #ifdef CONFIG_FS_VERITY
 	sb->s_vop = &btrfs_verityops;
+	/*
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
+	 *
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
+	 */
+	err = fsverity_init_wq(sb, WQ_HIGHPRI, num_online_cpus());
+	if (err) {
+		btrfs_err(fs_info, "fsverity_init_wq failed");
+		return err;
+	}
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;

-- 
2.50.0

