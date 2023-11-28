Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gq+SFIn6"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91A6CC
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qvKT2IKtwQBcZfuxO1OCkpspzoUfmVoxq13ZSmR6hAc=; b=Gq+SFIn6A2zm7JZk/w6qR0/olJ
	5yC3DPqTIJS7hRMzGF8yPCXYLRWSvFHXfDcxVJddOjTl6zvA5NVOBEjOAuwOxn1+GOXpGGq7PVlvy
	0ApdBadwXQy10YVQA7HYRtlBmq/wXee28bxBFRZzaxhIJD04is7szUgP1aUCc8J1HGzL2XXT66b5Q
	1K+4YgvXX0VqXYuVUWyI0wVi1bgaqBd67uHbklrC9vOQ+mO3puzZlFdx+aeWME672Kzit3v0oFTPC
	cAb3r6IURf8mfgSAXrrTMFRzTNu41tyKp1wTuYU08B7jw74mkczs0VLnOn9gj6dgCjTMu0iGuP7tx
	N5UGzjkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7qng-004ABE-1m;
	Tue, 28 Nov 2023 05:38:24 +0000
Date: Mon, 27 Nov 2023 21:38:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Message-ID: <ZWV80MfauXWdVzGC@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
 <ZV70YNvPWauYckC4@infradead.org>
 <20231127182738.GD2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127182738.GD2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 10:27:38AM -0800, Darrick J. Wong wrote:
> Hmm.  Or I could decode the ondisk field into a stack variable so that
> future flags don't have to deal with that:
> 
> 	compat = be32_to_cpu(h->v2.xmh_compat_flags);
> 
> 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
> 		fatal("External Log device is required\n");

That looks even better.

