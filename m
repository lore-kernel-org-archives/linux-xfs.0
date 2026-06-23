Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4285F37C90A;
	Tue, 23 Jun 2026 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222748; cv=none; b=liSEpTTlWvGyBKGNn+R07m3qyIAWk4ETsdUUnTJ/DE+8kuDD7B0mTIMV3h9zOkGMrc0DtiRIUEeiae6zAmjXwlLLvdF+LfaRiecWAByMVLsFqojQY3H1zhqpAONvxbnLX7hKWHpxIC8qLl15UqYMKpoRW1Z4gDj5QLOiAQHbne8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222748; c=relaxed/simple;
	bh=9yOGUaL8kbNxM9xfsL/gfAlIaS8sQaxxGD/1qY9o130=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLyjYqY7E92Ir1UXMCIniK4LBzCEo3VMTHnitXc35VRWft/E7Tv0tJF9MJVF0Hs6KgzDqdxoaz7OLc76+b5g4YPZ/qaZ8+gcEj4XH3liYsueubczo5eSxImSiyvKRctFWPsygVjjJdjzAgoInxj5sql3VdQK29oOB4BSafZ7v1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jn5S83jL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jn5S83jL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PoOEKS+eDTfInw4OHh9azlmGlb94rL+G6EWiMKCHpNM=; b=jn5S83jLuCl3m+DKs0KX2qnWLx
	m2yF7h06gH9mTy/pDA92JeRc2O5jP05jl4ogvEK0WS/W+H2H/z3IkvpjXXgmHUpvHT3sptVLvL7Br
	bdj61w5J3Idd4NY/Zsc55aMTtERBE7uWQwMF+2/Q1aC0sRMqxRDKFRxBcc5cshUtO69Ggren/x0SY
	h8pgGlgpkm4+nUORnZ/nDCZO9pXSB6IVG3ZOpm0ZJOk3keO0M185jKz4nbdMD+4nbb5wRCPkOSlA3
	1v37DXKZK7FKgA7oHSLZygJ36ECcR5KQ52Enk4r4EyA8A3DUt7SoRgfLPxdwc+/PDcp90jw/dz7GC
	VNZ4Ipsw==;
Received: from [2001:4bb8:2f6:ef61:5b2b:8638:3844:9408] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc1Xy-00000006NCY-17nf;
	Tue, 23 Jun 2026 13:52:14 +0000
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
Subject: don't build bios/contexts over multiple iomaps v2
Date: Tue, 23 Jun 2026 15:51:35 +0200
Message-ID: <20260623135208.1812933-1-hch@lst.de>
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

Changes since v1:
 - don't submit fuse context after each iteration
 - consolidate some code to support the above
 - fix a bug in the fs PI support found while doing the above
