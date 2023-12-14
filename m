Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYAoeY4/"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228D125
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 04:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702556240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o53sFaU+W8MO5j3FAVWZbzIH4BHwmrc/QJDioeffIHc=;
	b=QYAoeY4/kWr8StLqZJQzBkALHaRAodz2zainsOR0NrD6PBZHK3pUs3BduX6tbC6fX1BaX8
	YStH8aRezTuTCxJPrB/fSFdtXn/uSxefRAcQ4OsGG4GTMTxjgFuqpF2Y45NKjkY+7wzbzh
	StJ1gmB/CI5eVHccMcDIeuVSYhvWW+8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-fc9KL78AOlOQqBpeB5ssyA-1; Thu, 14 Dec 2023 07:17:19 -0500
X-MC-Unique: fc9KL78AOlOQqBpeB5ssyA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a1fa0ed2058so271450066b.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 04:17:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702556237; x=1703161037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o53sFaU+W8MO5j3FAVWZbzIH4BHwmrc/QJDioeffIHc=;
        b=mDKcJIPuyqM3vyyyrCGepZk81/ToT9uuHPDbiZ820LcqzlxIL44wq22SOFvYn+1nf0
         wJn0GPt2sxjlWlXIHYOBYFhYCI4E2/p4kIA85F1GdLgO/ByjDdirQ/wJ9cEgX3uGQWEF
         +dpJHOBcs9h/sfnrVtmCvhDjGgbeWSzOkcPRYlWRlF9qP760g/8/dyPLBQf2936K3Fa+
         o0RuKvomHJgxjzZo+PKpb7sMicHjqPoDBMSmblAfJrcjNhbfUqUUx+eYlbN2+QRfFy70
         /+T2w2Lm148g6ZpRPbXPCNb6k+Ucy4QRN1kAPO+oFzdwZDuY72YuUgllRVXrAgjZ5QWM
         6h3Q==
X-Gm-Message-State: AOJu0YwQMr7ZrH8LcyhjXMJzjZU+o3viLuLMti62oAzvjR7xXWcvmpDx
	vTe7GxBwEzrnz76KWtiIShScCfouxeOaaUWsPaRgqvHa4RyemNsmsUC8dxKsDumbK9yAPFq4Rcn
	M55jttDX9xl9uUdbyqPXPs3KVOA2L3ScKTNzBD7LRC5LqBLvFoLK4ZCNrSeD9bscb4xMHwSjOQ2
	qKItc=
X-Received: by 2002:a17:906:5349:b0:a23:f82:985f with SMTP id j9-20020a170906534900b00a230f82985fmr276455ejo.142.1702556237350;
        Thu, 14 Dec 2023 04:17:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxO6LE6nnI4EkOmY5fEpQK3XVxlx05SZlGx5DOnmIP6uhaGucOJq3wPt6sU4mHQz773tkK5A==
X-Received: by 2002:a17:906:5349:b0:a23:f82:985f with SMTP id j9-20020a170906534900b00a230f82985fmr276449ejo.142.1702556237056;
        Thu, 14 Dec 2023 04:17:17 -0800 (PST)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id ts7-20020a170907c5c700b00a1dd58874b8sm9291282ejc.119.2023.12.14.04.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 04:17:16 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH] xfsdump: Fix memory leak
Date: Thu, 14 Dec 2023 13:17:15 +0100
Message-ID: <20231214121715.562273-1-preichl@redhat.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix memory leak found by coverity.

>>>     CID 1554295:  Resource leaks  (RESOURCE_LEAK)
>>>     Failing to save or free storage allocated by strdup(path) leaks it.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 restore/tree.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/restore/tree.c b/restore/tree.c
index 6f3180f..66dd9df 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -4977,9 +4977,22 @@ static int
 mkdir_r(char *path)
 {
 	struct stat sbuf;
+	char *path_copy;
+	int ret;
 
 	if (stat(path, &sbuf) < 0) {
-		if (mkdir_r(dirname(strdup(path))) < 0)
+		path_copy = strdup(path);
+		if (!path_copy) {
+			mlog(MLOG_TRACE | MLOG_ERROR | MLOG_TREE, _(
+				"unable to allocate memory for a path\n"));
+			mlog_exit(EXIT_ERROR, RV_ERROR);
+			exit(1);
+		}
+
+		ret = mkdir_r(dirname(path_copy));
+		free(path_copy);
+
+		if (ret < 0)
 			return -1;
 		return mkdir(path, 0755);
 	}
-- 
2.43.0

