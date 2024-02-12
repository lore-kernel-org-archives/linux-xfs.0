Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DD33D571
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757198; cv=none; b=GMSWLp2JVEEwJj5cCKGeMuB+V3o6uGAWup5B7H+LnadZ4/+2ccpQkfm2VsQBuk2fAz1RZaljMhRMP3rb1yVlkj1r+Sw1wHqveXo2WhaQ5LkcxiL2OTZHnnaw3rbhbvfhJ2LJLVlMUv+Kjd0rU1oVYG5oIFuyYj5zr2hhWGHS37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757198; c=relaxed/simple;
	bh=iGCn00rEq7PG+afvZlZGmDPn+zqmaqJVYlT49tydKx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qGeKjt4VIqYfbv7LKRA/bBOn43GT+yL2/LBmWpSIYYn7I/FJ8SQeENjYy8k9zZHyT9Vx3vJXaO0k1QPwJEi9dfdYWoEjEuJJFSPagTz6Bxj/qw77v+TTcllHjbcTFtT8TOc+QeIk1++NLxvKShvbcFxWOKnLbDip1z5Ppy6jekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e7bWp9aI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e7bWp9aI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBcesGNJ85C40O8Wbwe4Jalf+KuBJVBEen9IDHFprmk=;
	b=e7bWp9aIrLFYJKpRrPcHgst4fLfT3P7gaO+ZMT64XU7DmriSVHBMYCb32S/RHjJFoIXniO
	Q1nz60DUpGc9B5tphLgL1TL87JfnSoC/EnNm5Cc9IVC0d0muVM3qPrW6zTN5zqJnLS1DuL
	qXyKKbunkx49rPx+M+69VDGNSGvIDMo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-U73VCrmtPR6miijwFsu9aw-1; Mon, 12 Feb 2024 11:59:53 -0500
X-MC-Unique: U73VCrmtPR6miijwFsu9aw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a2c4e9cb449so228875266b.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 08:59:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757192; x=1708361992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBcesGNJ85C40O8Wbwe4Jalf+KuBJVBEen9IDHFprmk=;
        b=n/Jp0nLF0FjAPZtXu00kwprICX5hbO08mauCmOazaSTiBUlgeLo3T68NIJCldQJtq5
         gMZ1PfjC4F7if8OtSd9BFon/wM79kpKD/8rOyZfhpSBcC+X/OzeSAY5y3SeNQL7azXI8
         1w+JG9soMPUOoskiZnouCWgW3w7vGwzvDwm0WBrnvSjv3g6T+7ua9w9hDs0605Z0RPKO
         nkK8X7x0noADyY3R/IKo+06FinfqHhiy5A1dEZUso3MlkGJO3dHLEy4Ac8HAkPqcGEo0
         5zuWKqC6lbj1WpNmWuuIYTNANksQn/C5zpR7CDbG5W6K7/wG7j/rUbl3YHvoDtjBDZFx
         VIRA==
X-Forwarded-Encrypted: i=1; AJvYcCUm5hSqeP5uLS/CO1qZEKBfAseQnp218MrgMY8xEX4YjZrsnGSo2zaybycDMRZ9dFYCQA0xoxWxkwFFuBexPqjUAHSQxKMgC2Qi
X-Gm-Message-State: AOJu0YwFSUgYHaVKCezF4H2CN/O63mTEUKe2pJYSzUcqpyBTBBllxia9
	1p5ePgYjRsVCm64hfFDfPcYbA+zlXPi3qW2TccG+rQHNl1tKrARQk82yt3Apim4GtKbgX34BCyV
	x9AjfSE6y3//pmfXzGsxbTxtxiPEDchwsM6JanZz2ec6J0jPMRSclD2ge
X-Received: by 2002:aa7:d38c:0:b0:55f:8c38:36a9 with SMTP id x12-20020aa7d38c000000b0055f8c3836a9mr5424651edq.42.1707757192752;
        Mon, 12 Feb 2024 08:59:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuAQY974HjwvfUXd9S/s2x7iBcid/UjzWaSIP6F1pOXoRVZe6HEND0f94MhpBhdqSR92/o6g==
X-Received: by 2002:aa7:d38c:0:b0:55f:8c38:36a9 with SMTP id x12-20020aa7d38c000000b0055f8c3836a9mr5424640edq.42.1707757192557;
        Mon, 12 Feb 2024 08:59:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUGdzvN1PlvyWuInXAHyDTNZDbZ3DXfxNsW3DTnGhPYQmdNWEbiWbsvxSno4SsYIW0Gcc8LWGDwRbTSQjOvUTlNaq3J5lBwDWuoz3D61CyakzhU+/Ztf5vms14kBfBl/qVaSH9L8ZAthUJf82RYURpX4L4q69P/l+ZSHjyspsgs02K9geKDabKzvF1PUu2mwvnnBAFZcgcXNEYnNv6JM0AnWcmeZWP24ZAuM994uoKNEWHfrsbobAzZthWH4rHt
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.08.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 08:59:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v4 03/25] xfs: define parent pointer ondisk extended attribute format
Date: Mon, 12 Feb 2024 17:58:00 +0100
Message-Id: <20240212165821.1901300-4-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent namehash}
        value={dirent name}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.
Storing the dirent name hash in the key reduces hash collisions if a
file is hardlinked multiple times in the same directory.

By using the NVLOOKUP mode in the extended attribute code to match
parent pointers using both the xattr name and value, we can identify the
exact parent pointer EA we need to modify/remove in rename/unlink
operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: replace diroffset with the namehash in the pptr key]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 18e8c7d44ab8..e5eacfe75021 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -867,4 +867,24 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name encodes the parent inode number, generation and the crc32c
+ * hash of the dirent name.
+ *
+ * The xattr value contains the dirent name.
+ */
+struct xfs_parent_name_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+	__be32	p_namehash;
+};
+
+/*
+ * Maximum size of the dirent name that can be stored in a parent pointer.
+ * This matches the maximum dirent name length.
+ */
+#define XFS_PARENT_DIRENT_NAME_MAX_SIZE		(MAXNAMELEN - 1)
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.42.0

