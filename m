Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B53E486E68;
	Mon, 28 Sep 2026 09:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586680; cv=none; b=gkDk9J77FKCKdQ/Hc1ivzBsWncmqZsrplpdvkO3a+OA2EW5/qiSEvOTO0Cpzt+K8ZiMYqKzkeFx3A/wCWONHs1GfKfZF4GWc8YWe1uvlgTN8mxd+3oegX6itveWGINwVaVgj9gtMLiEUNePjy5ksTZMtwGT9UQaizM7o0oaYdWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586680; c=relaxed/simple;
	bh=PppXONCA9MymhYVrQKvzvM8cBhoXqzY51r6xoSLhMkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iVpaNAV6sYp707N1ADpAwzVLK4i5jRS1tU68LgmSy1oPA0ct5GbiFWP1yVRw9Jj+2o2VOnhhlNtAwrCCPR4bYyuQ1gVCMr+PH1EStnXbwgM4RM0lhFZIOcJuTxu55KQsOkLSHcEQdyPkBMH38eUF9qGkpm1IldT4XJk84lrXdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vBUkCS1X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vBUkCS1X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0UFt0S1YE6gcAY1M8KTB9TzjiXLL5U3YqWkJm0nIJWg=; b=vBUkCS1XqXQrOQTqOCk0QJXf1t
	oCQVnZXKktS2zetMqQcbgcxOf0oADTjLpESgwoP8am80WTbcuzYQ/kJbiBrq8cr8Ta0P/3Lx8KrGz
	Day6kBfTawQc9OLCuHhPANgraGXVdqPqjSBAw1bsqqs8gO8hvGdLP/2mWkt1oB3y2+x/2GIGfYEa1
	CU+53qc5qkgbtgsq+EWfMhczAzZW1b0CTh4I1J+6a+JR+rEkKzghKyfotqTRSyUCP9TBoCYABi5qS
	UFsQZZKhiPrwukiGIYTbo5ILPEHGweFqTi8oni3hVCBFtMjxLNShVI++FFZe9gJJ7QvfLndI4m31Z
	h6PMeLzQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7OE-00000000Blk-2zuL;
	Mon, 28 Sep 2026 09:11:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: use bio_complete_in_task for iomap error reporting
Date: Mon, 28 Sep 2026 11:11:06 +0200
Message-ID: <20260928091111.3986811-1-hch@lst.de>
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

this series replaces three pieces of code to queue up I/O completions
in user context for error reporting with the relatively new block layer
bio_complete_in_task() mechanism.

Diffstat:
 bio.c       |   46 ++--------------------------------------------
 direct-io.c |   19 +------------------
 ioend.c     |   48 ++----------------------------------------------
 3 files changed, 5 insertions(+), 108 deletions(-)
