Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486F1F9F7A;
	Fri, 19 Dec 2025 05:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122562; cv=none; b=SJBxAjlQTSjV3QEuuwepMhGjaInv2q0inl0gQfFZmBctJMkZumikpZRrmh78Nwe53v2xgYASdtiQjkKIntpdeoSdNnhoaHwwT0KrL3HZLrxhfkDeTXz0R1pSg/41401hXsQhMicy1kmNiEB68+v9YPsRIqzHarYjqpkB45J+IK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122562; c=relaxed/simple;
	bh=MlglzBdQ0NbxOrqcPISNox8iE1QeYTmm4vnlzRksX+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hYNU+Ny2sjWCyFf9rQ6a8qj5ohLs1jqcWItVA4FWwP19Mn8UlzN9nda2oF+tZxqqxmgbPDJa4K1QxkvMlPjM+xJRIFe65MYl8XG2ZoFQ2czdUCtFWNtbN0sMemNnvg/2apwqWmYSJNEV/mDcq86adlx2Oxa6mRszD/JgD1cg+FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SB0w2mey; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SB0w2mey"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=+bcELLcv9NKVRi6VRyskaNG4EHPrTctSYTmtGi4TMdM=; b=SB0w2meyzJhXBj2Ac+G/oX31Q5
	t5vVH0obq9MRTyofNz6J7P4+uXr5R5bjYdBkgY133pfdkd+io/fpebLaNGj4MTKYf+WUEJ7ZtYXpx
	LZEkrybcDaMKJHzMOhz69ZBcP4mQUOfrUAWuf44e/zDW9939TfytW/m8UAql1SvfhM2Sf408NBCOe
	5nf5jgZm0SKVFj4KVe05ksKtKTrwFq29E1y4KZ67dWDLE6w0dJovP+nN6Y3tb+ostH+e7B+k97zGb
	hjeFzXhYIAl5HI86ZqTnXU6Dw5TUsKcJzRKrwJoZItsTKHJ9Odq7WGqca9lQXQherKJcPQKiQTSqt
	u+p2juTA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWT9i-00000009eWe-2hN5;
	Fri, 19 Dec 2025 05:35:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: various tests for zone aligned RT subvolumes v3
Date: Fri, 19 Dec 2025 06:35:43 +0100
Message-ID: <20251219053553.1770721-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this adds a few tests to make sure zoned RT subvolumes are always aligned
to the zone size.

Changes since v2:
 - use if/else for cleaner golden / non-golden output

Changes since v1:
 - don't run the rump RTG test on non-zoned setups
 - use _scratch_xfs_{get,set}_sb_field
 - also test mkfs on a non-aligned conventional device.
   This will fail without the mkfs patch just sent out.
