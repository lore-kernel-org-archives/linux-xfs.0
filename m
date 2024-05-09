Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29EE15E7F2
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715267723; cv=none; b=l5u8j2Ej9w+Ie4jcsB0aGQ9uEyLG+ctkdkhCFelE2kkw93K98oEUVx2jNYPB7fGbm6fPHogFllgBcDGQPj4el1WFrDA3SFZvEyqkLKMAjGtD7R3F72x+z0SoczVc3oWMiHkiEBCO53kgplds4zNdtBHh479uJ8dnaP6x/fG7XPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715267723; c=relaxed/simple;
	bh=fFM0/KvDvt5Y5FvHpzFj4UyoZ0PlkPOytftVHOSGlFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyoArqM4VYWcddzipbHqMnp5qWjQdwf4H1Qc/EuMqSm4DCXaffCXBMTCMetmFMiNDBh3/WURMQkQSevpSkokJTZALQIlfWrLGh5YWXe+qdMtFoA6NOOVUbWSC6/3kIHyz1MN4PO9920357j0Keh8xcszb1FZGVpH1hQd3dFa+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMWUHExd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMWUHExd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715267718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bVAoqP60G64zUWYOq6YFxYCBZUQsiboflHYjc+CThqg=;
	b=UMWUHExd/TrBIMXrv8C8Yzan4E6hleevrf9roxnOYkupEIMwxSatO/jPaBhNXmHSGhi4w4
	SXMhFIPq0ebpgFvAIWK3JYp8YbDCadyABqZuOlCrrcEjHZgrOW0gjv0tobOtfrd8Uhrmwp
	7CflbOftEYmmqYoEs1cCehSmIrSZksc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-YEGwjO-tM0SE4k9XQtkeXg-1; Thu, 09 May 2024 11:15:17 -0400
X-MC-Unique: YEGwjO-tM0SE4k9XQtkeXg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-516d46e1bafso743442e87.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 08:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715267716; x=1715872516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVAoqP60G64zUWYOq6YFxYCBZUQsiboflHYjc+CThqg=;
        b=g2+cCanklZYXEPxnMkj5QJEEopsCi9AKD+fkZHOFmuJ40d7XmC0Hh/PQ92qGNMMwpO
         eTU/7UcyaQ0WD6rbCJj2zQKmN7krGbuooheV0+YXQPqipIwdvGDcpI2KEC4jD5iir0km
         /fjLSF5BiVAJyuVUQQfpwRibdMJsBgBX4bEKk3AftLIPFEhjBEkoyCJfyrBDoMA8Ppee
         4A51p0PGT0OeFdIdZERlG5hqG/cgzhdlTV/g/8VI4bgCDUDHzYSeMXAHvN66JR+/Hx6I
         Bl+N7ZNJKhKq+2Q/+C7FHdVbw47co1hRn6KLbMQK49NX6vzh6zKiH1YQa4b82W3VeA4d
         3Xtw==
X-Forwarded-Encrypted: i=1; AJvYcCVTBZV7WlVEoaSEh+oLzRLzEOhuZAJmZrKH/ZBIwKtUbdZf9b/OIWTSk8xJBOvKROKy5wfFT2HJ+i7wg0GbAeNB8WEghDVmY5+k
X-Gm-Message-State: AOJu0Yzdd83kC1HtR1VX3VhN7yjREv30QY5cDo+Ng3QtsN5Ypa+QKAmY
	8cLmj4wdP2dsEWXFF6IA00i9z2ezwmy6UNM+m0fK4+4XnSmdbVh0lxJXFwEMQZWnrN6Ih7mrZuY
	mXKDWub5cti6MsthK38wfDIvRG0JD4MFY4hjFUTeHmGftsYE6V44MaTDB
X-Received: by 2002:a19:2d04:0:b0:51c:cc1b:a8f6 with SMTP id 2adb3069b0e04-5217c566fa6mr4688813e87.20.1715267715502;
        Thu, 09 May 2024 08:15:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED5UjVNgGIK4ztNZsNrbCNwOsZkMbo8b6l5A4/xZn7J8iHlQJs90qL6QRpE5kELHeJvC3WVQ==
X-Received: by 2002:a19:2d04:0:b0:51c:cc1b:a8f6 with SMTP id 2adb3069b0e04-5217c566fa6mr4688795e87.20.1715267714882;
        Thu, 09 May 2024 08:15:14 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01785sm82035866b.164.2024.05.09.08.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 08:15:14 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-fsdevel@vgre.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/4] xfs: allow renames of project-less inodes
Date: Thu,  9 May 2024 17:14:58 +0200
Message-ID: <20240509151459.3622910-4-aalbersh@redhat.com>
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

Identical problem as worked around in commit e23d7e82b707 ("xfs:
allow cross-linking special files without project quota") exists
with renames. Renaming special file without project ID is not
possible inside PROJINHERIT directory.

Special files inodes can not have project ID set from userspace and
are skipped during initial project setup. Those inodes are left
project-less in the project directory. New inodes created after
project initialization do have an ID. Creating hard links or
renaming those project-less inodes then fails on different ID check.

Add workaround to allow renames of special files without project ID.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 58fb7a5062e1..508113515eec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3275,8 +3275,19 @@ xfs_rename(
 	 */
 	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
-		error = -EXDEV;
-		goto out_trans_cancel;
+		/*
+		 * Project quota setup skips special files which can
+		 * leave inodes in a PROJINHERIT directory without a
+		 * project ID set. We need to allow renames to be made
+		 * to these "project-less" inodes because userspace
+		 * expects them to succeed after project ID setup,
+		 * but everything else should be rejected.
+		 */
+		if (!special_file(VFS_I(src_ip)->i_mode) ||
+		    src_ip->i_projid != 0) {
+			error = -EXDEV;
+			goto out_trans_cancel;
+		}
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-- 
2.42.0

