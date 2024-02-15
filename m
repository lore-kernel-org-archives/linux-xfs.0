Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB12BA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980075; cv=none; b=VY4wiTtvi6kL3dcm+C2izX0SJB/DTvucUTFmz2pu0qIKw6fU2vYQH5j63uDtL1Io0VVVPNAXoR29f8S8hbx0zUcRtKuSb1rMFoFxcmd/io0EuuaJyHfX5I6Fvy7PAA86ykZ7pOuqfbDwv9r1mZ/DFiz50hOm6OM64Y50QIaB0ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980075; c=relaxed/simple;
	bh=sAsAMRlHD8KYqOUcyBZ0UR+HsurbXkBXXGb+K9mnSH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JL+ojbjQxXFFqCjCT4BK7csFwcAWoa4EIwmbAI0O5ymKzWtyt85Q7WC2my0d3gLhhebab+t81uvuQd0z0kzWmZOInW8cCPuS9N6E1/f4hgzC+AZKkxMXj5hElcwHor9LXm3dVZrM5RIdPUh9W3n20DHbqdr5PI//aS0SnEFCPAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0qog7HJC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0qog7HJC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ahjwkPJT9VLgRZBjI5BqDtGRPHK+gjD/7EVVk3cy9TI=; b=0qog7HJCD3qJwwlAebgoM+okbx
	w7y9lWlAVcTXffxLdyIrbBNofZjnc9a2FrUMHNFfKxbV4zQHIbpxPNZe6D8ZVzylYpo4MabxVW7kw
	jK9RHv9UTK2tvu3UwSa6cBzVsrecI/49QkBzh4uisvSBzFEd/hVnAdXeFCgdx/OjTzpDD3gPzp0ha
	TJqaP44RjHPChouhus3gCJNBR2FkEmleFrsxvnS5yvo9A3AUFzXhsoz/+Ot8MeMV+OrFcDwv0NPsZ
	G/WuyPlTZJmb6bDjE9qTKU+duaOij/NOTVf/Yo34PE/Fy3EJVTs1QbFBBYB/1dTEwKoitUrVyGdeg
	5CK5f3Gw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdh-0000000F9BU-0p3Y;
	Thu, 15 Feb 2024 06:54:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 01/26] include: remove the filldir_t typedef
Date: Thu, 15 Feb 2024 07:53:59 +0100
Message-Id: <20240215065424.2193735-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Neither struct filldir, nor filldir_t is used anywhere in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 include/platform_defs.h.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 64e7efdbf..02b0e08b5 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -25,8 +25,6 @@
 #include <libgen.h>
 #include <urcu.h>
 
-typedef struct filldir		filldir_t;
-
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
 #undef SIZEOF_CHAR_P
-- 
2.39.2

