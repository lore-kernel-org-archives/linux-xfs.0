Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A033590CA;
	Thu, 18 Dec 2025 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074250; cv=none; b=EpfCSrNp3PrzjoyqJpgBv7eHkt7GSIeiRxM7Yx+1Ss+nLIyYUCHoZ/GuIKjjLnne0tI4b7yS2kX4DY565cR2FDpnKhLsAMAhlwRX++5Cag+mDKd0u++Lv2/mBTKxoP6Cf5afbV5rGICCJmGM1AmFk1qdpCwVhnMQlpONx14eAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074250; c=relaxed/simple;
	bh=/5OsuzKuVsx/oxp+heOEXS7yCY6dHiRfCmunB8WlngI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ml3GWyYxAhflqpZighL/TdiHlMPviONoEBW72XJNjs1yLDxQhkk0AOm3Hrk5kFZ2fiPqJL3m+GMRpAtbJrH5cHPA/ASXFrlctNMpPlX33JyAkmweCfKSTQfUe/4y3HQY7ErCue0Td9AGJiIzCXUr4Xu8vWz72Kh3rcnsMJGgvRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QW1cB29i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QW1cB29i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6oPfTo/VDV70TLEdXdeuE9NF8j80K4P/Wiw6+1M3DfQ=; b=QW1cB29iUxQ0nj1Xh2kFkN2AK0
	jJRuCiXKunqqe0G6rdgh70z3u3TlNI0Uw3XP80c/AWgBpiDpwX9wm8+0zb21KNEEPr/m2emox3gVP
	SLow9Y8nUuK32MmYF0acS36X0ckkR8k+GCglMO9UhYaGVrUP0FTx0oq/R3L5QaTeLiuM7jT36Nf3g
	feGe4mIGFUSnzCYlz5tJ8mDFQyXXwapalWDiJ/fCRL4YMYmCiaTZNbfjgC/M+iabViTBvfrQEijPU
	H1qa3fcWfmsD2TKeYUUb30STvJ57TiyLTKa7Mc7wbZ8SVqysIdVwzPrShTelWU31XWY8WBcEKVq6N
	kimM9Tgg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWGaW-00000008n2X-0XRH;
	Thu, 18 Dec 2025 16:10:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: various tests for zone aligned RT subvolumes v2
Date: Thu, 18 Dec 2025 17:10:15 +0100
Message-ID: <20251218161045.1652741-1-hch@lst.de>
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

Changes since v1:
 - don't run the rump RTG test on non-zoned setups
 - use _scratch_xfs_{get,set}_sb_field
 - also test mkfs on a non-aligned conventional device.
   This will fail without the mkfs patch just sent out.
