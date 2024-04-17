Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14613D602
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358789; cv=none; b=uSAu0EfqTQKHiIcdLaWk1Y+/R+DaDBsvVt5yWgYRxVZamZnG3vM4nmhn7zkXc65xmCqBCr2S6I9NGHZtGDD1w6GDDUHM/rSy5+hGkZ5nuZ8K6ZmyyQtFYB7wNo7JRqgZLJ0uI5jzIM4VWKMmsYsgAe16UXI09UM0Tmd/HTlY4zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358789; c=relaxed/simple;
	bh=JOFYvRABO6y0jTqmTScSEQKsVA2GsLtTANrcIjwmc9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luWMCqUQ1qyMhhgC7QubirEan3pYRe/lZxzJbXyfdHEcYe1emZwLu4JaYJHlZTBNhG6LFztsuYfG5Kh3+KnKOUq4XdqdVdOZ3/FW9ZTfcQIIATxVDFjmwadPUgRyqsaeiaz00xHA0rl8pl4aKzNCOjX9Mk1Lv+e4qG4j8wxUYr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PxQDi30T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PxQDi30T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4jLs7WDQvsc/TaTgXelU4d709GzBrXvlSBJrj50QPvU=;
	b=PxQDi30TZ9zlxyUHL+A6HUXktV8RHN/O0h/zvON5CARqoeKtM0qZNRn9SDE3N9ljff5FDC
	/I2+XRPizvU2NbkqSomKGaUGS0ubWoUwrULbw2cwLTYYNkEURSge8PgI6iNGujBhX7zkaF
	W3llWPoTi8hAakjPxJODPTFhoQRxc7w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-AUN7_w0rMuKWikUNJULe5Q-1; Wed, 17 Apr 2024 08:59:45 -0400
X-MC-Unique: AUN7_w0rMuKWikUNJULe5Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a450265c7b6so286877466b.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358784; x=1713963584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jLs7WDQvsc/TaTgXelU4d709GzBrXvlSBJrj50QPvU=;
        b=t4eLfFTf0nibqOnXvXYIMA+XHxSXsOX2id28MqEcQB8dK59tefvg9fekEiTKa0xnvp
         uRcBaRiJhQb2XlEjgnGR6lWThOAof+mwVPLctOHYlbTw9ig5Ub/NpJZhYgaTg0erdhV4
         5jVufAXeRfuh4Vh+2Sdgy6eqedRYVCXmqPdm3vK95To/HuurRaSPiuMPRrQtPXUtnoSi
         f+wdpNXG0pA7TIcMyCpt0UfDt64wqyblbDSIz0eYOI/M91Rv7wUE+ZnmpCE/OgsdWGhl
         9w9qZk+oAmpru6U8aSz5GH8aUWd+/ell3Pa60JXAUaUq/gtmIe9v2fkrO5KyNjhmiNWJ
         j6wg==
X-Forwarded-Encrypted: i=1; AJvYcCWG4H5aFBP9JbImDmu/KlMkTLNxzEFbZZ6p8jnx/wfxqYPjbIe+k9+G321UsddUpbX0i92OQ575ivVWgepH/if5adxEM+Az3GyJ
X-Gm-Message-State: AOJu0YypbmuT/2OBDSQLwtZxgylUXUlDp3egCOo50bx6gWB4VBVGpkwC
	dn5ddmKBDQYUU/LGQskCTRvFcdwZnDVNaMwDwm9ImKDtoHhNMNkQTK3j9G90VswG9Jd8Yaeyp0L
	lakOvM5xsNg3sJEvRFhQ5GHjY1kEkb307Z2ypDBWdUb2k9o+/9icUT++y
X-Received: by 2002:a17:907:d8a:b0:a55:38e2:75a3 with SMTP id go10-20020a1709070d8a00b00a5538e275a3mr4397717ejc.16.1713358783951;
        Wed, 17 Apr 2024 05:59:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY+0XWSJZRMX0HHncDewPebPkLcIQZEX58jLoEdzfTsDXLmRCGUid0WNqG1mfuPAcC+XmjXg==
