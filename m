Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525D116DEDE;
	Wed, 24 Apr 2024 22:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713999293; cv=none; b=WrdlQyPfYXa90gkRGTdWJQpXMwB6FlO1EswipquEsyvofMokQ5aPdJusio/SvStg/m8Rd4RfUetqFbbuyLhP8Y0zOuGAjtWDNBTHOkYxGR3h/6pOhy/zyBC8BJ4g2SzOGzizCE/KWAPI8ZQdl0Btm/ormRFZuKusJluVhSximfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713999293; c=relaxed/simple;
	bh=Teu/rIF3h0hRJj/6aYp3wQq0kJy2BWpbwqudl8sG9FA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a8Y8ylYOWPiBrvqUUCpEs4REx6UW5IWgGoJA4V7KXyYNuZAK4V+YC/SXYYB30cPSsD9EO27Txuq0GrAj9BJApWAveKIx+sIO6AUjngdx02Qh9JgnaMoF2bNCHBPZlyLweHxw+qIX6en4wWMOj3OjXLG9yHSABC9TQ8vX73smWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eCj4iiRu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eCj4iiRu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qhV20ebwyjVS9ZmsvftKQpBJifJwQvLD1zjgUNQjXno=; b=eCj4iiRuMnaF7BjOuB048sOqBK
	b0pf9KuMzqPwbLvEttEdI5I7j8RuQlZl3w4UUFJo6dpycXfEhwNFaDbwGJm7M4nw5PncuzhzqGr/z
	90QOa2VOJbdupbJ8cR6jxjjwexzdayhLmK7k0KenLUDxSE7FLyNB5qtuBiOKQlOhy9V575o5o3fP5
	zkcTTK1h4PNr4CQa9zxEK2OzDsEkNbXxwu0fUgeHZDxiT3Zz/C1JBZQawoCSDiEqVxa0cNb37tn/8
	f2mQfx0NPHs1jFKV3D2daBLkJwvv9GSpaycjHnUtAfm9EGri+7f6dL0997Q6As40dj81DThDf8GDN
	F13nkQpw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzlVq-00000006HlS-0TnN;
	Wed, 24 Apr 2024 22:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: akpm@linux-foundation.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	hare@suse.de,
	john.g.garry@oracle.com,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH 0/2] mm/huge_memory: couple fixes and one cleanup
Date: Wed, 24 Apr 2024 15:54:47 -0700
Message-ID: <20240424225449.1498244-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

I've been stress testing large folio splits using the new debugfs interface
with a new fstests test [0], to make the debugfs interface more useful it helps
to do bounds checks on input parameters so this fixes two issues found while
doing automatic stress testing of the debugfs interface with found files.

Provided there are no issues I think this should go in for v6.9-rc6.

Also, *should* we strive to support splits for large folios to min order
with say MADV_NOHUGEPAGE ?

[0] https://lkml.kernel.org/r/20240424224649.1494092-1-mcgrof@kernel.org

Luis Chamberlain (2):
  mm/huge_memory: skip invalid debugfs file entry for folio split
  mm/huge_memory: cap max length on debugfs file entry folio split

 mm/huge_memory.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
2.43.0

