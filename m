Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB8D14F76
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TgERG1Z4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EkZ3APwQ4pV20mMbP/uH2mvLd1WS55fKnmDkHbGqqA4=; b=TgERG1Z4d73REdIFWKuRcSEahz
	VQY1WECNFEXuFnV1OPmWt9277iO4CuXQzSKaAqjVcLIuGQ5pHe7AXV9VuFKOrrzUklTgP+OzgEyib
	NGq3uco1TztF7qPbGXzRTfQR6QvXBg5QXiCo2QCDI4dshuFCRrPgNv4ulR15RNmRB7EFbv7wcYmMq
	hrKoLL2Cpht9ddlqhKVrCQIffO933811ox3H7m7IJhgKVghWIoCL9GPosakD8eCEQTfIqoqYD9Oen
	6Q8PT3UB6bI221kqlNTJOcaoYkz9toDFkndV8yXROrsqWw+7nj2sVSXo9LRk8RUASnSO3uMqji5tw
	Pmtw+bmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBfi-001kcq-31;
	Thu, 21 Dec 2023 05:32:38 +0000
Date: Wed, 20 Dec 2023 21:32:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_io: set exitcode = 1 on parsing errors in
 scrub/repair command
Message-ID: <ZYPN9nz2dKVMjID8@infradead.org>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
 <170309219094.1608142.4865155109436063528.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309219094.1608142.4865155109436063528.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 20, 2023 at 09:14:33AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Set exitcode to 1 if there is an error parsing the CLI arguments to the
> scrub or repair commands, like we do most other places in xfs_io.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
