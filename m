Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B99157487
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728043037; cv=none; b=b9tU8DzU6fIqhgEGIkCVkLePK7yu61wNwT2pKtv5Y1y7IfB6nKrhmYrQLgRDpPlcJonWys2rh5b4zTImuOTN7PzZpM6sHiCukJ2ds12pxKwp3+MujWWneMpwfi/5La7Nl+MjtlIFG6xkGsmtaX2kNKl7cGlyESb+K+rGr5Rvj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728043037; c=relaxed/simple;
	bh=URXEBJreisPCa4lLw/TAGR4MFn1cgcSg1bIs53k/0OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0GPAwuGlJxlhLbYhbj5d3KYH3DBZVpLHnHgyAbyED7cklnttbSvbnLWOEJN+bJLPDMhmK6Hu1+Zg3qB+OyjadH6OYS/74Ur0IURJuJnVCFnN3mzfQICAX3GMed8VvXSiT1U+w8LIW6+9vC1smWv4SBgTlKg97o3gkWWxErKvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eGfWoq4o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGfWoq4o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728043034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KN0fYPeHsc3j1Q0Gn6HCPdjsFTgSR6ExkB4Wg8g7WI=;
	b=eGfWoq4o9UN8KVhOi3dRfS2L1TS06f1W6RY7MrztRWNJKFX7ohv5XF2VnlCbQ7xAILfJEe
	UCMyGHu/gBfhfghQwRuN/1D0Q1ZH6siu4nFLARRA4zqrmGo2bR2/BaNsPKltLQ22uoqmU5
	f9UeN0HNPggWidToix/ludTwQiZvM8U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-3k3DLOW_OiGuLaJZF7N1pg-1; Fri, 04 Oct 2024 07:57:13 -0400
X-MC-Unique: 3k3DLOW_OiGuLaJZF7N1pg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8d26b5857cso156198566b.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 04:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728043032; x=1728647832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KN0fYPeHsc3j1Q0Gn6HCPdjsFTgSR6ExkB4Wg8g7WI=;
        b=pRUnQFLw0zAfd5Ymc9p8Id/G7XTNzE4MPOmAUUOMv6clMSLBCNCM+KXrQGcAtiyPAa
         agHRY/BoSvCVw8U63LwSPdIaUjJ6kRADJ87csP5GVertoAGcCn1AqJPk0wgyZUzluMKq
         5S02qRNNpxAewZ8AXx2h4WRCKZJ6t3LPYZpZ3HwxrKtUjS5vF2SBqBY9SZv+HfCPGz3g
         5UF2pTX/FO1kaeQfVBhWm3O9WdVsxSiw2dLWUOpJBXb6Jh6SJeyCLxYNdpyFxLzQi+vc
         s9XxvKo9tT1BJ7/MicaNf9kwwmbIJtELKS3Heu6eId5wYWm8DqhXyX2lq5r8BmmwIZkk
         dQDg==
X-Gm-Message-State: AOJu0YxHfiGJVjnravl7OE5wHGnVwoBEnyPCOW7FqCQY6qMECxJjQj3e
	b/+LhabzEM8x1eMyRD9y1cKK72VrzsgAmmsaHy2bBh2gynOLBbbnjHUbDN6t3ichd1dzs7LJ84i
	Yp4bo1ecU/Oop180p038uHBzr6t3U9Yc5XB7/inRwKNXkCQbZpj4B9hZCYGm8WZKF4zLaGXlsAm
	X6A9pGWR3oRiDJpg2sCUXwM5fw1rWS92XGfoWykyk6
X-Received: by 2002:a17:907:26c7:b0:a86:fa3d:e984 with SMTP id a640c23a62f3a-a991bd401d1mr268908066b.20.1728043031881;
        Fri, 04 Oct 2024 04:57:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJyB9t2IlxO0Dd64oFjv/7SHyb6+DmwA8ffnkh3Op0NzPHiFatj3pgPGcMbFjmF90diKWNUQ==
X-Received: by 2002:a17:907:26c7:b0:a86:fa3d:e984 with SMTP id a640c23a62f3a-a991bd401d1mr268904766b.20.1728043031334;
        Fri, 04 Oct 2024 04:57:11 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102a64a5sm216734566b.76.2024.10.04.04.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 04:57:10 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v4 2/2] xfsprogs: update gitignore
Date: Fri,  4 Oct 2024 13:57:04 +0200
Message-ID: <20241004115704.2105777-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20241004115704.2105777-1-aalbersh@redhat.com>
References: <20241004115704.2105777-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building xfsprogs seems to produce many build artifacts which are
not tracked by git. Ignore them.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 .gitignore | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index fd131b6fde52..756867124a02 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,7 @@
 /config.status
 /config.sub
 /configure
+/*~
 
 # libtool
 /libtool
@@ -69,13 +70,16 @@ cscope.*
 /rtcp/xfs_rtcp
 /spaceman/xfs_spaceman
 /scrub/xfs_scrub
-/scrub/xfs_scrub@.service
 /scrub/xfs_scrub_all
-/scrub/xfs_scrub_all.cron
-/scrub/xfs_scrub_all.service
-/scrub/xfs_scrub_fail@.service
+/scrub/xfs_scrub_fail
+/scrub/*.cron
+/scrub/*.service
 
 # generated crc files
 /libfrog/crc32selftest
 /libfrog/crc32table.h
 /libfrog/gen_crc32table
+
+# docs
+/man/man8/mkfs.xfs.8
+/man/man8/xfs_scrub_all.8
-- 
2.44.1

