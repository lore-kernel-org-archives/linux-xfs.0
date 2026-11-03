Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716409;
	b=Jn+vInLIy3i+vkfPKEimED6IEzIjTusRlr625bQd18or/dfswhzvb1nzF4sVU/Yx5nhE
	 pJxm7Yx6s3nWnWU2IxkgyMpyz0cpac/ZUQV5J34Jr3U9zKH9ysIqe4LOgyT9fekGb1zA6
	 Bll4Mke4nfhO4CWmy8SJ3LMHR9OnljbdMLURSYR6hEFh2ik5thLEh1aFJN1zg1701PZqL
	 wXHlA3mKC+2brrPDfzgf3f9cSSsu2nv7nGBkquqBih9lLrkFR1MaOk6eJbXXSHC403bI6
	 3goBdMzAp2fMTX2/zVAT02oed93tSe1W9KzYjRG8ddM6PUiDJn/dtrgue8xTYjZ5VlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tI+UwBYPAdWdAqb3dEv/Iv9MEi3mF5GYk2Iq/sV6Q+g=;
	b=oG7/oDGFME4Zm7HP9rpPnxsWuAOj/UBIErJ/bCyzCMyDKbrU/ADFnAF4AfdHFnAuc6u2
	 mlLYPYMZEsGCSQYl0PbN5h6qj8LS0VC2/XTv9xRg7kcltYhwb7gZh+4jFzUI9gBjRW539
	 CYSaILZppot+ioDrw8/MFEMbAPyr3ELniRWeMaBOLgXvr6IGAkoJW+AmASWe8Yy9WpGw4
	 3Vjpr1r07zQjAn6szOuldmkFDnR7G0vSpIhZZT5yZH/Xq4Ui/10C0isft3KvgZGG+Foa3
	 hU4OGq1iobzHXPUgrAkecU3tIN71qj6r/GflgW+FzOxs6ovkJTZB9ShmILxZivE4kWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OMakKWWq;
	arc=none smtp.remote-ip=74.125.227.135
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B80606A327
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52B80606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OMakKWWq
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3ac63aee1ecso1185900a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 06:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793716409; x=1794321209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tI+UwBYPAdWdAqb3dEv/Iv9MEi3mF5GYk2Iq/sV6Q+g=;
        b=OMakKWWq92Jd+LPrw2dMjUdTbbCAHgwKqsXYpnakA0v1IJIkLsk4HcA6AbC23W5evB
         tBOnUGm/ka/t1RUwhJg+BHoPaU+s00V6u3Fe1ySkT1SBqwNnxJyzcLx+qHUoRYu32qhP
         tXVZErMxSmBKIh3vGaM8ZQnRggivAf8MstgCX58MI2A/pAiHxCjpybxhMMRYYxvK5Mqk
         m4teoOc30twESU7y+jNP2M7ZEUioy8qxI+whMvVDc98MA50iAUcLcIsXt8dD5CtmR1Y6
         gRxgV4ApYBNEUqoUkpRJ0jyPFall9y1XOJZnbNjJs2eYgcoJ/SYs/A50n2jOFhvZOc4G
         CQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716409; x=1794321209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tI+UwBYPAdWdAqb3dEv/Iv9MEi3mF5GYk2Iq/sV6Q+g=;
        b=m49gdTk3FAQampvaYTAdszIqdM5S3i9gEteOJftofe8HaiDb1+dBzihxfYeni9JP6O
         JZH+S/QZi7+NDj0rq8B81oh4PYmuR9BhJNyn9dALmkCJKY0a+Gqe6+euqyju/VaspTG3
         LJtJESWNA2xt1NvCwt6LBzCPSLH5iCke9mn+j6LNskG1wiymFwOfW7AeEkWGyLx+skio
         HfwQXEToo3WfkwK2O/tYDps1hh/oEMMGh40xWDr9KjabWmU530NBXxMVMpYLab3sPWGO
         9ey67ZYBEc7qKwWcKIrirzYtxkcet+l1fpHjQkx3zQ4RplSGTh9nFtdplonxv+bncQnL
         0pcw==
