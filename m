Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5A3E3C7E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221202; cv=none; b=CXZc+ytHBj79EnhuQ2AOwPHwPRwOT7tolnMTJ4d9aTCLOHcMxz5NV+hz4WA3BKGYNDLVp6CH7ZV6VTzTME0ql3MK/S+SGVTvAS7E1tJcV3/LQKPUS7f2gE9TgJL5o/wMQzfV90X8R5QARvpj0Txy2Ced+mswJkWrBrXjGMJ5Cw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221202; c=relaxed/simple;
	bh=LjeTpkV1uezTWo1aPBaKujmidCqc41UfsubViccIbD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SAWqjECTDaZhk/8ZinutsEqht9XpGp8tfc/ZIoG4otoA7yT+OPI8SAEbD7s+kFmbHqIvwLDxc9SADuyFn8wIzOgtJYoaaSKOA/GnKiGDE68JiRqNqo7g8dvjcB5LQZBNM3odawpUXVcBBB3azMwNHTOZTVrvn2oFLuv8W6T0s4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wehmyTbj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wehmyTbj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=G0vSZ0Y9UPnf0oHPOOMTJLTTzGNo3V6M5ANRchoYAMY=; b=wehmyTbjFAeTdmUFVxEMb7TAob
	4Eqw2B2hnow1FnLWnGkhEHNkF+bazN6Bo28BVz7gNB4c2BUfzQYZv7bw+BSA0btoom82LgpK724Zp
	FJulR73spB7TQw0paIo4aqSYq2ZcgJSLsX7k2nvNvxeGPBmwWsAEX1AhJZOV43ArJm7swCUlFS4+5
	G1AVKSGgxIvnxHiOAC17teH1XZUOzyH5i1vU8vaOxRXfxmcrsXg3ivEEODnZVJcIlOptxTYQ0HAKZ
	xVD+1XNhfHgux4UN7QaAB9w/TVXuC6nJKflCw3vjUpfskPWqAeeC/Ik0HfueoQ7ug9oCIMRznSy4L
	ozscx0tw==;
Received: from [195.12.231.117] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0Fpt-0000000BHbL-28w3;
	Wed, 11 Mar 2026 09:26:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] io: print more realtime subvolume related information in statfs
Date: Wed, 11 Mar 2026 10:26:27 +0100
Message-ID: <20260311092634.995699-1-hch@lst.de>
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
---
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

