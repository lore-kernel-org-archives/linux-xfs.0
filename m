Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66909492E20
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141897; cv=none; b=olqMNbaAsDfp03510UOlIDy662W6LNYFoxdZXBZHJAwJqkv7ziLbZ0gXPF7U7UEQy72Ymvrttl+kTNk8z7yLqCqz+uPB/o4OBEMc3OknyyHQQcWBEQgt7O0/Lc45uS+JkwnyCjkHyerQozdA1SzEMpYFe2LP65vznI/MAQOyXpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141897; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVGHVhduqPb+Azq3SDEUP/iaPSE3xaFetUq8v4qlmf3fIrCrAKprfJd5vHaIRQkc/knMqEbelcCcFlk1tLE/XmQbfqN65e2+nATA+dgTJj3z7jcdmFjTMBFn/rUFQE18ZsIo/n//ZQeV0e8rN7VrhaK8ttB3EQXGppLJ+mzXfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QSfdAUYM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QSfdAUYM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QSfdAUYMc9YjmqrCbMGXDDtNxY
	k7n2XM2NzdXCdqRySPgEcpdompVzDEe1uA+7ECG0aj6mxTBh2QpXWIVsbNgMimttD4VhEBLraQwUE
	Cqg6sN19mC/1Dc3qwSPITErIsiHdbe0upHSJfCLOAH8YG1qvR6YIKacma4rCMnwxS2d48aZRK3mkz
	h6rmRT+YkB5ZitmIe/KKW5/JQ2AbOpESieBMiB+nNXWYPPG0oC6TQILWrk5rMnlmXY9eW6FFgP9J9
	wsXcEnu5P1ctkexCeedEl3GtKjToKBBPif1DCRfoUff9Iromcu5yDm6hK4doaE19MO6SJE9D0c3DU
	Ad1RR7Lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x53XK-0000000H8cw-2YyY;
	Fri, 11 Sep 2026 15:51:34 +0000
Date: Fri, 11 Sep 2026 08:51:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3.1 9/9] mkfs: allow specification of default options
 via configuration file
Message-ID: <aqQjhgKOWPJy7kli@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910697.4047311.7950680370504292957.stgit@frogsfrogsfrogs>
 <20260911044352.GB6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911044352.GB6265@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
