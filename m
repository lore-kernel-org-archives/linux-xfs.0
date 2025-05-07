Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F2E193062;
	Wed,  7 May 2025 05:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594774; cv=none; b=IQbI51XKYklXnQj/99y2/8iBCv036Rfq2XTDRCJ6bLHbAZt5vqOym51U7acQ29RvdyK0P2XkHbz4RTKJwHLfJST78pADrlDNTB7SGZNIWyM92ymBpGEjt5IYY9J75C7VlrH6yZxiZmjVmy063YbdvLN7sMovk7SpQtpoVirdmqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594774; c=relaxed/simple;
	bh=UwVv+fJDi7fAFMcEYn8SUToAM0dpR9+3aEbs0C4jtYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xwjreq49yI0ASMdamfIASW4l5g4Yy5yMhDmEO3VsUo+FJeMuSFZIZKOdZg/XFictClKBceH5ou7D6Qhm2pnUQaootGZUZpMAKCljUkQQCqTfvd3BjLyDTIgLPf5Gmg0p/Bb6qdfbkSo2uCjJHpINzqk0/AXRkN4E67LZynOKly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b+sYzsgb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b+sYzsgb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Dz0wON/6+3eFHmq7W9RDS05kO7ZrG/7xwAZ437rufmk=; b=b+sYzsgbGJqrv7IZzW15yo+uT7
	zf/YUdXPoNrb8CFChfBsFXydI6LNOJZhCOcyi6u3lzrG+M0zx9pTJ05QC/jeeecIia0kQ7S/epUAg
	LeK4DppAaaKroyHYpMpARK9deDbV0msz0D5U06DZClXTtuCA+vBfeXfZQ5H2nPByjxCMKxR8QuYbj
	26+35N82dOfDCXaZlgX/iOA+42csA0fsTD/r5o8/OvlVfbD5pJrVxiC9CEzFQA4mF1yFP2O8iW6Ak
	yt8Sb9YEwnSEjoszuiKHrJgy82KX2BH88dfHYduodFh7jAoWAdOk0litgRJOgrIKR1gFqZ0pIwP+L
	ZxxOZ4Aw==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5P-0000000EEoN-3l3B;
	Wed, 07 May 2025 05:12:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: new tests for zoned xfs v2
Date: Wed,  7 May 2025 07:12:20 +0200
Message-ID: <20250507051249.3898395-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds the various new tests for zoned xfs, including testing
data placement.

Changes since v1:
 - drop unneeded _cleanup routines
 - drop _-prefixes for internal functions
 - remove pointless sourcing of filters
 - drop the last new test for now as it doesn't handle internal
   RT device, it will be resent separately
