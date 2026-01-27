Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6DE35EDCF
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526637; cv=none; b=l+ZDmlCyAoofWtX50srXVArUMegh7qAR7prMhmBDXfgG2wCSJxHt7SUYsuOqW3+QtOeCaI7M1ZPniAJLBhH0eZogbUO3c7DkR1nVWcqjBHaaJaT23X9AZoGSzSPggplkKUdXdsquuatdscIMlRAvQyxF/uCOqcP+P+0kfQFzj7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526637; c=relaxed/simple;
	bh=8lKn/EaWftaMqigMtUScvF4kqcexISI6g6Pw1zThdW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e4zLN5H+TW/zIgyyMVxO5dEGORHvGPR6/E+z+ZcZtMq2UU06VOdrZYM0L07AUJ41Bejaygr7xoi/OwgacE1xdSisJbfM3222r3YZFSpXYacchk4DN7dHdpNsqdZvG1xifXjAXpbgQXhPEvqbdy4d7tKK/lEsZYSyRtYbOZMfPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pBAL/Tie; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pBAL/Tie"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=74MPGHul9GQK//xx0t6KeVFybayl06NxGrWQW5od72g=; b=pBAL/TieP64BbI7/ir8LwoCrCI
	rNJ7qwW+q5EVuAOxfGTf/QH0DfbBdMRj/BxXtPgyGAt3yKMPKrJ8hgZZaovIPhUNVpjlAKLELXlfI
	azeQ5BQG6X8dMJXl94KRBzPv7jzssETXN7V6uwxsl2UlKaXnJ5EdsfV2Fcy0koOUOeVnDfOWn2t9/
	mlW65NliZnNfvznohQP85cuHJJ2rzzKGOO2gcIZEMw6VT+QuR6FrVMpkR6cud9OYMyPNGP4cCQ840
	wnA/M1+irjZQcdf0xYta95eoyUOW3mWC/trncOr0g8c0zfTmOtHH3BDP+NqfZRk5a4ExiR4DCvTRg
	FegUl2cQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkki8-0000000EVWj-0apa;
	Tue, 27 Jan 2026 15:10:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chris Mason <clm@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: zone GC ringbuffer fix and cleanup
Date: Tue, 27 Jan 2026 16:10:19 +0100
Message-ID: <20260127151026.299341-1-hch@lst.de>
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

the first patch fixes the empty vs full condition detection in the ring
buffer as noted by Chris.  Keith had an alternative version that uses
overflowing unsigned integer arithmetics, but just having an addition
counter as in this version feels even simpler.  The second one is a
trivial cleanup in the same area.
