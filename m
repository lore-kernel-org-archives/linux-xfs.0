Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C05643AA1
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 05:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723440243; cv=none; b=MJTJxZlPXEwVD3YlIBWIhZt1y851WiJ8/jXljOuqUgoukygbzdHjNAz+RiVfFPCDjZVZCbasAzNSEtzwYVyEyeAN7tW/5Xaxp9R6KqnPah6pIpRA/LJG2V9Nu8i8by5woBOJjHKR1rhDhNcp1hROFh5RoiBTwlQhW9QbXhD2pgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723440243; c=relaxed/simple;
	bh=uzcgMUqRCZoGKPmaebQaYggl6esMZXzi0FkUfUV8cck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AA3A2ypk8LJhbC7t+/1uNldMMHpfs+F7I+HXIQtq/XixZGYw3nsPwfCsFudgXYNSpiCI5N/9h5PjCbqIV80u9/ox7V2WumBAx/4MSZjBwcuKKtjSluEztHta6S8fsgh88OqD6pATXZjvxNXjgzeHlXSY3foWn8HxiK7n1VnxEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h8+0Lilr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h8+0Lilr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MtxUalxLYDPdGkNl0mPOWpi9pz/xYeIK87qQz9cBxhM=; b=h8+0LilrQZCsxI6fNEpDTJRJIY
	EasVTrq7VPjzgpQVcyckjsG2zKts5Lhmc9GIwTF6DyopjTV+4R+UYVKr0AnvDdkBSc1Hr0uoNsFfF
	tC1U1hTOcwTEGLmM9RxuzjneYZpdRn8A5MPCLS5H/K14cVg5zcOhMwwsFdFgNuvl1Z7oq/q2v6J5S
	PVGooUNUEY9LLV5pSOmnr5ZUNVLU1THnsOyzSmDw9gNdPFsA13p4OqobjB3vpTeqO8oW+XSARPtqm
	GVWjmQ78uP5IsEwrf1GTnRiblggscKYVrBHWWI1Djt63/ZIuC3q0rzbcKfdN6x8bs7+6vQk9Wcw3u
	R5L8qfLA==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdNXD-0000000Gv5C-1Zd9;
	Mon, 12 Aug 2024 05:23:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: iwalk fixes
Date: Mon, 12 Aug 2024 07:22:59 +0200
Message-ID: <20240812052352.3786445-1-hch@lst.de>
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

I noticed minor issues with skipping RCU freed inodes that end up being
reused in other AGs.  I've not actuall reproduced these issues, this is
purely based on looking over the code for another little project.

Diffstat:
 scrub/agheader_repair.c |   28 +++++++---------------------
 xfs_icache.c            |   11 +++++++----
 2 files changed, 14 insertions(+), 25 deletions(-)
