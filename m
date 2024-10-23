Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37452914
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729690680; cv=none; b=SAdyzvt3OT/WPoV67tZgS8l46By0nKKD4iqAwAh/ul3ZbG5fv+UuSjNotWNxsILs/6y9Bi1EWoDU3WKFtXQhvEoA+S+0LcASNxaJF8vmXgCUo7vDoX4HY1jn0bjGxLsWdyds79atWA5mpsPO0nTwsaLDAaRfeRbTHqb95xKNVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729690680; c=relaxed/simple;
	bh=l1Tga9G9S9PB27aHgzziXDKDJjrh5wPDXmlZfHt5GUY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m3h8Od7CdfceXOVPKW+gdw2SEClurHSGAltKJ1TgxWbV+ul/S0mRA557IC4oQ8YqXM2q1AJAeQvnH4mGPFPLhQVV7vFJWAIeAx+PIIRsVCuyKPqRwaVtym+DfR96isEH43Bye4/9PbJ5Y83CmmUbf1XkxNVuaqJ0oVD1/MsvXBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nRrUx5kM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nRrUx5kM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=l1Tga9G9S9PB27aHgzziXDKDJjrh5wPDXmlZfHt5GUY=; b=nRrUx5kMKVMo7oMoNvzHCv4U1m
	MHbcFATfxujB7oiSoSoif7hhmjT8h0uSN8QUkPEqAI66Ci8kiXSB8E9L5/7uoXJSVxL1Wess9OpIA
	ROBk1wgIAeRRtU/PrQiQuiDuVpdlUl8tBIasGDpfW/BfxjU5NW+fI+INlYwLXzfgrXEf4EUZsZZFt
	gy/d9ixl+bF47aDFhoPn/VovqoF/a7Q1L9pnr4F9OodUu++go7O6+RL4S+12tHWKRVDFzoLzwRuZd
	NiOY7XH4/LHetho1XejdScyr0w/rx3ryafZ4ZHaCa1L4cdCmVfmYTM353/7k0xMDzfWlroIu6pJbl
	tTgwy4Sg==;
Received: from 2a02-8389-2341-5b80-8c6c-e123-fc47-94a5.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c6c:e123:fc47:94a5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t3bYj-0000000EZVW-3BAo;
	Wed, 23 Oct 2024 13:37:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: filestreams syzbot fix v2
Date: Wed, 23 Oct 2024 15:37:21 +0200
Message-ID: <20241023133755.524345-1-hch@lst.de>
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

this series fixes the recently reported crash exposed by syzbot in the
filestreams code.

Changes since v1:
 - reorder the patches
 - remove a now redundant tracepoint argument
 - drop the reviewed-bys because the context changed a lot
