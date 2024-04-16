Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7860F13A87C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713299062; cv=none; b=GSSZX45qt4X+HmN/DtQqzB+xgGzi+zVb4/ijq9fL3JYWApwspy+qajaJPMZKQHYNycf909xF/564CfXvYR4ahcJEg6XGjnhJEa3h2b48DzdjTowznJtd0lrSbvOOdGaMGUC844bygYfMOElGF9Di+j99tUwBc5fCE8eernQLkzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713299062; c=relaxed/simple;
	bh=gle7VWmBPznO5lZOFMUP9sBY5Upvq3wZtt2Re6qobO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmBvj8JZUcIfQ8y7cTxz5bxMEKMcUkvJ8/Vi4PXjrHXE8HwuRljAtlB6ri4xmJrLOCapKxtyTth6OpVzZF3fTEoc+mv0zbWnm8jyIlSDYXXehL0cBTz/H4kN8ct5/QMP48Eve7F7NC8FRL7RHgFAgEiSbCLrzuREVS6HSGu01lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcZC3Hi0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcZC3Hi0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713299060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1nUsgIEwvUZY/Y7sKjmmu2jqnXOcwZbDo8j/OXZNko=;
	b=RcZC3Hi0pB/Zq5gVa1n5N9L0LlPc1cEbv1hw6c64lzWgV5Hd+/c9SddB4zCGhnwArdALhj
	9ABdfTy3WJDTYQhc86WdHCFDvCbVIeOnbk0+HEfZbxmYcvtxb0ox8NQywExap7qeFxlwhT
	CTLdtD+jA7+74RMyX5xRPifATEDB7zM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-GtaLcJtCMFiEgPw6Qe_o7A-1; Tue, 16 Apr 2024 16:24:19 -0400
X-MC-Unique: GtaLcJtCMFiEgPw6Qe_o7A-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56e573582b9so1597298a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 13:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713299058; x=1713903858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1nUsgIEwvUZY/Y7sKjmmu2jqnXOcwZbDo8j/OXZNko=;
        b=sRd3Ld0ipwpu05DmHxqCLs6PLpybQNjD2lqhUb7Oj9/8DlcN+o3YUXICO7EBEeN93k
         K4v4h2MFZbCbnaKMhpVKzimbIXI5pWshZWH9hTisKHXp3+kCofWGcOl+O7YZ2H2tN8rb
         OVTLX6oF6yvT77Ko4Mr3u5AstBm0ApbhHnK5te91wA9VP5tYFJj/xRzoTn8J9OLfb7wv
         gKE3x5hqj9Qdvaw6QYuSVK1VXvPYQOG782den/m7b8oN9KpALPqG9c2Gcl/mV9aoK6im
         wAy/gvu2JOUt3PQJaorfEo120d1oc27ADwzZgEMwHAnjgShFy8p1Hn3wGuN+kCQ+5s1t
         7G+g==
X-Forwarded-Encrypted: i=1; AJvYcCXUIm8N3r5vLikhhC/PzUoWarnPQrzokXYIgK0+11eVBeqQFjPkjR/fM3mbfvh5+bXsXAMw7h/DF+zSUpL4O0awrIsJHW/6j6Pg
X-Gm-Message-State: AOJu0YwNoRzEsWFKTMgLlOodgK3xpljECoHDrMu7XtB4n2ZY2LSqu4g7
	GZt7LLvhv/KChxEAymgZqSbnL6NtM3788ANkM6xCuWmFiaMgIS9SgwcG5ya1bMpnif9hV5qDYfT
	Trx66LtItiDrCLgGutkWFfUC21/b3ZAdABs3I71BhiWf+NCVGKFWx/ZVrBLIfN2QX
X-Received: by 2002:a50:8e19:0:b0:56e:2b0b:58 with SMTP id 25-20020a508e19000000b0056e2b0b0058mr9431598edw.10.1713299057799;
        Tue, 16 Apr 2024 13:24:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVMbsxmgbfwPflTCr2me7yhQYX1cvv4Zs5Xqd8KJowgpYMfcShyGnZm7swpMdtnq/oet4cZg==
X-Received: by 2002:a50:8e19:0:b0:56e:2b0b:58 with SMTP id 25-20020a508e19000000b0056e2b0b0058mr9431587edw.10.1713299057408;
        Tue, 16 Apr 2024 13:24:17 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b005701df2ea98sm3655687edb.32.2024.04.16.13.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 13:24:17 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 4/4] xfs_fsr: convert fsrallfs to use time_t instead of int
Date: Tue, 16 Apr 2024 22:24:02 +0200
Message-ID: <20240416202402.724492-5-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240416202402.724492-1-aalbersh@redhat.com>
References: <20240416202402.724492-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert howlong argument to a time_t as it's truncated to int, but in
practice this is not an issue as duration will never be this big.

Add check for howlong to fit into int (printf can use int format
specifier). Even longer interval doesn't make much sense.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fsr/xfs_fsr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3077d8f4ef46..4e29a8a2c548 100644
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
@@ -165,6 +165,10 @@ main(int argc, char **argv)
 			break;
 		case 't':
 			howlong = atoi(optarg);
+			if (howlong > INT_MAX) {
+				fprintf(stderr, _("%s: too long\n"), progname);
+				exit(1);
+			}
 			break;
 		case 'f':
 			leftofffile = optarg;
@@ -387,7 +391,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(char *mtab, int howlong, char *leftofffile)
+fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 {
 	int fd;
 	int error;
-- 
2.42.0

