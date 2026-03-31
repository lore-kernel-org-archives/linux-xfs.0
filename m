Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF28405AC3
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970783; cv=none; b=nv8r/IIeGGxjChjBIFAtG/Z5hKHAutegQtr3+YR1DDIGjDw7NlYASrDli8ZU+W0vt152hA3+IFqDKDwHO5gR2RBn9/qmKqtv5fso8IMMtRHMM6MLi7J9BA3ulU6N1AujqsBpVeGEwFeNbjoudorPAXrks1FeXA2WhEQ7R8eCGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970783; c=relaxed/simple;
	bh=ze6aF/Jw2BIj/m3bXlI3nsi7H4lgi7QE4ZjkQ3X3yW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P/siJTpEzcHGRZglcjXQ0n57mYw1uQj6FqG4Z53XRLqvghTdPV5h4cyP9Z85TYfc8AoX5rSzspeJMbhf2qYR/gFzX2I+eFVgTO77Mcyb00xeLQTQaY1cRSL9KciMXK0bY5gC0Nw2gdlIpswrGkBCTS7WDCJx9Xk6VxTANcO65Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=etXbNd5D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="etXbNd5D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/O8hBxFnsk36Soacwqpx4OyXg8M5czko/Wtw7Zt485c=; b=etXbNd5DUHspvlYRA1zX5i6Y7g
	5OzCf3eg0B9H15L9sUgg9y+zopCGCetid19p4/oGI4g9xGcZgUZ1Y1QEo1/2S254ZhD3c3nl6talP
	Nbf00S2woTHA8mLp+oXTwXuHjG16NQm6+aoWm1ZZA4yfTDKeM0eTSK+UiUTezu733AOTaTrHY6TSM
	BUUmQ9N6EhVicrrU1M6XSt40VMwFE+UPplpgjknnAXBtLLPiiRpzJha9rb292Ll/zI5qFSHQ1Se97
	HqcPgx0sEp808xvJoWUFvjW4mrW7krmS6e1YeY+aHzBomilvY4x7HJaXHAe0qHf0+0ObpO8st2bsQ
	i/cRCGmQ==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7ayy-0000000DAwa-1niZ;
	Tue, 31 Mar 2026 15:26:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: fix handling of too many open zones at mount time v2
Date: Tue, 31 Mar 2026 17:26:04 +0200
Message-ID: <20260331152617.4047908-1-hch@lst.de>
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

because there is no actual write pointer when running the zoned allocator
on conventional devices or zones, we can see spurious extra open zones
when the last blocks in a written zone have been invalidated.  This
series adds code to handle that case and remove these spurious extra
zones.  It also fixes up the mountinfo code for open zones to be
more easy to parse, and adds a new sysfs file reporting the currently
open zones, which makes it easier to use the value in tests.

A test for the open zone behavior will be added to xfstests.

Changes since v1:
 - spelling and other documentation fixes
 - move two patches not directly related to the fix to a different
   series

Diffstat:
 xfs_trace.h      |    1 
 xfs_zone_alloc.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 110 insertions(+), 20 deletions(-)
