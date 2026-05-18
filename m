Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035733DB65A
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 06:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779084149; cv=none; b=ndoz767zrMrKtR7fUMZmFElPkY8ZxdcghaBJuif+fTHEbSVcI1sIWds5iDe2iR9vsOjjLJuTSkwL/fP4gbnhq+1jTXlXXvrdDmvKv8252qo3dO19Dz0IntR8gK0WPdQEAXpGZH9NeRfFSjSsBXxS9S8QrwA134PwoJ7HVE9U2mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779084149; c=relaxed/simple;
	bh=30sML/qbzabI1VGhBsxZvci9BdCa7tAGJbBUu5beLTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qPZlA5XYLfTALdroiPZ0EtsTBKJ1Fs/rSgkGyiU8Z1rBexVVksib8UodH0m3IHyx/NMO/FPq4XwV8fPDfD46GZ3Wt4/1b/+mreeyc9g7rfKaIKUm6Ie6LuwXQitaeq3BSZ1M8wQe9NEd7z6ehOk4SugLxAW8VauEKlBNcSuR3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sHv0hxmU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sHv0hxmU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7TkF3kO6RcIJWIfdW+zga4pfe5iwsEvzQza+o850leY=; b=sHv0hxmUN/IcR1XCEsFtIsYG8b
	0Uyg/LYDGFrpwrhVygeMo3/PFOI9PCXOFKxP2V48skKB5Zq8MvNt29SFpcYhtq7seIOABWbxwKfPN
	dyR7SLjCk1KWW10y79ZSHM1u/sC3Kozw6hK8tg+een+9DvNkbaBxKjJqezraKaaFtgPsyFBhBoyEY
	4ZtDv4IA1RmzcN/0h0rOM5eY9bnUHfmlcSNMpg30I+reyRLAFwh+Vn66BVR2/P48vMeKtoDu/5z5r
	pJCwyaxJ+IfNbScWsTui22o00YVoWeXoVNAIrWkjjmWwpDe14Tmtt4HDdkbb2Jkdr0Z/RYVoztNXy
	E0tDv5SA==;
Received: from 213-147-166-103.nat.highway.webapn.at ([213.147.166.103] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOr3T-0000000ENQx-2pDc;
	Mon, 18 May 2026 06:02:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix a buffer lookup against removal race v2
Date: Mon, 18 May 2026 08:02:04 +0200
Message-ID: <20260518060209.502179-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this fixes a bug introduced in the buffer caching changes in 7.0.

Andrey originally found this when testing the fsverity series, and Carlos
came up with a reproducer using xfstests generic/579 with the fsverity
bits stripped out on upstream.  I'll look at adding this as a separate
test as well.

Changes since v1:
 - fix ordering of hash removal vs marking the lockref dead
 - add a cpu_relax() to the retry loop
