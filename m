Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C70639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868115; cv=none; b=DzYxhaRngbk+2u4YsEdZbhJJqJOjJcKhTRWYuqcaMYG4coE4u+TNOgZ+0/7pMyjm7pAzxGo+ITrgR665ivT5+gNx66zQdzcjDMppDHjBlWZXfq0Tza6KlHXFc5K2OFivF2zb0vSsgrgZbaFwCQoydju99VP9Ylur31S51x3geP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868115; c=relaxed/simple;
	bh=pcJXZ3cKA2T041aiaBZgToDQADccA7auqZaOaPyOI48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1Adp9GH0uNL/Elw3uSnD1j0ntHbn5OERsWIqr3/yW4CimSGXRjpQItD/Qp+pK5etjwzJ3gAGUpnp4vHIUYz8NYajjSHAMf3bTVqqvfZGY+U13qq/EghlmUOKLeS1U3ft+CXzvTrse89HwflqVDTn5d/zCjLhSCfP8xJZa3luEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F/XJsR7A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F/XJsR7A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gOZW60U0l4N7L00yEk9pU+wWQsIbEQf2Jk2KrgKQA+4=; b=F/XJsR7AAmLKaGhoKDHLHhhXwr
	FwTUJ6gxR9eKO4cfGPhHNyHrZo6XoQaLpgCr01Hcj0GgQyCJCeZbQBWK+jPAJ3h2aLBFzgR5Gxuwt
	uuJCDyL5k+raibLOrXQYhsMz83cMJetN3QcU/tmO/Ldj77A66gZB5DZ1nLwenFpFW7xQhwtwVnWxR
	Ml1HpWEZINhSXIZQ5ekz64jGEWZFpUhnjMVNi2acBiBAVp/ZRwiclfju1HWG0pH9qjqQAaoBbYXv2
	R4/S9hfm68aX3A6wRyv+28yPYE3gdOUri72W6lbEOklb0Vw326ZezoDxLwFFrM05knVSKQZUF1ZA9
	7z1QtCHw==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7F-00000003xXz-0q2t;
	Thu, 20 Jun 2024 07:21:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/11] xfs: fix the contact address for the sysfs ABI documentation
Date: Thu, 20 Jun 2024 09:21:18 +0200
Message-ID: <20240620072146.530267-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

oss.sgi.com is long dead, refer to the current linux-xfs list instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/ABI/testing/sysfs-fs-xfs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
index f704925f6fe93b..82d8e2f79834b5 100644
--- a/Documentation/ABI/testing/sysfs-fs-xfs
+++ b/Documentation/ABI/testing/sysfs-fs-xfs
@@ -1,7 +1,7 @@
 What:		/sys/fs/xfs/<disk>/log/log_head_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current head of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -10,7 +10,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/log_tail_lsn
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The log sequence number (LSN) of the current tail of the
 		log. The LSN is exported in "cycle:basic block" format.
@@ -18,7 +18,7 @@ Description:
 What:		/sys/fs/xfs/<disk>/log/reserve_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log reserve grant head. It
 		represents the total log reservation of all currently
@@ -29,7 +29,7 @@ Users:		xfstests
 What:		/sys/fs/xfs/<disk>/log/write_grant_head
 Date:		July 2014
 KernelVersion:	3.17
-Contact:	xfs@oss.sgi.com
+Contact:	linux-xfs@vger.kernel.org
 Description:
 		The current state of the log write grant head. It
 		represents the total log reservation of all currently
-- 
2.43.0

