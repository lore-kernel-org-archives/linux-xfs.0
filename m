Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0FB2BD04;
	Wed, 12 Mar 2025 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761982; cv=none; b=EindYgXb39fXng0bKP7LOhJXsvDD3Pu7r/ieBCcpegRcLlXU4cgPOC6ULwCAgATJSoNrhHGFwEu4OMEQutDzk+QjzcrV9TzQHm4iPe5vli2Zqj9RoFr5OGhHFfhPhJy6E1s871aSqIdXdUxCwPW8WFETyeR0CIuW7sN2q2aXKMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761982; c=relaxed/simple;
	bh=8/ogB9bfCR35xQTfrmkb+xVCT2D6JNUDUB6diz6zlJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJmADeLjrq4Lny/0hz5GGBQ7kc2fGHASemEarpBI0BHLBYKgYUdF+e14UgTo8dZfZ99CSJbLiaDMfDDprsUJl9Ko44TiyUhwRA8ZCm/inRXlY/QFtBjp0+eyYIQXQJsUEKQg/IIZjb1uWpvejO4+18/k45oORnbYdg84jqmw01U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IgOrRQVa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IgOrRQVa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nxEnUdpFIXWRvVmdlWPtE3Rp+e3KUwAIqUkd8G4VSKk=; b=IgOrRQVaQ/8Cbs37wVKcScrjIC
	tmFsNyrUT7N2bwM+0YUwhKsPEQ6gPhd96WKaamhZv0xCs9SYd8JRb45rzkNPI0XvNPYSEjzkBgFyf
	keOdfJZLjJxgGxLphOfGZR5pQqO3xCVnTmBJ6rCXbxuCUvg8baPGeFscDmTgMfB3DU8FMwT2zKWyq
	nFFwkty2x0eM1GAbogBBOKYeWIjtNLXCu4KQ4tVE50sFBjShWeVaXBTUVASXQvsAVhtZp6XU20aJm
	kmRUWYJ5/KALWUzSlN9XB3mGaVzFjFc8H4dBGnjmZVKfU2gnutFfNHpsFcfIa4tZM2H2i/06TcHfU
	+/NJrtOg==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFrA-00000007ctv-3Fe5;
	Wed, 12 Mar 2025 06:46:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/17] xfs: skip filestreams tests on internal RT devices
Date: Wed, 12 Mar 2025 07:45:06 +0100
Message-ID: <20250312064541.664334-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The filestreams tests using _test_streams force a run on the data
section, but for internal RT zoned devices the data section can be tiny
and might not provide enough space.  Skip these tests as they aren't
really useful when testing a zoned config anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/filestreams | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/filestreams b/common/filestreams
index 00b28066873f..bb8459405b3e 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -108,6 +108,11 @@ _test_streams() {
 		_scratch_mount
 	fi
 
+	# Skip these tests on zoned file systems as filestreams don't work
+	# with the zoned allocator, and the above would force it into the
+	# tiny data section only used for metadata anyway.
+	_require_xfs_scratch_non_zoned
+
 	cd $SCRATCH_MNT
 
 	# start $stream_count streams
-- 
2.45.2

