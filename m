Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E54963A;
	Tue, 13 Aug 2024 07:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534532; cv=none; b=nJoLSc+4L2XSn5yNWQF0ENF2ASaMWFsDwdk5y2dBRXPtGGf1/6a/Ns+mdTxniS+kYdzAiT/b4HwoGg0wIS6GkD4mQN2CnvXLgwLSoXd3C/HSMKxPU1WBihwYp4tyVPejI8s3EoB9sKz3Pr3qOfcjik21qFugfKiMXxBdoesxh8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534532; c=relaxed/simple;
	bh=sjdmPUwMowI/t/9ZQCKCf0beEW07+g58g4E+V+gvQks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FuhS2SsuPsHTBkUmouVnwBnDSigShe74zr8LWNfA5XHl4GB3miHSHmcfMfV4A3oqTm0Sl2I99zt2ZU8osAecxJU5AP/+jN5EYcvG0zqpUD/tgcK+4DC5ljiSMHPILdErdu/qPy/xxbBEsPPujT2tdskOiNC6C5jTTgHmWfh120w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yuc3r33G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yuc3r33G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sjdmPUwMowI/t/9ZQCKCf0beEW07+g58g4E+V+gvQks=; b=yuc3r33Gyc0DbV4dxfQipKX9xe
	Yr8x7kb4vcBXG3/xYnvKSpSD93eBVSPSDwc1PI/TuDzNrYHEECwtfQUFAJ6ARIAb1+21i44vhm78o
	quqYGL32udER6d5Gc+bbjcyVBgop/xHYRN6XihbH/8t5jKcHbcvaVWv8Odlpu3DDxHjmxX5ZVVH2K
	LXXZxm5L1w2bM6GPtUKPbv/GY1CytDktzH1SWciywtVgtmHdJuToVHkyO4gv858uWz1qQ7hpKxs6O
	ZIPFfMfJVnRawA2fXuatapblMTNO5kqsnjdARTFnj+xTlkAFjfq8js827yQOhx51PouDTC1nj4yuT
	gZ/7yyiQ==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm42-00000002kVD-2QDy;
	Tue, 13 Aug 2024 07:35:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: improve minalign handling
Date: Tue, 13 Aug 2024 09:34:59 +0200
Message-ID: <20240813073527.81072-1-hch@lst.de>
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

this series improves how xfstests detects minimum direct I/O alignment
by adding a C utility that checks the kernel provided value in statx
before falling back to the existing strategy.
