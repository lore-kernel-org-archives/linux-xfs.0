Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF08158858
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479610; cv=none; b=YL/Er3JLiVQ25AESFzBUSk6Wf7ZgrMWQpV4q3dBXIJ8lz4lisyS8T+QV4ydM6Zcfe1UVc8nbxPqIdMHLpqyPCqHkP0bTREyrg5m5n7RfXtCbeAkBlfNtk7YubiZDaYp6kVApQLgRb51ptwM4+qtk9/WXGaSf8i8eeLQEhIa4X5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479610; c=relaxed/simple;
	bh=93/3urfxAt0DpQZHCjcjAoUb/WZncQAKA6xs5MIkCR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf8x0bXDG7U/ZnU830qYXufiR1IEf8mnBPPe8d2JBbG/+mHUb2rxA5ApwuPt17NWb1G3x3jhRfseKKwo2mVDCynB05DiSal9EZdoX5tFBzvdQRBh0+IbpP7/Wp/eJUVJ8RErhdd3CvYtDPxnQStiA4MhxUyA/y1HU9hFh1Y01lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6odcVmD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6odcVmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1do80XOcI2G1ofCeVFUgjbKOVIrTOij9h2lmh48ylI=;
	b=E6odcVmDIXxTbsVvFHwUX0enTrxMzovJeGbNBTxSJbl5UinPeLoUOJne6tFs91adKwWdXR
	DEGstWs4D9KOcNsBHZKYMXLHqc8HArUzcql1/c8A+j4UZ3nRYaWQLKlKu1uctYL8q9/5wH
	XTwdMds9KV5/gWo294HbmJNm6PXiFRQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-dVHNCpkPPgeTg3547nHMFw-1; Sun, 29 Dec 2024 08:40:06 -0500
X-MC-Unique: dVHNCpkPPgeTg3547nHMFw-1
X-Mimecast-MFC-AGG-ID: dVHNCpkPPgeTg3547nHMFw
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa6704ffcaeso74782566b.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479605; x=1736084405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1do80XOcI2G1ofCeVFUgjbKOVIrTOij9h2lmh48ylI=;
        b=Gg9s6H15M2RmRnfkV/pv3f4Po/WWMttu2at6Vf2IesQkn2CUVnmcYqd08PxFoaJ6AU
         mdxfuKiJc1A7lUu5Oe5nWt+gXX1njx319//P+rr7VREnpqxE6klr2lFT+CBxO6+tK6eO
         N5F0tH++anmUon5BMvvOVR+4gF5Mrxb9ZaaGA+L2sD3C4+dqZf44WsGPVj/SrG5c+fAT
         kRmMFylu0KTRAcnR8oTjo6NQK2z+QDEzrOQyO09W48HXtsPbYxPl+H3/vHSfZ0Ax2GS8
         FinP0ZtBBZimBdsQlBgy+NHnI/+EW6eYcRvEePvgyNU4dciyhAU9RRj78/3qPrnPr4JL
         SgOQ==
X-Gm-Message-State: AOJu0Yw40V9bH7AZy8ipXU9oOt9HeHJvSmJPghmlbob+RJ1QNzEuCBiI
	VV/abJjKR5EeiddgckMM51J6mc/NznzR6tkGEx3Mbl+MKRd7EF3Q10nCG8tyW6ab/G0jBaqmCg0
	qhDO6T8EEKFE+5lwP6OVaTqfQCvSi7RPgrVVMRPecVPFwiFHfLhMi/qxefAVMSV1QQOF+6iDi45
	Siw+q5L05nKczD3HQ78gHmgGcRqVFHp/L5Di0f+KCA
X-Gm-Gg: ASbGncsHEceyBbg4XCnHOHY7wGoAEV1JPz0Td8qz1zb3IcY6bwOy1iD+vU1kEg6A0V4
	/b/E3HPPNo7L1FKiYxRnyaYM7e2QAWQ6YwurRMfJGHZPeR4Ze9RnLCVsROFBwS7jid8TkCKNtnh
	8+rh4Iyzpq5h+JV7Y7hQBowuEE4XxLLzXGgHZGbbAWiJqL6NrpnjL9FRpyACMRMaB/BO3DVX5iQ
	gxSxKpKmhr6WOSwesn9ksogNFgg3jA2rbS/DwlrkXUDnPOi/sZqGA1VEIxYi5sZXqtdAjmk+oV3
	Dh/auA6cUv92gGg=
X-Received: by 2002:a17:907:c10:b0:aa6:74a9:ce6e with SMTP id a640c23a62f3a-aac2ad7fa23mr2903232866b.16.1735479605459;
        Sun, 29 Dec 2024 05:40:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQdExpM/5xnKmqWZ+rvOxhXWJzEx3mF6IZbQt+z1C4g4X4iEwQh6xlIVlsOHjMh9p9LQdNzQ==
X-Received: by 2002:a17:907:c10:b0:aa6:74a9:ce6e with SMTP id a640c23a62f3a-aac2ad7fa23mr2903230266b.16.1735479605040;
        Sun, 29 Dec 2024 05:40:05 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:04 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 14/24] xfs: initialize fs-verity on file open and cleanup on inode destruction
Date: Sun, 29 Dec 2024 14:39:17 +0100
Message-ID: <20241229133927.1194609-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 9a435b1ff264..67381e728b41 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -32,6 +32,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsverity.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1258,11 +1259,18 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
+	int		error;
+
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
 	if (xfs_inode_can_atomicwrite(XFS_I(inode)))
 		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
+	error = fsverity_file_open(inode, file);
+	if (error)
+		return error;
+
 	return generic_file_open(inode, file);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4ab93adaab0c..3de6717e4fad 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -52,6 +52,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsverity.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -678,6 +679,7 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
+	fsverity_cleanup_inode(inode);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.47.0

