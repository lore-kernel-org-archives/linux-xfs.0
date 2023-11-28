Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kqwrkA+5"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F9BD6D
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 06:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=arupzmYreUbfstLyTTAdqsFuEXRrWf9Yb+la6wd+waU=; b=kqwrkA+5oJVag0TSMmnBq9Uk9b
	DGhJOjSCya6d8OAB2Dlh+9/46bzHl4jLm1EQPKuTRZ1y3Wvb/Ck66ZNoMAxuC4Y3Vo97rbvjrVXyy
	09SMLMsq1VP/jC7X4Rc9HMiqhCD30s0EXcctAETlcM6dwrayqMjcdIeGY8HX74Zo2ub37ao+v2+Qy
	AaSGiwCUPg5k/xuk97gRLh8+3gT3EEtGgm+p4RFBRug7QISt1WgvxohjnB6vf/5ZoGrXXBq0GXmtW
	WtuKlKooSzVZe3wSeSTL9qfYPe6srDalciilPjNdpvzVzaldxkorY2QxU1s2fPDBOtX4LLNpzRrbg
	2jWX6uGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7yii-005RRa-1n;
	Tue, 28 Nov 2023 14:05:48 +0000
Date: Tue, 28 Nov 2023 06:05:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <ZWXzvNHCV6QWeikg@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/*
> +	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
> +	 * growfsrt trying to expand the summary or change the size of the rt
> +	 * volume.  Hence it is safe to compute and check the geometry values.
> +	 */
> +	rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> +	rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
> +	rts->rsumlevels = rts->rextents ? xfs_highbit32(rts->rextents) + 1 : 0;
> +	rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
> +			rts->rbmblocks);
> +	rts->rsumsize = XFS_FSB_TO_B(mp, rsumblocks);

Same nitpick as for the last patch.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
