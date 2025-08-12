Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE0A2D6E49
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 09:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989562; cv=none; b=CfW2MO9lIwwpJLPxbLUmI0CZjIBO58M22Ncw73A9+L+baCPsT+cHMHUgzNooOTbS+lZcWeOHIZvknU0LShlxpHYGIgHSrDpPMllpj7AzC07DeYfbXEyawi0TxU8evGHKozevuPFfzvX2loabx4D4ZY3YbUO7XFUvh+jTJ5bOejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989562; c=relaxed/simple;
	bh=WGd93S89QsgvNac3zpAimdzce0P4v2bMI5Dxm9DwgFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rqSYaClodayVEtmJ2GsuLTvxS1NO/peuClvZSbYqjDZNUqbEHxO0sgryyUhBAnHLFyBwecN8UKgpJYOaG9Wcysay/hve/tTas2BNyK2z+oCkhy56wxCg/Kk8+ccXtERymZRlXg7R5Ol92XwEeXBUzrV3XgZn/Hm2mzT6Rv4Nu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C+TPZr1e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C+TPZr1e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WGd93S89QsgvNac3zpAimdzce0P4v2bMI5Dxm9DwgFg=; b=C+TPZr1eD4XIPbIUXiUIrlzIgL
	0G3jD2gxTHPI7jGpnONTv6fXtPVuo9FIXZNg3nG5lKQeV/q4/w2gKgLFfjj5iRmRSSrbmDWrJ8VYH
	iMpPTk5jGY6LFxBybYpEws7CKZBJXgkWUCQaJjtlmzJcjqaWT7Q7ZbvkWSqbMz/LDHmpZJfFDCV/v
	GYsmYmOZ4WxOkwX9WX2gAAv4dggeSTmOkgH3y4iNsJIvSDIBL14IQNSqyOpUZRuYdojCvk58eg+Fr
	ZtFoO1DQmmmlBw5ODkpebQy7sDYGABguhP/9Pc8Iwj3T+KU896iZ/ErdVPZMeSuNjTgzssKsrd9/w
	k0kmmGew==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkxD-0000000AKLm-3oqv;
	Tue, 12 Aug 2025 09:06:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: sync xfs_log_recover.h with the kernel
Date: Tue, 12 Aug 2025 11:05:36 +0200
Message-ID: <20250812090557.399423-1-hch@lst.de>
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

syncing changes to xfs_log_recover.h has been a bit of a pain.

Fix this my moving it to libxfs/ and updating it to the full kernel
version.

