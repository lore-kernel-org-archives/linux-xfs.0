Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9542058
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868130; cv=none; b=D3T5cDWFGP9q+HGzLxd40v1MjxkOlPLgSwOTqKhf4iRUYlTqsHVabBsgUV1cVuoZGfAvvQr6Vd3aIMi2+I4N3C/8hG/fQ82taO4uiNBi8/2jw016yHIY4byLcsNgiiI40yy1S7W8ja8No9GG7Cb139E7yyepKL+G0J6CnrZskr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868130; c=relaxed/simple;
	bh=B1eOuAZkx9Pu9OGsV4CKE/l4I3y/4bFwVjWBPXTyl4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el5guxAsY4Rc0CdMEE0qrAtlcmRpIPvGeF1Fpywx326JVQYgpd7PLXdHVDLi7Yujn/oC/kj4n+0rFiFcZXtUPhGV2jgpsWT5J4nvcCWdHnEe/zQdzUVXW5E5HY80Ua9vup8daYMUZA/qdjQBKrzg0ygMtMSY2Q8JwB8S/4cRHmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rHSX/2pq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rHSX/2pq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z8AW968Fz99jMlvhAw0+6auj7U/QMMjpl/YT0DsCG10=; b=rHSX/2pq5w6Z5yu7EWWdSNQcqP
	evpNdaCG5bdSwIkDyBM+dPZ7j7RKierXtJfn27eQrQ2CIx9PrhUWKR3PpCnX7Li7d5Ca6lKNFeUsY
	5c8p/C89E9mo20bHc+fG5Yn2u7w9AbW7kOmUpCkuNf+3Dn42zTuGQNbW77nhz53GYiyj10W099t3m
	WnrBphD6XIaxXLnQnRIwW5fmwBsWY9q59bVzd2hRVYR35gzS/3JKgNvOYzYvaYc7VTz8p22CSDSdG
	F5pN1vUmdqOr/MZfAC4d3kzR7KIllffmz/UF7nf+uQgiUg070+d7nwvbSKr1a0teFYdycxNqBVUUb
	7K5mQwAw==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7U-00000003xbb-32op;
	Thu, 20 Jun 2024 07:22:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 07/11] xfs: collapse xlog_state_set_callback in caller
Date: Thu, 20 Jun 2024 09:21:24 +0200
Message-ID: <20240620072146.530267-8-hch@lst.de>
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

From: Dave Chinner <dchinner@redhat.com>

The function is called from a single place, and it isn't just
setting the iclog state to XLOG_STATE_CALLBACK - it can mark iclogs
clean, which moves them to states after CALLBACK. Hence the function
is now badly named, and should just be folded into the caller where
the iclog completion logic makes a whole lot more sense.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1977afecd385d5..381d6143a78777 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2507,25 +2507,6 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
-static void
-xlog_state_set_callback(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		header_lsn)
-{
-	/*
-	 * If there are no callbacks on this iclog, we can mark it clean
-	 * immediately and return. Otherwise we need to run the
-	 * callbacks.
-	 */
-	if (list_empty(&iclog->ic_callbacks)) {
-		xlog_state_clean_iclog(log, iclog);
-		return;
-	}
-	trace_xlog_iclog_callback(iclog, _RET_IP_);
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-}
-
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2557,7 +2538,17 @@ xlog_state_iodone_process_iclog(
 		lowest_lsn = xlog_get_lowest_lsn(log);
 		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 			return false;
-		xlog_state_set_callback(log, iclog, header_lsn);
+		/*
+		 * If there are no callbacks on this iclog, we can mark it clean
+		 * immediately and return. Otherwise we need to run the
+		 * callbacks.
+		 */
+		if (list_empty(&iclog->ic_callbacks)) {
+			xlog_state_clean_iclog(log, iclog);
+			return false;
+		}
+		trace_xlog_iclog_callback(iclog, _RET_IP_);
+		iclog->ic_state = XLOG_STATE_CALLBACK;
 		return false;
 	default:
 		/*
-- 
2.43.0

