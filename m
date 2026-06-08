Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1944071D2
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 05:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780894936; cv=none; b=DKBBPGiUEoTHGJMFcoC9chvFpRUiVd0ZT5wHJvBqJPze3QLl/eMCj4oNd015n3gidCXcuH8ubgo99C9svz+ZW2iAkKVJIm/Q3Qpqo7SIISSBkWTySM9mh/2ZMbtBJdf7sLj3OtyoUudZoKI/jAr+PfIFMIqlG6xnIY3afVhg4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780894936; c=relaxed/simple;
	bh=Hs8/AGHHb6on4pTgsOq1igC2x03jmEPiFsBnI0Myjak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gZSiHaifakcqL17x0pQcZ1P+7DireIFTJz/ItkVtfwT/thKgAfrCzCm91O/YHSviTcOK4kvsb4kre4sv5/aMv6pNLCrnwpuHUNEMAAmBWEyX9PWBKGVYQW4b78q3Vl2eLPpvIKdjL2RU1FWg/bUDab7q0suAIChhZ8R7GMRmGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NEj97YlA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NEj97YlA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AW6dCsYqT5eHFOV3hF5p8+lQrz7HDGbbbmnn1g8DI3o=; b=NEj97YlADLHtGfTXMc/TwnZMhV
	JA3RbUW1myoHVhkvgL5nyCiILLyiGnPWHsKpTkLTEo3wXFGgQrjSqEqkZbDjm9iDY5NpDTC+VSFIY
	BRCXh1GwADHiV4ntUcMJMSPrBCkcLqdHYtKgTxbB3bN3OqRIJmbRN47c1IfYOT37PZqiUpW6TmfQ9
	ER/meGDHkit72SiJMnsQ6bJNRWqzumkHESq/iu1HhCA3+4pkAqF58L2H6Fw4XUV40fSbqK1Z2HegQ
	l+4CvWpAjDighbznCyKP4sXSm2xUBPd1wSSzlBcCkQscqlAvYSC8U+UyT17jtEQvhjwuKOlYa0coj
	KcEeuWkA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWS7n-00000002obg-0HJu;
	Mon, 08 Jun 2026 05:02:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix dblocks adjustment in growfs v2
Date: Mon,  8 Jun 2026 07:01:54 +0200
Message-ID: <20260608050207.1203276-1-hch@lst.de>
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

the first patch fixes a possible incorrect sb_dblocks when growfs gits
the maximum agcount or a too small AG.  The second then cleans up the
surrounding code to be better readable.

Btw, is there any reason to have this code in xfs_ag.c?  It is only used
by growfs and not at all in userspace, so having it in xfs_fsops.c would
seem more natural.

Changes since v1:
 - clarify what we wrong in the commit log for patch 1
 - use a 64-bit agno variable in patch 2 to deal with 32-bit overflows

Diffstat:
 libxfs/xfs_ag.c |   44 +++++++++++++++++++++-----------------------
 libxfs/xfs_ag.h |    5 ++---
 xfs_fsops.c     |    4 +++-
 3 files changed, 26 insertions(+), 27 deletions(-)
