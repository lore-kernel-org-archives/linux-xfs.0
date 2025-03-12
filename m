Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AA41E51F3;
	Wed, 12 Mar 2025 06:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761954; cv=none; b=OD+ROlkE73BfvENlfNEdxmS7IF+aRcaoEpdw4pcQRn5lXJFOw1TvfaR2/jGiaJl3wibHkTUoZ9y7D/R/81E4azd5lP8kwzCa02eSXZ+/fIQX/8Q9ZwBigkl65MDv7JNxu/YeJ99wu1knyNyqxNkpa/xhSbQBFuWRhIn2r6uNnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761954; c=relaxed/simple;
	bh=ZitEwAydy+enmOnWR/0i6NXS52j6t3EL37N/HUAhGMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/R5tlumKNqK45Ue6VgptktyJy3r4I2cD7ECnvkJ1LF0ZV4iDWkMHbqiiluqaWD/CpdMDGMs+AL6v/0IptfY5/4rgVjn4e8rcKxD2mfKwVJDM4N5nIE+JErGXCZSuIjYH8ll8/7x4A6jUr/xFz9oA4P+DNzEAxS/pC2Pd0AM19E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZputGOrj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZputGOrj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=89iPUUS8gT/28hMWv/aGcwyRVz3k80H4Guw8VAWfhVU=; b=ZputGOrjCoA2escPdkISiFgF2j
	l9NpKAvytQRAbhHyRHZF5Oaq0Zdfgid8j27EVayqEQc3DN6bCGEQaIhHb7J7vsBrQrhDd5aSSGyOR
	VOswKZdm9Nm6nckMNk352lRpcFVpE0blAAuYCdXsS7GQuNkApfPcju7Cp/7i1pcS/lpG8nAXmCJ9G
	I2Tgor2aOIde/e206BItFn4x5arbiPCMgjJkn0YyXyyX2RtYQvPKbhT+8EIDxEa69pcn7h0boUld1
	S2hz6VpqwAywQ98AWVykVF5qNOPzpLY6f6wCC4EFlqxwEnPdr8BPAoDH46LamuL94XI26weLhwIi1
	yXVCgwfw==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFqi-00000007cjf-3zE2;
	Wed, 12 Mar 2025 06:45:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/17] xfs/540: use _scratch_mkfs_xfs
Date: Wed, 12 Mar 2025 07:44:55 +0100
Message-ID: <20250312064541.664334-4-hch@lst.de>
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

So that the test is _notrun instead of failed for conflicting options.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/540 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/540 b/tests/xfs/540
index 3acb20951a56..9c0fa3c6bb10 100755
--- a/tests/xfs/540
+++ b/tests/xfs/540
@@ -26,7 +26,7 @@ _begin_fstest auto repair fuzzers
 _require_scratch
 
 echo "Format and mount"
-_scratch_mkfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
+_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 
-- 
2.45.2

