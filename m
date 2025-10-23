Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96430EF84
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232633; cv=none; b=NGE4lpfULRYD1fq+nUiZgjtcNzxQj01/1W2HKvCBSd/+72PJFbdMm1vozP3KVKie0mv3QQX/407hoB+gB1QkxgD+6TS4tMVznAucij6e+3wkBuqYbwL28vnuPzm+2x8xJqfHFGsLfvry+U9mbVK6MRYRQaC7wb72EYiQcolr3ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232633; c=relaxed/simple;
	bh=EfhRoRyW29DeeF0ucUFoLJ21gFcn6zR+2J3sR6xutnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZAfBjp1NcVSDaw6ZEjC/AwgmTdqypA01pZUFwJ8GukRlxgOMGm5DUJzh6a1YXl3pSdb2yU+IqVO/M1KikQ6gwnB6ApPRekHBOFclzWC1CNMIR4hmbcD2Ctoa+SGvsr5JHsIfi2tUHNLWv6Ury1AQv5yJ6mkWATK65sYm47tNbvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oWSkkJCs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oWSkkJCs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=EfhRoRyW29DeeF0ucUFoLJ21gFcn6zR+2J3sR6xutnY=; b=oWSkkJCsmBfGxhYsh5Sdzg6BL0
	adIylUfVHptondsnFAH3Cx6tKq9pMiXVTWBXmDhZZlN4AX6MNHed1wstNMCHS8hcpYPWxeuzIl3QV
	nwGW5sgtP8v2j4NWPCdQjEDhYVIFX6JpIGHoEPQ2AsJAK+E0/9nGLHgmhhzcr8bdo+BFTNgRN3Vl8
	/KlRPdN6+ALrtXPCtHptu03bgEE0UUKo/Xrnv5aCZQZm4ndA3PVMobCclKd19syTBI3lsYk3TF18C
	Q9duXN2WIntIVrVRuymQshOZLGvGMXQy1F/z40QDDqeGcnr7Hod9bkfU1tdY0js+sjPvP3OayZmSb
	T4ZQnuTg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBx3u-00000006jUq-15UO;
	Thu, 23 Oct 2025 15:17:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix for selecting a zone with active GC I/O for GC v2
Date: Thu, 23 Oct 2025 17:17:01 +0200
Message-ID: <20251023151706.136479-1-hch@lst.de>
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

the first patch in the series adds a counter to ensure that we never
select a zone for which there is active GC I/O for GC again, as we'd
try to copy the same blocks again, only to see the mapping had changed
in I/O completion to discard that I/O.

The second one documents an non-obvious version of that GC race detection
that took us way too long to track down.

Changes since v1:
 - fix text in a comment and a commit message
