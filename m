Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940C43101B5
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906228; cv=none; b=kbzxZmNERPSnYgThW92+NvEXPyJ9Tc6dFcvw0hkB0T6Z/LqUqxISH+wOtGTJ09+mbDnXm8bTxk+fVJrN35gfEihQhcyRBBlJQzFswauJXojQku6FRvUNq1S6y78IToN+NNZpCylCx6d6Mw3UOYgcYT4Rl0eh0+VaJaA24sCaYX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906228; c=relaxed/simple;
	bh=lua3pQFonBFnE3jvuy56//6S61KkHcMOGMBuBbXUZL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLD0CJlzd2uwuuiiEsksMK9dXIsPLRnyb9yd16Fot9Okxf0DiWCr0k6jEaBsSiI2PWt0MAKBbH5vhri1vYQvb0emXPfWE9nh7fMmX9W/NKp6ozk4qWSv5t9r3OYRByfdVvcAz859h6mShGgQFnPob0sSQkr40J2lM76dIQP74Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VinDgaNj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VinDgaNj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lua3pQFonBFnE3jvuy56//6S61KkHcMOGMBuBbXUZL4=; b=VinDgaNjQ572fa/AnnP6ufnOhI
	o9yLE3yXpVIpJUDvai5GOyrfduUDUvAMqrkKo0AoCmRn0nP47WSIWW4DPQpWQbeGVi19HXn015zKM
	kz6Xs3rJr+n8ZpYC4d+ZdQKMXVVRpB4asru/umuK1YOjxnO/5mefqbHqQXefYNKBDIWhdPrr8Rdut
	H3b4fHP1t9DtL/tQxcKdI6LLx0ed/xuYNoBdYVZUwVGwU7HrxzLdQ4haoKLCuct1eq8UD3jMmmg/A
	GD+8HFUvFk/0W9UlnAluOXPVK0xD9aZs1tW3r/fjJyb3Ie2LB+2EuLQ+zgN9bDQg3hK//lrEoAJZN
	dXAUm6SQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVYsP-00000005cCr-30De;
	Tue, 16 Dec 2025 17:30:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: reject non-zone aligned RT subvolumes v2
Date: Tue, 16 Dec 2025 18:30:07 +0100
Message-ID: <20251216173014.844835-1-hch@lst.de>
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

this rejects not-aligned zoned RT volumes in the SB verifier and in growfs.

Changes since v1:
 - adjust a comment
 - add stable Cc tags
