Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA43242D70;
	Mon, 15 Dec 2025 09:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792241; cv=none; b=B37Dir6km4TphnVudUvIXqksog8XLrDBK7JZlCKppHUtPLweYiH+xOmM2jCvhg5Ju7zu/bpcXzFDJdLsX+AsPH/QWC/nWpqonyf/e06MTAhtx6RhnHISNqFhfccDQZokQTeYUqFv+yau/z7yBlt9FstWf5NCNy5DYjjDDcgJYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792241; c=relaxed/simple;
	bh=JzQ74ce6gnqB+Ae1CvUzmxTXJxn993D4lDJh8Ya/Pqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ja26suSXAhCNLlQyf8+WoyUSibqmC5CYG9MrEkI8+iwUfzdLKBkytpIr7eDIU3SSGwPf2nTHzuzc91GbnqrHHQ67863VAbfQMdtTqcFYbcVJquqyStQ6IB/73zfl7+i9cj3xARjBeMIjQ8MhNyUU6KNBgAkTT5X37kYu3NAtmxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iEA7JzQR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iEA7JzQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=JzQ74ce6gnqB+Ae1CvUzmxTXJxn993D4lDJh8Ya/Pqk=; b=iEA7JzQRxknA2/alqXM9IquPlH
	cA3HcvXchm19C5nLwqGSyNh7wlnHZiUfOtY5FbcG/7yMrJkbGo7tbnsodJRi1UGAeRXT7wI8/ZXcS
	zk9bmLcsv7edzOEUx0flIxo3ssZGvb2rI3wIgyMJAQAFcHHVkjKVnoNr6MS7UahInv6be4qjtwkWq
	Q4XYN8CSJPkRxbzYnYykcqJsQAp4Bm4ffLbXuHw5DM4DOnejZfrAbwp775kHdZMMm8k94is4irFte
	oVbNy7rpCvqI8wFINfwzxViPfM8pgOmHq+slo41jv2Rwmc3Nuv9f0WHEifUfzViIlgCqD+K7De1ry
	9CiKoukw==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5Dz-00000003Op6-0wgu;
	Mon, 15 Dec 2025 09:50:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: various tests for zone aligned RT subvolumes
Date: Mon, 15 Dec 2025 10:50:26 +0100
Message-ID: <20251215095036.537938-1-hch@lst.de>
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

this adds a few tests to make sure zoned RT subvolumes are always aligned
to the zone size.
