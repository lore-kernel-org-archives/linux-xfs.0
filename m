Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65280155330;
	Fri, 21 Mar 2025 07:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541741; cv=none; b=rnnIZJJ6bxYqabg3khyIvgGHCVGGzYwXx42ybX9m2nru5n+aXWS4H4poNppXd9zHS839UeWVc0Nfni+1Kd0hlTCBjsR1WhrUes9pfg8+sugVzCKYp9VB8uzHtHAvG+s4EqILBfwCxIymJhaGVclX6Ln7avymzH7+BlRVrDqLJxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541741; c=relaxed/simple;
	bh=EwsG5SHT0er1vi16CnWn5qBPl1CYm4rIhMnCmPzNAw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBNttX8D/tZj7DKka+4vPhL+mWUfWFGXTCHWEfBL9VYNpMxRU7wpv6HURoNIwEOMtH7fMUpExEfyqs7mjVBbIGZSqvruD48Npjxe0pL6eG1cQ5xPX1y+cndC3O0Rnd6k3oJJiGQCYR3QDP9oL2l6cgCK5woPnV7Nn5HeHSKP478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3hwNjPyV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3hwNjPyV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lw7hPiIqwbd11YHqKohhne1m9Y3tugoyzwR/EGKxXQA=; b=3hwNjPyVKyLbMaS7NxBscdghUy
	nJsWf3KqvnHGEBPyxmgenwQtbdQ1u7QSfmeX7bk/bKnXSQ2LtoIYU4FQ46LiNckol4WQtH6pwdDs/
	Xm1eAlVCCdEiEJeNCc81VCta5/YYhvaWuWHTm3CEyTTSNzTLmePXOWB9IrEoNOsPUH5Z1RLwX/0uj
	AxZEv10K7WgTZQaajspAJQFEb5lx4dzuuxNPoAeviq+GhZCUJ2NQrt1LFtfE0FWXQZ2h9/ybXGHg9
	5gLSqnLROeZy0WSWyqYeEWmrp7NAgswUxYqL2I6j6lL5K9dmKBj+QU91jr5N62HtzDXRzgb1qZr8b
	NNdZpeDA==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhv-0000000E5Kn-1u7b;
	Fri, 21 Mar 2025 07:22:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/13] xfs/206: filter out the zoned line from mkfs output
Date: Fri, 21 Mar 2025 08:21:42 +0100
Message-ID: <20250321072145.1675257-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So that the test still passes with a zone enabled mkfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/206 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/206 b/tests/xfs/206
index 01531e1f08c3..bfd2dee939dd 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -66,6 +66,7 @@ mkfs_filter()
 	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
 	    -e '/rgcount=/d' \
+	    -e '/zoned=/d' \
 	    -e "/^Default configuration/d"
 }
 
-- 
2.45.2

