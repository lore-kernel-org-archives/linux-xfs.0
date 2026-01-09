Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905822B5A3
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975812; cv=none; b=tAmoSK8vwQmmjhoBOv9PS8kWvUBsHMqkCJDjNCXoFfB2SH/aq+OZgAUE3/kVJWfBwglTxmgdvc7mbJDhQjPT5SiItHWubl/JqMG1MBo1WDMC6y+fWlmL39WfzhK54vVFynVjIELIxsNF8lN2NpTHKSWoN2TLgf6PrfHY+VE2yeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975812; c=relaxed/simple;
	bh=OeC0aAE+ZjW8XHL1wtELAIFhX6UDmFvwLmPyUrYhLS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PrLwd3/OZ4uN79BWpdzB18nPHPsDH6VbRweCxO7hivjXdI7m0/tX1oM29zib6yK9zaccnx5mGKjSSo+SkSWYOGX89OKtD8AHaBHmIWjCIxqvFPHyzrIG5lKtHuskR31ipSP2B+j1p6GAosfpgyhSosZMyzq4Re5nnFkUWSPkdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k3Ie9LBp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k3Ie9LBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=USpMD+e6yeFiCs6ErXn59Mp+dn/nY4R5Q/N/3ihCKPU=; b=k3Ie9LBp3mWBwS58oyaApNu8rI
	fWC/HZpKlSmLMdZ+pcm1UWPZF4poutyuXmVULpLRVpweMyZLl/YUa3uNP6NRaVb+x3VgdKTpbZotp
	GK+BigvsaYZeEAtDDfq5amSqedPnoNo85MJqxSd7CaYyWFP9HlrR3NOepLDxHJ+WucmFfHXp/7lyM
	Oz2FaG45Z6BnpddFkE5pYOtfmm4QY/WTDXHo0OjGQDDOoQKeICZkAf8brZY8+irnN8TUG98XGpQd8
	ZZuXK+M4dFKPKXcNE8+sfBd6TB1wGYGA0gnU4pxanctGOznN1Rea5h58hISpIGBUoG9hiy6T9dOMS
	c4St0P1A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFGr-00000002c9f-2Zwz;
	Fri, 09 Jan 2026 16:23:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: enable cached zone report v4
Date: Fri,  9 Jan 2026 17:22:51 +0100
Message-ID: <20260109162324.2386829-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Enable cached zone report to speed up mkfs and repair on a zoned block
device (e.g. an SMR disk). Cached zone report support was introduced in
the kernel with version 6.19-rc1.

Note: I've taken this series over from Damien as he's busy and it need
it as a base for further work.

Changes from v3:
 - reorder includes to not need the forward declaration in xfs_zones.h
 - use the libfrog/ for #include statements
 - fix the include guard in libfrog/zones.h
 - fix up i18n string mess
 - hide the new ioctl definition in libfrog/zones.c
 - don't add userspace includes to libxfs/xfs_zones.h
 - reuse the buffer for multiple report zone calls

Changes from v2:
 - Complete rework of the series to make the zone reporting code common
   in libfrog
 - Added patch 1 and 2 as small cleanups/improvements.

Changes from v1:
 - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
   fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
   support BLKREPORTZONEV2.


