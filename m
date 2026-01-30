Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FFE183CC3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750420; cv=none; b=ETH5+J8KCgskxMf3biGpjq7jd3KjmhoCnCXiyUr6sIkBjNUem/DAePFeSRK/DfmnV2xUNCdnlnNIVDxsA2qvUcNop9FiZ+04oCiqgtRCz7lmVbSMygOx1keL6SYeg1rGMei8ju0e48okGh1NcwNRh466Lieqcq/1YbheqejY5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750420; c=relaxed/simple;
	bh=Pz3SjK32InW1pcxVV1vAwJyOy792oFEX+xvEotFEyuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8yUhUhZ/sTEzOVMwzGMeEZncaNX3xkKOLArbZrNAtNQmyb4LF0yvMiw0C/DwdZmuOCfUimjFsocVB5zd0y0GS5ywBMOv/ay6eJytMk/o8zGxm8QMAA8K3ZB6t6iad8deTLU4DCsVcnv9LXg3Rm+O1ipThqR01HH+OMJgzgOJHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ew6rHhyI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ew6rHhyI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=tt26cWT8+YLZjAaLJqBbMMPsrTs/l/wiG8Piow3o6co=; b=Ew6rHhyI8qa1Ruhb096JtMGi4v
	hR3MLS0T7NM8JFoqKg7BwvEnsN3gDWuTeagHypfi0SzYdm/rTZWUfkoxLBgM5lm0dSpJc/xdYIUjx
	+S+5DCezTIsZslwKB/bTNNf7h+9XMof6CukchB5Vaj7561oByVQVuzU3dLcaQdMjNo2zXJ3gEamQH
	TobPbNrcJbaKztzz3EE/x2NR+YcvX4YCwBAoOdcwmmEfAsNvuklMaxCZatbhu4HYnn+ti+5WxVEou
	Mn5KDfbjSmxzktbVbvBsRGyKD6ms0jS9SdieHwchRvtu+oKQmhv570wxaHkDEVeDb1btd16twQZ6B
	7BQYIQxg==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvX-000000013HQ-3pjs;
	Fri, 30 Jan 2026 05:20:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: stats and error injection for zoned GC v2
Date: Fri, 30 Jan 2026 06:19:15 +0100
Message-ID: <20260130052012.171568-1-hch@lst.de>
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

this series adds error injection for zoned resets and zoned GC stats.
My initial use is for a test case that verifies zone reset error
handling, but that stats should also be very useful for monitoring
tools like PCP and benchmarking.

As part of the error injection work I've also added a mount option to
enable error ibjection at mount time so that it can exercise the
mount code as well and cleaned up various other bits of the error
injection code.

Changes since v1:
 - improve the errortag mount option documentation
 - rename the defer_log stat to match all the others
 - rename xs_gc_write_bytes to xs_gc_bytes and correctly track it

Diffstat:
 Documentation/admin-guide/xfs.rst |    8 ++
 fs/xfs/libxfs/xfs_defer.c         |    2 
 fs/xfs/libxfs/xfs_errortag.h      |    8 +-
 fs/xfs/xfs_error.c                |  142 +++++++++++++++++++++-----------------
 fs/xfs/xfs_error.h                |   23 ++----
 fs/xfs/xfs_stats.c                |   12 ++-
 fs/xfs/xfs_stats.h                |    8 +-
 fs/xfs/xfs_super.c                |   20 +++++
 fs/xfs/xfs_zone_gc.c              |   72 ++++++++++++-------
 9 files changed, 186 insertions(+), 109 deletions(-)
