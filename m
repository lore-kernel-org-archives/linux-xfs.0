Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABDF3101A9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540795; cv=none; b=kpjBQTzv6EBSxV55MaT2jqnv2UxEyd7brD8qdDtcJXkK8mMMMH1dj4i2zaPYYCng58BGS4RaA0aPaqPk/sI+6SOaUJ0OGyLKPkpeK26fvta4j1AVCfhtHp0KZpzKHNJK3bWmR0FfADh655Q4WSJ1FNgwlUq/QbYaaiKM/9tzu6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540795; c=relaxed/simple;
	bh=r9fWK4QI6Mw24W8iCByGV/7KG9oRqb3p4L9xm238W0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTnJ1O8E7n2SqWJlAxfLZNifIceRFpSjhQKum6pOxQE9501sxeyErAISb3dKQ+j1NANfE3urje7Uzcdl5Blu5wtOYJGZfA+IK3c3Fg5RZCEss9KihJLnOoFd5z/4zsnhHHlh7rZV7kvF1Z9SAF/ObjeojcbwGlSsU706mF+C6F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DPq7X8Qw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DPq7X8Qw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1DmqkQTDcZ8SYM0LOsXBdPdSBCIw3F9cFX4KvcaYN40=; b=DPq7X8QwQFpt3fLK5351cXOqjv
	M4LbEKk6pb+CTtioi+xfsFBeh9MZuToc0rmx9VTKPzCYOhXv3EBkRXJ4wx2ytMg+CCEL0hXNt7eFX
	iAH7JHSU+bgzHOa1ViW8C4L/w3cmkcA2NykHXu9gy62i+ncyOjJB9hXySvtjpaRlIVo8VR5mD/HMq
	gjss72syCTUqVQ80PsWhhtN3q0IIl0lHBlizAxR4uRjQybpdwtFfFqCR3jaIdw2nsd7h5jbpbUyNE
	9st8QzUEfaSqDMG8zjM1nF6Z7E3sEUfTro/MdizA0H8G5eKB9WNdUf6aOfRzpJj3md3mA2a3hQ4/8
	h0L9aKDA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlka1-00000006MjG-0m4o;
	Mon, 20 Jul 2026 09:46:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: add lock annotations to xfs_ail_delete*
Date: Mon, 20 Jul 2026 11:45:45 +0200
Message-ID: <20260720094609.2191633-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass up the __must_hold as clang requires it, and also fix the formatting
of the __must_hold on xfs_ail_check to match how we do it elsewhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_ail.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 99a9bf3762b7..f955479a08fd 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -33,7 +33,7 @@ STATIC void
 xfs_ail_check(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
-	__must_hold(&ailp->ail_lock)
+		__must_hold(&ailp->ail_lock)
 {
 	struct xfs_log_item	*prev_lip;
 	struct xfs_log_item	*next_lip;
@@ -321,6 +321,7 @@ static void
 xfs_ail_delete(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
+		__must_hold(&ailp->ail_lock)
 {
 	xfs_ail_check(ailp, lip);
 	list_del(&lip->li_ail);
@@ -899,6 +900,7 @@ xfs_lsn_t
 xfs_ail_delete_one(
 	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip)
+		__must_hold(&ailp->ail_lock)
 {
 	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
 	xfs_lsn_t		lsn = lip->li_lsn;
-- 
2.53.0

