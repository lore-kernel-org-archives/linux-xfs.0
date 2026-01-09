Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C7368288
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979306; cv=none; b=OLvxaUgGvC5ZzVyIL1BK7TA2PIvIkXCJHtIoLFWnqr3/F7okDsrVYBwSGDVQ/xWhkMTbCa8U+lXfw8mQ6xLkswbc+CC0ZWH9DPZKHHzpTCJtGdL+Y90ERhZar9aH+GjqPoNm9aslyIjd4TXObEZb8y2dKSUTdXIs4Mf8xr9QJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979306; c=relaxed/simple;
	bh=pwo9Qg3lFviwAsXHLoF7qSXQFOd1TCYTNU0TmQbrHac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P+CQizbnH2BOmZCWCE1qSuwSF5ANxRy7AnufaimC53gXMoosaEu8Y6GOAAtF+hH/mIQk/0HK575FsPDtmD0Pv0ceCouVzOiWgWgmKEhMvkAMH8EuyTekXV0+f4cCaH33Hi6VgKwsVpg85MYNH1Z/r3eEYu/PhFvrOBjLL7i+7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lp69ZsiW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lp69ZsiW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wV8MijTg5T0Okoni6B7uZ5EfA+7kXmdO3u6lgt2HgYU=; b=lp69ZsiWrfLwkW9rCYcPLlFrHg
	IR6pv/nt/8Vedg+0KxyiIb8LVpjeb1EexVcMdtbPAttolXvl7qTvbo+XvKtt8evjO+ubHqI2IkIx7
	lE5ARZ/99CnUo80OiLShppnWIdXizFEH8fviQeXYd/ofjPanDNW+uSi8BbznyQwNwEYALAroXnUtY
	yJDjTz00pPyq/DPYhIS7zB1zMqFYcqKKaiUzSMsIcr5kZSRtUvkrbwfW8rwgULJ3segdEJPorj28c
	/bEF2zHhKLejcTfBSxmM0//sSdn3vP/FRAyudhoBnxY+TsS9eOCElr6xKKWfN2S16yeHjrPuwY9Ik
	SHEFDdpw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBC-00000002nXK-2KKJ;
	Fri, 09 Jan 2026 17:21:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: refactor zone reporting
Date: Fri,  9 Jan 2026 18:20:45 +0100
Message-ID: <20260109172139.2410399-1-hch@lst.de>
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

this series refactor the zone reporting code so that it is more
clearly split between sanity checking the report hardware zone
information, and the XFS zoned RT information.  This reduced the
code size and removes an iteration over all RTGs at boot time.

It will also allow to do smarter checking of hardware zones and
RTG allocation information in repair once ported to userspace.

I've also included Damien's xfsprogs patch to make xfs_zones.h
compile better standalone as it touches the same area.

Diffstat:
 libxfs/xfs_rtgroup.h |   15 ++++
 libxfs/xfs_zones.c   |  142 ++++++++++--------------------------------
 libxfs/xfs_zones.h   |    6 +
 xfs_zone_alloc.c     |  171 +++++++++++++++++++++++++++++----------------------
 4 files changed, 152 insertions(+), 182 deletions(-)
