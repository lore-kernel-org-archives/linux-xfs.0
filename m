Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992B8F4A
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 07:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765177896; cv=none; b=WMAIJuZdZ47Ob0ONsi1a3NdN0AvHEdwoC9zotgGCguFRtx0uTdPVqnTBnwBukVkl1tDRVAqdklBh8BehA2+oVxdl/i3LH2UXHe3LjyT63WXQZ/33V89jSOyIDLlgwmqmGO2fVMafu4wQnCHIPXtSAe+L14aGQpiTQsZC3yo8ytw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765177896; c=relaxed/simple;
	bh=UIDgSQF5ieKlXXmDpeshmzlihztQhXid9TByUNDqZW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eJMYL9VcAmcSvO4zWbAjyPe95dqUsvPjEfruSm9ozxzxC8UdCR8l6zzNmOpY7kkoFK44sARuWXo++nG8tcSy4a9B3RtYtBRgOfWcUo8yCH7NsRSBGtnLSJMPPifHUwm9sSPtx6PBn1izBGkJU7FSFJ7/LG+q0Pp0oQmRsJLjOtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wXaftmEd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wXaftmEd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=q9r8pZV/laRCpZCuJ3d0lQdsUlQd8+MxG2oUMmn1GeA=; b=wXaftmEdJHL679ivrMc+dXlIWd
	6i56BC/tWC8qCnDs1Gv16N8IRBH+M9SkQXMd29mZSD97juRBlmWXyoYkgLpWLoS0OnUrkAXXGBa2g
	M9szwSuRvz3AlO3MQg5EWjK9o9Ndv5GHWVnp/pOgb9WWIurTG3qXxbRhBw9F5v/Up400J+SYPc6Lm
	KUZXx+GJ0tfsgrHi0wAlB7mpk2SyKP8ToHO+ii9b/NH+JZuJriS0eFIRpwP7o3zsFjQ6ckg+oFx9v
	sQlbthT3y7M82eqhBghCE3g08Q+H1fc+jd2mw2tVB+Ex4mELXmEUIxj1cB3idzJl5fzlFFnAcHQA0
	0W9G1+Jg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSVPA-0000000CjW3-1erb;
	Mon, 08 Dec 2025 07:11:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: repair tidyups for metadir handling v2
Date: Mon,  8 Dec 2025 08:11:03 +0100
Message-ID: <20251208071128.3137486-1-hch@lst.de>
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

I recently played with adding another metafile type, and of course
messed up my first attempt.  This series enhances the metadir
repair code a bit based on things I found while debugging that,
and in the last patch changes repair to warn about unexpected
metafile types.

Changes since v1:
 - add N_() annotations for gettext
 - add a build-time size assert for the inode type names
 - fix a comment typo
