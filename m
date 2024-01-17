Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2A122615
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705512801; cv=none; b=B3CYndiei0AaEgf0kR4Lyh4w2m0ByGvpKn1rufDiQZeI18UUR90CJ/OhITl3b0IPstJV1dd9A+0uA+BxKSXjT02/H12vwEQlvDVI5nJa+sSwXxragaeA1MbVwhPN+fUlSuDD2ivBwxIbztJ+Hnbd0KpSlNYsR8zhQAoN1qTN2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705512801; c=relaxed/simple;
	bh=LfRKo75gNkXonLeS9gSBOf9nK3u7uGJH/rxWgG7e8Pk=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-SRS-Rewrite; b=auYHNvAHrJxBBnP+htShedrmJ/QsHRfJE1j0RvqPZAA0XlmZj953QpdTDXNs2yTTKIA+AIC7tzf4vImuAVorYlwf8SsY0vmGSGqj31d/rRpil+uv/m6fUWB0QH4Vcz5/mt69NaKol8wbHQ/tvK0D3OFquMTw3GRwh83vsDDLbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CrIu9G9O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CrIu9G9O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8Qvol5GfP0jAQOpGN45t/srUZ2G6lZemOI8Pjks2ZcY=; b=CrIu9G9O6nrKuRIMp5oSMllfKf
	4M7DG4hKQtSgDGVotGNYVZCQbPp5D/XusONQYwWTkt6SDWLGz/bQEtvJf9kVhZm3KQ9Uu0jgL9tW9
	X3sRBnHfzLkF1ruCpWap6kiNe7HMQ/KuKauwdZF9ZCG72sIQED2ohg1b4v1Qx5x2UvKDgHXIKUUa/
	EV1qnykkXoosrh3CAnFvVBBrtQcVgBlfZa+CG1cuv9sixV525JeUIa+LT2z63S/bsqXbite5Ult+/
	d8ldIE27pqwAEkohxqTY4gS+K6OHrlP20nGBlYdS0pVwCvYV9TTN0j/YkLM2LuzVyIcjwKFfIaZ8s
	Kn8SeziA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQ9mt-000EOo-2v;
	Wed, 17 Jan 2024 17:33:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix log sector size detection v2
Date: Wed, 17 Jan 2024 18:33:07 +0100
Message-Id: <20240117173312.868103-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series cleans up the libxfs toplogy code and then fixes detection
of the log sector size in mkfs.xfs, so that it doesn't create smaller
than possible log sectors by default on > 512 byte sector size devices.

Note that this doesn't cleanup the types of the topology members, as
that creeps all the way into platform_findsize.  Which has a lot more
cruft that should be dealth with and is worth it's own series.

Changes since v1:
 - fix a spelling mistake
 - add a few more cleanups
