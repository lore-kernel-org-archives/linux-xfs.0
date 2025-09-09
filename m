Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F552BB17
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431493; cv=none; b=n9vygNxCCkgNLH1i1dxDGr96KUGWgdSwlDWQHx9GhDNsNLn7htA8/4IZLoZw+sBiuOed34Nhovkzm3mp7T6v1/RuAHsSdDsRQJK7Kw+EdnYRmM795iXrjH/EcXy6uecrczjcTknUHAEhhvYKsE3Uy6ee9WrKCtOBc7fp1jQ/Wd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431493; c=relaxed/simple;
	bh=z+tyXqRc3qX4wqplgzQnqDbFqxJloPMK3+hI46X8YgM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kSMpbkbhDVsis2PfEvQq5szfTjE8X+rcq+L3DGvTDWXNpqnFaoTKQov3XqAmdwHn+O+7Vj89bUd9s2lIC6/oVjVtplXB+5vwpgCBu6pQq7aKB1V087yBihniFAuiuW1nZa4mzJkr0VlndF7c1UIj06F1KXYSAOT272mIw21q5m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZjQxVgit; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZjQxVgit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svATf4jV9PaaZloPDRsoRh+GR/XlAbjioABy+qAlzGc=;
	b=ZjQxVgitmCtimHhJmBJcLrGhGJwssDcZhRHlGHnPJMujI/IRAhP1VbamWZLs36PByTjHnk
	u1N/xfie+1S2jtPpvtW6rHhFkHTUS6taFr1mLSq8oF3F03Wajh0szPGmtbTTKA67qCkcAT
	doy08xjLQQo8FeWdmRc2j7QjG9Cqw1s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-xZrGWUZDPCakm7b2phD9pw-1; Tue, 09 Sep 2025 11:24:49 -0400
X-MC-Unique: xZrGWUZDPCakm7b2phD9pw-1
X-Mimecast-MFC-AGG-ID: xZrGWUZDPCakm7b2phD9pw_1757431488
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45decfa5b26so6085615e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431488; x=1758036288;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=svATf4jV9PaaZloPDRsoRh+GR/XlAbjioABy+qAlzGc=;
        b=Sg4zjA/9KdwobZnmIyy4ylodicvjxqHwLoKk8sSXATyLOHQTfFP/DjJi43ujcFK+F4
         hpx0gJAGZz5+R377TedNels+CmSRHyW+d9hQlNeJIw9/OnuYG77D1ys0kyjdkTvN3HG1
         X/hVPASqtQxGReBuM4fSCPr2ZyZIA+ZBo92R8enqasDKWMHCnlfDFQcdfuE4h9bae9qU
         UbbuQBNcDmZp2LOH0Suex+VtNe4K0XK2q9tcQQLbZpNMo39hTQKT5rBIB6jrsiRqZkUr
         BkAK93W1lKztS+OMRjHGIqrYt6Xc2+gvURwLaX3VC/pfUGcAziXsbq9u10/NPonPH0bA
         Qd6A==
X-Forwarded-Encrypted: i=1; AJvYcCXuI6B4YlTpHdSsKsW1nBj+nx5qu2P6f/XeaqMdZySb8Ff8QU9oozRPsEPERs5ZcSoY7UXRc8hsRsA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMTrNCFZJjv8dVh9xAVeRWKveEk6jofS2giRDzvKHwi9JJGNe8
	LKN+JvKAMQEil1WtqlwKwiMiljsOOvtQxKhRlaHKGVHGXkN3nPOJPr9A3wRDPddnIE364PXvHk4
	GDtA5fHWBJNv6outcSL0CZ19sYwz5eJnpMDEahd5tujvSTRWKBq/6CL6SbS4h
X-Gm-Gg: ASbGnctilj7GKTQKhF2QH3HH16N/Co4wXpMdil4lNEW3tpXblScx9FUIxoKSDofKrI7
	Fokf+mbRzYOXamqRbi4Ma2D2v0r4wSpXLIGKTfJ+chqcPONIVU8/3EoNAaWRcUGA6ZCX5CzyhB2
	+yTy6XDRNBQVcOjLjg0mOqFsm4j38i7Oh5aHG4vLi73035ITAf7KadwrLtpRRdj/liUPU0oPPi9
	KipEoNz74WbWrSXeq0LbpgUUaBUFkqj0ZO74vSrOHE+RAmjKG4qdb5aCMeULnbumQlF9pxokzB7
	dusC6uMEKpo/xqpbxsKfRsi62pt3RNySFADX+9g=
X-Received: by 2002:a05:600c:4711:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45dddecd454mr99452915e9.21.1757431487603;
        Tue, 09 Sep 2025 08:24:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvf6FWC/ciiTn+/Mgina5JZXqPtWrvEBZEV9wK96oJZ5HTW8jnE2JD2EpF5Zh+/kwyDtOPCw==
X-Received: by 2002:a05:600c:4711:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45dddecd454mr99452565e9.21.1757431487139;
        Tue, 09 Sep 2025 08:24:47 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df17d9774sm11432015e9.9.2025.09.09.08.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:24:46 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 09 Sep 2025 17:24:39 +0200
Subject: [PATCH v3 v3 4/4] xfs_db: use file_setattr to copy attributes on
 special files with rdump
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-xattrat-syscall-v3-4-4407a714817e@kernel.org>
References: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
In-Reply-To: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1588; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=z+tyXqRc3qX4wqplgzQnqDbFqxJloPMK3+hI46X8YgM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg647VJeFfRS5PNbm+txYXFHulYL9+/rS26boicl8
 yNTWfUrU1BHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiWwSZGSYWi17/eyGpMrW
 1kPhywLCDlXWsKg3iU+0O8tzeWqcW38uw09GoSpeHZegCFvB6I7ADSsnzBIUXDeFpUr8hHn2Zz6
 hJfwAlglCEQ==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

rdump just skipped file attributes on special files as copying wasn't
possible. Let's use new file_getattr/file_setattr syscalls to copy
attributes even for special files.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/rdump.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/db/rdump.c b/db/rdump.c
index 9ff833553ccb..82520e37d713 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -17,6 +17,7 @@
 #include "field.h"
 #include "inode.h"
 #include "listxattr.h"
+#include "libfrog/file_attr.h"
 #include <sys/xattr.h>
 #include <linux/xattr.h>
 
@@ -152,6 +153,12 @@ rdump_fileattrs_path(
 	const struct destdir	*destdir,
 	const struct pathbuf	*pbuf)
 {
+	struct file_attr	fa = {
+		.fa_extsize	= ip->i_extsize,
+		.fa_projid	= ip->i_projid,
+		.fa_cowextsize	= ip->i_cowextsize,
+		.fa_xflags	= xfs_ip2xflags(ip),
+	};
 	int			ret;
 
 	ret = fchmodat(destdir->fd, pbuf->path, VFS_I(ip)->i_mode & ~S_IFMT,
@@ -181,7 +188,18 @@ rdump_fileattrs_path(
 			return 1;
 	}
 
-	/* Cannot copy fsxattrs until setfsxattrat gets merged */
+	ret = xfrog_file_setattr(destdir->fd, pbuf->path, NULL, &fa,
+			AT_SYMLINK_NOFOLLOW);
+	if (ret) {
+		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
+			lost_mask |= LOST_FSXATTR;
+		else
+			dbprintf(_("%s%s%s: xfrog_file_setattr %s\n"),
+					destdir->path, destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
 
 	return 0;
 }

-- 
2.50.1

