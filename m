Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617876;
	b=nUOcGOLKGs8JaUn5u5tRRu4ClX/ex+uO5dM3dqS7wzBjIZkjzo2AmPCCqHWKSTKAcRoh
	 9bQWmpAzJJkL7aFr19/sYo/Mm7OoNHvmSQ1G0NvCJIhw++mKXR3Y/aZHyc1c8VXXnh5i/
	 5+ouY64lHpqbKoebOC7iyCuZD76Ijcyk/9PO8Lym5H8pkE/uYzuC6yKm5D/LPDQjtllAi
	 2MquhkZxzk454xIiqV77asG1+eJNPK09XX/E0tDkEjS7WRFmooMPLRPoDrn3F3fq+pml/
	 jUT+PsojoDWMIu+gxbeVei87r6SAW67Jn/21I8Wm1blIXlgQxj7Gwlr0XEKvWjiXxRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617876;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-SRS-Rewrite;
	bh=Z7+M2S8QfgsF0H0d9NmxT/eGhfHm7fdJBZhOp4/Cpd0=;
	b=eZhqo2sA6nvpv4TrJAvgXBC1mEY3cJEhft/7e/LX/dVz4fkoV1qauRCccM9zQ2ZfXvXU
	 Aq7t4k0dTXfSTcoYzNo+LGhxE8KWapQ1kpxjQJnYxgsSwPDWrn5J8WtuKffU/kRbgP25m
	 z+jQ/W0RjIw9JOfVq82oHyGDA+cgy1vUDjYRX/T3tnnaHYhnbwLXYrXnL4IWysvBjVpFl
	 dl9nXrg+kxwGuLQvyPauxvRq1uSvblN1YkxuF9DET6R/VVOzRODROj4wWq4h9MYgo9Rlj
	 RQm2SNCgscdo/8fR/mW5tOzt9ZKUl964shGO0Mh2jXgK96C9GFFJfOkeDKJGrIEE76Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Cvf08hbq;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7D3606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE7D3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Cvf08hbq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Z7+M2S8QfgsF0H0d9NmxT/eGhfHm7fdJBZhOp4/Cpd0=; b=Cvf08hbqPIWo+zeiLmvluagrA+
	WiP3NPQ83GVL77AxRwtQ+Ps03EwUo7ZAsBeMPx3ZDZTrpBVKnyOJehbOzMVufE1kdQh6tFiJtAVhJ
	wM9kkUOYwLOVmhduGy/yXd3GbHZUfNqve3eiOorZ8TiSVCi4ExjyVnEvnRtlm94yFcHpb35hMNxmX
	qktSI3U3d3uU99q6ZtfzKtjHBZCmYbdGzhk2Rpgun2KelNoTluj4RMTVbdJqwu+TFjF29Bm/tln5R
	aqaJ4pRC74kz2ZQ35MoDp91Y9rNe7xxnfdNlJQsWi2nQjj1ase7YK/52sqiUAUdzOAlqBwBjZS8X0
	C16drUxw==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEc-0000000ADhZ-3SpJ;
	Wed, 25 Nov 2026 14:44:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: handle ophdr formatting entirely in xlog_write
Date: Wed, 25 Nov 2026 15:42:21 +0100
Message-ID: <20261125144430.728485-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

for historic reasons, generating of the log ophdrs is split over the log
item formatting and the core log write in somewhat awkward ways.  This
less to subtle extra code, extra (small) memory usage for keeping the
headers in memory when they are not needed.  This series refactors
the log vec formatting a bit and the xlog_write code a lot so that the
ophdrs are formatted when writing to the iclog, and the no memory
for the ophdrs is allocated for logvecs in the CIL.

Diffstat:
 xfs_log.c      |  298 ++++++++++++++++++++++++++-------------------------------
 xfs_log_cil.c  |  258 ++++++++++++++++---------------------------------
 xfs_log_priv.h |   19 +++
 3 files changed, 238 insertions(+), 337 deletions(-)
