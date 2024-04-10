Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A80222085
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730041; cv=none; b=XXzZt2LhGATZe1qjzYxBENeFu4KrbxrPytYOUFfBOP/BArU4DNFs4xJL17OScfrjM11XamtH5lTB+7nTYyYIRica9SBdZWAjgUDZ6JPnfGJg3KgLHTC3r7CsjTWIrLtbLn46L3CDpp+Eu7NSdYDnJI9FOmPpjTqn+pJiD5TPWT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730041; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXCeTRtcFIxTb7OwAYgkdY79ReGk1t4k1hLyJp4RitNB+nbpWwkzmZbOIqup/6sjZPkGSfuIOeKyb+E+WUC/XKZnvnbRL/nGaGMPDRZoF3MhEcQfZy5SuGefzLN/cQ3KKwVF1ihGAdhHTTw1bcoCGN+5hh4hLK/aF1C0gfQFAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S4I6L/HQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S4I6L/HQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=S4I6L/HQ5mBi2I2pJ8zAgDlAw0
	c3ce1betIXfzIvZeJMAv7RoiZvGktPD5n1R0mi4bAsrnq3zxOWeiNIcZWijz5ZoWZHsZfIzZOfrIq
	PgilAdpd3GojpCNSGzCc1b+nz7KA0hpELPQxgZKqUNb/tZ9/2De+FX3KjIU87mzMmY19LnDneTGGS
	nNRj8IlAvQRCVUJoH9FL6pjzZI4W1vrhjBaunN+dXOZabEDNYTiDRZxsaetc02WxNxMYhFf+7LLrV
	Ilw81ny0CPeZ5rGzWnjm3KpsIz7gWgVSOMpS80oMf9Fgd8H9S1HhOMmS2I+raMXCuxRpoBfHq4rk0
	9oABtzLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRK4-00000005MAO-07VO;
	Wed, 10 Apr 2024 06:20:40 +0000
Date: Tue, 9 Apr 2024 23:20:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: remove pointless unlocked assertion
Message-ID: <ZhYvtzPXCtJzj-qI@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971120.3632937.11416985248213244019.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971120.3632937.11416985248213244019.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

