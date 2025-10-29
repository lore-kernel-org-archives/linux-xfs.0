Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4662522BE
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761728864; cv=none; b=pswdyiyZPiyoIak+wz7mpeGV1ex+xNJCCMw2+k+qDZe4I7/hG56xKf2XJk3hmSuCf9xQBrIwEukt+eyxbqychHfPRPo5dt4QpGLKZ6xv80wzt8bVGOfJctes8ZIyIuRxkDkht/uzRBH8xit1Tkc1pc4IoZl16mPIfq5FDdAeqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761728864; c=relaxed/simple;
	bh=TqpungkO8c1Us2cUaaXHv6eXkA9q1sBmI3oGp1YRz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HuIfIUw7BxvvY04xwdzqQ7uI7bhpppcCBA4oxWS6sDAHF4WoSzgR6R2EJzIRpEBxrNnul6BB0RlhG3HygIjoDj3xm/RgzfJV0QPBJ/wPfJ/mlNCJRKwxjCgktfTmSqhtxEZlGumhYxyoSpHzUcY86kPuXXJW/HQTCxBKZ6sxnrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SBM/zmxF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SBM/zmxF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TqpungkO8c1Us2cUaaXHv6eXkA9q1sBmI3oGp1YRz1M=; b=SBM/zmxFDr70N2KpvUVvaEpOMB
	oYguxsscu05UVGubVJ4RdS/LFg5CGkRMx7w3UptFNAE0pl7cIYFNBA2npXQ/Wj1vsNxBia2WV4mTT
	LxFQdjmmTDfwxVArgRxfbWAwkf7uTXBFSRgvV6BBbgYm9cqVq6PnK/uVtvByna1LDMM5CIrbVRnRw
	pbjCi7OvcVOtnTp5O4YxL4Iot6q/XQbQRS/IViAk5rbnx5UPFBj0ancs25YABQS0Me7AVW0IPjy/C
	xF6h7XQ6KADc+gLqU/ASExgjDnq3YhKgDQeidxG6ZOKsXhFXSRA/OpL1HYHDrXmWYC+b/VTXtlFll
	SsPSEVzA==;
Received: from [2001:4bb8:2dc:1fd0:cc53:aef5:5079:41d6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE29e-00000000Qj8-0dJ7;
	Wed, 29 Oct 2025 09:07:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: improve the discard / reset zones code in mkfs
Date: Wed, 29 Oct 2025 10:07:28 +0100
Message-ID: <20251029090737.1164049-1-hch@lst.de>
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

this series refactors the discard and reset zones code in mkfs a
bit, and then allows discarding for the data device even when
the RT devices sits on a zones where discard doesn't make much
sense.

Note: this sits on top of the "improve a few messages in mkfs and
xfs_copy" series sent a while ago.
