Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDB01E9B1C;
	Fri, 21 Mar 2025 07:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541721; cv=none; b=AlnTSJqQWIFkJ0tnY/d1uV6HAl5YXA9/uDJjDK13lWH6Twc9Q6FhAkup4e9C9YmPmlzgkGz4gA19C41tVN36vg30e0yJQFaz2x/QgJsuf1ts0SqGKm9UHZA83UH7Bzs/FruHzuYsJm7HyBs/SH3OPPR5SEsD/bhBxgO4iunXjQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541721; c=relaxed/simple;
	bh=S9/nZcIo3PEzz1VIKgOUtSLBZAj/c3JI+g15Bfk2gwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJuI8+bMFQ8NZtyFDITi6OCnFaBtWCXrmTAxPGtZulfq71urbCls2VVr5p5UPuHHyz/jWeWY/pRNR+a8uVZazAO3GU5o1CLsr7YxIE7UYAup97TCMtNFNHTNgYpOfGj0YaOlhVmIn7qvqO8Xc4XHNNY8kYqHY36VeWT9ndJGXv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1T0nz1iE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1T0nz1iE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V0meUuAUHYdocnXYZda63A/Wcy3Jp/42ucClUA1A2DA=; b=1T0nz1iE6RrOwc+2ssI6WOsvTm
	40Jq/AVZkdBJAYQ4n1/4hD+3Ty+E5LsMfjC6+UXoVzDL+fc41STgxIP7r3Q/TP9re91Y5pbOpMrhJ
	6LoJogAShPBkJI86rrPhNFceS7WzHka2GAtblh53+6zBtNtoyaPRSVdAaWLlR9KYfzCBGbtgVB4vL
	Lt3b9v4YVprAJJ7gIyrr47uE/MSdNt3CGpUGCD5o7XgoRXTkU7qftZ7K6YEuIhFn4raCCP4SQD5np
	JktN+sJKhcyLL7HRBnrwpGzZ0bFNozZNU9MGskR18o+41Tkm1iESDN2yjSoa/XfmAg/Xgjri9xP1t
	66yose+w==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhb-0000000E5CW-29VV;
	Fri, 21 Mar 2025 07:21:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/13] common: allow _require_non_zoned_device without an argument
Date: Fri, 21 Mar 2025 08:21:34 +0100
Message-ID: <20250321072145.1675257-6-hch@lst.de>
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

So that callers can pass $SCRATCH_RTDEV directly without needing to check
that it actually is set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 7cd8d5ffd2e8..dc6d4ce01e05 100644
--- a/common/rc
+++ b/common/rc
@@ -2545,8 +2545,7 @@ _require_non_zoned_device()
 {
 	local target=$1
 	if [ -z $target ]; then
-		echo "Usage: _require_non_zoned_device <device>"
-		exit 1
+		return
 	fi
 
 	local type=`_zone_type ${target}`
-- 
2.45.2

