Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53D6222565
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 05:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769405910; cv=none; b=Jjakgd0gW/YpB5p6yBctSVcHw61kfZ5ScDSGsBAi5XFa1IMGOMNpE5uRXx7IqS3sK0UBIDwrGUWZAjvCdpuWe8w9SyLLvsjq/u5nLR4HJtCKi79/RV2I4L6syHuIIqhSDAx22uHzmaqcTjJIGt0V5ciw5dat207q9wtUKR+QQXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769405910; c=relaxed/simple;
	bh=aJEDhuazncVi+2BKcDO1OcbpD3PfFITAvjNO5Me2aHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zgem6xVosMn/jlqpEQJ6lwZRp67Vkhj2rUGOrQYJClOyUSZktMPP3YOoFfcONcNDd/fibBpofUbOJaDalGep2y/8Gt8fP+MPecEUEv6TqKuK0irZR6xBE38l9pQVwY+sO3eGVcuZ6QdXIGACiElEhOsn8vxyD8nPV8GJRBEoq1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dUySapLU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dUySapLU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XrnhF4Ua5LyS+w5Z2v9ynhdsh99fyMBVvMhyonZis6Q=; b=dUySapLULTjc39Ok/bYyFKVMNj
	6B2h9CrDSgD6fWo18eiYpIjfeXvkkuNGTupR9zICsFCzwzmuCvdxGQDRc/GebB416wZ1an6oax5v4
	U/HgdWa30fe0po2z8etat1U4I7+lWjuJc0W+pjSb24yzfvWF3wG4XwPohb/TBqKip3/vdjMjmudiF
	k5kcP09+lo1M+SOpYN21rdwqsy0TceYPA5t4/AvE7Lplk96PZd+Tl0jP6V7CQ+cHv4+SXV/YGp0iX
	72SfSks+g0sVeMGJfWarHDeomYK6ALp21NR3gtWSOsQCaz3G7jn2vC+w6GhfvpA/vWDmRw+qGTMiD
	AN+eMi5w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkFIy-0000000BwV7-2ecz;
	Mon, 26 Jan 2026 05:38:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: buffer cache simplification v3
Date: Mon, 26 Jan 2026 06:37:59 +0100
Message-ID: <20260126053825.1420158-1-hch@lst.de>
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

Changes since v2:
 - mark b_hold as signed in patch 1 before removing it in patch 2
 - document the changed locking in xfs_buf_rele_cached.

Changes since v2:
 - add more details and a link to a commit message

Diffstat:
 libxfs/xfs_ag.c |   13 ---
 libxfs/xfs_ag.h |    2 
 xfs_buf.c       |  234 ++++++++++++++++++--------------------------------------
 xfs_buf.h       |   20 ----
 xfs_buf_mem.c   |   11 --
 xfs_trace.h     |   10 +-
 6 files changed, 91 insertions(+), 199 deletions(-)