X-Forwarded-Encrypted: i=1; AKwUvBwZbX4oEzeedQTOTx67aqAmOSOeGOOv4wjZLG+2pDjufV9bZS1wKYsMjHGf8OKJ+pVMLClftAncZ20=@vger.kernel.org
X-Gm-Message-State: APuU4Z/9Q9sE6rnGsFNq9D0mLAGE0SdozE832DN6YwWx42lCNQy/8tkc
	kavbDE1apwM4MxjzFbsMQoTyf48jpJidyQW/lsCWf7bKFqhcluw8XcxWMgxPYjexxmCVLVtW
X-Gm-Gg: AYBFou2YayoguZ0cl5FgF3dd3wdfxvtSHrfpA4VdbAbTOqUjyvf/c51Q4pSr66An+AT
	WP8N97aaoGVu5vA9Bnt2/3mpHUn2gxcDgPvUCS2rEc97Va71vJseLliFoGbMDc4jfZyj6Gweq06
	yAOoqKmGmoauN+7Cu/ljRU7kAcjhUEsU5NulYu88qYqE0oPwq2oiUoxjX0+hx1sxvd1KM8nTHrK
	Ydjl81ftWx9L/Sk6T+LnGdJS4jVIPh+IORHgZpvxpM80ZvIvf1sfgEMnC//aJEyfhyj53aSb4GB
	UaTeQagkSNg0c4v3/lR5/qERHqv3F//yNdmZ9Wp2Y9Rdm6Zn+1a9McxBk/sfJ8hpeo7j4bQRart
	cspsYMSCfGgkjRZrtObjdgeLGgLsJKcOx+AqHrPCBay+4XWhywpfIJxafJLxRsoEGQaZUGq3e7t
	mG/F9p5Yn7th2eiJjWXIjUYAXx7nk6Lh8XViQDvBRkaFjcWr9YcMjpkrZwkaGXWW2vNUAeXisnt
	c5RmfeJQOk7GtbmBEE8JIIsjT8+heaHlhnlwK2afGzbIdqQkSbvdx7fKdP28JaFBM2ST5HJN6mX
	Bbd8gnG1PWETaXUp/ehVxc45x7gWWp6H8mK0bKGMjown2rT0FL8/Lq3Q+h0a77iabF3qHaUSRXT
	6aj9sTom6cu6tOCeARTY5ifHJBMF5WylziqcuaFvucJDfct8wXOIxiGVEAcfNF3LRmg==
X-Received: by 2002:a17:90b:4c08:b0:3ac:adce:60a9 with SMTP id 98e67ed59e1d1-3ae8957cc59mr11107986a91.9.1793716408508;
        Tue, 03 Nov 2026 06:33:28 -0800 (PST)
Received: from localhost (ec2-18-182-19-4.ap-northeast-1.compute.amazonaws.com. [18.182.19.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c9b0ec5sm4698225a91.16.2026.11.03.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:33:27 -0800 (PST)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>,
	Viktor Malik <vmalik@redhat.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH] xfs: fix inverted action for empty leaf block in xfs_dir2_leafn_toosmall
Date: Tue,  3 Nov 2026 22:32:58 +0800
Message-Id: <20261103143308.10870-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Jianyun Gao <jianyungao89@gmail.com>

When a directory/attribute leaf block becomes empty,
xfs_dir2_leafn_toosmall decides whether to delete it by calling
xfs_da3_path_shift to find a sibling.  rval is non-zero when no sibling
is found and zero when one is found.

The code currently sets *action = rval ? 2 : 0, which is backwards: it
tries to delete the block when no sibling exists (corrupting the tree
by self-merging) and keeps the empty block when a sibling is found.

The analogous xfs_da3_node_toosmall (xfs_da_btree.c) uses the correct
*action = retval ? 0 : 2, and the non-empty branch in the same function
uses *action = rval ? 0 : 1.  Flip the empty-block case to match.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 19cb536e53ef..55244d153f84 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1546,7 +1546,7 @@ xfs_dir2_leafn_toosmall(
 			&rval);
 		if (error)
 			return error;
-		*action = rval ? 2 : 0;
+		*action = rval ? 0 : 2;
 		return 0;
 	}
 	/*
-- 
2.34.1

