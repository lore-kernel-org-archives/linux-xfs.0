Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3413AD514
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778851942; cv=none; b=q2B2XFvGMvlcsbaBcvWLj89rrKGmwPeEAW/h7mYfbSn8i7AGJf+60qARsxlD4ebsH36JlqlIusytTUx35m2uMnV1lrhtsUuA04es39WyTg2KLmIxVlzOQCnlxcDMN3OX8uzMFd5NXztSyTZUXIUKlfke/KSuEvtGUFnjDjwUCzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778851942; c=relaxed/simple;
	bh=Mj1KWA09zOC0oZu2H4ZbzQ3mr9ABWp5F/CziUY3jgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XyWdvIYLy9dJAfm0GYQvZ8CqTCymqvy6vQn+kWU3Yyc2DdLPEsHw8ypKwHmjYMfY6TEM+IF9/M5MTS2jf4tYD5okZpfwpYT3qFCHBF+RNwj56ylHOH+y7dXy4Z8PgYM4Q0oDVOjA8DnvZJOQrCiQiva6gaZq+wPV5n6A4WiV+7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=il9LdSqq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="il9LdSqq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=L9PyRQRKufBwf5WLJUOkvVRGXBSBByl1X0BQTuCuIVs=; b=il9LdSqqkzuHYP1HCMJw6fk3O1
	yu1ZIgcKal3KRnwcQL1PmFyIr9SIRZBXJ+QnjF60rOQAqxkWLmbsxc/8yHLMJTyzb2mm37QaZv1KE
	vb/BeCdkBBFs62vK6sakzw9gnHAs0AdBwExNajTS8r8Go3qwGOwaepHPbSN60PBtjM68/r8hgwkkN
	cIa5yqiUwitTjk7s9GiEPTtWPhBX5bCRuZAISOyKdMNLTMG9Z1rmudNvEyVHOMkNXBJZqDNGKNGqk
	HPGo80J4e2fLa4gWbjcCMYbfmVLdIANbKrc/703ibRCG/63NkBXA17azvXr5vL8jFkllQQLy5zi77
	RElfzESw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNseH-00000008S5m-26Lq;
	Fri, 15 May 2026 13:32:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: fix a buffer lookup against removal race
Date: Fri, 15 May 2026 15:31:57 +0200
Message-ID: <20260515133212.4039831-1-hch@lst.de>
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
