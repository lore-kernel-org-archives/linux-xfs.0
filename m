Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71324321454
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307773; cv=none; b=CwIv+d25e7SeLtXPZpcnd3/rWeMUBQTctkh1edj69XMSN+JHRsMZgnEP3/E8iOH7WkkBlqWhJfaM5tIBcqkst2JNOvtGKSKLIwtjXLlHlngp/I2/CbGEk0OOkfEyA+Jc2X75dzT45RVY5MP9zzWbSswSwgF2XK+gQLcNQ3yB/Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307773; c=relaxed/simple;
	bh=izSJWa7mz724b1JHGLezzPPHQAOYuss7tQ3I2vbEPI4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=t5VvCRkX8bYaYF0Eg4JYkQ8Zc+bluNNfAcMjm1py3n85Xw1cUm0FPE0eETGf70tyNzM3/tc12eV3ipC4IBiTtqXQayO2FXypucy0K2a1Y9SfuIa239yf926+kRxDtMFbgSmAMhXSQvASKMsORzK8rXi+9Z7fYxbpWDbB/Mnd9sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SjDlcZcy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SjDlcZcy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756307770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ilPsX5xqHT53yqhTHdeXCad6dD85Xi19tJRkkZN2ujQ=;
	b=SjDlcZcyRb7McRYcR2NRGb7G7F2QtwuRKx7bqQVT0PnPeEPmurXUsiaH4fAObu6tth0xuJ
	fPpC/i79OWWUjnOzCPmmrdF8+NmZujGkDg8mv7Az8Pz6o8WB6yTIVgC8jstPZw3agGsvWW
	+j3M97zi8v1LO4bxxpbepbQz20U7qWQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-5Cf220LrPJqfMB0_3syMxQ-1; Wed, 27 Aug 2025 11:16:04 -0400
X-MC-Unique: 5Cf220LrPJqfMB0_3syMxQ-1
X-Mimecast-MFC-AGG-ID: 5Cf220LrPJqfMB0_3syMxQ_1756307762
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0ccb6cso34362035e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307761; x=1756912561;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilPsX5xqHT53yqhTHdeXCad6dD85Xi19tJRkkZN2ujQ=;
        b=Mh3Tr0QPdyDqzSgt+k4HQIJqokHF3NB69zMxZ00HLgG74FBk+QNf1vln5nyNIKyEjn
         6PvmfHa//tar5C0ExUrWmrrULvenwFWkR40xNx0X3qepIH89fRMPQa3IEsFY6JosMDVm
         R6svI5IhEXc5rV0mvZSnPp1v2bcnvQSP4E5PyKjuleGK/yJMMvyCbpfE32OCw4uTaW/5
         2xoLqBCbOPL/P41fLFQMTcQHjcZKWwzI0igYnwyy3wi5/D7XeEgDvkKlxJGgzA9+XKec
         /bNgabTIL+jZ+Ll7+YKfP4io9i45gOg4ILXozc/MhBpbHGMtqm6h6RYJjgJNQlKkryqy
         rA5g==
X-Forwarded-Encrypted: i=1; AJvYcCUe17AcSiul9/h0cPiW91a6cITvEZesN6+IfA7HrAkgTtkjPsALBKvvjh2DARybR3pcrgaIvRgPdQs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwwr4YjlyE1+07239RMNY2+0fJrTzjXG4rJl85upuSJfo+rb8R
	7xZgvvsNBfoqUfOoE00kw+dQC974ZPHUcp/eSXET6kwg6mxkrooVwVqODznGoLmo6Pe7BY8g1iW
	1HEGOONZ5ep/4/Z9eXjIOFCsISonChg9PXSBhhQw+hZX3voMX/mD/YoV6fC840wF+wRdmqEREc4
	VomBEyJEV6jP8bt9qfeAe2r+xlp5hlcI7aZxFxA3fhlNXw
X-Gm-Gg: ASbGncsB6rHm7Y6z+yeFLYk75d4WecNy0fHj0qUDrdSABsb1vlmnFJg77tfVzr7SbZS
	XaK2Pp06z6SpDoHmKp9xvq3sLWRoyT1Tjpuxhq/5TW9qM+Vwuzyl53hqzXL//yCnrlzVtNX9f1J
	03reii3N34kkIYVHIX658pq2s93GWeTUkijxB0LNngLhuLEljIT4PDERMMi5xrOqVNhekM6w7gy
	7z27YqGUt1IqFkiSzE5ta5LwSPSYJhkVPu2l7hMrctpBlVf31oMwTxUat0R63eVaFrvsNELGvnV
	r5MwW9JqgJ9vJCvBYA==
X-Received: by 2002:a05:600c:8b55:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-45b54b21175mr167644095e9.9.1756307761134;
        Wed, 27 Aug 2025 08:16:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjEsUcMJyO+PVXTjXz23g996Y3GnnPBnHITgsL3/hdP62yPOXCCipt8Xc5Y0OEQxuWSFy33g==
X-Received: by 2002:a05:600c:8b55:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-45b54b21175mr167643805e9.9.1756307760700;
        Wed, 27 Aug 2025 08:16:00 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0e27b2sm33896285e9.10.2025.08.27.08.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:16:00 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 27 Aug 2025 17:15:56 +0200
Subject: [PATCH v2 4/4] xfs_db: use file_setattr to copy attributes on
 special files with rdump
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-xattrat-syscall-v2-4-82a2d2d5865b@kernel.org>
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
In-Reply-To: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=izSJWa7mz724b1JHGLezzPPHQAOYuss7tQ3I2vbEPI4=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtYr6sx2X2/9R/D67Q6xFYxlLXWhp/qbZFq/RwTff
 npny8VlBZs6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATGTPKoZ/ag2LZ8awTl3L
 0TMp2qHn0vufM3mZVTblO/sEbdHvd55awvDPlF/kdm7+m1dPhLcJu0x6k3X2U4jQtEvmWgdU7vC
 cbvjLDADKp0kQ
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

rdump just skipped file attributes on special files as copying wasn't
possible. Let's use new file_getattr/file_setattr syscalls to copy
attributes even for special files.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
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
2.49.0

