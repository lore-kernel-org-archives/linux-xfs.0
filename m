Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B2145323
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 08:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432430; cv=none; b=D1S+e5ko3DHSyhFYMLqFq1gTuNZtl04MtGRSyWSTxujOtTfR9G6lA18bcWnyjlW/soSQY+obmdp3RwlqXdxjjlG759oobioUmvIF2WYMMCGoZthwohWKrAt+8vv1qJZ8s7bKxCvBDokD7P0qGq5+/TrNBJKpipaPVrWOqBYRuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432430; c=relaxed/simple;
	bh=Ldya9+ZXHjKjFlbqHRlwdTpttV/IT1HvHFQJE/ulyk0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Fo7t3sauigxsuspUPkE7pl3q3ngbbUP+MItP198di7gxVYrZUc0euzy68wRXthXpCDWaQHKC2nxJ4wDMWZo3s35CnnkSZ/0nqsI3rZUfyLLQ9qjCITuK4lQwzbpXhInMj3bCpWKMJtCkL5ueZnETtYXKt6KppmCL1IAweINcJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=XEYa/Y3R; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="XEYa/Y3R"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 5BA15240103
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 10:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1746432421; bh=Ldya9+ZXHjKjFlbqHRlwdTpttV/IT1HvHFQJE/ulyk0=;
	h=From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:To:Cc:From;
	b=XEYa/Y3R3G/pZxse0zPoRu9I07BK1DnFj1NztBy08TFL8r2eQN1JK3bvCm68reeIU
	 9WA10nw+WswPXv1nprXJPuLxdvAlYKIsbgxsokT72Q48BfynY+wUxrsS7PxG6kNo/t
	 VYGMS6x+ywgpuh3wSVaLM9XJBEdfoY+ACcfrIGTMoeakmawVFmtaJg4j0041mtWYJu
	 7La8ff8EX4O8Qbdb1dfmeOxI9r4ONenyJdr1OO7cxbxa7J31devPsrbZqyqMdh6VTP
	 x3HNBXP1+M5yDyfQUsuS2j++5JXReAM0gty69mX1FXRRgkqBNzWy/Yxo6kMfY6bp7i
	 3NI59mlpMQTmQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZrYyr4TLVz6v0b;
	Mon,  5 May 2025 10:07:00 +0200 (CEST)
From: Charalampos Mitrodimas <charmitro@posteo.net>
Date: Mon, 05 May 2025 08:06:39 +0000
Subject: [PATCH v2] xfs: Verify DA node btree hash order
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250505-xfs-hash-check-v2-1-226d44b59e95@posteo.net>
X-B4-Tracking: v=1; b=H4sIAI5xGGgC/3XMQQ7CIBCF4as0s3YMoLXVlfcwXSAdhJhAwxBS0
 3B3sXuX/0vetwFT8sRw6zZIVDz7GFqoQwfG6fAi9HNrUEL14iwVrpbRaXZoHJk3Pmk4XYdxlFo
 ZaKclkfXrDj6m1s5zjumz+0X+1r9UkSjRkpGWbD8LcbkvkTPFY6AMU631C+3AZBKtAAAA
X-Change-ID: 20250412-xfs-hash-check-be7397881a2c
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1746432407; l=1894;
 i=charmitro@posteo.net; s=20250412; h=from:subject:message-id;
 bh=Ldya9+ZXHjKjFlbqHRlwdTpttV/IT1HvHFQJE/ulyk0=;
 b=SJ3FkV+GKPNOvm3hS93MfHLRitfL7HsXcS9xRaNSv7acsN8cUpR3KSTgni1rf+tGsjNGlZv55
 /zoHwPbpy53AR/9r8HxOLnOS6zX8v+skHwh1jk+HKhbAFxVhA/CaSYx
X-Developer-Key: i=charmitro@posteo.net; a=ed25519;
 pk=Dwccy7f4QM74qKQFgkWc/EpYGEDY0qvP4cycC87VXeQ=

The xfs_da3_node_verify() function checks the integrity of directory
and attribute B-tree node blocks. However, it was missing a check to
ensure that the hash values of the btree entries within the node are
non-decreasing hash values (allowing equality).

Add a loop to iterate through the btree entries and verify that each
entry's hash value is greater than the previous one. If an
out-of-order hash value is detected, return failure to indicate
corruption.

This addresses the "XXX: hash order check?" comment and improves
corruption detection for DA node blocks.

Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
---
Changes in v2:
- Changed comparison from <= to < to allow equal hash values.
- Updated commit message to clarify "non-decreasing" nature of hash
  values.
- Link to v1: https://lore.kernel.org/r/20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net
---
 fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..7c42be30c3eb746e12b457ca6fce7c88ac191ba8 100644
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
+		if (curr_hash < prev_hash)
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

