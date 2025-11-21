Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B183321D8;
	Fri, 21 Nov 2025 07:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709023; cv=none; b=cNCE3QRgTk4Bs2DchOJ5wyD1lNYvZZpUCibtBeCALUDK1rYU71gCQet8cXrzmU0T4iaUzXTAUOyxjv/Ye0EGX6YgZGOWJQcwhJcBfLRda+5fADQ2qzj+rJqgnjD0HoTOfV0z1jGX4M51VPTGYIx9p/7zeHygZOMFmY2yHaCTGlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709023; c=relaxed/simple;
	bh=4xLHVRWSJJNti+g4KADIvHlNWMkwofkm98dOpy3+ydI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tne+4dHzfEAFvdbyDoxyiO4lZI4zXqeIwlTnUsKwoQyzk6sAdvhAVaxj1nJ25uVK0HLQcS7cDkai9WqIorHUelZiuTIgtetyGCadEcGCP2subfYjk0pHJGFN8eN3nndSlOMzlXDzD4RnzEyM06SudBglFxeGhH3KdT47oTcDGuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GAonT/Ey; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GAonT/Ey"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4xLHVRWSJJNti+g4KADIvHlNWMkwofkm98dOpy3+ydI=; b=GAonT/EytzOsFPNbwnCLzf3PzS
	EmBXGI8m879+jLu5ZEa9euWw1K+Blrl/FTBOk555mopG5LaNHcrsP0HSp1F94EWWQ5nVAMoWbJLdr
	ZixxpNm4bxNKYcO03s3+zPsBUb/Yq+Zc3TEZXNMd8bRWKF/1ppHhnFj/8x/GIUe9izRLgyN03/m7u
	PSzYXO/VJr6kUk0iO1ip4jZuS5v84mnmNxUYP7LdDwRo2D0GB5fpGGq4OoF3b1YVnT9I41eXKqxRs
	rtJs6zBZIIOEPPdYx94iKkj6fAsoyMvf+eVQkZMMw6GO7ZBNEv5vsn0gjjfIxn29VuOspaWHWL4ez
	QhfuEYHg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMLHf-00000007xCG-3SlQ;
	Fri, 21 Nov 2025 07:10:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: misc xfstests fixes
Date: Fri, 21 Nov 2025 08:10:04 +0100
Message-ID: <20251121071013.93927-1-hch@lst.de>
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

this fixes a few failures I'm seeing on unusual configurations not
expected by the tests.
