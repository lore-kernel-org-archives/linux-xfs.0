Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CC71E529;
	Tue, 22 Oct 2024 05:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576109; cv=none; b=ushBRlSj7NSf1isFdGBxMq5geGH+01AaMPVxhPHEvETYPaFjlId44mywXu9cJB+Th2yyPrXoR8tC74Ug7ukk6EJcwFd04BH+qRrUqSFVSG5uRV4qlMsS68CrZDhfEkkJcte77pTXdibysVohUSf2t/sCr4rMEyR9c1TQhPtUw0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576109; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOr0Y8LcCIGUs5ATYif7RhTkBsLC4p+JteLaBhC5ib1yIRl7ufi09ByXDuZWhMGwttehPz8O2VKbYMQOebBUkUCMFF6eKmPfLWxnQDKB3gQn2hOIS61+X5OAIjmuKygNMHeHNhmO0iVH9DNPyPkJ2SG5uNdzq5hKefsIxlIUdhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a9Ddi4Ub; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a9Ddi4Ub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a9Ddi4UbgB3YxoWn6t0V25L5ND
	NAQCxGJZ5f+J/4HdTRaR4tChCHfEqygyuJOHWfvqaW8fACXW8Z9pE08grEBW7zNNbViuE/8uYh0Mi
	0tXacQfMABNNZ4OXyFJWlKPJgIDBDs7dUj88TBfAzltkKBfI5thUQLf7+lidJRF4iLqc1NgXnEnQW
	TTanUoboh9cf4+P9lzLkLNWZFim7IhTkcdPnbpZQopkqLdf290FG/gi7xnw5Om17JSt2RR8e6jJAC
	Jc9d7S29jzeOBMNGCC3mtlUM1tAtjeurJtfUgqsUT4W6rycyHRbMJHFtyVDb1ZcNlOp0bmzquOC/H
	XaAHTs2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37kp-00000009iEu-2tUk;
	Tue, 22 Oct 2024 05:48:27 +0000
Date: Mon, 21 Oct 2024 22:48:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] misc: amend unicode confusing name tests to check
 for hidden tag characters
Message-ID: <Zxc8q7Cgad-LfLoQ@infradead.org>
References: <172912045895.2584109.2643798036760972085.stgit@frogsfrogsfrogs>
 <172912045911.2584109.3860719636262870391.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045911.2584109.3860719636262870391.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

