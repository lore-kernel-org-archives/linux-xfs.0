Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6D4A32
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190319; cv=none; b=arFcf9CW8fIunIn4wIDR4CO+CiL8+v3TNTUqCYS7sCHyZgEMrN6bs9pdqW/y7X1TAja+K1OSRV0LZW6mjyvAIrRJtThPhKFBRLwuSwzX4ORf0vGNt0eML2HZd/BgN51t613UP5nU+AgwF14DmY5Bnq1RG8fZ1hvA3tUpF6PwUps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190319; c=relaxed/simple;
	bh=oPv/m6pJQsPTkPE51T+Zyx9JkV4InILfmtHbPwfaJUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BYBUAT8Xc7TnbfpBVX07hXhpw+YBnW12If2YVGOCgNbslbspLp7lSUMb/naFfUf8JKp4OYUNkJPB8rBInyxAtSgCWyb8rcvvIlO9aWpQm6KI+yle9fKAwtoyP4dPMpfHImt8Ix+JTvgXniz+pl8rOJ1XiJCKyx/55vWTaX3XQqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hQovzbdJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hQovzbdJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=oPv/m6pJQsPTkPE51T+Zyx9JkV4InILfmtHbPwfaJUk=; b=hQovzbdJrGWUXzB6oDdra2c9/W
	VkCKVWtuzz0MAYXeQ9TEYnw7R+NsrUbeYXy/sZJIk6/3JUhg8V4vP7ob7fWayWBFfUyyDD2ALPggL
	FTlBComrSuoSYiprUqr84OOnSVVaDx+wxYmVd4+FW3Sa0jWaM0PmhHVjhTm4D9sqjWx79qA9qKO64
	pTlgPseqRgymkz738MC8+mk38pfOyrTAT9L4ntm0gdIl/V5kzbTt4cVUEgNxAO3UGYcINrn3BmJ5j
	kg4UvaY800DWcO2ljF0Yc0BcWBfh4R1bC0o61FnTHBU30V/DopIjMNSQdCai2cDpsofR5R0ClILr0
	QPRxGAXQ==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3Hm-00000001IVL-48RA;
	Mon, 17 Mar 2025 05:45:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: zoned fixes
Date: Mon, 17 Mar 2025 06:44:51 +0100
Message-ID: <20250317054512.1131950-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is a small set of zoned fixes, one reported by Dan through smatch,
and reported and draft fixed by Darrick, and a little cleanup I noticed
while going through the report from Dan.
