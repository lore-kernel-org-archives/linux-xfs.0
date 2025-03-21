Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0371EC00C;
	Fri, 21 Mar 2025 07:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541728; cv=none; b=vGOOr+/j/EZtEXuMyFRUwnAFKQWD4Hubb1OHRrMlgfO7Z3f/Q3KpA2XaLcoBpCQkwEvlFq/XggvigzK65LlNtaefNol9Inmi47IA0JkR0A705CZ3Ikug21Y+FLooId5mBlUuRuGpzR9SvCrqBIgMM6J9bCRRSlwgHKF+CbDI88I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541728; c=relaxed/simple;
	bh=LxmhSlfcBvjcKGqxS4JI0t4XWOQhGKh3Qtydkyo4nz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i86Ty6AA5VVIqtFJX/0U6+dNKbLL8K0YunoFJmSrKe34GwwV0vTm0yLa5IGwCi45+X9oZozvuf3sJLFTVPr7BL2QarL6B0XpkXT86oo74nLmGaDSCo3NksDovr9ubr1bNRrc4YtntZFgc/Fzg75NKW7+aRmn1HSoOwmC/jA/y3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZNFhUHps; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZNFhUHps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0nPUv+T7jaYRuOS0PUXTD32oEmQgdrfp//NX1PXLKB8=; b=ZNFhUHpsj8U4fHU9eDRVWVp5ka
	LdjmF+Bjm3oH7SQQoGhcmTdSY13udrg/aBzsvzEUuSYy32tXAapzOVvDDYPVsJaj4kiFWy0kyW/va
	x+IERdpl8F/z/QeUHCLwSePGs/T6998MoW9n6wAbI8krGeYIcUSEKz3ireyy8MtU1BPm0KgF0IruZ
	L2PWiZhYx2i9S7uKUTxWNED008HKiBe7T/ftyxhGLe2EueMycWQBnO75XLFVHuNMG0RxTLA6um0FB
	kibSxJoJTUmfOKbYMO8PmgX7e1izobMIXJhKp5No/fn3MUSr9o75gEVeMc5jGmPcNydNb+suifRCG
	c8Ukqhbw==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhi-0000000E5G7-2L0P;
	Fri, 21 Mar 2025 07:22:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] xfs: no quota support with internal rtdev
Date: Fri, 21 Mar 2025 08:21:37 +0100
Message-ID: <20250321072145.1675257-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same as regular zoned, but the previous check didn't work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index c1b4c5577b2b..ccf263aeb969 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2206,7 +2206,10 @@ _xfs_scratch_supports_rtquota() {
 # can check that quickly, and we make the bold assumption that the same will
 # apply to any scratch fs that might be created.
 _require_xfs_rtquota_if_rtdev() {
-	test "$USE_EXTERNAL" = "yes" || return
+	if [ "$USE_EXTERNAL" != "yes" ]; then
+		$XFS_INFO_PROG "$TEST_DIR" | grep -q 'realtime.*internal' &&
+			_notrun "Quota on internal rt device not supported"
+	fi
 
 	if [ -n "$TEST_RTDEV$SCRATCH_RTDEV" ]; then
 		_xfs_kmod_supports_rtquota || \
-- 
2.45.2

