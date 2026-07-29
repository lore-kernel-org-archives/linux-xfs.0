Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF847CA73
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329507; cv=none; b=V4su/Ej2y1d1fIF4GOaFrW1ehuXCCDFDvggas3n4CbCrdFv3NpQBonSOVXOcRt8+sKmiJNfoSglGCgFxMEFkHIEH8zLWBPeFTqAFVZ+3Pg4CRjyq2CgqC34fum505lmreplab1mjYwS3volLlCX7MZPCRpuKctoGc1XiWQE0DEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329507; c=relaxed/simple;
	bh=1E/31lQACVTCI5zruhnHwX0cW5Mlyhi5tFENf3bLopM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fUMHv94lIhh0w0u4oGRpS6Ta7298uTf1OgjdRspR8DOln8GCpIXh/e6arFfvCA5Cj21OqMAHUFpgzSygIyHqYsyo4+n/0CtBWn3DWQP43S/UJrNFNxvQ3sao4yn56oIIghYQ0RnHFbPCUwzUapQU98+CAVaWT7408gjJ7G//mB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YkN66CHB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YkN66CHB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1E/31lQACVTCI5zruhnHwX0cW5Mlyhi5tFENf3bLopM=; b=YkN66CHB/pvgIwuW+jqEwM8oTx
	PzZf5c0orom5l6e+ZUhwU5/PtB4FSF9nyn4WMAQtXCjLo1y9Fdg24+QoE5zZv/lAlqyXcNHBeOHkT
	ZDsy5lRGuWeEGRzG0Vd/4P1dJm+MDaJhy/n3HRqOYXUBgzL5axEHmJ214AwspZccjPMqHfl+mqQ7J
	Q6AEQGlIEPDpG+Qif1zewN0glxMH8jZcH60i7VT5fdV9q/XNqXcKU7MK12XlmxCGnhS9FjUhg5dXF
	apHC/JK32lalgzdYYOkGa89zTVj5LrU7jEdhHlINMSyO63G0uEgNmUFZ8ot0GHwJgB+bvRoA4HoYa
	Lq2F6quQ==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3l9-00000007xyK-029l;
	Wed, 29 Jul 2026 12:51:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: fix xfs_copy betwen devices with mismatching sizes
Date: Wed, 29 Jul 2026 14:51:32 +0200
Message-ID: <20260729125139.2280775-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This fixes copy between devices with different alignment requirements.
xfs/601 trigges this when TEST_DIR is on a device that requires minimal
alignment, but SCRATCH_DEV is on a device that requires more alignment.
