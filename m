Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279767CF33
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579553; cv=none; b=PDRhGaT2Q3m8gzZwdQfGlcB6/2GyuGM2CwkEiCzhOEu9tAVjYWI1KD3UoWaT9wH6UQ0Q/bgA4M2fVle8cVEt1zTY2LfYTp+ux0VC6NmRxT8sE36ofFgbkiWYdtZs/HF5fWZoO+3poo+tftfGqa8gW/GQwGdwjYbBNY1BNixKwP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579553; c=relaxed/simple;
	bh=ERtzRFPdr2VH0zZPj8RxD5cx+rKCLFPSdsv147J2+aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a78Uhi+2oh7vqIngVIsWkC0E0v/coXuz4yFo1ZqjuUD4Td9MX92kV0dM5FEa9WzXUAGh1jKhF6kh+bdVSODm1OuWu5wnxm4wIJL46Of06FwscV00omHQSGEaVfr5e8NK6xA0vRh1q6M8jSkZoXVb7XF4zpK4aP/SByiHZIXY9yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G7HQ5JFu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7HQ5JFu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krPybzmQrqI1Dp7C5c3ykOUeWIJQjCMl72CpYY79DB8=;
	b=G7HQ5JFuKYrWivOqPYBk4FM3Dbm5D5jTRfsLkXQtGlc0Jj1ZGiVakh+QlRG1LEr7Kh1fbp
	uQ4tpmqVWvVV+/r0d2TUCTgNmPD5HiHpz9ypvVBdI6oxM/9CeoodTr5Dd4lOrDEQ5cZBxS
	1e8+jjTprQEY0RhDDhsLBJ8vhVfcSPE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-dZ15VDAJOc-bgA-WhaE-CQ-1; Mon, 04 Mar 2024 14:12:28 -0500
X-MC-Unique: dZ15VDAJOc-bgA-WhaE-CQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a448cfe2266so371152066b.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579547; x=1710184347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krPybzmQrqI1Dp7C5c3ykOUeWIJQjCMl72CpYY79DB8=;
        b=YmXjCVObt88/wUdESj/WbP+GK+aM1WjZistycalke75gsmTh4bqiJdlk3yvNg2M4y6
         WdomQc4wxq56LAfSP4670f2orfBEF6JH9qK+n75AuCaQSvi2fywEqs1VZWZ8yG8uAf9z
         B+qYEW1oC5Kn4FTtmiK0MpyoucdYESTo/e5TFdLXLfjSjoBq1MWa13eeKjLrBqo8il1u
         0ZUM9dOlj3FRTRh/fXwDccti8+1I5VFTIigs5WneT5rmX3f3AmgoIUYB7k5jBpBqT89i
         LxEm7hjzniE5/gpWsMFVM73XTvEaC8UhBG96vzo0QaT94RuAFDt5XEnmbNHZIKaOVlKV
         +cfg==
X-Forwarded-Encrypted: i=1; AJvYcCVPL8dKNe+1BlHl/+qUkgf4FnspPTUz9ZFDRtlDTR3KSqe+gaOXp4vYpe5zjV7YO1hM6roSGF23M4/fmvj9Nb7p+baKtQGDVZ1E
X-Gm-Message-State: AOJu0YyUiWknpykpy7LZT14RIQ/1oQHHka2fOzbso7VTRYEkGHl9IRSN
	LMAwDMJSrUOEl5FLt/zsA/3C05B/mPX9ELIZ7eMTMRtocq5GmazL8uRVFG3Zc2Zs4+HYF7yeklr
	BW3e8+lC6MgNiAzR+CJ4LywOtecthB01DA/TMRrrl4/y0B+CiI0wedK0K
X-Received: by 2002:a17:906:ce26:b0:a44:415d:fa3a with SMTP id sd6-20020a170906ce2600b00a44415dfa3amr7056582ejb.40.1709579547483;
        Mon, 04 Mar 2024 11:12:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcAC+lTxlNi6h7UWuTBi4wKvqOw70WGSF/a8p/9kdmtD66jYKFg2m1eW60qx48UVYaEc8wIg==
X-Received: by 2002:a17:906:ce26:b0:a44:415d:fa3a with SMTP id sd6-20020a170906ce2600b00a44415dfa3amr7056572ejb.40.1709579547287;
        Mon, 04 Mar 2024 11:12:27 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:27 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 18/24] xfs: initialize fs-verity on file open and cleanup on inode destruction
Date: Mon,  4 Mar 2024 20:10:41 +0100
Message-ID: <20240304191046.157464-20-aalbersh@redhat.com>
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

fs-verity will read and attach metadata (not the tree itself) from
a disk for those inodes which already have fs-verity enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_file.c  | 8 ++++++++
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 632653e00906..17404c2e7e31 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -31,6 +31,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1228,10 +1229,17 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error = 0;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
 			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index afa32bd5e282..9f9c35cff9bf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -49,6 +49,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -663,6 +664,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.42.0

