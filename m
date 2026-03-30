Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20243803DD
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849537; cv=none; b=qLt/yndeWw5oddG9Qb7NhSRBa89sNkSSEDGx1D/q3n2uV22+MbYqNkqYAekn2i7hOPFI6myUPhS9C8KNz7dE1FEUkOG+hfh4nGXaGGV5z4mfh4GZy9wg9Tq/rALNwQwzYVMBhb4iByTF3Xnn8leCu1nGf4TD9adsydj6YcCpGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849537; c=relaxed/simple;
	bh=CyAZoL9Sck1HjoKbfcWBdrRkYqO0wzxDVhBvVHO7Auw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mzo1YLbR24D5QqFgjbgwfUixaprEe9kPUe6StAFPfTuh8Yz8M6patLmIlze3mAm3Ylke+mpZ2WjcoV4yBx2aD8mNOEEqUwDH9C5QRDrru3sGeWvGYSmrxuyu6JWbq1RTbOD77+uLinNzMJLvrrSiqhaAu4zDuNMr9fOw5yafYnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K2R4m00p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K2R4m00p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+iISRimUH7FReLC1o3YroDZ48izvj7bZe+WHiMrer1o=; b=K2R4m00pcaoicfbkic3c/m1z5b
	pj3FsOW2Wg8iQsgcbKFFac5mwCs4xsnvurHzSd7Hp7VTom+SpEKVKR1qE51xXLPXMWJA7lGKBQ0ub
	JuXn/0lN9fH1rxmOF3GLGpdEstBU7/DGXYW7HjEn30lxETfuBpzxT2Nk6myxyvt17M41Yg9VA0sXB
	36ItrP/dD6Sel7u6VtA9sGrif0IW5upbJEEoLuf4RBAqztD9vmJ+xK7gXg7X5hahMsPWbWk9Uhcqr
	PczrlnHlBGHwVrNxQCI45OqtQJMpM9z7DXraR+oGROmij+OZXzmLHU3/j1n5NM1HLjh1yFxqSxbut
	K23euBMA==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75RP-0000000AeVi-3qlk;
	Mon, 30 Mar 2026 05:45:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: cleanup open GC zone handling
Date: Mon, 30 Mar 2026 07:44:10 +0200
Message-ID: <20260330054533.3856339-1-hch@lst.de>
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

this series cleans up the handling of open GC zones so that the
reference counting works more similar to normal open GC zones.
This cleans up the code in general, and also helps with experiments
to support multiple open zones for GC I've started.

Diffstat
 xfs_trace.h      |    1 
 xfs_zone_alloc.c |   21 +++--
 xfs_zone_gc.c    |  230 +++++++++++++++++++++++++------------------------------
 xfs_zone_info.c  |   12 --
 xfs_zone_priv.h  |   15 ---
 5 files changed, 129 insertions(+), 150 deletions(-)
