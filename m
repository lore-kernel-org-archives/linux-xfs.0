Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BF13630B8
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 07:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252267; cv=none; b=RKNxnGg2LMl+ja9awpFB6CKqPcwghhSj+m2CB+7joHY5sTXo9THCN0KjPh4EjRhlpPGC8mjji8PmtAoEiIFf4raW5rYm1Rxi8ptmU+AhTQmB9dWHuv2B+UakA6uRGZF7HS82fdmzDkW8QJim/V7ma1A9A8oPAryH8s3qzwdHmac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252267; c=relaxed/simple;
	bh=h99xWyQzmiQbd9A46/MI3PbFKW5326KQIlJz94iXc+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OYe5KdITLYg2AlLmQ4paTPtNlEdZEG6u6RWxFvHldZPIqTNYVz8WpLgFUqyNrojh2xtgV4NtE+sIATB7XP1Os72j5KODyFWccnZoH8+Ng8eUnqtkvyorLH+Cy11z89cafwQljAtRcd/Or2M8HLQAejtVcnKoOmYd4pvuhpubYyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kPGfZs5s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kPGfZs5s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=s1utFNm2tD8V6GA+ERfcXuGuhFJtp2hs6EapCHxZsfI=; b=kPGfZs5ssrKg/zFFbFeje1qDpJ
	DVNtpHasGllbWAZTdO5noUf7L6ayZVWwJ/DhxqqbnyPk9IoaI4KJ75jd1sOdEqtF0N2lV3i600mG7
	3nWytgxr3oY78JU15rH+rBabpmBIJWiM8V16ixg0gLDC3X57yazyXWbwW0ow71HFkxM5H0fXvzrC3
	QmbWuyw3MYnWF3VII9/Szo1PCoDEWhM0PBXBDloH3xWLvvW0eEV4z9jGNAzbtAGFzXV+6UxHe50T4
	u2l3+rXxFfn20w3Ihkdf/q8W3yULlA9OGd1PNKyDdF26XSsGkFudaRcDFbaJoOGd8pNF9xX4SfBx5
	StF4/h/Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4a41-0000000GEeM-1hmN;
	Mon, 23 Mar 2026 07:51:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification v6
Date: Mon, 23 Mar 2026 08:50:50 +0100
Message-ID: <20260323075102.2952705-1-hch@lst.de>
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

this series has a few old patches that simplify the LRU handling, and
moves back to only having a per-buftarg hash now that the buffer hash
is using the scalable rhashtable.  While some of this looks like
performance work, performance and scalability is unchanged even on the
80 core dual socket system I test this on.  Besides cleaning up the
code nice, it also happens to fix a syzcaller reported use after free
during buffer shutdown, which happened incidentally because of how the
tear down of the buftarg vs the perag structures is handled.

Changes since v5:
 - fix whitespace damage

Changes since v4:
 - don't drop the required first patch from the sent out series.

Changes since v3:
 - split the change to handling how referenced buffers on the LRU
   are handled into a separate patch

Changes since v2:
 - mark b_hold as signed in patch 1 before removing it in patch 2
 - document the changed locking in xfs_buf_rele_cached.

Changes since v2:
 - add more details and a link to a commit message

Diffstat:
 libxfs/xfs_ag.c |   13 ---
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  237 +++++++++++++++++++-------------------------------------
 xfs_buf.h       |   20 ----
 xfs_buf_mem.c   |   11 --
 xfs_trace.h     |   10 +-
 6 files changed, 93 insertions(+), 200 deletions(-)
