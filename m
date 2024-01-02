Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B52DDAD
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n6hwjAAZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n6hwjAAZsnfeOeeSn9ZPgc+7t1
	Ue9/B726YjZp/FkWTs3s8JO8VaOh+Dv/2AKOj/6MtMIq8vdT+NtBGkpNq4d6fXTfp6zAKsjq4tHn8
	EUwyf/xiTEXjIJY+ojOwqL20EBgOgUxsM1JFbDyTwDox6K5jkMnhFI2amnvCNYmUkbwXqRxJwlFDA
	0rlT5hzHqBtNo9WqReFBvXdJIfJKAUKZHUcVJK9naEzIhkVmz3VEfOrxyZIPIpGfHf63EkGV0Q+LI
	bLa6qZqN3OB4vOyoQTMirBPHOwiB3bNXutHrH+NwEFkMWZHCNY4AXSHQ6iJUP0qc/9SHiE0h8bqPL
	ClJAfUjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcFj-007dGq-0f;
	Tue, 02 Jan 2024 10:44:07 +0000
Date: Tue, 2 Jan 2024 02:44:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: split tracepoint classes for deferred items
Message-ID: <ZZPo9wgI20nF7WRn@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831441.1749708.11833404272521238326.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831441.1749708.11833404272521238326.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
