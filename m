Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=71.18.227.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794081028;
	b=DRWRpDV3zJPvbiszLCtCryZYE2xIBZgDwfBi7fMBXIgLk4w1tagYoLaOh6UO+q949Yhy
	 /Ch1zU3HY8BJCZB+GxG3ysBnCUVIMYuCPlcvnvZchTE+NBl4iYzDS7jA5pur/8ePRepq+
	 +M4oGR6YidKiiuxCnl4mocvZDPeDSTEgjPJVXX0yLsw734K6xLuCd8ERdXV4UeLUe2KIW
	 jgO2mWpQZeDm38rCohMNHxDLTX12KBnrcKHmI9/lW780HuHbwcpl6HoQ1bqyv4kzr7yIv
	 4+esBZe7YUosrXnuxqqYrr2pnZxpb+yxxbv85a1DyNIUM8NjTqiBxaEpGD9ERddEwGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794081028;
	h=DMARC-Filter:DKIM-Signature:Date:In-Reply-To:Cc:Mime-Version:
	 X-Lms-Return-Path:From:Message-Id:Content-Transfer-Encoding:Received:
	 Content-Type:References:X-Original-From:To:Subject:X-Mailer;
	bh=wuFiqEMNXobyrUZZEbIg89e16nK+cSGEJ9lSVhiQV78=;
	b=CAfH6S9dTJHcQ8gjddqYAIvKjeIdvmyHvBDywfZK+tmO78yIkOvqY2NUPD1vPI8Lk7JM
	 z5FkhfGOtguwL0FhKNjCNu6tEi4lPS4+OvThqnphEXV6/Iy/LEzFNm4uG+aovv99oHbwL
	 9L8grcFhaf6GFOmQ5uQpCxw0stieecclNaQH3fUeYU1wWwH8IyNrsWxl64GF0t/3bKWAP
	 ggOmx8r33TITXFoVEm8f8IiRrmzv2dDP8Qt12i8M8N+xrSXuTmUrHbKS3dO5NRp4aed7T
	 WvS1PwCLFJoZL/yqP5dk97Yzf4kbGeoRG/dEgHxAiDdQjrTTdWDhYLLNy4k4ybdv8Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cherr.cc;
	spf=pass smtp.mailfrom=cherr.cc;
	dkim=pass header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=iHoVxQV6;
	arc=none smtp.remote-ip=71.18.227.4
Received: from sg-2-4.ptr.blmpb.com (sg-2-4.ptr.blmpb.com [71.18.227.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4EF606A33F
	for <linux-xfs@vger.kernel.org>; Sat,  7 Nov 2026 19:50:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB4EF606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cherr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cherr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cherr.cc header.i=@cherr.cc header.a=rsa-sha256 header.s=feishu2604220257 header.b=iHoVxQV6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2604220257; d=cherr.cc; t=1794081015; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wuFiqEMNXobyrUZZEbIg89e16nK+cSGEJ9lSVhiQV78=;
 b=iHoVxQV6LrBJGI5+0igVfFV5iyqWZPAL/An2MtaEI+AyhFQ96EDIixTCi3l2b3TMsyF6Eh
 KXiZt7MUP9oUx+r88fC2VKFIJJWAsOADtSYFh/+cXC8luMppDZzZcwZLyi9iPAp4e9tWHy
 9t5V3k4CP+bJPFMZeR7Gp7AUW7a+MD91ouYNBKrpdCmLQqUtYq6uaNPkM/SV6psk+mRfQD
 hulIUi5LA9xP1GTtZx8xstQUYjAB0LerbptG7tvM2ds0WE8vdmZTEomoF2Zwhls5xMy68H
 6fNh2dwHhN4HCp7aFNFjFcMUrMjnxzmTKst4mx3OZdnX71VPi1WSfkn8I0VYEA==
Date: Sun, 08 Nov 2026 03:50:00 +0800
In-Reply-To: <20261108-twin-20261106-fs-xfs-da-node-v1-0-0d4bd47938ba@cherr.cc>
Cc: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Shengzhuo Wei" <me@cherr.cc>, <stable@vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aef80f5+1ecde4+vger.kernel.org+me@cherr.cc>
From: "Shengzhuo Wei" <me@cherr.cc>
Message-Id: <20261108-twin-20261106-fs-xfs-da-node-v1-3-0d4bd47938ba@cherr.cc>
Content-Transfer-Encoding: 7bit
Received: from [127.0.1.1] ([111.40.58.155]) by smtp.feishu.cn with ESMTPS; Sun, 08 Nov 2026 03:50:13 +0800
Content-Type: text/plain; charset=UTF-8
References: <20261108-twin-20261106-fs-xfs-da-node-v1-0-0d4bd47938ba@cherr.cc>
X-Original-From: Shengzhuo Wei <me@cherr.cc>
To: "Carlos Maiolino" <cem@kernel.org>, "Long Li" <leo.lilong@huawei.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 3/3] xfs: bound attr node entries in listxattr
X-Mailer: b4 0.16.0

xfs_attr_node_list_lookup() walks the attribute dabtree with the
on-disk node count and indexes btree[] without a fork-specific
geometry check.  The node verifier only bounds the count against the
larger of the directory and attribute geometries, so a crafted attr
node can pass verification with more entries than its buffer holds.

Reject counts above mp->m_attr_geo->node_ents before the btree[] walk.
Use the existing corruption and sick reporting path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
---
 fs/xfs/xfs_attr_list.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index f751edb930b6..667740e37c83 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -258,6 +258,9 @@ xfs_attr_node_list_lookup(
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
 			goto out_corruptbuf;
 
+		if (nodehdr.count > mp->m_attr_geo->node_ents)
+			goto out_corruptbuf;
+
 		/* Check the level from the root node. */
 		if (cursor->blkno == 0)
 			expected_level = nodehdr.level - 1;

-- 
2.47.3
