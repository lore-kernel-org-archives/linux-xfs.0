Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063A3E556
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GPxA71ud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GPxA71udtM79W+2z4Pcehk+qtB
	jrYBgK9LJZjHFLEUnoYlMHqpCR8uMHEPGfQJhy2qfrtUXxW+vK6XsAwYsglvjWU55u7VS9xgSG4Mf
	V/VzHlEXRjqJCSkfwLqstPye0buIKGn3UY2nBkpjY5qQOCw1H3kRVYp0HAYbgLtWHWAFtWYE7sVDI
	6hR4aP7k3zpB0OE81vmUq0Y0vFnkkleSZ/LXNQkKgScPZ69xbWn7SBkpDekWaPyZKSVIBNgdkU4OT
	QxBKBjeoHBWuH2ljSq7wGFKf8ZYhwGPwCn6RLjqsDulMumcHXhq8GkvgAjm/ADK0D4Rl2HIfXiOBP
	Yb7iolsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcHA-007dSj-27;
	Tue, 02 Jan 2024 10:45:36 +0000
Date: Tue, 2 Jan 2024 02:45:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: add a xattr_entry helper
Message-ID: <ZZPpUAUDaUzmC2uF@infradead.org>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
 <170404831535.1749708.14746477172224685881.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831535.1749708.14746477172224685881.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
