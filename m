Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C263B27F74C
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734703; cv=none; b=k8eNbX2G0fIZ/NhmZTozEFQPKonbfkKDJk/wPbB//nz/cq8q8LDFvnaDWHVUiYIWa+HkcgPIL0wn5re820eufQrfWjgyh535GYCC5+oKQ6PMi2GWDSnBAh/DnT7SlGH4B6XSi4kLZB5cL+GgzFtcbMZoXe3jKhwL9+2y7U/+C+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734703; c=relaxed/simple;
	bh=g2kUFE2cbPGJe3S5Il4ER1RFhvk8KicxvvkVs0nPlcc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L4SYNx7NsGEUWbfdMafoYw/9u1HlIQqlMuEQGe3O4kYgn14LXL0GJZiGolFtVai546aeZIUON4nnhzZ+UBN/lZOcbMBtZ2FhviCdj7pLbO+O71DACdSAMhIuCgg07lQ+FNvzT0NisYuDCPtTTnN6JZ9w7SdYMBvPBCy9b01P+Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iohnEr7p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iohnEr7p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZXoaxTDjRg/a/jwd5LEvOIoGKVQe52rJ1WByCglYh4=;
	b=iohnEr7p1vwCgrM+7P9oPfWtB2j2Kxl4Vv7rxStECUGZLg661aPEoB0JCRbXZt/tKt/P1t
	szLVfakUDLzWHRRyxJ3XmaCY5aQRoLSzxa0TumvIU105KoDDJeX8eQo03r5hE3cTl8gxuL
	PbcVrx4G/BA3RcvODl9XRhh7+H/Gbus=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-THBm7qmFMa620SvCaIkevg-1; Mon, 28 Jul 2025 16:31:39 -0400
X-MC-Unique: THBm7qmFMa620SvCaIkevg-1
X-Mimecast-MFC-AGG-ID: THBm7qmFMa620SvCaIkevg_1753734698
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6077833ae13so4417361a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734698; x=1754339498;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZXoaxTDjRg/a/jwd5LEvOIoGKVQe52rJ1WByCglYh4=;
        b=RnDJWpqjn0/GOJESLqV0c9SYdzhxteSrzdNzfQsruATALsXT5ipQVxobpIWrRV3Sxv
         nvu3IrzUaQDzzihJVf9d6QSM98WBxLfLm3mf0HvBT1UNxbp2I+JhNV+0CR+07DbSRi93
         FGErzHLjcuLaC/5+2KrQlTxux8mGSxWYm7QX1tm9ydpv+uOX555Y4rXjL0gTcWyWnBtz
         HtvpOkWxk22X51hrsARFlMT7cTpwMz+MXeonZkba3VN32rlera+B24MFh7bZwXZbon71
         3ChARFH3/vlw7f3xLrYPUZlC6xWSXBRwgvgjPsPoUkmnuxCFDenz4CkeYJ7K3S2faoVL
         rj1A==
X-Forwarded-Encrypted: i=1; AJvYcCX5wT8hGCwabWA+S/H/D4gpTiFx4J9GazxxLZ9uWFGhLJTK6XLaMiZtc73u5C7XRffmf3TPMDM6cxE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynj5wbjdopMmV7M+Pm1aljQP2PtI4AD+ImQHAHVl3tJ0KaQBKC
	wOQBPEEl1AK+0b/MK7tuznQflGsEiEwlEnzHcBTaT9COrTQcxGduPTTtNevLMFgHOa1Vg2N0Hgd
	NxiTS19H5Lcj1e0hTNqBykZWnsOu94jRBseWziLEIpFNeqwJXdJbJ+LGLFVKG
X-Gm-Gg: ASbGncs4+7XvaeEJrLsOdBO8UEyp1g/crVvL0ScccBLqxUZ3iKpDxEqwcjueHM1dCAW
	r8tz3ope8So3K210dLuAQRhoj18Mwy+tZA00oHuxCP9JZtyySAlwaXKUTiGB2tnCmLD2EPAaM2Q
	osTOrK5DSVuf/PWUvNY60b0tUbXS/MmPyp7S2EFIawsIppj0tK1r/vfK9+3qeokB1hFDjcyaSCQ
	Do90un7uLfOTqCsIGgBtHHLL5ApXAZ8zzYqj8TJMAP80CB1PlZobefUQATJ6B6YGQk3qW52qGv0
	4bX1d3W7BMZTfV8WTMQ5rHm3ZUXBj35dBDYpMUDlGLww/w==
X-Received: by 2002:a05:6402:42c8:b0:615:4244:8c46 with SMTP id 4fb4d7f45d1cf-61542449868mr4455393a12.28.1753734698106;
        Mon, 28 Jul 2025 13:31:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIdGe4USzRIJTcsB+22wY5Dcu9XUWv6bWITa5Ihoc1sZZDfH607srcXhtVlDoAzyIrl4/0yg==
X-Received: by 2002:a05:6402:42c8:b0:615:4244:8c46 with SMTP id 4fb4d7f45d1cf-61542449868mr4455370a12.28.1753734697628;
        Mon, 28 Jul 2025 13:31:37 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:37 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:21 +0200
Subject: [PATCH RFC 17/29] xfs: initialize fs-verity on file open and
 cleanup on inode destruction
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-17-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1800; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=mGQiXL42Qj1BBahuGJXihH0ERFZ0YR469i+3LjqufUY=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSdgvCnmWomy0fqqu4U75hki2q+/sPI6kbXqlV
 /vztqvWlBcdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJrLqNsN/t8ToqqUJzxzK
 hE76r8iQVn6hquGwuqmuoDJO6fr6iJdLGRm+fGe7bVoxZcrD7vnc9Q/bV5/6mJV04O/SE7PVO65
 cn1PLBgBfQ0re
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0b41b18debf3..da13162925d9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -34,6 +34,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1555,11 +1556,18 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb0a82635a77..7b1ace75955c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -53,6 +53,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -699,6 +700,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 

-- 
2.50.0

