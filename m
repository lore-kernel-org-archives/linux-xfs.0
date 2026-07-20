Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F417427FBA;
	Mon, 20 Jul 2026 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556540; cv=none; b=angj8dsfLZAKjixDj2oCH+cE/sjRnY3IwqulJTAx9I1kLN+JvZcE1u8iJ8Y5pm//subzelB5jHvR6G3MAUUuvRZtN2iCvIG73YhMnruJLgzKKGneUrw3bz2qDIhMgg8K7w+LNVtG1iG/Bp/lLMUubuse6z4MfqJLMtkbjt0e6RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556540; c=relaxed/simple;
	bh=dEGdF+fHbxJOLlUnbyOXKR6nxMRBZ4dtKBLoA1/JsPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cbAsv68efczJeo8+vdTy8gEcH5s5Gt+QpHcqpUsv2IeTfpYrueQp/ZpWSuKhYxw2NKHiX9qaZOoqyTr5FAK/v7WIpF6gU9xdypIMammgHlR3JcfJ6LRDe8xa6TfKwojA5NSKoJygOjnyZFO33M/DXO47ZujOrEV9q7rNrM/6Pzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SrdpcHlf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SrdpcHlf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AKXVom8OeF7UK7vrTcOr3QHYWP0i9XKE/Qk3dJpYWOk=; b=SrdpcHlfGRq/w9VjuFMLMjohde
	JZo1XdQqHrO/XVnPU7JkBhbEkGNFQtk/vmM2TVdhbNKG0CEtmqIeQzEa+Tn30MA9rv9DgU55s1DOW
	VHCU8W8C6kp/6udPWsbLm+L3DmYs/sX5koP6TwuBANJTg8OmiLGtKCIN2d5kqGmv/4PgE2toR3G/f
	V+cysceEvMHPHxjOMZ53C47qMG0L7HeaL6iMW7JdEwUsIg0ay68EjEIDPTngxOgFyn8aFy+zMBbx1
	+ROtdVfif8Qh+GLaV2HmW60sj82WpRWy6UMPe/fOQC9J0XB/CTBEg2yOIHi7cnn7HT6nC0crmsPYL
	Ed0Xos9w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wloft-00000006uJO-2GiC;
	Mon, 20 Jul 2026 14:08:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: update BDI {io,ra}_pages values based on the RT device limits v2
Date: Mon, 20 Jul 2026 16:08:46 +0200
Message-ID: <20260720140849.2269776-1-hch@lst.de>
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

we ran into a bit of a funny case where adding an SSD to store metadata
to a (zoned) XFS file system reduced the performance vs using a HDD for
both data and metadata.  It turns out this is due to readahead code
looking at the BDI limits, including the io_pages value that can't be
inspected or tuned from userspace.

Changes since v1:
 - restore the old value at unmount, unless the BDI values changed
   since mount
