Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F168D534
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371335; cv=none; b=Wg9K+E1yO6Fw0pHbLorz7fX4qj7V8xMEIZQ0QJ4ljGAVKrdeEQjWKGnH2+93ZCXq5/ZE3O1LAxAGu7ETbhiuuFt4nXx7XA9xEOtaWVjWS0B/2+RlS+oq+OLsUp0AyXT7Y5BcRFD1+264kro8f8bV0NF1sOao3WZu60TKMWkUQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371335; c=relaxed/simple;
	bh=W+oqyxYZkwWtSJt2ZdoV/iF0av8kwh5VMkyoIgcoGk4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lj4ZRsQWz7t0poic5P4pCSlNbXBq+YVOKAMVtwqYQy5inx/Jpvac0h/+vfBJh5boque2PI76rxrfy9ema3t9L+wIOIU72oaIbBR86nG4icN7+1Qn6UK42psmZvPtavTMB5Qtr11Xsw3fihjCZB3u4H3KwdPC7mqiAHfiF0KHASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KWinXmcl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KWinXmcl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WqX/JmrkzcDu9puEK/spRV9NA0auOMBPpXnlDqJ55f0=; b=KWinXmcl3h5tjmrHg5KvmPNk1U
	HvZK8dtZZddoUg+VIhx8ivLIbqjVQziIbZtohkZjQBxo/m8HzQaCnYsJm+VeLVUXExNiP0LF5hdkM
	Gn7XPOlNMNP8jtbpcCPtbpkBm4IOH059FXykZQlk1hYeH2zc6zfoL0BLMESSGX3IfBtfWpeW+TqaJ
	Cu32Pg+cqDWaLw6tXftZ+2+sDKjFeWdi0k4Nm3A7cEoySWt3uVzX6ep6V8uqZ2tFHjOF3M53Tu4n2
	ha2um5ZCHPpyW7ESfF/Sdgmmlfs6x9FxvcmJEctiuJxIZQHvXsfKWgZBRzAxvjDjVzGaQnh98K/wz
	QE0Tw9gw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIW-00000001ch1-20Pa;
	Mon, 29 Apr 2024 06:15:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: xfs_bmapi_write retval fix v2
Date: Mon, 29 Apr 2024 08:15:20 +0200
Message-Id: <20240429061529.1550204-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html


Hi all,

this series addresses our long standing issue with confusing return
values from xfs_bmapi_write.

The first patch is the actual return value fix for the fuzzer-reported
issue.

The second to last patch cleans up and fixes long-standing issues in
xfs_bmap_add_extent_delay_real in code paths that haven't been used much
or at all.

The last patch changes xfs_bmapi_write to not convert the entire
delalloc extent if it hits one.  This sounds simpler than it is, because
delalloc conversion has been designed to always convert the entire
extent since the initial delalloc commits.

While this has gotten a bit more testing by now, this will still stress
code never used.  I've also looked into the alternative of having all
callers handle short delalloc conversions, but it doesn't look appealing
at all.

Changes since v1:
 - rebased to the latest xfs-for-next tree with a minor conflict
 - spelling fixes
