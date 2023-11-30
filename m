Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UJHPcnR3"
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD0010DB
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-285f46e1cd4so595348a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701317141; x=1701921941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzZ48eJfLHHMlCtm8iE2OIqQ5CTleeJ/lIhizaNpWbg=;
        b=UJHPcnR3IAmJ6BxYQcXs7BT0KpYQYFtB/3DXw8JWcNb7fSZ8IRsEXMwkCdiQ8HdeVO
         CwzuFiUDBemxBQElnHO7aGUMkApPCPUahx87zMrLqmp7fCSl2tyYA7MgOWgU0cXyoBh5
         YMb0H62WuMO8EJqVlA5yO5E624R6AC6/VLMM6UEZnZ/vCYrmBnGD5zKG5hUVoRxfUomX
         U7AS8n3KzT93bvXas47dqpCCID49mN5djQx/cFUH4xF2+Dc41RhNAvQu2/n5ywgDDkdO
         2z1kvP48MKjlbkKdPgnk46k/32CqphqTNvOkHDBpGcVLKJr3I+rCU5i9pSU11Y0ldU95
         Hd5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317141; x=1701921941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xzZ48eJfLHHMlCtm8iE2OIqQ5CTleeJ/lIhizaNpWbg=;
        b=w/gLjGs8w+gQ6ukbe6bIAftNVEDuifXzsKS9MZzoRTBENS7gzTgC1aADQBwTQqg6+8
         J5tMBoiXxQH1EpdHfWXBzfuIWYwt3t6kdD/uKYdZUC/06uaNeNKiPpq7twgm/wsdtJit
         ZPDX3Kxs58udkYtFsy3rqJwHC02h6cb7yg/JKdHn1dMsa86o/dY+uhfkunABPQ8llXeM
         q0LhqseI6f2aUZBl6OGiFUViZgLyHbFNTvOW3PQPO2rfQHMFcOQ31eJ1RSs7bn3xmuAY
         ua1e70HeugbdXoNW+uRv+eD3VIHvimVPJdxUZqZHaEP9eG8WJo1cNRkeF47RouXbZooR
         ROjQ==
X-Gm-Message-State: AOJu0YxQsOaJA1sMWOPECXReBct3Hq2HvieXG6q8MQ0dQxTld6gEG2tv
	XGKOaXOef+t5ROUuV7oqH159kQ==
X-Google-Smtp-Source: AGHT+IFQrYsOQuWo3n6G/FFjxEVrJeW/vdVp9n45XlrFZpjEuQm/fsiX77YwpQo1mKZTf5I7LaOZgQ==
X-Received: by 2002:a17:90b:3a8c:b0:285:d720:b568 with SMTP id om12-20020a17090b3a8c00b00285d720b568mr11942054pjb.27.1701317141432;
        Wed, 29 Nov 2023 20:05:41 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id u6-20020a170903124600b001d01c970119sm174181plh.275.2023.11.29.20.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 20:05:40 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3 2/3] xfs: update dir3 leaf block metadata after swap
Date: Thu, 30 Nov 2023 12:05:15 +0800
Message-Id: <20231130040516.35677-3-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
References: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

  XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
  XFS (dm-0): Unmount and run xfs_repair
  XFS (dm-0): First 128 bytes of corrupted metadata buffer:
  00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
  000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
  000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
  00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
  00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
  000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
  00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
  0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
  XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
  XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
  XFS (dm-0): Please umount the filesystem and rectify the problem(s)

From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..f3f987a65bc1 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2316,10 +2316,18 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * If xfs enable crc, the node/leaf block records its blkno, we
+	 * must update it.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.20.1

