Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F025A345
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185367; cv=none; b=sdvYIru5zNhFwN1XNTlNFhLD3xPguBGH30cwGb6/wEzERdXhXm62Grv3xS1OuL7Ax6mI5yVehwi3BoseskDbdB3BQfoM7wMSwlFTs3ecW1y8cFUK/i2vJRlrDMlaIG/udcHGCuWyULRkSzauq+OpHCCsE/Y3pYhVE/iY2cLaUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185367; c=relaxed/simple;
	bh=5rNtVEqpt8AndqzMx0+ZpoB2dVQluu3YlJzpB2WPkpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gHi2ONLcH+HaevdyaVxG9tuh+OJHmi4sg/9sVpR/QC2Rx4yWoyQGpY30/x0bYinZ2celZg4cFahAKZtmnQIWrWkllXpz7qCFA7Enwb2rh9uiKlA1tbmcOUixIkii6OiiD2UMpXhobIf0GFUVxvShfpm//+RGlD9nE2+H7S1Tivw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LvaxaNpe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LvaxaNpe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vwLBf3tiaRx6ZYxtiSkK5CApiHEyckSgBJtSA+sqr3A=; b=LvaxaNpesHAOuvJ//igIdwWhTF
	wPXCck/GcwZn7EYaUB6UoVx1d7hfK9K82TwqlDZ9wxDK5SoqlkChBXaXQ1dCgJNMMd3STLR82qS1W
	XoqB2n0GTuFjKaTYCNtr27aC0VgK0IQ+8sHJVhUII60NuFPYGOw1AaB/+/DNWCHQFFVpAZeL0nVw5
	fo+sNPHiPhVxGVLHJUIRQWlAUdGzdxuB57/atlVUkGA7UgOK1xluNP0r+1hViXpPSvJ/QagFFVc9k
	7064bv4+d7uctSLwJWke6ShzfEUw3ZwTEid8WsLOaVN2EN1qrz8xHwCz7gg0z8iBgy7wvoU1J1pUg
	BQw7Jy2Q==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QHx-00000006U9S-0OOs;
	Wed, 09 Apr 2025 07:56:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: xfsprogs support for zoned devices
Date: Wed,  9 Apr 2025 09:55:03 +0200
Message-ID: <20250409075557.3535745-1-hch@lst.de>
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

this series add support for zoned devices to xfsprogs, matching the
kernel support that landed in 6.15-rc1.

For the libxfs syncs I kept separate fixup patches for the xfsprogs
local changes not directly ported from the kernel to make rebasing
easier.  I'll squash them for the final submission.

