Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0CB208BD
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0x3P29d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702585554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1Q+Gblh5Z9QB0AwKQwxjCIDjhxJpch+W60X9OSu57RA=;
	b=d0x3P29d6+EDybNwbupcbvaTILrw4oHy7hzcBFomwXiLmcEI1mYVmZi5jLVU/KMB4HsqZC
	xjuIIYISkPOSVngpZl3zVspgBOzejSsXnpMun1teuXBSQmEKMsHd1GjYmfCgXylCKef/+N
	OHi1TXLhltQnUB9WbsAF22iqlsmjM30=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-QNki4ViDO0uyUvx1X280YA-1; Thu, 14 Dec 2023 15:25:52 -0500
X-MC-Unique: QNki4ViDO0uyUvx1X280YA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a00dd93a5f9so509458266b.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 12:25:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702585551; x=1703190351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Q+Gblh5Z9QB0AwKQwxjCIDjhxJpch+W60X9OSu57RA=;
        b=I3Lg3pKXM8R/iMKbxWTxU072WZlFQtuchOkCAT9ytZ0XCSua0tVJAdOtgd9AzR65uO
         FdWGoBL1FmzFTSXGs68QfFrYJXfvmbTYsHsgK/bpg2kl6hujPhSKb7P3Op2SJPeCFZ1e
         GXD4sB6G3pV3mRGZUGSb2MLp1JwvhRmA9dLx1m//Ru6dacHnE6CUbUlJUWYAF6C62kYl
         iFL27jWraoSte7VWPXxoVpgLDVkCtBck0h0ibKNDEsXNOquEk1l0fmLrj3tLtD3QTsmT
         deNGaZy3ZgHAx37uYw5J5di8+6lrdtn0kvkaf9C0g7J0MFcMT1z7RkoCbBHQxL6eFMlI
         DOnQ==
X-Gm-Message-State: AOJu0YxZUeX29M3QwEZEBzNGXHpplNaAAPTvKmhVUS74oCIkOps1BL7F
	JzvlLrVvqouitjhJII5ThDAe3JHYL8+o6Zz8MPp11D++ClOv3OCtUW3jYxFzKOJm2geUBU1Mw9Z
	IiptshQ70N2VYvuScFIpVDDGoaSRO1k2l6U8d9fhA/tUj4970J0qDROFVWTZcfqKS0v5O7mcduw
	v+0kk=
X-Received: by 2002:a17:906:dfe2:b0:a1d:8f9:8eac with SMTP id lc2-20020a170906dfe200b00a1d08f98eacmr2930802ejc.249.1702585550919;
        Thu, 14 Dec 2023 12:25:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7d0+LpFsD4BcnELLbpp/fToHAkqMHINrZ3CizpHf1yQT+qCfsB+o/7XIipXh11BZoeXmcoA==
X-Received: by 2002:a17:906:dfe2:b0:a1d:8f9:8eac with SMTP id lc2-20020a170906dfe200b00a1d08f98eacmr2930798ejc.249.1702585550614;
        Thu, 14 Dec 2023 12:25:50 -0800 (PST)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id tq24-20020a170907c51800b00a1f9543a540sm7177131ejc.160.2023.12.14.12.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 12:25:50 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH v2] xfsdump: Fix memory leak
Date: Thu, 14 Dec 2023 21:25:49 +0100
Message-ID: <20231214202549.580231-1-preichl@redhat.com>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 restore/tree.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/restore/tree.c b/restore/tree.c
index 6f3180f..4707fdc 100644
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
+			mlog(MLOG_TRACE | MLOG_ERROR | MLOG_TREE,
+				_("unable to allocate memory for a path\n"));
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

