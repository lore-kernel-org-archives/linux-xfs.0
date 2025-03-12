Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D51BDCF;
	Wed, 12 Mar 2025 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761949; cv=none; b=fSGO9GvpOWkE+E2WAT/U6hDnkWaJuyOaUx8CZQpMJs48aoSPtnGgLuDiYlbcYPAJJfqjFVT0LzjiaObXZ2OZT7tcOOuv7nHCW5iDC5GoLt1OAUGSNACWVA4c4p6OLilq7D928xYgNYw/6FCE9aWk+GS51PT12Sw0PQsD0jw11Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761949; c=relaxed/simple;
	bh=ZiFK445Fm9ga15GozLcEHxKHLU6PjXIJtKvyaHCA8SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+ixdO9lQPUkXkaH+nOF7TXgoCVpHGah+TsMqmExLq318TsY+36JiQwWhC0OqOGonWXtpb0mbpE6xehP+0gyy58/OPHM3QalNJh2cpN6NTQO/LbxBwyz1YOMFAM+IkALmD66GoZk/Qdts91EwFleM2hd7l8sbbt3vqb2TJmWYIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dL6coCwZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dL6coCwZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FABb7VRvCfRKUzVM44IPS4mMQGvnlut7f5XDm2RGHsU=; b=dL6coCwZl8qEjvgvdaVUl4Diqm
	0X4npsp521udWJJYflJAD9pWaZCQ5tKOx1pDVJ1OEO21oycw6SsMzbI+Zl8xvHBsShciK/dSPZEKB
	LopO10qCvF+XfJOVaPEX0NxV17NhDoufoTYVn0fIe8NVAVV2FU/KFfPZhcNi4tezE9POJgtC+LOKC
	WNFN44EO49FIatccXUo4Arq6SjKJWqM4K4MxckUEgZrJjne8UIQXgU4KY2aqBp7+WPRgXdmG/XPxU
	Jlxuj9UkgMScLFPgKcuSVAud7yUknIxxL3fTSwIgz/YKCU6pvHCSGQaKHC8f1B2WnpH048Eyenq5k
	hqOUmpaw==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqd-00000007cj0-0YMW;
	Wed, 12 Mar 2025 06:45:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/17] xfs/177: force a small file system size
Date: Wed, 12 Mar 2025 07:44:53 +0100
Message-ID: <20250312064541.664334-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test make assumptions about the number of metadata inodes.  When
using small realtime group size (e.g. the customary 256MB for SMR
hard drives) this assumption gets violated even with modest file system
size.  Force a small file system size to side-step this issue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/177 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/177 b/tests/xfs/177
index 82b3ca264140..8d23f66d51b7 100755
--- a/tests/xfs/177
+++ b/tests/xfs/177
@@ -77,7 +77,9 @@ delay_centisecs="$(cat "$xfs_centisecs_file")"
 sleep_seconds=$(( ( (99 + (delay_centisecs / 6) ) / 100) + 1))
 echo "Will sleep $sleep_seconds seconds to expire inodes" >> $seqres.full
 
-_scratch_mkfs >> $seqres.full
+# Force a relatively small file system size to keep the number of rtgroups
+# and thus metadata inodes low
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
 
 junkdir=$SCRATCH_MNT/$seq.junk
-- 
2.45.2

