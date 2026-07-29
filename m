Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E8247668A
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 11:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325199; cv=none; b=Ir58Bw6GHLRQ8Jf/lNDEBY58iUmDIHNWMEhRJSsUgdtdCU3xJX5Pt8c7Oe76XZA+aXebX9KwQpHIW1tcO7IsF2SduP973sTK4lx0zFSndMrpvWyI4pjeUJ7QeseQ1OfVCDXoXmuaOXpXD3Z2N9Wq6akjJuui1f8ojS6scft8LAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325199; c=relaxed/simple;
	bh=UbqZi+N4uWwWLwnirGoJnakTEAxPNX7KnSlFR2R9jJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CbMapcsCUnTjiiGxMFfWsq/nMqd7Tg/hWjOKaOzMYzzI0YfgZI+R+dUqZnM6UgX6Ocon0NEFY9Epey6F+j31UTOSPDK9cMvdyQ+Mt7Q/iiy0nm62N1yR9dclFD3FiHZThNH7riLXIAhF6LLpBGhcztXCW2dGCvoT4aNKNdWfUQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H8SOVQG/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H8SOVQG/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=H9YT2WCFsFK2z+2yVuh8mu8h2yjV9HMVtAoXa/R7VTk=; b=H8SOVQG/7bA7qDPIEvnpR3+b33
	8gtL0KIA9hkKfW0KvVY2yQNOmfxJt2h+AIKko97mmDU5AYywiWkC19uDYWH1Mo4rtU2Rw0n6lBTAO
	/sRgH8xwn80KCAbaxVUDrBGzlR7df5e9BpkCscxWQIdMLo3IR6Qu1iomMutyWDYujKUNH+a/RCazQ
	eqaNqm6iACEiamb7KB+7CTObgT+2lwD55GqlbfZMXJ/ZucoMRWtCYJPrQCBxBuAJDo2KFvcyqEKsi
	xkQEA7HIkOsPGQWMiW6RQ8fnbtYmZd7RXHy/hjt0jGIB4o9BxdVGEB8gEPIbrnJ3JlnCf3oMPPR03
	eaMAS2sg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp2de-00000007kym-44tA;
	Wed, 29 Jul 2026 11:39:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: xfs ioctl handler cleanups
Date: Wed, 29 Jul 2026 13:39:00 +0200
Message-ID: <20260729113952.2255638-1-hch@lst.de>
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

I've been annoyed at the KASAN stack usage warnings in xfs_file_ioctl
again recently, so let's sort this out properly by splitting each
ioctl handler into a separate, well-named helper.  We already do that
for most, but this series completes it.
