Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E722322A21
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949728; cv=none; b=mmC3x+1Q3vYhyqRb6EVK2RRVFSKZ7xsBJXOhphU43Ov96AdlCO9oieIUhj/q4/+tLGt3/rwniIyQs0Y+i/ZpKfXs0gK6a8jqRcHcCqiLf8dFRGqvkg8a8cUFFrjNnHFCq76YVK2yI+XjvlS6RYZtREzgKfr+w7B720F3Jc1PP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949728; c=relaxed/simple;
	bh=ohbeLohTUP64cWhIi960Y0ot2eSUVZZ6ZUeln/UbFBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fomhTgwTLoy2Ajq+L2Bg21bARbONJ2Or+aub1gk1YDKECXYRw93eKe+M3FQmiv9CnDHD0mPdKocob9rWk14T3k2lGvHzQ6bL8UmFLhPl68oZIS9mLnEPRlgPvJtytMjPSsaeQX6s4M+Bl76DBiyV01aUANJzXTC4bFuIrRC3W5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mLl5gNeI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mLl5gNeI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h4oL6EqVOf48HJFRdky1adx5mNCoWQrxbRmSu0Px08s=; b=mLl5gNeI3Uvc2b6ayZ49uWPlEb
	+4z8UKB4XCOOk/6wy7pLtHCLuJ4Vpkkeb8YZW+5qdaoAXyIk1AZlqJ9VCWrdLWZGSnkwqVfNA1fUS
	43BYth5aACfOK6DkVigizZgfNuUCb5iAYOwqtNjPhF1vJcwUAp1/ao7fXb77mly3UOTF/olWVQ05u
	dakbkHvfGRY6BD7LqFb8/oAaE6VY7xo8ioP973Y0S/TT5a6oXWowZspveSmEkTojF4TS6wQrwqw7P
	tTeFBpNBrWLa94SGVdbuElH151NRhsDGFnWH9mNCa0PWfwqjwUhZ5iu5+AZNIiBJKWwHdR+Tbqw75
	6V1eJ+6w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9kz-00000008lD5-29ji;
	Wed, 12 Nov 2025 12:15:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] xfs: regularize iclog space accounting in xlog_write_partial
Date: Wed, 12 Nov 2025 13:14:22 +0100
Message-ID: <20251112121458.915383-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xlog_write_partial splits a log region over multiple iclogs, it
has to include the continuation ophder in the length requested for the
new iclog.  Currently is simply adds that to the request, which makes
the accounting of the used space below look slightly different from the
other users of iclog space that decrement it.

To prepare for more code sharing, add the ophdr size to the len variable
that tracks the number of bytes still are left in this xlog_write
operation before the calling xlog_write_get_more_iclog_space, and then
decrement it later when consuming that space.

This changes the value of len when xlog_write_get_more_iclog_space
returns an error, but as nothing looks at len in that case the
difference doesn't matter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 93e99d1cc037..539b22dff2d1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2048,10 +2048,10 @@ xlog_write_partial(
 			 * consumes hasn't been accounted to the lv we are
 			 * writing.
 			 */
+			*len += sizeof(struct xlog_op_header);
 			error = xlog_write_get_more_iclog_space(ticket,
-					&iclog, log_offset,
-					*len + sizeof(struct xlog_op_header),
-					record_cnt, data_cnt);
+					&iclog, log_offset, *len, record_cnt,
+					data_cnt);
 			if (error)
 				return error;
 
@@ -2064,6 +2064,7 @@ xlog_write_partial(
 			ticket->t_curr_res -= sizeof(struct xlog_op_header);
 			*log_offset += sizeof(struct xlog_op_header);
 			*data_cnt += sizeof(struct xlog_op_header);
+			*len -= sizeof(struct xlog_op_header);
 
 			/*
 			 * If rlen fits in the iclog, then end the region
-- 
2.47.3

