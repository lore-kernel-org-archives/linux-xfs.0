Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5A8101C5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714450084; cv=none; b=cWh1ZGYXNukswCmCscN2dm8nISxgBHXUmeDgEdzw0W6vNy0RhfyVVSlkBlFhdQx/aStgAGZMfn7xuN+C5OxYfEUTIqzWgdBjrQ75cJp3/s5jvpFiBC6s1YB3Oqmlw5zZDQrKKwU5us63ob8113ax/7vPBwTU2SQt+RKbCd1C0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714450084; c=relaxed/simple;
	bh=LQ170M5rbe4in9OxnxepMxgF6+bx7gTeCjxmFzh9jXE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JkW6Wrf1ExIe36ah5WK5eXEx3PnZMnFWYYbtmUUlm0Mo70E112+e8lG1bbqFxUtFXaNvjURcBDY5M/8f0xLkqJN+x2rXS5Bd3ul/7DE5RUj52/TvBnYYDm15P4M0DQRuOxpsV39cYq9cygZ0S55d/bFmAoHYTDMTYtaIh64b6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jt5DZIiD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jt5DZIiD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=15nHgy/RsppO2RpX0pE9MRvgsxsIeepqsiwedKNxvgY=; b=jt5DZIiDv1wE9st8HLp5wEJxNd
	rSsPLcI/UGmtuubuaDAcZoyuLHX0g69kB08KM7bDx8JNl4UkGCqJII+CIzStjt4f+kP9CU+b9ap5H
	7XPPZVf2KSL3iI8v4Qhc8cBU7m+MAqgzOBefbqCZJ6pJ10/+etT5HCAPi0aSBmF4+LNe6mivfptl4
	mNYMl1N6OuZXXM+6DxNn04M0MZSegmluJhB6T8TkGzrNKaVuwxK+rhj/qNFqc1eHVsNr5rnYCpBW9
	tSk7rXz3GcUQErI7GQZo1cLg5+k35eLrpydZ8jt4cq0faYYyTWwp3qYYNUFNr7SrveL6gpo3tdpGs
	f2s1v8/Q==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1emd-00000005014-1kYs;
	Tue, 30 Apr 2024 04:07:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: fix h_size validation v2
Date: Tue, 30 Apr 2024 06:07:54 +0200
Message-Id: <20240430040757.1653768-1-hch@lst.de>
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

this series fixes the slab out of bounds founds by Sam's fuzzer,
and tightens up the h_size validation and log recovery buffer
allocation while at it.

Changes since v1:
 - fix the commit description and fixes for the first patch
 - drop the previously second patch to reduce the scope of the fixup as
   it needs fixing, refactoring and a good test strategy
