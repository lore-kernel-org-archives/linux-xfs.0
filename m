Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27894349CCF
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068057; cv=none; b=l1vf8leWSxhiq9XOPgMoTt4IkZK2zmKTtbcb2lDQmbH9SjeWDkY6CqhC9Gp/+R+oP8mwIS0Ysnz6S9CZefTBQSeRX8xjMaZPoqxb+LpdSEKchKsP8GzrwLFcuJjxeo3dmu7T6oXTqSmhXY/2SpU4QGKcqnNggVWMVVe+/9Do3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068057; c=relaxed/simple;
	bh=Z8mLdQjF89qPtFxiE+IIH2HinI+Yus4+MQThW/8jqvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GNB2ZyCTe3R+/7Z9EupXT++XWa2k8l9D+HeHjC31lvTV5agipNW9gIYFSCddgauslnZKAh77BjVK7WnsTtNHWSmCj5/H9wXb9eLiHvRRByaiRKKzAPnDpSscgF0zL+7PlaGBPLbSw4aFLN6fqJZKnlEqNUAM1tiake2HEwYsVGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DzWWN7aV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DzWWN7aV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ZLeKsbxYfFfUczt/GgE2fxIGjjv4m5w2Cwnm0Y82lJQ=; b=DzWWN7aVroSJp0TUJBO7gOesCb
	Cct884N69hqUdYL87xkglkITZ+xYWWDhtE2t51E11EAmGT6DAPO1upDAPz7xWqlsViTHuGO/o54QU
	+D5HkvljNMRJkexnCphhEK7B+ro00aXaIhDZes1jqVXZtKFt7FExWzjCVxcEqHtEIhKH4AtwYYOrE
	Ek2NvRbXCxX4FBQ91GZ6rV4VwnxdgeRdxPx980EDR5WpP+PGlUem9ZRvwvsffFuGnOStRdYvvBPNc
	7Tth8k8RWshHTq0QMCuODUrjLSITdoGpHHds6NEHl1t54WkEo8SYiKElPNaotpN9c9V4rh5Jo1P/Z
	AtEspgJw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBA6-00000006o7A-1NJV;
	Wed, 10 Jun 2026 05:07:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned growfs fix v2
Date: Wed, 10 Jun 2026 07:07:18 +0200
Message-ID: <20260610050731.1906760-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes growfs on zoned file systems, which so far has been
completely broken.  A test to verify it properly will be sent out as
well.

Changes since v1:
 - rename xfs_add_free_zone to xfs_zone_mark_free
 - use xfs_rtgs_to_rfsbs to avoid overflows
 - improve a commit message
 - add a comment explaining the zoned growfs space accounting logic

Diffstat:
 xfs_rtalloc.c    |   16 ++++++++++++----
 xfs_zone_alloc.c |   11 +++++++++--
 xfs_zone_alloc.h |    1 +
 xfs_zone_gc.c    |    4 +---
 4 files changed, 23 insertions(+), 9 deletions(-)
