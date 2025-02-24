Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B7320B80D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 23:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740440946; cv=none; b=UbODuYE7l8nUiDW5CRFnvJ5073u8Y/IrVBmSMTgnZNpKOayocHtctCvOSWH9HNrjTFYApJorMIFv+qOXffuIqUO1UHlNdxlqkPtsSEjWc877STvI/MclUlQ470QgV5zYxboV4XHEK0Ynr03QV0XHUgRZygucjRi9ZtyXMTjz3Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740440946; c=relaxed/simple;
	bh=xlKJXE8CGNgmG42cIK9xHzxDXYqYRrEFqPWdpGVPcEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkJdSEW9+Y9nYM4VEbLBbtqGuIq+vMXQI21VlBeF4/Ga3W2WGh08QLNvBhPx162n8IXe1Ffq88Fru2y2Onoa0fl8+Cnv0JkCX9CMWNFIABuhecJPSGaGSPDVx+OgcjaABNknHMgvHWW6Q6GiXnd5VK3XfdqDZ0NSSYtBMJZ64To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OK1qWPmu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OK1qWPmu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=FCw9Zohgq8WhIEz0ksUB6s7CeFKnZcVqO8lpv1gYTZM=; b=OK1qWPmu8dkdSCDvuhcOj0IUUe
	IvifwibJnWm82152Pd3vw28RVQ0XpI0gRXAn+1d0IpTgBoTJuFXX+KTT9d2uth+y01ppD/SqcLTuU
	+pYmd+SwOwn2lLmYO6j0rNQUK3roAKHSE3YHluClepBKSdNvcriWbk4R9hrDdF/ckD9tdwnsnb+Ul
	ERaFmxLiBnHKmrrWR8EgaQRy3r0JulXGF6keV1oNmTKWEomaWJ6CLzxGLwloIu4FzIxL/krivZ7xR
	pcilDXJv+Kte1FVDnmPwiFvkRdJ40ZQwjA5kp2GblUtShRurNUcnoAH9MWC1792DIDrR9XaFZU8k4
	2shFetCQ==;
Received: from [208.223.66.147] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmiC8-0000000FXJP-0ta6;
	Mon, 24 Feb 2025 23:49:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplifications v3
Date: Mon, 24 Feb 2025 15:48:51 -0800
Message-ID: <20250224234903.402657-1-hch@lst.de>
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

this series reduces some superlfous work done in the buffer cache.  Most
notable an extra workqueue context switch for synchronous I/O, and
tracking of in-flight I/O for buffers where that is not needed.

Changes since v2:
 - more comment typo fixin'

Changes since v1:
 - add a comment explaining the __xfs_buf_ioend return value
 - fix a function name reference in a commit message

Diffstat:
 xfs_buf.c         |  182 ++++++++++++++++++------------------------------------
 xfs_buf.h         |    7 --
 xfs_buf_mem.c     |    2 
 xfs_log_recover.c |    2 
 xfs_mount.c       |    7 --
 xfs_rtalloc.c     |    2 
 xfs_trace.h       |    1 
 7 files changed, 71 insertions(+), 132 deletions(-)
