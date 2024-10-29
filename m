Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9862190049
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214741; cv=none; b=Y34rVGnq6Pgdy2Ao7SjU1Lc4ZnhHyhsgBSBJ6jomVjxCRYAPJMtBYbpyHfORKptvPk7OP6fR0J9+b4KRmh7ktuI45w64Vkfc3il0w2SQ2D7cywyXur+b2oK4JAzxOWB8lwckhxx3VktTUaj2L4PExS3Gt6HVd0hTmVQHtN/hXxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214741; c=relaxed/simple;
	bh=zUzA77u7+1QqqZ/0dAS/8on3r0jYrn9LYnY2cPmLakQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNbVgprBl144ep+eCvJ+y63OMYCUtbJRRokvy/QTFCem4/+EfvdoflBNIMBpuTe/9wXWrbmr7wDGVDeMqHuiz5UvHilgIydE+Uj8eRfZ8bnEDLYn5zLt7Z9bczajk33/QYSB5eeRG1t0YyiPVI9Pk/lez7l2l3KDbizyn8ajrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tWkfo09q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tWkfo09q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zUzA77u7+1QqqZ/0dAS/8on3r0jYrn9LYnY2cPmLakQ=; b=tWkfo09qdvHeAR12SBPk2j1kb0
	xN98J6CmdBGYZZx7R5BNqlLVWb4FV/PHEX5IZ8t0Hae94lR4XBZ3LOAYw2Wc2oyyFJOl6ztOsM7dB
	XHwO1To0QZi12TQZSOyn43ydLAX1JdFbcueVwqdmjJd2dghIfGCRBKD4qSQbhP6vwJkfPW/BlTA3/
	Dkft/EPC9HwmJZgozRFD/BAy+KF+zO2jBIeX6dHHoB1Vq2fSw7OfuCHZcw2JQ4lHisWwC6uqWcC3J
	9GDjKp/ARgUdm7c+sq9lNq8LxDiufoceWS1xOFVh1uRyZ9aCbE4kNucBtnKWyH/zpR2hOEKnFcp9/
	E0QvM8yw==;
Received: from 2a02-8389-2341-5b80-1009-120a-6297-8bca.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1009:120a:6297:8bca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ntJ-0000000Eqqp-37hu;
	Tue, 29 Oct 2024 15:12:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: misc page fault handler cleanups
Date: Tue, 29 Oct 2024 16:11:56 +0100
Message-ID: <20241029151214.255015-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

I recently started looking at the page fault handlers, and noticed
that our code is still a convoluted mess even after my previous
round of cleanups.

No bug fixes or speedups in this series, just pure cleanups.

