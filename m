Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6A514B952
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 06:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444367; cv=none; b=IASIg8oRT/r8jbGThy+m+qkQu5TUa29YB5rtH1GtuYjmCoPnEDU3hmljUORV5JZ65qlUfzJ03F/GVrxD4F3qzR96iQr6wNaFJ+QMkLRKL0mVVvh53/4dbntN0pYdX59Q/kkfFhTneHftcc3mhL6WpyM6nEGXzSrMirxBKZp3qaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444367; c=relaxed/simple;
	bh=UDXt26yPYSvlDiJIi61Fd9nwutA00cOvhF9C9cXOsqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q8yLLq5HWmmrINWyJr4bsRAFc3cbDh/BThfzrpbfYXxom5tJhIxx2qAHNsRI87hvlAvequsfTxgOW2DG8FAqLu3y5bY4OBz5UynJe0IQbfawctHUC92id1m1ed/hlb/cU+Ez3vcIipD8Oo87YM/1AUGtnj2VZP222c2lUvFlxgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aOy+WHH9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aOy+WHH9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UDXt26yPYSvlDiJIi61Fd9nwutA00cOvhF9C9cXOsqA=; b=aOy+WHH9276f2671BGFKLhXa10
	FkHF5weqDezoK7HiPY4VRpQeqvlYQ/lYQULqnKCbDkoLgIcmJ8ww1RB+FEvaHHPUbBlOB1MkeayVS
	kVkesCOauk9Z4mPH/lvUTkMteVfjMYkzWFN1Y9+m76iz8z79QzrTRlDMzMjzbXlkVf1LukDA+Qb7N
	g65wIwcPFbuIDiifdpnqRueXiQ0MDRAHRVUG2dQ/MAsGbRSWFTBUdh69b4k0FcmzRzRHGah0Ux5TP
	Jn3hs425rFMBRSBXV7s5fpTy7u7OnJIFlamNJxrnX+IVvCeorCDK2OtbfroBgzqBCxbeSgCByZGOu
	npOePtqg==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdObl-0000000H1dY-0YCe;
	Mon, 12 Aug 2024 06:32:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: xfsprogs port of perag xarray conversion
Date: Mon, 12 Aug 2024 08:32:27 +0200
Message-ID: <20240812063243.3806779-1-hch@lst.de>
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

this series contains the xfsprogs port of the perag xarray conversion.
