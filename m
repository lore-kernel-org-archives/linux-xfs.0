Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C0B1D094F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031405; cv=none; b=cjYH5LCx7Y74tzs57M3ef0t/g7pcRcege2IcBuFOnANujLnEuaJtfdFSPBs2YWlaBNKJIq+7iYjtyBhd23JYXhogj9dUHHyo8e0e44ZbNU38/0Mp4xcgnD31Znhu7sDRN7aRg+3UIw9bELxGB6nUHswGbhFXYKhi1W9835MKqAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031405; c=relaxed/simple;
	bh=mhCIWdILfJN+TZAgEtJ0lGwWxFrv0y9tILq4f+9TAJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FlMtsKFjrazY514eJ6GoPocBJXBLHmYq6A7Zqg7W9IFITrBA3/7bIcFWL3A1nrgxg5vkPl/SpApMoJO1OGm82YLezXH59xLmvq2gDvdwDgySG8qNgmy80oM1VVN2Qsy3ZOwASQ0fEgOguvUfcsu+9YLw6cYIBir2tTkv3X7zJNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sjMTaA0h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sjMTaA0h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qI/DQ1NSetPEzM5gCWZ1+nj/lPgVLJY711tv3TH7WVg=; b=sjMTaA0h2m26dN0+gX68U4aEkc
	217LD2pGdXdeKQjrppLc5Bro2zJvawQmiO5c8eEyMT/xo4F5jSGyzAk3yOpHZwADpCMlIppm7A0DU
	0BfXvBI61v5PJwCZk42I8/DbCec90F+FMnVvqMa9Mo6/fpHRxOR+wyQ3cU1BN0VB5bMr9Ym4jO10E
	imOaedXrHVmw6aZegobJSj6/wYUBy/msV3WAk5UjS+Ojy9dh4O8gLDt6ZjoIAj79iS3ozWWGPSrMU
	Yys9e1t6+ZyOZAxrs7suhU0b5eN8jWpFMcfMrWAol1Ft90mM0/jQ/akYCQ4EeOyOnqxiTqY43EFTr
	8WHCpbmQ==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDQUM-0000000CvcP-3P3O;
	Tue, 19 Nov 2024 15:50:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: small fixes for 6.13
Date: Tue, 19 Nov 2024 16:49:46 +0100
Message-ID: <20241119154959.1302744-1-hch@lst.de>
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

two little fixes and a refactoring to prepare one of them for the
new rtgroup code.

Diffstat:
 libxfs/xfs_bmap.c |    6 +----
 xfs_rtalloc.c     |   62 +++++++++++++++++++++++++++---------------------------
 2 files changed, 33 insertions(+), 35 deletions(-)
