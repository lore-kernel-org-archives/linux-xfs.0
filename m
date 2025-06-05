Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6811F7092
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104206; cv=none; b=HKa3syxwpuIy6xsRhs6l2WS9Ay/GYQcC6SsvaUj27IhLa9NSRK5BT3UsHbBY0eCXg0lq2YuqX8NqwpnqmkInG+JeLDppQTbdDarPyRvqF2wPP/+b0J1SHGjAnPLIkPZtnEOVvMEiqWWzvZSE4K2n0zc3BrpNjFxEzutipuBTBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104206; c=relaxed/simple;
	bh=2IPBGZwee2Gi9AEsWVV1BmObG5THhQvFaZJpz3UNJok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n7KQljWKlqKWZwB2T8lDsGAb+aRFlB2kYae8Aj3QCG1pWk93mvpMO9JvR2wBJH5JMQHxx3IyeQ6icvDtg8Ga+zZK4LlUFAL/PChusKcA/Rmlri4ADNCPrOAGjw64sjleAT2WuBH5ZByubX109/Vgf/sYQQfm5zl548tFNelrM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JgfzW9bN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JgfzW9bN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X+UxiH5H1q7ULNaODwb7VIZsrWmQgG9hewD6OZuXybw=; b=JgfzW9bNj1VNPKKIWuSrVDpPJQ
	P0VpvFjkbE4/sfZ8Ksot2Ooj+OEEEhehvQON9wInvDVbujovBRq9AdU7nusp2vWrb5lJPSzc4dqKo
	G3mDAtmj2LxkABSCgbzgPSYfJ5oDXKjJrgLldtfjGOLRtuQrVYAVEfGJtJQUJg3ZYmI+ETU7HLmX5
	3UIYB731VLTuAEEAYnQVBvDLS5yANywxhOO0RY4gMDx+BMf7T50aZzO4/Ujxnh7ZjJyCtYldTpqKY
	sssZ8dOrc8sePzPtco/iks0x2MDmkE2Ag51oFQoRhvBYrHqMKCHgOEp45q0osRo0eXFU84F3LEm27
	GLRlqC8A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN3u6-0000000Eq1S-3eBG;
	Thu, 05 Jun 2025 06:16:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: misc fixes
Date: Thu,  5 Jun 2025 08:16:26 +0200
Message-ID: <20250605061638.993152-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

a few misc fixes for the zoned code infrastructure updated by it.

Diffstat:
 xfs_mru_cache.c  |    4 ----
 xfs_super.c      |    5 ++---
 xfs_zone_alloc.c |   42 +++++++++++++++++++++---------------------
 3 files changed, 23 insertions(+), 28 deletions(-)
