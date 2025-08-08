Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E76C2882A5
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681429; cv=none; b=lVRw5g/mrfyEkUlw5UWvOACFAwmTblwtgtDjlIzangLgkugziBiqHqskhLQzXMK2nzduwrTCjoVyBsaYKsSyHFSIGrHMAgHSizIhZsp6b8SHHtMpDJk62rA9PVeaFCgjIy1tgcvoKH2Cxbddng2psmxtzi/IOJl/Ke6sI+oamfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681429; c=relaxed/simple;
	bh=rkmNz1sSnysOaIdcGInEjZTg0J3rQpVEu6HfuiKCXOg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=CVgoiiBIYASP2G91erDP7nGLZUCqA9nO/sHNIRIIqBSP98Z4eqMCM6up24P5qzRFDIbW27i88ohuKbIE+QoB/FlwPyj0SsEwJ6XSRPdlRM+l8mPobqsBP7Mm/l54QVMQbY9UxPqkBLT29MgY3oKH4mCLT85Z0vXuXPQ1aRUeVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I/7LxGgq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/7LxGgq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754681426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpVGkkrUe+YakAilFwzjKDkOETJ448oermX++9pfg/4=;
	b=I/7LxGgqEEMGk1uIuiqfWcoynl39W2upcb4YPv03wZqumNBpwVsBbUyQ+9ztHBQXBBbOHD
	ybfPadj+4gM81wDVArBYq02SpzxLvPx1GXJdzAfuXBinwUZoCFtUHjoCfHYlemZJ9qDzXL
	YH6GiEL2FE2OwHE9qGZR/ZJNzh7GscU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-UB92E5GgOAO5-pL4MG5q9g-1; Fri, 08 Aug 2025 15:30:25 -0400
X-MC-Unique: UB92E5GgOAO5-pL4MG5q9g-1
X-Mimecast-MFC-AGG-ID: UB92E5GgOAO5-pL4MG5q9g_1754681424
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d30992bcso20724835e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 12:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681424; x=1755286224;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpVGkkrUe+YakAilFwzjKDkOETJ448oermX++9pfg/4=;
        b=WbYJ0hsPO3T0xevY7C4wGQK5paiLOKB3hGts7ezEjBMF8yX0NA4nQmBUjcKzIEOHBC
         ++gRHtWQVk38FnSYpBYPy5X4ChXd1ZVjk/3/1XiL6QNqdUbRJUy98coIU8pkel34hYG0
         /oHca/EYRwllMOZipNRX8v/Y9oYgqC74LvB9uZ1yFFDRmKn23+dB7zfU+aC1isp+WOqd
         WeAT1BnDZp/pbtwan4KEAB3PEivTStc+J/dfiqVc9zSEG85mKPczvlphMkwrS89YiivT
         HwCW58zQ//IPa29Fx4OxncqZpYb5FFHG5n0++pXqro07uTc7S0N3UilFDF4ASd+tHYHk
         gqGg==
X-Forwarded-Encrypted: i=1; AJvYcCX+LOAK81BuHghnqQ55MQM5qb0UWKmXmDTNuzo47mKvtwRxEDIr6an+1WRpt+/RB8/PFd72IoyPUmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTrmaUsoZsGVeorYdS3qdLIZ2Tv94vGitPhQnRcfuU3DMwJqEx
	pEwP6OtANhCa32YStGnuFHdaoTmEMRMJMt2W4cc5LrvLgiMf04fKLAlKiXE/BsBF3U7ZSXTMW36
	s2T5OYCeU+PYyePBxQ40DbvAGs4+pzxAA1uhhi1R4gJ1kBD6AM92vrj26eWGbV5oSnmDO2GLF0R
	S5OcOGNLQhnTQQyiSP+z3f+mr77pWIeATtl51kmBPTQYsx
