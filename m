Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55306486E48
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329950; cv=none; b=d0lHViHxL+oRGfGmy85qX6jxxtiGKR7uX1wSKRbzFZv2H35klouwtN9RNfHqLUDUEBPy7ov6ss2HxTMeG7b9BV7W/s6EsFRy/FnM56fbZaptdjklm9s+VPLggZcDNek+H/ZNSyBjeUnzm5ytNMe2JdE1LP2Y3N406qy1e6CO0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329950; c=relaxed/simple;
	bh=1E/31lQACVTCI5zruhnHwX0cW5Mlyhi5tFENf3bLopM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f6TR1Xu/G85sUON2foayAO5oShcUcHKH0qXWgAEEzkypVECL6bx7ixnHlgsmDHs11f4B2XQR0Cu+AvTEOlYH6cUCstHs9MTSdb/j3IJWhtmLTWX0oGZl/slsMzUKgjaIraXiJ835Oy4A0s+8VHB5V7qU5niDvf7dtewXEkmaRVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YBm/CNaF; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YBm/CNaF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1E/31lQACVTCI5zruhnHwX0cW5Mlyhi5tFENf3bLopM=; b=YBm/CNaFpPR4gkkG1e5Aj7hQ8O
	94QDioQkdLW0IzQPmcp5T1cl/BH0dPS9Zt7BBkZseRvz4TYFD305y8Efz+cdFzS8MJn56j83qUZqZ
	AH0Pr8EDs3TWn/AWo+HJQQ1yzvbNlIhjuwP4WiOYWibFm9n+WzBEuSin1HEu7yfesmcWybV6ssHvj
	V1KTdL/G2ieEjtuoc9kn35vJxzBSsznypxH7s9NadvQBN9NOSi7mMWdU4cEmQVLNCoamCv3QWDqiR
	lKxMzUGNhGzeTlJzuR3a167M3+blw71IMlPoIv7xEi6uoncGGu0aArx5aZOitlOwKxGciraT41CJl
	4/Um/IVw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3sF-00000004N2L-0fEh;
	Wed, 29 Jul 2026 12:59:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix xfs_copy betwen devices with mismatching sizes
Date: Wed, 29 Jul 2026 14:58:55 +0200
Message-ID: <20260729125902.2281706-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

This fixes copy between devices with different alignment requirements.
xfs/601 trigges this when TEST_DIR is on a device that requires minimal
alignment, but SCRATCH_DEV is on a device that requires more alignment.
