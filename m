Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF9F1350F8
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875824; cv=none; b=fRvtwvp/LafRw9rVyE+J3t821I/F+2qt1YMmy5YTDf03B6W/u94pcNquu3PpuECmVFlfbWBH1cM5zF/n89pl0FDYupPTc51mMfTRfYSkITRRPVu7p6dhVBIAj/mHY6UNAjaTRINFFzkrro4QQ2VvZCghiECCR2DAW7MI2Zcidq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875824; c=relaxed/simple;
	bh=M58YW49eqB4hUf/akvPZwjxoJHQcW1zBANFCkx0Oyyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvztWg/Tvig+127Z4l1ti2cL043SRwzsh/SVNwxqLxiESLpV6H5m2qSczh/XucQ5Uh7IddVHJPmeYcRZ4fhLLXjPSBGnSqwwBKUF6g+3S+D7RDf84be3XMyBslMKoFMGR/KiPlvsSEWHoleQ4n3stdzeonFLsscUpAiKqkGYXSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rwz4P+w5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rwz4P+w5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dpVpkDusONxbkM2QhNnBSL8Tf6PN4P83p60GT/ae07w=;
	b=Rwz4P+w5Od74lVIblNqcFwkzKGpDqNexaqyOrqtkiW69zYsYNz2ElkHRVbg7Sy2A5t11El
	EXcc0xj9Xd+13qK8yUAMrX9vg/2g3Mi5HH3Uf3LEjlSKt8iHcM9VZpUdoMLmnHvSMqDw51
	Cluv7/v+JHaT5FHMmJANRJ2zoY2QK6Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-K8zfnhAUOf-pc96-0N45dA-1; Tue, 23 Apr 2024 08:37:00 -0400
X-MC-Unique: K8zfnhAUOf-pc96-0N45dA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-56e678f6d81so6404062a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 05:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713875819; x=1714480619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpVpkDusONxbkM2QhNnBSL8Tf6PN4P83p60GT/ae07w=;
        b=Vj+PnTdK+oTrO6Lru+zXxEjxKFAPAKlJTPnkkQ+SYrMlknTxEOkwZ1NmM7/1UwwrEn
         spBz1+Wtd4lBhcnwb/LFO3A8YQuOn3cECuY8oF2zZrvXYi0uGo0UpJsqKcmJOjHQWlwu
         NYsJKAAA0qIrZMRWLmUjXgbqqfaTbDdAWwDvJpFqFlAC4oP4xrnl+ARJaBsQyWoBuArU
         gEeHYiCj4JWxzcC/aCUbDthA9zuLO91ezyDPLstXLH2ci0dKv2lOS0IqpNAU7Le2Eut3
         ss42M7IWLl1+RvDb0XNP+lwJXSiQZx2NIjEugEu/jrQfFv0ozycUNx9K13Db6lYBjLNz
         8EEw==
X-Forwarded-Encrypted: i=1; AJvYcCXXHEpW86gWbd2yB/esZUwAOuno1SretDwZCZtP8SNrOIri45nx3iteZ8DjKyrGXFzhUBZqakl9mvJIB1tG/05cIBYgTgSQsSii
X-Gm-Message-State: AOJu0Yzn5PzZDOMIw1pLj8Juhsi2gefQ/X0ANAZd4iVe/eiDsZXL7IEk
	joeKgdNdczkWqIB8R/b+yO40OzRjhcRn1EH3CC2SsvmiDPY08nk+A3Ldh4QV5jbdbGc1iK8QJV5
	X2hnTda2cj2kRVWzcyjpFDAvxve9RDlFZGHxGFRjeaNCLi6IM2z3QsShk
X-Received: by 2002:a50:9e8d:0:b0:572:1c21:1937 with SMTP id a13-20020a509e8d000000b005721c211937mr2662199edf.11.1713875819351;
        Tue, 23 Apr 2024 05:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/7MkF0SXqSifaAQkbxR8qkm5vtYzqqmVZCAwNi7LzWk1grJKM6pe0lEfswJ5jejvGOiVUeg==
X-Received: by 2002:a50:9e8d:0:b0:572:1c21:1937 with SMTP id a13-20020a509e8d000000b005721c211937mr2662168edf.11.1713875818823;
        Tue, 23 Apr 2024 05:36:58 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id et3-20020a056402378300b00571d8da8d09sm4783170edb.68.2024.04.23.05.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:36:58 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 4/4] xfs_fsr: convert fsrallfs to use time_t instead of int
Date: Tue, 23 Apr 2024 14:36:17 +0200
Message-ID: <20240423123616.2629570-6-aalbersh@redhat.com>
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

Convert howlong argument to a time_t as it's truncated to int, but in
practice this is not an issue as duration will never be this big.

Add check for howlong to fit into int (printf can use int format
specifier). Even longer interval doesn't make much sense.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fsr/xfs_fsr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3077d8f4ef46..02d61ef9399a 100644
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
@@ -165,6 +165,12 @@ main(int argc, char **argv)
 			break;
 		case 't':
 			howlong = atoi(optarg);
+			if (howlong > INT_MAX) {
+				fprintf(stderr,
+				_("%s: the maximum runtime is %d seconds.\n"),
+					optarg, INT_MAX);
+				exit(1);
+			}
 			break;
 		case 'f':
 			leftofffile = optarg;
@@ -387,7 +393,7 @@ initallfs(char *mtab)
 }
 
 static void
-fsrallfs(char *mtab, int howlong, char *leftofffile)
+fsrallfs(char *mtab, time_t howlong, char *leftofffile)
 {
 	int fd;
 	int error;
-- 
2.42.0

