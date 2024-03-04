Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A737D081
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579558; cv=none; b=i2qZzb3m94EzbxG9d6RASL+BUzD7gJmkx78Y943UDzUROuj5SGVx0XvKg0njTDQaEJcx8OgpUxtAzSwip5XKRcryTayp3caCqIjjOfj1XEMZYC9aECB0Y50ybEKVkwl9/ISEtYQP6QfPvWODVOZVt2exUvGRbwLTN7nUU2lhN/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579558; c=relaxed/simple;
	bh=INc7MitHePby7vAUkDxfEehRxdrWRG6wEUUVyYbtgRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeKYmVXavyLbbifdyjSNy3+qfVdCT8DyXEi2u3b79uS0sOCc8noIhExbIkatcFuHZwcAv5bVRs5zynyamDKBCkdspomSeFnUmUJRGXGhaUJJ8du0JexUqC26Ku95pDo9fpVqOPubuY/JxdCzqA9qHPpVTSfx4oFo2+wbH6JqOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bLSKjNmo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bLSKjNmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdXZxugOLeL3RCRxiry5bYRXbpoWIDFypQghiFAJrD4=;
	b=bLSKjNmoPLMOV9xS4IHPj0jQkNGIzNHWcJwNarDhzfBItpIH7FEJDAhwoY9wwaMrIMkvVB
	mkqFrCT8vC3unhAYoHOZcIUJOsbpMnNUZMNxxLAoveCoPlGZe9LYRCrv3nXoWz71F8K8bV
	XRrxHKdRBtC8ONJl5Lql6c0MH/Xr8eI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-dGcShvr_MRaYUglghjo1kA-1; Mon, 04 Mar 2024 14:12:34 -0500
X-MC-Unique: dGcShvr_MRaYUglghjo1kA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-51329001fe6so3510061e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579553; x=1710184353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdXZxugOLeL3RCRxiry5bYRXbpoWIDFypQghiFAJrD4=;
        b=tnGqUWCpd1bSVx57mH1wqcFXXiGcP4yHpXK5cobRoFJc0lYY6uGIl1nqdXG+1DE6c5
         ekvax731ZpzzRj7U1lWu9N9XTHV7NJ/1aOJMnIlTFIHUCWnJeNJci7zLWn6IJSQq7KXi
         NWuci1Uf1X6WF6/Ekm3pX5vs3suYHO5CLFmCbAFeLppZ8GXiIiYg1FzUV0LYqoV/oBoF
         xfoG00ZzZ8ihcqEQ5I7UQ4wPS+n9GdU5Qk9DmhVYGvKkJaHrjv9Udhxg4dP6xRJq5mvt
         jCElKzcP75pppQUe0n7MKun+eARwx8QESmqzvL4B4hgo8hMtZBgOLz8hm20hbtnXECfm
         TUeA==
X-Forwarded-Encrypted: i=1; AJvYcCX2pduH4UMTDMm4KBqHJCGX6aFcviA/G1grctTbrtFVUehbqaXjqIkOgUcSbgou5NQQQ1Kx8zVjcVZXcDo3LXzvpTRg1O/GTYz0
X-Gm-Message-State: AOJu0YyEi6Y7Qajvb9b+c1WZXv0UYukxhGEzawKVF7a0b9lArNAl7w7q
	cMKMyad3363oGSu2uijdI/ykstwhODyv6gVFScrTqIl86jVm5/+z9+VvYteMpm+p4p6jxHZnaMe
	Mc2oGO5HEzpoNK7e4/5nSLnBtuD5jmXYfp2+8NwZ70j03c6vtJ69/cEfm
X-Received: by 2002:ac2:42d7:0:b0:513:49fd:c63a with SMTP id n23-20020ac242d7000000b0051349fdc63amr1699736lfl.56.1709579552845;
        Mon, 04 Mar 2024 11:12:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETsl9dsoS2dwS0BLYcGhPQprHJfq00rS2fw55aSA7GEdV3c2F87uy+0BYF6vYReQxkQ1fYiA==
X-Received: by 2002:ac2:42d7:0:b0:513:49fd:c63a with SMTP id n23-20020ac242d7000000b0051349fdc63amr1699729lfl.56.1709579552630;
        Mon, 04 Mar 2024 11:12:32 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:31 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 23/24] xfs: add fs-verity ioctls
Date: Mon,  4 Mar 2024 20:10:46 +0100
Message-ID: <20240304191046.157464-25-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ab61d7d552fb..4763d20c05ff 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -2174,6 +2175,22 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, (const void __user *)arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, (void __user *)arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp,
+						    (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.42.0

