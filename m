Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zCQvleEW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684B1C4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OZ8drJyOEnlms3EVGAxgRV2w2y0FxFIWHO8/ygdBUaI=; b=zCQvleEWeCCh7fXdzzBxTzhqyW
	budUFDmd1BDNkTgokudJxgMjEP/TFurPzW8Qog6zQXelF+rIrESN5tCoRI13JYDLLzgMGD/LZuQz7
	Ualrg4S7JSnEFQNM/2IbBboqTdRxVD5vTrSk2C3TvNPxkatxufuQ544hQcJHFaqRuj4GLhShqC0XV
	G2OMTP2C4Omb1/w/hiD1m9RQdPeJaLrARJGoG5r8D222Cv0flNTWaixKnokaNFm+KUgDUboZjqucM
	BhYcUvH9w6tZb1w24s9vvmZhORzEiPnPWI20uHldlmjmG6iwIoFAoWOKzY/BdBdbEyhR+eqd7XUt8
	Bo61Oz9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qrl-004Aa9-0w;
	Tue, 28 Nov 2023 05:42:37 +0000
Date: Mon, 27 Nov 2023 21:42:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <ZWV9zdT7aQxhMEAa@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
 <ZWGLH786QzH5KpUj@infradead.org>
 <20231128014437.GN2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128014437.GN2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 05:44:37PM -0800, Darrick J. Wong wrote:
> They're not generally useful for users, obviously.  For developers, it
> might be useful to construct btrees of various heights by crafting a
> filesystem with a certain number of records and then using repair+knobs
> to rebuild the index with a certain shape.
> 
> Practically speaking, you'd only ever do that for extreme stress
> testing.

Please add this to the commit message.

