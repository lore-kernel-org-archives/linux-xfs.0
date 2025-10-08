Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9D825FA2D
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 12:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927473; cv=none; b=YHQGFtJxgrqXF/AFdyCj5XeeRhPbggXtcI95z3uyKXLAUvQzbJFAPHgONt9M3rxzCjCoqcqO7DLFPcipO7C/AcQCH8eIAb1Ua9JQl2JtGhmXoM72JTl2ZOZ6P6yvU+kP4TrrLvQuy/lLPGI4axH3B5Ha0W385ybrTpioebDAE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927473; c=relaxed/simple;
	bh=0FQzczq+XvPIcLSgmN3fW8/Mf+a99S5LM/p3VLvLUUI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S4xjhpz+gZjRypmZD9v/IZoZKCWXcuPBx16ijOCBWcTdkoKA/hUauBMbAulfr+CmGZz/03Og8GVvjWCB6KW6dDXZarDIhkIgH45yi56KDT5iz74JyjK1fBUGNPyN5ckPTLM3nnzSsB/N7wxEXUKN3CqWxbHzLVT+oOeapDoRrvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpTP8yIZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpTP8yIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759927470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTuvQMGGyHVj/GABY47oNzO2RJy8snMcE51C98ebSFA=;
	b=HpTP8yIZWcjqQI2KKV95aoP7teZ7uYi+Mt6IH60k5JUUgbvukdGgCs1Of8hCI8mGKNnvwe
	Kqizn8GI32rrXT1MgAtI2peVvbniX46PHCrLk9ctyVTObEu+gwplUnz9kgjihEeic1+6jC
	BBDzMGJMPzQK1vnGZF/X+8O5eGCGyUI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-uub5SHPcMQKPOmZ7sNmpvw-1; Wed, 08 Oct 2025 08:44:28 -0400
X-MC-Unique: uub5SHPcMQKPOmZ7sNmpvw-1
X-Mimecast-MFC-AGG-ID: uub5SHPcMQKPOmZ7sNmpvw_1759927467
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso39265705e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Oct 2025 05:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759927467; x=1760532267;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTuvQMGGyHVj/GABY47oNzO2RJy8snMcE51C98ebSFA=;
        b=uL4mwNFNkcejKccy92ZMSER6hSXGYuqgGE6ZlUe7OdTDh6h95jay1vtjuWpo+n6ErE
         4BOknHdfKy3s12E4GbDEG3z21eX1sj1y9PPZ2FKfXG4eXmMKbB2aq7aalM5YukateIBz
         C4NOwRXygkGJb4gXMQZEx1IT/cqHxLKR1XnS77bC9VoGWnN8298/USlJ90dBZabzKk+3
         orTVEGvQbNI/e0oa0x4xcPQhwvPAPKKAvP33qSmh7RYNOIiJeWyK3eQIyJPlnRQpffKu
         hT9Zcbot81FotK0wrVssJjlaTbME0jYcJejuDDFCMCkN+9Khbm6HILiPo/zroVVnq7ud
         nyFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN/5EgiM7H8aQeP87cstQytullv+3SxN87OjiAF+tGsLSuqMw82p8E4eQjRB6x4RELgPUITsDcw6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJFzlmnGEBFqoef+B8iZlFcYFWHYywj2b2DGmgCLpXUxRF+ZmW
	sObDINw21YhYKDKvuqowsNU7Nj7TVDzAopE6OzHsEss5A/yMtjCet2GgoFg7V0IPGypu5ml5eGg
	YwxPGtNtB4F6JnTB7EoLFNWejTf9W0jjWdGauA9KqoKItMpTRCC9xio07jFIs
X-Gm-Gg: ASbGncvmXhDOI89KJTusoAy+5NahtF6IBAAo+DS2wT2M17GXvO8s7h/kkBVhH4wPHXx
	omsCacT+Mpjo+4UJ4ZHquKdrMYCQzusklXfO6eJD/nHkeiWfaYtovGB/rBe918Lkj+eZjARza1n
	EpjcaQVptb2Mb4CojOJVmbAhmOq+gX2eK/3yCYQJ87zwsuEll1X4OvTTykW78IJcLvNm0kDJMAF
	ECZKYDvT0C6cCyYFQAJg3dFxw6r1y3xCgIhUiUr8+Jf5rLBz420f/bWsIw5zOrfP6n9BoCYf4mh
	ldeTh2qEZSEGAwxM0EbGVhHZzHTvnJHrhdB0jz56lTG7jHz4dr6JKQE44lNfEw9mo9Sc9bF2
X-Received: by 2002:a05:600c:4753:b0:46e:1d8d:cfb6 with SMTP id 5b1f17b1804b1-46fa9af0621mr20360735e9.19.1759927467230;
        Wed, 08 Oct 2025 05:44:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUOOWjGZbNdj8gMQY80gtaJEpiEmEfUTkvwjILGRLj8xEez7HmT/bGwpHIikuJuXE2VGR3WQ==
X-Received: by 2002:a05:600c:4753:b0:46e:1d8d:cfb6 with SMTP id 5b1f17b1804b1-46fa9af0621mr20360455e9.19.1759927466628;
        Wed, 08 Oct 2025 05:44:26 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3d438fsm13918765e9.2.2025.10.08.05.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:44:23 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 08 Oct 2025 14:44:18 +0200
Subject: [PATCH 2/2] fs: return EOPNOTSUPP from file_setattr/file_getattr
 syscalls
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251008-eopnosupp-fix-v1-2-5990de009c9f@kernel.org>
References: <20251008-eopnosupp-fix-v1-0-5990de009c9f@kernel.org>
In-Reply-To: <20251008-eopnosupp-fix-v1-0-5990de009c9f@kernel.org>
To: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jiri Slaby <jirislaby@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1018; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=0FQzczq+XvPIcLSgmN3fW8/Mf+a99S5LM/p3VLvLUUI=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMp7FLGXrP8A6vbUxj0FJYk7QpN39id7xEkWd89QkI
 zpFkg//d+woZWEQ42KQFVNkWSetNTWpSCr/iEGNPMwcViaQIQxcnAIwkdJChv81zi23ZYUvSooz
 rV8jnbo2JlSBw+6ARlfjho/CMi9lDOQZ/unft+y8uohbU15J7LPhvrUve3LPuzVyGeXnnAn6cq/
 9HjcAeUxC6A==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

These syscalls call to vfs_fileattr_get/set functions which return
ENOIOCTLCMD if filesystem doesn't support setting file attribute on an
inode. For syscalls EOPNOTSUPP would be more appropriate return error.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 460b2dd21a85..5e3e2aba97b5 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -416,6 +416,8 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	}
 
 	error = vfs_fileattr_get(filepath.dentry, &fa);
+	if (error == -ENOIOCTLCMD)
+		error = -EOPNOTSUPP;
 	if (error)
 		return error;
 
@@ -483,6 +485,8 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (!error) {
 		error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
 					 filepath.dentry, &fa);
+		if (error == -ENOIOCTLCMD)
+			error = -EOPNOTSUPP;
 		mnt_drop_write(filepath.mnt);
 	}
 

-- 
2.51.0

