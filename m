Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8619158A23
	for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108718; cv=none; b=DA70gvdek58qlzfSE19QemFUATTD33er4arEm9b3P0FLm7ssaRh0rv+Yp4d/OSXDn+cP0IGVl/6vSFopBpJ4B2FJsD306mHZRCYmvTLHjC3VmbJXknEs8nHcv6P0lPsbuRzZQq65adbkahh/RGpxX1TAvWCzcTyxs5g46X3w5tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108718; c=relaxed/simple;
	bh=8uEL7LOaxBe2zYOC1ER9tCcB1uhzqh4OVfgLktiwhec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9kXm9uw9ZpVjTb2mrt1ObduPnZzxUePocwqsshA5APzYY8YW9EdqAS8MYs9QklHSU8S9bMUa8RzavUCR5uIPyiUHdScRkzQ3iivAmx67BBr6RXGSSJyjXWOM3sKlRz4quwITDOC0Zs5crMU+JNKpJgAt4u7WFW4zVl3jnkvIps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kl1g0qZ/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kl1g0qZ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717108715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V64FAc8udCCb/Com74YGnVDUWw9uEkCgUMKkardGstA=;
	b=Kl1g0qZ/il+82M77wDPWWO1eRA1dxHertkOO2BLxXO0FQJjHR5p0Zxr08G2Bku/kA7DBpX
	uqs8DzXCjM2Bsybx20IswpDlUk18gqiKzLNxss6nSWGlD8//QlVChxYo2WSzO2oMBboLt8
	IXdGwE61xYTJ7BXSvvoOFOK9RW9k818=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-REC8NWFoMBCp_W9CjxUpeA-1; Thu, 30 May 2024 18:38:33 -0400
X-MC-Unique: REC8NWFoMBCp_W9CjxUpeA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4212a4bb9d7so5878035e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 May 2024 15:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108708; x=1717713508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V64FAc8udCCb/Com74YGnVDUWw9uEkCgUMKkardGstA=;
        b=lkY3ZzUpIzo13Ie77AE2lAUrIMyFZy9nA8P21bo9MIf4b8QQIIuEMPUMTdiH5w0GRA
         NfG7/E8zxLW7Lj/a1OsyCwDVkIp/10Ba3eDgaTCnxQptGwq3Hs/kHbN1W1Hxp8Vo4mma
         4GY6B5OFGA23L70kq6TeNFt7SYTCdY2H8A0hIQZ1Mc0kSJKI9pnOqYVFmfhcefCRyxjG
         llyQEhCcOqEiCGvBoRO6ylU1ZxgZymM5Z/dRd1GKHiXJ/zbavAGbWPPdw5qIP3ks1NOv
         7d+DZZwXJj0jyVebxitRKvWvtlbRr3TKdXWjaUBIaVDchk8+R8fjHJMwgV6uMOWcx/mC
         X7vA==
X-Gm-Message-State: AOJu0YzBpzaNbV9dvqebxMIJzElc9yeWTCCmNV+zr+9tzOpGdEOp+/1V
	GJ/7KwxwGeFdCLrHbQ1nhgbruMCE4HI2cZAN1qxgHDA/JX36xU3kxEEr8WN85J6O0NdbYRbNZ3P
	v8jx7rLoUPA3A5XbfQeeulc/C6hPFkvYI+nDps94Rbq+kCjbknCRZt8rXdUSs8t4WQaBBNATk1k
	svEBP1ZtY/Bt1naPoZe9AjKIGXvKxY8xijg0M7cBQz
X-Received: by 2002:a05:600c:5117:b0:421:1fb1:fe00 with SMTP id 5b1f17b1804b1-4212e075248mr1621425e9.17.1717108708466;
        Thu, 30 May 2024 15:38:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESkVxJVLUFYCpqv2qCW9C/TXtafaBLHsfrPUBaTk0596saCC2wKDG6jqyNo0BwjoYnxXgA3Q==
X-Received: by 2002:a05:600c:5117:b0:421:1fb1:fe00 with SMTP id 5b1f17b1804b1-4212e075248mr1621275e9.17.1717108707772;
        Thu, 30 May 2024 15:38:27 -0700 (PDT)
Received: from fedora.redhat.com (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127062149sm36053675e9.14.2024.05.30.15.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 15:38:21 -0700 (PDT)
From: Pavel Reichl <preichl@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@redhat.com
Subject: [PATCH 2/2] xfs_io: Fix do not loop through uninitialized var
Date: Fri, 31 May 2024 00:38:19 +0200
Message-ID: <20240530223819.135697-3-preichl@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530223819.135697-1-preichl@redhat.com>
References: <20240530223819.135697-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Red Hat's covscan checker found the following issue:

xfsprogs-6.4.0/io/parent.c:115:2: var_decl: Declaring variable "count" without initializer.
xfsprogs-6.4.0/io/parent.c:134:2: uninit_use: Using uninitialized value "count".

Currently, jdm_parentpaths() returns EOPNOTSUPP and does not initialize
the count variable. The count variable is subsequently used in a for
loop, which leads to undefined behavior. Fix this by returning from the
check_parents() function immediately after checking the return value of
the jdm_parentpaths() function.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 io/parent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/parent.c b/io/parent.c
index 8f63607f..93f40997 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
 	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
 {
 	int error, i;
-	__u32 count;
+	__u32 count = 0;
 	parent_t *entryp;
 
 	do {
@@ -126,7 +126,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,
 			       (unsigned long long) statp->bs_ino,
 				strerror(errno));
 			err_status++;
-			break;
+			return;
 		}
 	} while (error == ERANGE);
 
-- 
2.45.1

