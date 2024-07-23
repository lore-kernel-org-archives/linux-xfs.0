Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FDD18D;
	Tue, 23 Jul 2024 00:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692845; cv=none; b=rQ7Ppq2R9RS/AwQh8TaL8uxnTEgjNzdE9ePD5kCSm+uu7oAIbl5F7WRKxXPB5ahFGY1Pf8KqDOFMhYo+b2tZWrv6TtVMh6RYMe08/2Ph1qJJgMAqT38ZaAcMNfsI9KGd2sl/CWOZ/rJ8hxIB7OenG7qIPG/8FBxTP1eXoaownYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692845; c=relaxed/simple;
	bh=nZcwkX0GC2hzAEvzEvQKviILozgwttFQmIDE5KCyd0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8urWgqi6QmCDznxR0ImCrxKCeN/2XjnhkZfZPqqzobvzXlIsRIlfd2Fr85Z9uSKRMFH1dxkth11hjT1eZP2kpbEsuKFuNWesOUlyBZLqlXRrHpkl8Q78H0c+1UnduA+NfW1GNCicLPMf1sjiVjhFDYfiLn08P1LRdiX5tnQJoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=43P5Aip0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="43P5Aip0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VT4CC/TOyF/jaFSIn8PFV3vlyTWiBoN89eUgsIfWnYc=; b=43P5Aip0o/V5DuYdWZxZqAD4vH
	ca37FcuW5CYOHvyhJxR9OtzOrddLSGjW7RRWsVP6Fwery1JSYsfv+s+Lvx/ICG8AY1VTVCWdF5nxd
	+9kuTsKNPbXzgB4kRPdsXFoSpzWU0n3/zFb3p+SeUi20EC10W2UhzWmSOegFyKsds8Z5Q/b2yiKjO
	R/qIhq4kmWZGWXyAedgfmahmIMlbZqS1TDXukC3L80wjYveN2AfSYbl8/Q0M7EqgLsUatFkFY9L8I
	l88TeNaChLsYqpKR8O8TvrDkO77C8B48cPpo2tQ/Y/QJcI2KuHWh0ZbPnLCI+47HlFVdZL50V79yt
	7LaD/EvQ==;
Received: from [64.141.80.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sW2xP-0000000Aumd-3Clc;
	Tue, 23 Jul 2024 00:00:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] common: _notrun if _scratch_mkfs_sized failed
Date: Mon, 22 Jul 2024 17:00:32 -0700
Message-ID: <20240723000042.240981-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240723000042.240981-1-hch@lst.de>
References: <20240723000042.240981-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If we fail to create a file system of a specific size that means it can't
work with some of the options in $MKFS_OPTIONS like the log size.  Don't
fail the test case for that, but instead _norun it and display the options
that caused it to fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 2fc38cbed..f0ad843d7 100644
--- a/common/rc
+++ b/common/rc
@@ -1168,7 +1168,7 @@ _try_scratch_mkfs_sized()
 
 _scratch_mkfs_sized()
 {
-	_try_scratch_mkfs_sized $* || _fail "_scratch_mkfs_sized failed with ($*)"
+	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units
-- 
2.43.0

