Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2ED2E62B3
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 07:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298834; cv=none; b=muVN3+alhXsVFu60ymyGrprx02+BjWLpIIievKX0y33Zy89elyfEcbOwZCO6VjWnz1PZIVkoEvQpyrzq4qY/LwCJMrBGBxTAhDdpGIpmDriRY2E0zhGQyEx8I84eNV3r3ScZpdqOn7am1Wicw7tLXys9wHs04ohUsk27AVFdm3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298834; c=relaxed/simple;
	bh=hLunydArU0VyErmTlKC2MgXrZS8pwSkc5FktZklJT1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bAIAg8jpm5kSnxR1zWa+SGc77jpcJNdryYUiMohbrc5P4LeQQsE70c6EKXyKXPdP41qXnOYCtqgaZcUN8v7Y+hCFIdsCaviTYet4zyCpJSMZPPKxbBKAR+S9okIY2qp+b0uyQ/5hC9hgnMiCiTB4XKwVM881xDqarevccd9Dg7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fCruRiBm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fCruRiBm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=aKixAmniqFf5+rYMVbyny/2RhAK5awiw9N95E2FOuvM=; b=fCruRiBmLf33VyLrhyLI0FekJm
	iZGu7hdL/64pDGGebAKA/3D0LjPkMkCXeH14VxQ8hfxIpKfr4WE1uwpnLT+aEiPXRQM4flUP9x91h
	xUiR1XIpnwZ3jIjgYwqM2rIilAYa38zX8YhNu/dBPPYFCYrEAsjELUp7e71r3j6dSmaEf8J09ep5+
	GiZv9xqoUTFRR9P1BhXFlxQnULe24YxR2zrEdrp05Hy8VKYzMrFUxV3zV/MP06scLbhv8f+0NwZvt
	Ru9rK2pOfl9j7msCe4+abKC6gaqakL9cIJhAmZnzy+s/l3eX4XwCLZKO/NL1e8hLbKA12Bo41/e2R
	uRDq/BfA==;
Received: from [94.156.175.128] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0a24-0000000DVg5-1lxr;
	Thu, 12 Mar 2026 07:00:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs_io: print more realtime subvolume related information in statfs
Date: Thu, 12 Mar 2026 08:00:11 +0100
Message-ID: <20260312070027.1156793-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The statfs call report information from the fs geometry structure.
Add the fields added for realtime group and zoned device support to
this output.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Changes since v1:
 - use a consistent subject line prefix

 io/stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/io/stat.c b/io/stat.c
index c1085f14eade..e3b3574e0416 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -282,6 +282,12 @@ statfs_f(
 			printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
 			printf(_("geom.sunit = %u\n"), fsgeo.sunit);
 			printf(_("geom.swidth = %u\n"), fsgeo.swidth);
+			printf(_("geom.rgextents = %u\n"), fsgeo.rgextents);
+			printf(_("geom.rgcount = %u\n"), fsgeo.rgcount);
+			printf(_("geom.rtstart = %llu\n"),
+				(unsigned long long)fsgeo.rtstart);
+			printf(_("geom.rtreserved = %llu\n"),
+				(unsigned long long)fsgeo.rtreserved);
 		}
 	}
 
-- 
2.47.3

