Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114287;
	b=rg6mys8gu7FX/4W0/i3858CJ2GESZZEFEedE6xWJFTJw3c+kK/db36O8HirB1QHQa1xg
	 g+jHaz8ZVMl2H5PFYJGLlbiSVs8VpZHXnPPVTJ4Ii/9AmQ4lwF3TdOT9M7M90lZx5uhuh
	 STa8sIDn8kEV3wzAwf1fYJucjElkGyZZnowwYrYtMukcMlokjkGQX7ndmokMeLo93FnxD
	 LvBbKsmOcsAccewpF6ty44vRcvqePA7/8fQRCnlgdvx7oKMMjrVJtpwrQ+aEPfN1u7G8H
	 71qjoVDUyj9FoOlAIkt69+cgguxkpmQUfQQPdOOwrp3gyPsev9bNbWJujaZUR1f8UwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114287;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=j3Qa+V3IuRI+P0CHYRVzERRph/QnLAAsDUYydB4MNhM=;
	b=nNrc0NVfbKOeX6dW5eFT9sYo/9sWGUcsrPe6Y72lFQ/cIVDZajFYKt3+eamskzJ42wzf
	 zpYkhjOCe/kuBGOVj7luNeE141kibC0far8LyikIquNuqN1CJoMDk4uQ+cIR/kabvqSpP
	 ZPCXsZXS9MnB1x6X1hL1XEDtVZmxSzuxIBaJn/nqx8bJ5MLuY//9BPNYuOn3y4/cCEa4L
	 5V5zjFVOuwo7Daxt1+6vHl0pfkB60kf+fHlypkFB5GkbtZechs4N5nGNaZmg3PHrnVEk/
	 MJUccfTrsJR0O8FKtYpRFs1+VzklfvhUxq1f2XqS7BJ5cndO/nLGm9hYC3+7nPjAYhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WLkRowIQ;
	arc=none smtp.remote-ip=74.125.231.132
Received: from mail-oo2-f4.google.com (mail-oo2-f4.google.com [74.125.231.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825D2606A31D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:18:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 825D2606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WLkRowIQ
Received: by mail-oo2-f4.google.com with SMTP id 006d021491bc7-70073621339so25569eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 08:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793114286; x=1793719086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j3Qa+V3IuRI+P0CHYRVzERRph/QnLAAsDUYydB4MNhM=;
        b=WLkRowIQXIhcPuk+Jxnyn81h2nuzryWq6PMTu+RVzNQM/XPlRZQlUuG++FIpXZw5Pk
         L1g3NAW/uBM/eUK/pgryfRBsgFyOT8aKwnY3xUHRr+cH3zysJe6Ntw5vD7qgQ1ImfJLB
         n11iJpyW0L1/pjzWnRVpHhfzj0+UvdweqZ1Mf3BFd2CneEKT9TyYvxTg5G0fJ1WbC8jS
         MT5GoU5vUOp/JeuOngShJ02939g4gGnG2dC6HLLkDG503hvKmubrg1kmnZ1kF1A9a44X
         SEm+8dSHbIakR44suIjh4+/HzV3uczmMxaWgg3f3cKlgPfSANCKHeK0SB0uTkLfhLGyO
         a/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793114286; x=1793719086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j3Qa+V3IuRI+P0CHYRVzERRph/QnLAAsDUYydB4MNhM=;
        b=ByQIaNdPfYqTgVoo0EIExWX4LV4+zLU9/d3AWmg0VQV8Dc1TfYG0AVceGJNe0Ns2zb
         d/hco+46jreo8orWB6XV4aoU1P2y9eeUMO3Uo5PWTUIIS4JPgC0GR56FQbFfbbPhHJU2
         yrWJLDXXOhg6wcJfqSa8Mgnmt2geg3Qw/T6cukt0XYsRQ4Ne8YQso6QVMEDz3e4jcsQD
         ioxWeqLJEIcRkfx0Pw1EhheaiuMaHlR6/NqyR3t8jtlQcGkNPCtJ7nUrcQF0uhhcq3bY
         LAnB6g0g7dvzu9ybAdTqSzdtfZj7koJ1Wemk6IYWkxDau5DnA7eXTT/m0Uwfdv3RvVmS
         UwhQ==
X-Gm-Message-State: AFq9FYLQ85/Rc4cMgAx0Zr2YenHizwKFJld4lXWqrzbhovHvMDk/Oy1e
	WEWaFxlbvnK1pyavKwI9MSTs30Hry4Ft73buzkY5Rl2OsZNo75VWoQIi
X-Gm-Gg: AYBFou2UwogP6qmY2nDGlp7OO34NxaiqIAl4/PSmFRfRoa2WEaGt1+0NCH/rjYeE+s2
	q0mNe75liORiLBWTzBD9fW/str+m8GQ3oDQYdIn92T/U8BdWKfg+f15dbZTtCD6Ofve3JiX+sci
	9AvA8Vx/jsBeoeLEWAJPp/6eeTJEkpDEsYcN01VgP8AWOcW1ShH4Av+gBxstZZyq68lMph4lD0q
	OnwUu1Vxa/64NC4Jiq3gl/PEA3wWwgiaNCwGU6vlPttWYNQBqEQs7rBrB8r1p4eVLn7vNDcyt+P
	y/LKElKq1kKvEtlz6r9tDdn05iyeo6mWMZ30oNfeRWFu1cYb2XYBaD92VFuH9yhJhg8vBKXgqdY
	3sYcxojgppY5tcLh08MRnjYfNgfhTgODEhgY4XSEDDUazAi5Gy9AF1UTWcLx13hkiTx1MreEToF
	ih7Exogj8HZqv2YlfOw3d9CHTbBpA7zlXk8yXf9ThkfHhhVc0i+212I6zJasMhEYo0Wtoj6nCF+
	iNSnsRcwSSWCVVBFIqbOUvVrGWskekccPyR3Iq7w1thSH2AbeRpTrNweUZO8iFVXN7Hamvi9AWm
	M/xvZ6aaDHpTQ0Gq1VA=
X-Received: by 2002:a05:6808:244d:b0:4f8:4ec9:b170 with SMTP id 5614622812f47-55bfff9736fmr6281431b6e.2.1793114286462;
        Tue, 27 Oct 2026 08:18:06 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.39])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c04311a8asm8009673b6e.16.2026.10.27.08.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:18:05 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	James Clark <james.clark@linaro.org>,
	Long Li <leo.lilong@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Javier Tia <javier@peridio.com>,
	SJ Park <sj@kernel.org>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Likun Gao <Likun.Gao@amd.com>,
	hongao <hongao@uniontech.com>,
	Kees Cook <kees+treewide@kernel.org>,
	Cihan Karadag <cihan.cihan@gmail.com>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix out-of-bounds da node read with a crafted record count
