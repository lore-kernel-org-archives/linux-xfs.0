Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8634D221F03
	for <linux-xfs@vger.kernel.org>; Sat, 12 Apr 2025 20:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744488261; cv=none; b=k55TYZ+QYXMZjhqwOTBoCjwqg61NCU8/r3NEP8EUc9igSwrt/khdf5KZ1a6jSryKD5T/CcbJPTpfzODYSEwrQJLCahQJrGfeLYyx9UO+q3Su777jMR+s10X0PMF8W54OK2fgJ7vVOmqcIvqGN/LhwWK3xVejB4uVpDnMIgOhQEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744488261; c=relaxed/simple;
	bh=OWz+aH8klM7UAUDqCrig0TrpdlpaKluF92h4yFy36e0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=J6D56dsvRuQwLB7oHLN8A//M9SekgGIudLr08g0sjePIDfEkXxjU/Td8ozFFYEZAZmHBBJuFdiwXkB/Zl2mEhnENKCKj333yjZRO22ijcLg/SEqEXCdPLybyUa8EQdO2GorZt7OLJlmUTn0ByvsAaso1vd1eIY3CXVoC0pW7nCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=qBUP54D1; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="qBUP54D1"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 46267240101
	for <linux-xfs@vger.kernel.org>; Sat, 12 Apr 2025 22:04:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1744488247; bh=OWz+aH8klM7UAUDqCrig0TrpdlpaKluF92h4yFy36e0=;
	h=From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:To:Cc:From;
	b=qBUP54D1qfZK36cVrlBNLbh+2nWmTYGzAHoHC6ZY6GWoKhKPGd8HKFzJzPIII/zCH
	 k/mChuHKA3RULPoEFta5AU4k7GEFZZ9PjZ83k2Xltzh+6QBjojznW7D1n68vfpyh3l
	 XboYnqpxWXONicWcJNfKZin1hk23v3i2Iy6qtP9zVyHiK16Lf5QQtXz4kFmnNv9448
	 Ojg6mS68MC0CEUd5ALuYwBo2IhEP5anCgOcFDne8MrSLnN95VqnKU2LbD6uR3qeqVr
	 CHP45rP7hVl7AMoUB/ceSEN3W3ne+BQAFRjqEFzOK4I2Si5IXc97kdBhYKOt4RPjmy
	 KDYAtCWMsbiDw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZZkyt5C2fz9rxD;
	Sat, 12 Apr 2025 22:04:06 +0200 (CEST)
From: Charalampos Mitrodimas <charmitro@posteo.net>
Date: Sat, 12 Apr 2025 20:03:57 +0000
Subject: [PATCH] xfs: Verify DA node btree hash order
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
X-B4-Tracking: v=1; b=H4sIACzH+mcC/x3MQQqAIBBA0avErBtIK7KuEi3MphwCCwdCCO+et
 HyL/18QikwCU/VCpIeFr1Cg6gqct+Eg5K0YdKP7plMa0y7orXh0ntyJKw3tOBijrHZQojvSzuk
 fzkvOH9Oj675gAAAA
X-Change-ID: 20250412-xfs-hash-check-be7397881a2c
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744488245; l=1647;
 i=charmitro@posteo.net; s=20250412; h=from:subject:message-id;
 bh=OWz+aH8klM7UAUDqCrig0TrpdlpaKluF92h4yFy36e0=;
 b=cBb1AvyINpf0A7xXg40VYb23V3WAlVb58xBF+YF0p1wdN/XbaBYsfWOBuJiqJ+50gJ5FNrq2x
 7zUbNnQUGglCMnAH/M8PBrVL/THQNmIfrUGixlkhnGZhyeetiof8sQE
X-Developer-Key: i=charmitro@posteo.net; a=ed25519;
 pk=Dwccy7f4QM74qKQFgkWc/EpYGEDY0qvP4cycC87VXeQ=

The xfs_da3_node_verify() function checks the integrity of directory
and attribute B-tree node blocks. However, it was missing a check to
ensure that the hash values of the btree entries within the node are
strictly increasing, as required by the B-tree structure.

Add a loop to iterate through the btree entries and verify that each
entry's hash value is greater than the previous one. If an
out-of-order hash value is detected, return failure to indicate
corruption.

This addresses the "XXX: hash order check?" comment and improves
corruption detection for DA node blocks.

Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
---
 fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -247,7 +247,16 @@ xfs_da3_node_verify(
 	    ichdr.count > mp->m_attr_geo->node_ents)
 		return __this_address;
 
-	/* XXX: hash order check? */
+	/* Check hash order */
+	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
+
+	for (int i = 1; i < ichdr.count; i++) {
+		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
+
+		if (curr_hash <= prev_hash)
+			return __this_address;
+		prev_hash = curr_hash;
+	}
 
 	return NULL;
 }

---
base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
change-id: 20250412-xfs-hash-check-be7397881a2c

Best regards,
-- 
Charalampos Mitrodimas <charmitro@posteo.net>

