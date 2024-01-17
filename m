Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2B22627
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705512808; cv=none; b=u8ju4EuYQwdWd7npFp0jFjKOrvuRnMkPdE7VKWMdGOwYvNYTg0ZPQUAgMkN4H7dOQ6jNfjQMVOZChTjf40jwiL4nSj2fhVUbM1xWkru4758biPgsPniTK5YTGXyOVmFlirsLFOWgIrmySEm3I7LFqHO4j+SiWp5/JpQAsI4zWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705512808; c=relaxed/simple;
	bh=6/6huu6en3MAKZYhRN3K8r2/uoGLwD9OAHfZ71+ObMo=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite; b=SvSwtbzaJl6F9ZlVCiU1fHWLk7CA7lhR3EkZvKXCCm7y0VYdUl/gGiiBrjrZ/gjmok4z81IwLj+MePltY+pBpGaEuQ7NJENluvyNJ0tn8NavEEC7EC32Xow51i/K/t4awTT3/1n4BiPxxckNPlF+5mixMqUcZy8iM9Jfx9UmyLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=erH9My7H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="erH9My7H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Voi8XCcC9/tmEZ13zCBFnWZ/MUG2A8SJbecrGjw57v4=; b=erH9My7HqHoxZFXpOFQeTG3k6J
	CXr0JUIbwKktcsLWSZSczFIM57aZjSiqDXxQLjr9zV3CQE3Op9sME3Ug056qVD05VtQVxWcABB282
	U2HE1gOZnIcf8fOvsVphaKYufMF/bw+oV9uYlMlNH4goizEDXmSJGMJ1BUkt2mU7LOWDp7HSi0T3z
	mdrvDSkWPkDvPgLhWwaTCQCedOalIbkreqZ8yUfH0tTo7btNVzT2boB/HDqzYvadSqFHb8b4o4LAe
	OIqj98o7v7BjD1kpT9JkvtY053/3Xr2p17r9vyZ8+4vzn/ENkb8E36S6llxJggCJJLiwwlUwlMQu1
	N+vnnXYw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQ9n3-000EQu-1O;
	Wed, 17 Jan 2024 17:33:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] libxfs: remove the S_ISREG check from blkid_get_topology
Date: Wed, 17 Jan 2024 18:33:10 +0100
Message-Id: <20240117173312.868103-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240117173312.868103-1-hch@lst.de>
References: <20240117173312.868103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only caller already performs the exact same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/topology.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 8ae5f7483..3a659c262 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -181,15 +181,6 @@ blkid_get_topology(
 {
 	blkid_topology tp;
 	blkid_probe pr;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)
-- 
2.39.2

