Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3098472;
	Thu,  8 May 2025 05:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682499; cv=none; b=c0K81vsutTaDNQc53pwNZlfYPwF44WqED8jF1004YwNNaDa31QkjUZ8qwucosrN/wH1RUqhuHEYwwwM/LkWKxCPdXXvZCA47bh54dYYIIAGVCslWwoK1CCw6rlv5UP5ojc5DPfXGO2gKyoZi0mSXP0g8VnLH/TJdQPkXO70nURg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682499; c=relaxed/simple;
	bh=KOAotCwmj81YbSM2Crm4gj3xn/7e/D8boK6otO4NN/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YzGn6ndJV6x/8j1Eygdkcw9hs6hc/rBFIVlC562w+aubkKnBskdp3HWfLJn2koeS7dMTylqmhwKdSVUpqUoA1UARtyEqa6kTQQPrx5XTlz1r+07m5+SSeGw1R1BZg8MUUabbhZFjpvlfLoe4xtKrONf7Dxen9/l6HzDM7NATkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FwhzLx4d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FwhzLx4d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8nzUeiIoIhQJaO8kNQRzcOd/42Vv3qMYOJpDDC7Fj68=; b=FwhzLx4dA2KwDSY/wei9QkB9HW
	y4+gNm/EC01G7Q/BNzMP7XKtWvoAkvI4ESOQYL+ZqlgmGLJQsmURDQtrZfA627vLfaWce76s+HlLB
	7kFeAikgWN2E/aT5JIPqqbmSkSJhHcqSeWuCiFqYvacdSn0ik+zj/SVeHGWB8TY5lMHt+H+r/BW9A
	M9j1vgriraUVkH5F+qrvucVbbA6wlMSypbgMqyGyx0as7yY793U1Nq4WvnrLwf4gFniMYJg5nSOFQ
	PpoTBUy5dgWVRrQ1uMEpk2FlKwXH8UXiCYvK3UkweiSceacH9QMK3+tC8+b+eFM0IesjYEDxuY5Tb
	glrmZz5A==;
Received: from 2a02-8389-2341-5b80-2368-be33-a304-131f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2368:be33:a304:131f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCtuL-0000000HNbw-1I2z;
	Thu, 08 May 2025 05:34:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: new tests for zoned xfs v3
Date: Thu,  8 May 2025 07:34:29 +0200
Message-ID: <20250508053454.13687-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds the various new tests for zoned xfs, including testing
data placement.

Changes since v2:
 - generalize the rgroup number filtering helper
 - add back the wp advance test

Changes since v1:
 - drop unneeded _cleanup routines
 - drop _-prefixes for internal functions
 - remove pointless sourcing of filters
 - drop the last new test for now as it doesn't handle internal
   RT device, it will be resent separately
