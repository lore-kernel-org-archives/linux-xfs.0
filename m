Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91B72D73BD;
	Thu, 18 Jun 2026 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790526; cv=none; b=ZGT/rSX4H1VQBt1A417NbPMFyoZzC0WScqgrALEHeGuHOHIJPQu1KKOuLaPDnGfIyd5m4XcVItmyffWO5aUmWgeHfrUYYEVwMjesNmLpKA9lxSq7wQtNJBLAJwvJxdxuN804jh2I7Hflt9ITA4G8+IwNrc2LpjHCbyxp8TTA//8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790526; c=relaxed/simple;
	bh=Rf7ld4K7yldVMFdIA2He4uR+NsQ2zU3SNLKfzmtzoyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IpFONjZnchxtPU9pcWR11d1aPvdHjtvvLPn3kjo98AU1PXt/VrcQQFKSJthmBEKoS9+In+lT/2Ino8En8SQqL/cUDVN0bV3VVG8bc+16qwych2xiTHRYz9iBsuE6Lky54sYQ8vzRA8ALOxnuyqokASzg0gxShN6itlm9PL3YPHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HH2+Yogp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HH2+Yogp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Rf7ld4K7yldVMFdIA2He4uR+NsQ2zU3SNLKfzmtzoyM=; b=HH2+Yogpgoan7jib0QVLdvTqIY
	UAITK1c2v64O8puW4uo9v+NX/+LZKprVFIi8CdUxFAj9gsoD4/2U8UyQEmkhMtiKuos9E4xkOANhk
	c2FDvpEj9tyLI7QXuuEymmkIVuezjO1ey1at0IfEWWmLojd9VFnlpd08UAn7wbUneHTJGhM0U7Eu6
	/qPJCfehtfTA0zSmQOsjAzhVz2cXTj89+YPa1b/j+NmWmyEdtEf/M2FwUddlm3dvkBiI5dsj9kIee
	0ma2g/nsR0zDWlhj1+V+lvFLQfMwGvMwdfOnCaRYuO4dnexeDZT1EH9Ev7w8ul3jp2Plwou81p3lN
	vkhFdnUw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waD6l-00000001OC1-2pVJ;
	Thu, 18 Jun 2026 13:48:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: cpu scaling fixes
Date: Thu, 18 Jun 2026 15:48:24 +0200
Message-ID: <20260618134834.237647-1-hch@lst.de>
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

this series fully disables the mkfs automatic CPU count scaling for two
tests, where that would lead to differences in the gold output.
