Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58073FFFAB;
	Mon, 29 Jun 2026 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735492; cv=none; b=EqtdDLYyBElKvogGkCDce9JxtJ/CJvwSMj+b1XvUsJwR2AREiQHCGgoZ/dSjw2DhfNX9RbAYldAfdSu5RDAs8VHmnXKRcg4KFlU8lAK4A6iQ5EOnm81aSINO7/O62FvDhfG+eE2zRYJkdRfUOun7xgAM1XXny63DjlzP9rUK5XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735492; c=relaxed/simple;
	bh=zAaeXvZX876NW4HBdu2eZaW/2BA59HGZK9czOxtwzCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QeR1NetzOalmfFBS4HG2p2INtDR41i/B+8yj54UoIVmKFegz6MjuZWr4vewjd45LR8J3cHjKeEVmjjakhdfldMMSQTycxuAU0agqoPFXcEvDOPQqcMQc041OTwvVfr00dq3IsPCxs942KLBRnfpbK7fjZOilF+tEXt6PPXW9CmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xa/6fOwI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xa/6fOwI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=v898+QkB1UDAKWiTlcnqdkDW1C2WbAo9fOIytjJGE+U=; b=Xa/6fOwIwXnUiihMQCuFbBCt1l
	LpE+6eJtf9J9rUjXsdqp/TyDk9l+UMjKFhyiR7+feG1+zLWMmIcL34TdcZT5hai0zCepUx7yepQJo
	qBjiMd9vE7vLxOEKVmG7z0AAzhohqY4dsUDfSS3f9hx4gGrN8iil0CCpM7qYTUIlfvfQKjegwXYfc
	m1fEO120AVKanyGRkZJzZ5hf12yrWyTjPBEA0Uvfx9RUZNcGsgk68qJNDqAKTS6Q5AZcog0yJC1X1
	FkziMp68z/OvI8z43NZ36VNCqkc08xZm5Jv0uzi2lEuAUx1VsR3DPiTgNMzCtfx/FTcAMV4ytIEA3
	XxcngfRw==;
Received: from clnet-b08-202.ikbnet.co.at ([83.175.123.202] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weAw0-0000000EWzb-1HZn;
	Mon, 29 Jun 2026 12:17:56 +0000
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
Date: Mon, 29 Jun 2026 14:17:37 +0200
Message-ID: <20260629121750.3392300-1-hch@lst.de>
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