X-Received: by 2002:a17:907:d8a:b0:a55:38e2:75a3 with SMTP id go10-20020a1709070d8a00b00a5538e275a3mr4397688ejc.16.1713358783316;
        Wed, 17 Apr 2024 05:59:43 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id gc22-20020a170906c8d600b00a534000d525sm3330252ejb.158.2024.04.17.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 05:59:42 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@infradead.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 3/3] xfs_repair: catch strtol() errors
Date: Wed, 17 Apr 2024 14:59:37 +0200
Message-ID: <20240417125937.917910-4-aalbersh@redhat.com>
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

strtol() sets errno if string parsing. Abort and tell user which
parameter is wrong.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 repair/xfs_repair.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2ceea87dc57d..2fc89dac345d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -252,14 +252,22 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-o bhash requires a parameter\n"));
+					errno = 0;
 					libxfs_bhash_size = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o bhash invalid parameter: %s\n"), strerror(errno));
 					bhash_option_used = 1;
 					break;
 				case AG_STRIDE:
 					if (!val)
 						do_abort(
 		_("-o ag_stride requires a parameter\n"));
+					errno = 0;
 					ag_stride = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o ag_stride invalid parameter: %s\n"), strerror(errno));
 					break;
 				case FORCE_GEO:
 					if (val)
@@ -272,19 +280,31 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-o phase2_threads requires a parameter\n"));
+					errno = 0;
 					phase2_threads = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o phase2_threads invalid parameter: %s\n"), strerror(errno));
 					break;
 				case BLOAD_LEAF_SLACK:
 					if (!val)
 						do_abort(
 		_("-o debug_bload_leaf_slack requires a parameter\n"));
+					errno = 0;
 					bload_leaf_slack = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o debug_bload_leaf_slack invalid parameter: %s\n"), strerror(errno));
 					break;
 				case BLOAD_NODE_SLACK:
 					if (!val)
 						do_abort(
 		_("-o debug_bload_node_slack requires a parameter\n"));
+					errno = 0;
 					bload_node_slack = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o debug_bload_node_slack invalid parameter: %s\n"), strerror(errno));
 					break;
 				case NOQUOTA:
 					quotacheck_skip();
@@ -305,7 +325,11 @@ process_args(int argc, char **argv)
 					if (!val)
 						do_abort(
 		_("-c lazycount requires a parameter\n"));
+					errno = 0;
 					lazy_count = (int)strtol(val, NULL, 0);
+					if (errno)
+						do_abort(
+		_("-o lazycount invalid parameter: %s\n"), strerror(errno));
 					convert_lazy_count = 1;
 					break;
 				case CONVERT_INOBTCOUNT:
@@ -356,7 +380,11 @@ process_args(int argc, char **argv)
 			if (bhash_option_used)
 				do_abort(_("-m option cannot be used with "
 						"-o bhash option\n"));
+			errno = 0;
 			max_mem_specified = strtol(optarg, NULL, 0);
+			if (errno)
+				do_abort(
+		_("%s: invalid memory amount: %s\n"), optarg, strerror(errno));
 			break;
 		case 'L':
 			zap_log = 1;
@@ -377,7 +405,11 @@ process_args(int argc, char **argv)
 			do_prefetch = 0;
 			break;
 		case 't':
+			errno = 0;
 			report_interval = strtol(optarg, NULL, 0);
+			if (errno)
+				do_abort(
+		_("%s: invalid interval: %s\n"), optarg, strerror(errno));
 			break;
 		case 'e':
 			report_corrected = true;
@@ -397,8 +429,14 @@ process_args(int argc, char **argv)
 		usage();
 
 	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
-	if (p)
+	if (p) {
+		errno = 0;
 		fail_after_phase = (int)strtol(p, NULL, 0);
+		if (errno)
+			do_abort(
+		_("%s: invalid phase in XFS_REPAIR_FAIL_AFTER_PHASE: %s\n"),
+				p, strerror(errno));
+	}
 }
 
 void __attribute__((noreturn))
-- 
2.42.0

