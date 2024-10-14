Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D2762F7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885935; cv=none; b=fuV5cVsYzZMdfzBKn0syxUd/LyvoUxq6J5DkoBCBqPr2Q6r4eHE+IWG2AN4A/YtIqO2MAd4xoJ22UHAv9IX+/cDeNxa3PhNS+vgxTSqXWkN5dFI+6FzEvOfICRQHvxbH3aGSQ3yHZJ7/iyvuSqwK9xJNTuCLaMbTkiJBRt4oP4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885935; c=relaxed/simple;
	bh=0DOuo53+AwZ/jms4C+JtYFzXPC9MlwwFuE3t0OJTOo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6UFMMQ8vtY70CA8Wv61XW00GfFcQZP/Rq2jZ1s55hOs2H30MWX+tVki03zyRQ2zhdihnkX4cT4+qYjcoUwX/3+TNilqqefqSmbfVYlARnwy5iPPTvi6exJIjNrZ3V4r2dsP00EfSFq21bCUwLhQOhKps5tSCVWUApteJYME31s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WqUT/piB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WqUT/piB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y/9goXeaD9/9jR2NKLR9msn8w7uAJbttQMwhzy2aH54=; b=WqUT/piB4IQoPbj6dNjG9FAmpP
	mEzcJB7d2ZsmzQithEAa1c+XOFCzXmBFp/cx1ilhEiL/3i7QLX/UOMxvTvcqd+MH45UeIb1dXlx5/
	cAaTb+cdWRuDhKaRP9UhPdboOk67jzMzkm2z4YF+8BocM+UdwimOXxb5xkt3C34Asp/a3RLuhdgFF
	JLBfHaasa2HIIh5QC5GuJfK8ueitNV02Vc15r+S47xDfMhN6qheT1nZNSOk2A5kRfnddmE4yMcWff
	GKsjjZhIqYTwGc10z/4b7OW0zRpy0xedc6sRQBVwyIpKzHumNtSksk62sIjKoxzA8XZWds68hq1yF
	jW3f0PhQ==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECz-00000003pez-0iSw;
	Mon, 14 Oct 2024 06:05:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
Date: Mon, 14 Oct 2024 08:04:54 +0200
Message-ID: <20241014060516.245606-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
which isn't really helpful during log recovery.  Remove the flag and
stick to the default GFP_KERNEL policies.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 8ace2cc200a60e..25cec9dc10c941 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -286,7 +286,7 @@ xfs_initialize_perag(
 	int			error;
 
 	for (index = old_agcount; index < new_agcount; index++) {
-		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
 		if (!pag) {
 			error = -ENOMEM;
 			goto out_unwind_new_pags;
-- 
2.45.2

