Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486673ADBA3;
	Thu, 25 Jun 2026 12:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389299; cv=none; b=nhkLwXtlH0T5EZ+1wXL3B1eZ+ogyVHJBnD/B7kEOwy/ZkD3qKjNl/6/r/4kIVFGToCcuSAe7fGyVf4Avqo1/go5/OVr9Y75qz/IRwXGf5nWPnrsOUWQpSfa76uyHBMWDrS2K88rOMPEem6VdfWtnE4zWT5BClZDJR37s91OHrLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389299; c=relaxed/simple;
	bh=zAaeXvZX876NW4HBdu2eZaW/2BA59HGZK9czOxtwzCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cctSXZKRacNnm7Y7bhtOEyQTHJXhG9Rx9avf/V8G4cRT4+jg5kjCJ56SB1hdwGVpHA5OlmOGL60d4EWVb5tkSEvk5Z73QMqWiuod54VmnzK+9AhSZt3V9lBMGnwpmn2mQat2cWjZ4zYr6ZhB2h2/aFaCT+diHeB/jofJMhQoU78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0q71m/R+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0q71m/R+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=; b=0q71m/R+GeSiQUd/K98feKFlYc
	P34kbrii86+FHhdh5PQ8b3o7/0unex/bdkTL+NhIK4csq9mCsMQI6o6Z+52/Y+ryWfHyFN9APSTvl
	lQ+KJ3dURUm8SXydsx5x1qAJYfSFVw5+TBoMoD8RfmNZL2edJ6/T909UcQY9l55QxVfAC5/b1mLfR
	zNkWv9wXsaOAxDQMDMupYXjqn4v9vLerhhUeGwopSGVAgqCEXprvpZoAFkU11mgQLhTR7kWu+gEtb
	xfuu01/gNSNJzytRdfkV54k/NXtiIXybpRlGkE6ofOp3fWygkg3oFzEzS7NxCFj1E8GJU1vz60uCL
	lVIx6W+Q==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcisM-000000099hh-0knr;
	Thu, 25 Jun 2026 12:08:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: don't build bios/contexts over multiple iomaps v3
Date: Thu, 25 Jun 2026 14:07:55 +0200
Message-ID: <20260625120803.2462291-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this patch changes how iomap submits bios for reads.  The old behavior
to build up bios across iomap was already considered problematic for
a while, but we now ran into a erofs bug because of it, so it's time
to finally fix it.

It would be great to get the fix into 7.2 as the fixed bug can be
triggered by users.

Changes since v2:
 - drop an unused argument
 - make sure we submit for the same iteration to not leave a landmine
   for future changes

Changes since v1:
 - don't submit fuse context after each iteration
 - consolidate some code to support the above
 - fix a bug in the fs PI support found while doing the above
