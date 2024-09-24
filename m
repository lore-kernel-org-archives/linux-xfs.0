Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874A4086A;
	Tue, 24 Sep 2024 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727167558; cv=none; b=eiWijyg65tYnh/7O4Ry5YjslMv6wyHqRAusK+OdFnryFms61JMvgs01e+AGFKFbTqdFBl+9C5k5JT2/HFDiG0SRhW/6LU/SaL+WQ9c2uyf0Jo8fhCQd+lUjeGw88ncHviJyCs8y8IsZ4hJqWHE6jRBp7dKq+OxVwaLBeA6CIf88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727167558; c=relaxed/simple;
	bh=Tos7X2I+Kb1aF+POKaUPNmwCwStkeWFetXG1D1MoBfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FKGXP5bKTJDXfyB904g1js5h+klm4zt/P3XMrH8Nnmic03zUIph+KT0dug1GUBY5BIHWpQu4A7eEX/GqslN89B4GYpVQ0SVALf/bPm6LC1lX3XMeHgkZSnZ6sO3Cxn4Uj4sOUdgUsTOFZAEq9Rxvss+yAUDqAFCqi1zTORm/3h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NOWTIAEi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NOWTIAEi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bncafWAyx6d7m1ZzrJ1TAXhv6YqdyqyhI6wbwt7U0E8=; b=NOWTIAEihDacbntSgSittdb2qt
	RU1YxvfQ9CnlKVvp5R4nToAQvt4YTxMbS0u6k4S07KlAFyB6lXKfHqlKWxGbzA0+ru0dB9H0IAWgw
	mV6MzFCSAB0ksUymH6Yd6VYsCOvbthnQrdvSkTB+2Pab0meRARG55pwoi4X0zCg3npMCiq31wJ8sP
	MerkDOX75FPglYOv+BQeUV3zne7tBqXLw1W66SvFkzmRPTOz+6wB6iG/rC+JGTj75DRSkt5e3u5QL
	FR2gVR8OVhhHH0k792PTuSJ52r/QJMEpzHQY9Ek2tjBO05d8nG7RFgipLQO6TqtEZ4CHcCwlftv0r
	121TgODA==;
Received: from 2a02-8389-2341-5b80-b62d-f525-8e84-d569.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b62d:f525:8e84:d569] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1st1BD-00000001eFd-1a9d;
	Tue, 24 Sep 2024 08:45:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: xfs post-EOF block freeing fixes v2
Date: Tue, 24 Sep 2024 10:45:47 +0200
Message-ID: <20240924084551.1802795-1-hch@lst.de>
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

this is a rebased of the tests dave sent 5 years ago for the xfs post-EOF
block freeing.

Without the patches here:

   https://lore.kernel.org/linux-xfs/20240623053532.857496-1-hch@lst.de/

all of the new tests will fail for the default configuration.

Changes since v1:
 - fix _scratch_mkfs output redirection
 - add _cleanup handlers
