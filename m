Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2710F79D2;
	Mon, 17 Mar 2025 05:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190703; cv=none; b=FD2/sksnnzHxbQxEXqcA+nzbMMKs1S4C89Owt+cZZ5THExI6B1cxRCgWWI12HE3EIU13omXpJtenBc/HwgS5zp5qG4sJo5j0ZGb3ZDQh6FmI87v5/g+O2Haia9edf1EeXizTot4DSYROp9qdUYrgwbcz/tBRws7FzlwdYR4h8iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190703; c=relaxed/simple;
	bh=r0xUn66OUPZkr0Gtf7amlVHFYTEOxaVbbeQ2w4cZyQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P1ge0mSpJvJGLVd6A0oguIVDMNMhNtbNL5iMQi2dU3ZD3QG57pax/FZ/kB0piOK8ush827J0okfZYX5QlKtwRJ1WOIYibeJeGopB3+z3SxcNrdyVzs7tQna6OtNaeiO9s44E9xLU8dOF9kr6241esPXF+2ZZR1OXb5DeTCqgCKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O0EmVXfO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O0EmVXfO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WiDeWt7a9Co+cnuYh5PnNaXRU/0t9jm2lDKAIy0uey4=; b=O0EmVXfOgaoBafAzWY3ugtG+9G
	n8SnuZyzXEf5YUz3ZneR2haPaU7IzJz59DqZTo27RinzVvMHpbAbK5pWtvR6flhlecLPCAvJwARk0
	W8mAfcJFf3NdKRBQnwiDKiQeDE00cwwbKIKpqgdKwxBa3xraAjuO0B6WFwYrPB0dLR00BkXXA8c3X
	entvvn5bo1AKK5olenkOqP9tE0Al5jVAxjSUoTOp27HP1u7M7/z8CqWgvQToE46HvafAeEKV7JDPm
	exNU70RmvDTOaDeJ24runc3zQKMsaHyiXrya+6PvmJ3ptoNvbxWRWyV9thOvXKL0o96TrNkQYpLop
	Y9A9zHFA==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3O1-00000001J9U-1vrL;
	Mon, 17 Mar 2025 05:51:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/235: add to the auto group
Date: Mon, 17 Mar 2025 06:51:38 +0100
Message-ID: <20250317055138.1132868-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/235 is the only test effectively exercising the temporary enabling
of SB_ACTIVE during log recovery.  Add it to the auto group to increase
coverage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/235 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/235 b/tests/xfs/235
index 5b201d930769..c959dfd6e33a 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -8,7 +8,7 @@
 # then see how the kernel and xfs_repair deal with it.
 #
 . ./common/preamble
-_begin_fstest fuzzers rmap
+_begin_fstest auto fuzzers rmap
 
 # Import common functions.
 . ./common/filter
-- 
2.45.2