X-Gm-Gg: ASbGnctXBhMlS7YaBtGhu50wp+KLDlL+hVrFcqVfgvXvi8CaA8Q82Z37MKgjsFByPNa
	a39QckS/ooD1Vzr0R/fzGeLD61NKCO1PlHpjYm1GcxDnwF9hQqwm2ABGwaMW6zGhqyvAvTgX2Fq
	G1+AnXE4/zcaU+8Rmp5H0vpaXmrxIuos+bhKqRz3ykjOxpll/0ew9KKBStfaUI+wiTROeSj5Jl/
	ClUC5kNuIA15TRDvW/dfJlgHE8QckP9zU8ttaZwguwqpnP/WAFZc/mCPcGpxdFb2Oa2YmBCaSon
	jR7vUho+HCEqknX5YQDCPvtfI33eSboP9wStAvgfWYubyw==
X-Received: by 2002:a05:6000:240b:b0:3b6:1a8c:569f with SMTP id ffacd0b85a97d-3b900b49861mr3916105f8f.1.1754681424070;
        Fri, 08 Aug 2025 12:30:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJrVlyIhj5KYTf9nlfZi/yobMCyyW6+KZtHs0zepTVKqSEVXLpboIqqa5l9qlNh4xq6cN0pA==
X-Received: by 2002:a05:6000:240b:b0:3b6:1a8c:569f with SMTP id ffacd0b85a97d-3b900b49861mr3916076f8f.1.1754681423522;
        Fri, 08 Aug 2025 12:30:23 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm8925162f8f.69.2025.08.08.12.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:30:23 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 08 Aug 2025 21:30:19 +0200
Subject: [PATCH 4/4] xfs_db: use file_setattr to copy attributes on special
 files with rdump
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-xattrat-syscall-v1-4-48567c29e45c@kernel.org>
References: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
In-Reply-To: <20250808-xattrat-syscall-v1-0-48567c29e45c@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1982; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=rkmNz1sSnysOaIdcGInEjZTg0J3rQpVEu6HfuiKCXOg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMqYFeC97cmja525mk/VHWDwyzlcw9PcHS5RW6IgKR
 K3rSDih/LmjlIVBjItBVkyRZZ201tSkIqn8IwY18jBzWJlAhjBwcQrARGQfMzIcUHUTum4oN785
 9wHPAjXpq42vTqbtKuH+wijx9EPhmdZURoabZwKK7BtDG7l2dVWbBsiaHpywP7RmQc3yrgcn4vR
 vZTECACz2RNQ=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

rdump just skipped file attributes on special files as copying wasn't
possible. Let's use new file_getattr/file_setattr syscalls to copy
attributes even for special files.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 db/rdump.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/db/rdump.c b/db/rdump.c
index 9ff833553ccb..5b9458e6bc94 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -17,6 +17,7 @@
 #include "field.h"
 #include "inode.h"
 #include "listxattr.h"
+#include "libfrog/file_attr.h"
 #include <sys/xattr.h>
 #include <linux/xattr.h>
 
@@ -152,10 +153,17 @@ rdump_fileattrs_path(
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
+	int			at_flags = AT_SYMLINK_NOFOLLOW;
 
 	ret = fchmodat(destdir->fd, pbuf->path, VFS_I(ip)->i_mode & ~S_IFMT,
-			AT_SYMLINK_NOFOLLOW);
+			at_flags);
 	if (ret) {
 		/* fchmodat on a symlink is not supported */
 		if (errno == EPERM || errno == EOPNOTSUPP)
@@ -169,7 +177,7 @@ rdump_fileattrs_path(
 	}
 
 	ret = fchownat(destdir->fd, pbuf->path, i_uid_read(VFS_I(ip)),
-			i_gid_read(VFS_I(ip)), AT_SYMLINK_NOFOLLOW);
+			i_gid_read(VFS_I(ip)), at_flags);
 	if (ret) {
 		if (errno == EPERM)
 			lost_mask |= LOST_OWNER;
@@ -181,7 +189,17 @@ rdump_fileattrs_path(
 			return 1;
 	}
 
-	/* Cannot copy fsxattrs until setfsxattrat gets merged */
+	ret = file_setattr(destdir->fd, pbuf->path, NULL, &fa, at_flags);
+	if (ret) {
+		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
+			lost_mask |= LOST_FSXATTR;
+		else
+			dbprintf(_("%s%s%s: file_setattr %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
 
 	return 0;
 }

-- 
2.49.0

