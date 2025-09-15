Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846E2D0627
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943218; cv=none; b=fXsgddCGC9DRn8Mf091FZV6VngIF6ZW1mmSaCoWvjp6Ip4nxgNPCFF6G8wPpa9kcGKErhn5ZapPlsRmQV24UJ2jMLKM4nTBLChqyN8pwMfiQuX0n+i+mG8TTypC1agp9hxad7/5NzyY15uDkrWxuyx3EYdNDwQPMIGCVj0E8T0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943218; c=relaxed/simple;
	bh=XG/bywve3OtVb8pgi73xbZERkZVudwAtCqdhNERsSy0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F1C/CBO8wcSXhKTQEDEVvzwuVs1B9IWfc07HHTOrOpITHg1fwjcbxiMB9Y5YIluvb84ky4/jFChNNmR7Sf5AjXaZ89hPP+x+IpZPHs8v3xlHhWCkQtu6BeSM/Ea2s0TkLTocrW8DH1Hen4jhibI4GKXv/F+cOhkjLhi9xdSYrno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XEYYf86Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XEYYf86Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XG/bywve3OtVb8pgi73xbZERkZVudwAtCqdhNERsSy0=; b=XEYYf86QATFQN6spt56QCsk2Gj
	mRF3QobitXze4YGc7jXHHbNNYwAsOF0FpdaaOWR181rSjZPVbCPC1ssZxjsl1lsX/Ap49L7DyxYac
	btan5qL/jtIvY2FDIar4SYPWchZZKm86FhJMp9aqAoxlDvJU1bov6BFebDfWZlGX+GoCI898HQW27
	RIUMXFZuAOTGVxX3FUeqvWhc4O8nwG9PF8YKJmR/bP/cSeqtlUoKk7GDLgAmctwZWggzMROoFlg/3
	fiZJBhM6xPtOKoPqbYSNLvQQbyBlcQMeg6GIFCSSgh9DJc5h7frAjgYiOsNTpCkyJRaw18+Ne4nLX
	NF+LIgPQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Kq-00000004L1M-1jc1;
	Mon, 15 Sep 2025 13:33:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: xfsprogs: cleanup error injection
Date: Mon, 15 Sep 2025 06:33:15 -0700
Message-ID: <20250915133336.161352-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is the xfsprogs side of the error injection cleanup.
