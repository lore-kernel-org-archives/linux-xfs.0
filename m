Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59833F7AB7;
	Thu, 24 Sep 2026 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244551; cv=none; b=pGm4kZCtbFOasigHaAredNYOZgH8JBaFxOzSuS8YgvuTr7/yDLp1mOCzW7CEakSjNMyQB/X5rD5mkC+/eU+XBjmquXnk/YTEhlgnglmLAzSoQTxWaNiDTDUVHT/0WHEGyErWDfF0febtkAaQxoCJ/BJ9uTBHpFeV3RQUBg6LNrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244551; c=relaxed/simple;
	bh=mKA7Qztj2NKdw/qGpGeNKMOTd17HuJjc6ryW1Dgj7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y1L8LRyBPg1HFina8QPAcUkOxY/kJdeXSOgkeqMAfXNJbh3a7Kswbm6927EgNQmYJJ+snhxotvZGRR387U1EaGDgGGhX2QW46usxT0XyBQwQSxwxdNuBg79pXIZYXpD/lFpfgm7Jf9L8/5x8ZSBIrz3FzkVDE0GqktUq9LZG8os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i/1xxhPs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i/1xxhPs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X9FI8dEsjjF0aFs5SF8Kf+k9ccTADTmP7ntJMxcCLNo=; b=i/1xxhPs+ablmrHTkG58KcnaGK
	f2oDjNJ00iWHaWUG3jCTJOaumNl/pNzjbJZrKSAdtgzqzOj075PsL3xJnPkopGxBE2ToBqspbD6sa
	9qrI7tRHCVGbntmQE7BdlPASEhjN6xfufVjyYC6DVB6Llj7BaI00LVF9tWKm+uwj80SWoQEqQecfL
	5ux462sKgxi0ay5FQv+NDZhPwH9z+K80+jCouQhSnu3P8qJzqkkzUrH+O8qhu28SZ+RyoVbxSO3Hj
	gb33vNlorXs+Es/jhOaZAl4K4uanimZMRtJN4n9Q7pn8UlvGuJiq7oJAErwVOSliu7cP1ettcdu23
	QzkM1UsA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gNz-0000000Afld-0C8y;
	Thu, 24 Sep 2026 10:09:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: xfstests support for RT data checksums
Date: Thu, 24 Sep 2026 12:07:41 +0200
Message-ID: <20260924100855.2734089-1-hch@lst.de>
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

this series adds support for testing the new XFS RT data checksum
feature.

Most of it should be fairly straight forward, but I'd like to hear about
the new xfs/2304 and xfs/2305 tests.  These are basically copy and pasted
from existing very long running tests, but add calls to xfs_scrub -x.
It might make sense to just add this to the existing tests conditionally
on the new XFS_VERIFY_FILE_DATA flag, but I'd like to hear various
opinions on that.
