Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4290D1E9B2A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907491; cv=none; b=raKnvQmdcVjo5ECzWv9pTUwWJqAh1unkNNdre2+WxOhBkA01qODlr5gTlhAexTg8nCQtTX89IzrePq9dy8La+s+Ah/4uBxxK3enfVmarK9xilF1O2clfEivBZvYH/rFT4qgrMskrKh4DdFnyHfI0upUV93TkZmUWqexC7DGa944=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907491; c=relaxed/simple;
	bh=0FnlNXllr9CaQd98WKKmyk+ghwA4MeKeqWzrZW6z/0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMl4smbYdQnb2nmC7vTnddO5TJoLYLCvGhiqqJ3GrzCCrjPH2deVwb/ORDVb6EjjnLqQmqSh7TMf5nx3haEcONgxRHGZyEsvVzQuh9G8jhkMW+w0iJqATqEZpXg+HAArcjSb9PfVnl2Q03fpQYnGm4HLY1xAnguhKfPt7bcrSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DzrlDNu8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DzrlDNu8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wS+aMdbVhG2pn7LPdlwqyE4+BsP//OFsk21PsgyaUS4=; b=DzrlDNu8AOc2zEaOC71AN3G4+L
	gS3CHAJ7lZpZsFm9e/HLZJJ6nIyW7HbAh7OlsdnMjFNoKLJSyKPeY5JZZY2vK3rl7l0+83sU8LH8L
	039krzNwkB2Na0Xfbv8/kMHoIqfPInOjT6+Hu5NStKvjh9nHRwC+nNp3mS6GAq04f6jsvlYLrLtgP
	AtPQl5ldOuTcmL0grPRVuZ0o0OtJZ1EnKvXpdW3mdKeGpThLhRl+xgtjriBznIE9Aet7Ush2acz6l
	rPOkLV0ymHSGuH2/cJ2nSzqoGRKh2MLK+g41Ccg0ULDfEmw+HbBEyy4sCsb471W9XEUw+z7SgBmnI
	aujlP76g==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXp-0000000EJPR-1LMk;
	Wed, 11 Dec 2024 08:58:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/43] xfs: allow COW forks on zoned file systems in xchk_bmap
Date: Wed, 11 Dec 2024 09:54:57 +0100
Message-ID: <20241211085636.1380516-33-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

zoned file systems can have COW forks even without reflinks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 66da7d4d56ba..cfc6f035ecaa 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1039,7 +1039,7 @@ xchk_bmap(
 	switch (whichfork) {
 	case XFS_COW_FORK:
 		/* No CoW forks on non-reflink filesystems. */
-		if (!xfs_has_reflink(mp)) {
+		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 			return 0;
 		}
-- 
2.45.2

