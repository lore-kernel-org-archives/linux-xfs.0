Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7C23D6CC6
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226016; cv=none; b=UMM/Nx5EUxU59iLX/l3b3LaTqWVLhbFEh+Xy+8TKc1mmdpbinA4gn3FAVWogNPShy2H10ykzurMi9Vp92g9fqQiHfKX6g51MzNAO9XUuNl6RAHzsnbOCl6Moc1XXbS9S+Ief0KgxF3L13LXh7FmTAgbFgarcIYQkxnPsPMwNmQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226016; c=relaxed/simple;
	bh=x5EMd5SKVHahf2fss/8pjRldQ5Gwq/BfCzxnUvsv0Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nZtqebAE/nY5b362W1dLOwRcppu5mDg9+mvmUHcn+FSr5o6bQ2gAwBNk8s8TIWXmD7MRFNrvGG03uBCvFuqyXT2wc72URiTNirj6R+dkfZVrv5mA0hLo/nzCRNpIXwtEq0K+kGGBMQp2Se+fgi0XuHb6dO5HUGm3IBuJ1bDvqQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y3JnScRQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y3JnScRQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PgZMhEK7+35pWAnAXV3cCBhvw6LpAt9L5zL92F4+c3s=; b=Y3JnScRQ7V/dKEvIlB5ymapQof
	uc0icyRd+uT9rb/CBDHZFpC2QJ6KVouKjT6+jkIju8Y7k9OdMIesEcUY7VVo/FVYtTqzfWj4nA8L+
	6h4zAJZm97L8SmUo9XIXsAsY7G7pFK4KmTNtn5ZrJ79NwEKNTqjsWXWeGT/kGb+FrPPdF+WLeuZt3
	87f6+vd6pTpeIPdKFQx8Ux1juTTaEKcpyn+7wT6HS4Z/HL5Cq6N9xrJ2DO7sq1n5hiF94b/XTZ0bF
	pBy2MB1krGjjAYpHOjl6LFFysfftx1jNZyPXZGaPMQffet4+w1/gHDRHKpML82/lMpwnxiG/+6blo
	gGMQR7Ew==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocpw-00000004g4E-3A4q;
	Tue, 28 Jul 2026 08:06:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned GC fix
Date: Tue, 28 Jul 2026 10:06:43 +0200
Message-ID: <20260728080650.1777545-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Carlos,

this series fixes a potential deadlock in the zoned GC code, and
also adds a comment in the same area while looking at it.

Diffstat:
 xfs_zone_gc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
