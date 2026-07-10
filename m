Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9042D7DCF;
	Fri, 10 Jul 2026 05:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661276; cv=none; b=hBjKKWxMqibMR0w+DjXPXzuc6Gf+M+c22ffILJDZD8zR0YYIFau1XVRBi+21WhnJs154FQRrAEuuqrlXIRuSptf4SWJIvxHv55nCHpbbk5RSZcvK11bcncFma35wxrDw6XbeHzk9vY2Y8waw3ZOtI9opJi8+X1NYSNwAdIM8gS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661276; c=relaxed/simple;
	bh=JWuWBKfPVtgAcABwCSrDBa+625CffJKhHI+CifJoqTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MPMbeTiFTt/C/CnKqQM+ekDrjgwMIxyXN80Gvwj05+XxHCH7m9GG/suPVzjES+UaVMlmk2UVtqeX7JG0eJNuDCYqT5V0KTLSjp+FGQZ6SRMxPLYgT9mQZ7QG2H8YwunRoGTbPqx8YM6MBuj2+KUEEV3+VY503a30Ls9dtR8Mj/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LeYK495I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LeYK495I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jeLUM/uUGphGKAnWajvaikeeaZYEyYOiYuHCGGRQxKY=; b=LeYK495Iv2xCHrJ/9Cv1+FCjZI
	jpc5hx7moT9zITkkM5q3+2G/yvi7t3qSywS6lgjZU5e5veDMHmwnjPqr7CEf4ik9sHMvcJdyn/RJB
	rVrXdCcBTOvDoT4Bnpf3Ie9YqcKxDQu99PcKcpWYGkNpxOXoaw/qY/tIZu9MWjdU5mc67lROVQSco
	6X4VzGJpmmnsjtMli6l1vY1lppW06xWr/XBfLpg5fyq2dwxBLfJLa1MOkwuMAhxgcjLZxUOFmxBa3
	HOdhs+3whe3wFzYpj2HVCibRGWsLHuvpvbSngv1l4bjR1ZoJAYosENwNrJY6sD5INr2Eq9yaph9kt
	LPuMrv1w==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3mA-00000004CIF-2exR;
	Fri, 10 Jul 2026 05:27:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: scratch rtdev handling improvements
Date: Fri, 10 Jul 2026 07:27:32 +0200
Message-ID: <20260710052747.1841555-1-hch@lst.de>
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

this series improves handling of the scratch rtdev.  It is a combination
of Darrick's earlier patches for xfs/655 and xfs/656 and my earlier
patch for a common helper so that they don't conflict.
