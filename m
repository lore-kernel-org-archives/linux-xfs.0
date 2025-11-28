Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCBE296BD1
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311843; cv=none; b=q/hiXU4vKFhRfePOCewwEHereeRLnK8H7BQ1fsAU0djshukdfREqDJ/G67KTOpoy2V1InE6ztIX+ly2o7kbJLKlrj0uvCKH80b4ajYivW5Tw6ZN0gCtQ8FiCWb0cIo/uImrpSUtb6cgeRA28nGUr4cVPSrqwIwCUi6YzdTuTwr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311843; c=relaxed/simple;
	bh=68HCPeEl7yHAIWdUKnONGazgX3fTLKZlKlEvSk4F2oY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TJo+pHRAjjJ+yMRtzjTp4cRGA3F8xcyiXSs9lEEwt23qDHKMht8HkQoUZ0dVu2EKAvxpjL7OoQ2BkSv2O8u81ApqTdxiNCLi2qZs6xyaaW+Y3BDPMBLyl9zxbPtuQcXhUsX+x7cVIXwWl0KdvWhm3SQWaDvMXTy8Xe/FDYDMIUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dVx6QQBs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dVx6QQBs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CYtQtAAIWHaXIvvFh46uq65zkBWaeBFQ+Hru5rVvGlg=; b=dVx6QQBsb1aHKWptTyvFQYRjpB
	wFrNAJyf0XDAAM7zdd5NZBiOlIJC+WUMQ/MiB8yC+P/qXLj/ECXeRworRBJsdvOBhYLaxToDxu+6Y
	R4ltdbqGctEYBZ3bYJLa/gv+3hRkcUjDV00rxLNERx7toiH9NPck3LV6HMdNr4pK6LLWP2uHuh5tp
	UdWGzIGvo7Dn+wd+KzW0J76jWSp6kT/7BU7AFRBuHE3NPQwR3WMsOjSaUFsxbdA3yYBpzseRmOjUu
	H5TFcuGZK2EN1xsZINkjUSNRj8hDQY459MzfpqpiGaMRbUO0YT+NZCvY++mMu70yfIG9T4wOkCTAV
	Hx7d6RIA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs6b-000000003DX-1M89;
	Fri, 28 Nov 2025 06:37:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: repair tidyups for metadir handling
Date: Fri, 28 Nov 2025 07:36:58 +0100
Message-ID: <20251128063719.1495736-1-hch@lst.de>
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

I recently played with adding another metafile type, and of course
messed up my first attempt.  This series enhances the metadir
repair code a bit based on things I found while debugging that,
and in the last patch changes repair to warn about unexpected
metafile types.

