Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F5820E3;
	Sun, 23 Jun 2024 05:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121145; cv=none; b=ix7yr/hltDy3+IrfZgTX+5XAYzm7nr9GA5IEQjup0sS9iu5mWj/fWv+Ew9Lp0cFy5fwHp8oJh1/Ac6S8P7rq+xBjkzoeSSNFnkXBFrJI/5JY6WSZRm5CRt47JwKYxWzUqREjbK3gpSnI6OZ09GH8s4b41KL0qmGIoMYZQbQH2F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121145; c=relaxed/simple;
	bh=IsxFt45Xwiz9m33ZYyw9AaEuUPjT4+f7RJGQRUvr1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uC5U8Zd3/6ich5jV8rPV1j0M2nFisRJYexXIbYmO8dLjHfQR5/W7Bzvy133AijNPAe2QGDdBHVZ7ErjusyiHMCnJG/efdJmPRBJUVhAxzp+zEYYC0BzQ23otvjQLNAyfA2SM4Ku3ZUrum3gBOu9vmd+/HZ82fw9u/XgMQh6raUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DSCMCfxR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DSCMCfxR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=V+u3RBmpT6puvuvOHhhvT1urrxGcLcUcBl+8vitxxAI=; b=DSCMCfxR8gjKVQRQnKAfp8XzmG
	BglJsXP/vfJV0X6GY538o92azTrOsVkGUaa+M7ssm35WhZHVBIuDj/C0Q7WGRlCKTKKKt7ALqCUQ5
	vN28ys70A60YcqZGpBldY0wszjRoIlfWCJ8wGeOcTKtsE1brOg669DFUn259RsR9iFfQUjdCVB7pm
	sraNS0B+vQ75xd4fp4cavs8EYSrqUaEdW2dEB0ynPF5vmxuHxnK/JJuOwM+8UCZOryX//1xxOf/nj
	orZ3qqIlR3NVkaJ07PQ+uf1AdUA+GHSAxaxpdpbbnSwTF9De1uwh73mE/yrhrC2lJGpYM5D33nBoQ
	h5GdJ4XA==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFwN-0000000DOWF-0NqG;
	Sun, 23 Jun 2024 05:39:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: xfs post-EOF block freeing fixes
Date: Sun, 23 Jun 2024 07:38:52 +0200
Message-ID: <20240623053900.857695-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is a rebased of the tests dave sent 5 years ago for the xfs post-EOF
block freeing.

Without the patches here:

   https://lore.kernel.org/linux-xfs/20240623053532.857496-1-hch@lst.de/

all of the new tests will fail for the default configuration.
