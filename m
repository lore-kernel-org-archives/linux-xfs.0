Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E31315B108
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267723; cv=none; b=dc+VhplYa+0zGL/yX1enKoqov3SVlB14VDVqOo2uFBW6oLogeXMsiOmhzpGUzRRcsX/g9qieW6KuKn/Ntjj1lUxIFlLzEL/xML6qWukODCk+K1anV3XoaxNDtqgGBnBqJlSbMIeJdiP+NMUlaN08YjwV23kRUACVK3SOe3txYNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267723; c=relaxed/simple;
	bh=1NL1/dDvDNU2Zbas8ECSCxdIjF5qA2fFI3IHXBmleAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CklsuFxw4V2ni2TxbQQ8kHAISWDQ9X2AqSLRKDCZMT4kUeFAEC/hAG+BvpkWAD6uUN2F1qXdKLHeLUNtb0LYNvtE0zeJKQwkupMvwexGkzlbsjzrjFd5xX2uLSCOT/MWmVg1ZqM95Pf8FqL0JTM9YhlUg3zNsniNUOAyYK6w+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cyN4vKgN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyN4vKgN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fnY+juoMhGcmaJz2MhrrIFayrEdo/RaxaccJjWuLCA=;
	b=cyN4vKgNFrm+jTF7WrMmsiEy5iMwkewAbYhwmbP8rNwFX9qZK19yMKMsFJJzZABE61fJGm
	7tdcJYuRsIqAudIHbXo4LEj2kLgbiSpGO6vcViO5yCc5EkZNrQ0HduMDCJGHY49A595RBJ
	ATGBSfrVn5kUTSRNW4gjVgRvpd12tYE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-itEBC8woOgOMNtxvtRIVLg-1; Thu, 09 May 2024 11:15:16 -0400
X-MC-Unique: itEBC8woOgOMNtxvtRIVLg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59c0ecd59cso74685266b.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267715; x=1715872515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fnY+juoMhGcmaJz2MhrrIFayrEdo/RaxaccJjWuLCA=;
        b=Pc2l5yZ7Q2trUNxyvZMPmV+cwwRnewyAZKzqzQS5aPSS0HVng2DgTtEzQZRfjua4DS
         6S0A+/LHDv3mMbYWtRU1k4mSJIvdeGoByI0ysfDi3JYlhJnQt8RNt1pfPnegw9PQ6GMx
         KFk3zMdk4RbwxkgeCIZuH07LddyUTwRyCQ7RkypVwOuK0ngqsmfAUONRww9D6pDNuVHe
         3c2UA6jXygGueOIAe7kQ9ZzXhUtLnbY/vHtXGZhYqniMgWGRSx6oi1RXwLuQoxST8Usu
         FFl67O9wuOFe+P1T7oSbVmG6cwjsG+7GuXPR6Vt/d9/j2b1985s+/Cyphl8S1AGVDaPd
         laWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKvll7rEr8k2bLmBO+qEjJjUpzx45YYao5gY9u08nte5vjt+WP3cN45TPMGbDZG7UfPW0zrLkRbpNV1hcqEaggC1riiu0gD8NM
X-Gm-Message-State: AOJu0YzKzwS83L01/gUym5Yw4ORDZ+5tGrPyr5GVkucfLjplu94oR8kM
	SZU1X4Z/Dlm7NAniyLeftwYX9jKalnEp6nxgaJ2Xy/yGQpEghoT1sPdjMObnfXHiOjBLssiRewM
	KQcZd1xKqhIq7u56h0fqZKo+sHaMAutWBEpyP9gMynz6xTInIpE0869iVs5o4p9HB
X-Received: by 2002:a17:906:ef08:b0:a59:afdd:590a with SMTP id a640c23a62f3a-a59fb9c6b4emr654984466b.56.1715267714911;
        Thu, 09 May 2024 08:15:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFmt7o0/NdAkyXCCoTiql70At8Tw5rG4AotCEnIbBl27agWLZSfEbyq0lrwzJ0gzNYP9udWQ==
X-Received: by 2002:a17:906:ef08:b0:a59:afdd:590a with SMTP id a640c23a62f3a-a59fb9c6b4emr654979766b.56.1715267714233;
        Thu, 09 May 2024 08:15:14 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01785sm82035866b.164.2024.05.09.08.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:15:13 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/4] fs: export copy_fsxattr_from_user()
Date: Thu,  9 May 2024 17:14:57 +0200
Message-ID: <20240509151459.3622910-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240509151459.3622910-2-aalbersh@redhat.com>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Export copy_fsxattr_from_user(). This function will be used in
further patch by XFS in XFS_IOC_SETFSXATTRAT ioctl.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/ioctl.c               | 11 +++++++++--
 include/linux/fileattr.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1d5abfdf0f22..2017c928194e 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -559,8 +559,14 @@ int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa)
 }
 EXPORT_SYMBOL(copy_fsxattr_to_user);
 
-static int copy_fsxattr_from_user(struct fileattr *fa,
-				  struct fsxattr __user *ufa)
+/**
+ * copy_fsxattr_from_user - copy fsxattr from userspace.
+ * @fa:		fileattr pointer
+ * @ufa:	fsxattr user pointer
+ *
+ * Return: 0 on success, or -EFAULT on failure.
+ */
+int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa)
 {
 	struct fsxattr xfa;
 
@@ -575,6 +581,7 @@ static int copy_fsxattr_from_user(struct fileattr *fa,
 
 	return 0;
 }
+EXPORT_SYMBOL(copy_fsxattr_from_user);
 
 /*
  * Generic function to check FS_IOC_FSSETXATTR/FS_IOC_SETFLAGS values and reject
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 47c05a9851d0..3c4f8c75abc0 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -34,6 +34,7 @@ struct fileattr {
 };
 
 int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa);
+int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa)
 
 void fileattr_fill_xflags(struct fileattr *fa, u32 xflags);
 void fileattr_fill_flags(struct fileattr *fa, u32 flags);
-- 
2.42.0

