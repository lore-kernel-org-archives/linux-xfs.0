Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292C2488D84
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330184; cv=none; b=FywnSWGFvvVdGouAU6vyJIdpjfZXffh0Z25f2U+yulDTtOqlKlfxsCIHMsp/LpT68YSBvYA7hy1TpA8HF+wvpcPORbvN7tQMQ79/X2DTX7MXPF61mrlHlfF0Bu0tcCDIktjBUMnAasmhtppdKQo1j82e8f2OjYzaMlPUCOQ/Iww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330184; c=relaxed/simple;
	bh=QMU3w9rXa3aVjaeLREllsbnwz1dutjPG4TBobE52KBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UHzLLFjzAOrGZbiwS6raGOG5eMShQCcmLde3VOKN3Zm7N3QP7ZqFHE/O48AVn47lyPcxuSu08DgUNyn2UE5vjQ29OSvqoBffnuUukXQCu+QaeTiSdX/Sgyk1eYfVKWNwi3wgI5C4cGGGo3SL6jjHrR8k+0/5bKGnv0EIFz3ioaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AyO5zZgN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AyO5zZgN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=H0wSOuNjsW6gwcsHw9AVYas0v/gY5Wy7JmneQ3iHK/4=; b=AyO5zZgNn+1dOkIBYrIwGADeTl
	UOdZwfP7AIumlaZOJABRK8UfMxCm7p1GzBhjE7gkKSY2Jfh/ktwzv/rkt0yJl+UJKzuhUj3or/SGS
	lZxdvniRY5ESzP/zxxIDjvgdDcBEXkLbPb44EkKRGDODJWxwWi19EnZSZfFESwX1b7PSOz0MwcXgY
	BSyBnTBmABgGpZmeoVb3HHuBX9p2u8y9vi/z/mpCKyPBZ0LSSiC1iAIPg5V3+S0cYYw0c3nXVYdyu
	/IgohZKFTB7XUWUZPB6R8W15GnuokoIa6fksooMihDQiU42iv0zkSbveDmkmQ1oiqQlWWM5BbR9QC
	u5v5h3Xw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3w0-00000004Wdc-3aKU;
	Wed, 29 Jul 2026 13:02:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned GC fix v2
Date: Wed, 29 Jul 2026 15:02:47 +0200
Message-ID: <20260729130256.2282092-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this series fixes a potential deadlock in the zoned GC code, and
also adds a comment in the same area while looking at it.

Changes since v1:
 - improve a commit log
 - improve a code commit

Diffstat:
 xfs_zone_gc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
