Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F9C824BB
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798074; cv=none; b=M5p2Df0tX/DXBXcAfE18U5kfQOQDwo3sLJHU62e6DM8Azg56EmOXVMQD8+73ugGbejiW2iww71YdFOHlf2qca4tMz3TAkBMYuDWqiOe/l8DzCbq9Z7WgZaRpuczNP41tH9nsbNGnQvWVtqwQNddUqEJe0/j2VHKLjgkA6MBVBLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798074; c=relaxed/simple;
	bh=3B0oXb0SWsAZFAbTylL5M+aBUJ4PXyRE917JENglLsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Frb6022csbkB6zaAMqmUButPXsTyaDhlfgjXMwLtvBeybbdDpLko46Skd/eaoj93oawoD6nv1xETfFtejFm+sNiXGlJHcRuyZzRSfqYOqygLHTy4jZyUm/jEmGKgBKXJaWmpC7HAcSDgKW9QVg63fSSgtDKKc7ysf25HzIWGmuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dJwhq8L8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dJwhq8L8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=j8gKlD3/aJiPkWDlgQG9ZNrBgFH4FoS0o3ZtUOT3c8g=; b=dJwhq8L88comqkNHCLbivZdZkD
	ft0/4YiHuXCtyxZa/8Pyrg/5zT4BBjripxcGWnCK1sl/nEcZTcO4sPXi5ElyyPtZ7v4qyGx+NVvXM
	eGydKdov0fALUJimNrk9NEqrHTnJ8lcKgiMD3tDzkozvXQZQWkuXrb2haO3lF5BLNlWggukXrbWh/
	q4sGdlQSAd58yYJ27hMZH3hdXmDM/YwNAE6WPnQqRRPnM4BSI3tfTdPeHJ4N++tXms5nhGERewnP0
	0T/GR+xt6QW+ejm9xo6WkgGTickvfAYOSpBOclreFBqHF5EhXwCua56IA4TsQYgKwJEyDrgLpiYLQ
	5W/5E/+Q==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJttV-000000014Np-2CHb;
	Wed, 19 Jun 2024 11:54:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: clean up I/O path inode locking helpers and the page fault handler
Date: Wed, 19 Jun 2024 13:53:50 +0200
Message-ID: <20240619115426.332708-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

a while ago I started wondering about some of the I/O path locking,
and ended up wading through the various helpers.  This series refactors
them an improves comments to help understanding.  To get there I also
took a hard look at the page fault handler and ended up refactoring it
as well.

Diffstat:
 xfs_file.c  |  139 ++++++++++++++++++++++++++++++++----------------------------
 xfs_iomap.c |   71 ++++++++++++++----------------
 2 files changed, 109 insertions(+), 101 deletions(-)
