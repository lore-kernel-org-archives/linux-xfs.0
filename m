Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F83466B55
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 05:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059637; cv=none; b=FE9lUZsGOwhByx9m46DPgY7IGeAMqvDsncwBW1vYzESKy6hicUW9QsB//We+THHUCKGt908+EB0g6ZeBRd5zT6qCXtq5kjynFPq1KDz0tICTBbTmpEEE2w5V2UZ+TyaOSvqvjgLbfdpCHcUTR/zX8RiS7OaNRkHRwncJ6o1gNFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059637; c=relaxed/simple;
	bh=E3zv7IA/+L1MFH/7gJ+yPjJ/sewV66njBZXMTGjTguk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LY7Wt3OJDOJov9mCO2ARZHFuUZSaVo6h2r/U3kTRWqVSyk+DL7l5KnUA+VUewGEN3KMstEBS6n033WwkSZjmI72ZYCa900jxYBwV9w7RzDG8bRBsxJpReBmCd5CUycWs5KCc8Hma7I7ZsNu0+TBOUPHFnWWDOGYuJPbHZA9GJdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1fiY+y7h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1fiY+y7h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yZfsSOq2EU10W3QrRMy4oTJkuAEBhhWmqFqGxHStvLU=; b=1fiY+y7hNvmMEMzm6iBMeTYYpU
	AkxIL0kZKVBJ5Hz6nWzC54T5y1/vGfk2vqqfa+/fefJQBSKO4I0Ebb8cNuUaaLNK4iVvqR8bOeU44
	EGhhVT1nMfB0cxxhq52bJNZg1D853g7pVp9VnRFwSWLFXjWQYWoEznyUBJEjG4xRASeRPC0ulgXv1
	6jIzCwfgCgiBKKjefbVxcL0Hc2Zr+L3aZqQyC/lA60M+uanHKEsFwZRJaPlFHf6oRmf/a+cS/f5wF
	EEfN5TnmqsMDrKu0JY00pmZZ5+2vozoNb71TRYiVDZYkhZvGAjHYByLYDwL5rTtdofluAWV2MaaFt
	30OHXTkA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vinDt-00000006TFf-1DJR;
	Thu, 22 Jan 2026 05:27:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification v2
Date: Thu, 22 Jan 2026 06:26:54 +0100
Message-ID: <20260122052709.412336-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has a few old patches that simplify the LRU handling, and
moves back to only having a per-buftarg hash now that the buffer hash
is using the scalable rhashtable.  While some of this looks like
performance work, performance and scalability is unchanged even on the
80 core dual socket system I test this on.  Besides cleaning up the
code nice, it also happens to fix a syzcaller reported use after free
during buffer shutdown, which happened incidentally because of how the
tear down of the buftarg vs the perag structures is handled.

Changes since v1:
 - add more details and a link to a commit message

Diffstat:
 libxfs/xfs_ag.c |   13 ---
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  234 ++++++++++++++++++--------------------------------------
 xfs_buf.h       |   20 ----
 xfs_buf_mem.c   |   11 --
 xfs_trace.h     |   10 +-
 6 files changed, 91 insertions(+), 199 deletions(-)