Date: Tue, 27 Oct 2026 23:17:54 +0800
Message-ID: <20261027151754.975492-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_da3_node_verify() bounds the on-disk record count with:

	/* we don't know if the node is for and attribute or directory
	 * tree, so only fail if the count is outside both bounds
	 */
	if (ichdr.count > mp->m_dir_geo->node_ents &&
	    ichdr.count > mp->m_attr_geo->node_ents)
		return __this_address;

The "fail only outside both bounds" conjunction is forced weak
because the verify pass cannot tell directory from attribute nodes.
On filesystems with a multi-fsb directory block size (mkfs.xfs -n
size=64k, sb_dirblklog > 0), m_dir_geo->node_ents is much larger than
m_attr_geo->node_ents (~8184 vs ~504 for 64k/4k), so an attribute
tree node with a count in (attr_ents, dir_ents] passes verification.
Consumers then index the in-block btree array with that count and
read out of bounds:

  xfs_da3_node_lookup_int()   btree[max - 1].hashval  (max = count)
  xfs_da3_path_shift()        btree[nodehdr.count - 1].hashval / .before

with count=8184 the read lands ~61KB past the 4K buffer, and the
out-of-bounds "before" value is then used as a child block number.
The read path is reachable by an unprivileged user via
getxattr/listxattr once the malicious image is mounted.

Tightening the verify conjunction would falsely reject legitimate
large directory nodes whose counts live in the same interval, so
enforce the per-fork bound instead where the geometry is known: at
the two consumers that index the array with the on-disk count.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: f5ea110044fa ("xfs: add CRCs to dir2/da node blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 3d02a0d7ba44a..ab3deff11111e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1787,6 +1787,18 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/* The verify pass cannot tell directory from attribute
+		 * nodes, so its count bound has to allow both geometries.
+		 * Here we know the fork; enforce its geometry so crafted
+		 * counts cannot make the array indexing run out of the
+		 * block.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
@@ -2161,6 +2173,11 @@ xfs_da3_path_shift(
 		blk = &path->blk[level];
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 					   blk->bp->b_addr);
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
 
 		if (forward && (blk->index < nodehdr.count - 1)) {
 			blk->index++;
@@ -2227,6 +2244,11 @@ xfs_da3_path_shift(
 			blk->magic = XFS_DA_NODE_MAGIC;
 			xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 						   bp->b_addr);
+			if (nodehdr.count > args->geo->node_ents) {
+				xfs_buf_mark_corrupt(blk->bp);
+				xfs_da_mark_sick(args);
+				return -EFSCORRUPTED;
+			}
 			btree = nodehdr.btree;
 			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 			if (forward)
-- 
2.43.7
