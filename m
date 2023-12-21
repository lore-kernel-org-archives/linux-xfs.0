Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D770E9467
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NIR3XOvI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NIR3XOvI++sxjcAreR4skkvH/q
	QuO/boeFsqm+4mL51Fl9ZGGQBgWP4fsw7Vp7C5KUFXkKhJR/SZUTcxLbkfoM9gj658t7TtEnzpExn
	76Nih0IMI4Yrk2YBSYPuo6A0PuXQhG2IPmxVxRGf9bGk5YVb0JFYeG9GKl5XAwgYJaPwUEuM7fYqC
	OX7lD9NnyntShhN7Cni2OSZP6miWZx866B3Y4qbtambo972zx9HtKzyd+CfKgiVxgWn2oWIcVP+zG
	U1m+kQJwYNTQh4Y+eceSwe4VBbnfVvgDGm9sS4hUZ+FbPXiD3swLkdajSZs1P5Q/tLPf+sMtidtMa
	vtyD5wsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBe3-001kMX-1b;
	Thu, 21 Dec 2023 05:30:55 +0000
Date: Wed, 20 Dec 2023 21:30:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_db: report the device associated with each io
 cursor
Message-ID: <ZYPNj8KgbhpGWIVf@infradead.org>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
 <170309218429.1607770.15957197387853311608.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309218429.1607770.15957197387853311608.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

