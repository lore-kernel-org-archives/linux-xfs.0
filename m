Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PSn4lxMX"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E7C171D
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVzP6oWmGXcbbuLpGSYfF2eV+L9jrEz+o8b3znO+7oY=; b=PSn4lxMXIh+DXMSTBpsjpgiEci
	qF4yKHk73GZcW+kEFBrkBDlQz3heCffk8SGTGNcD8EDi2O/O3dfdtWGKCt2PdD5T3Naxp2pCpOMTZ
	1noQzaI1fdCMlGCWojgOtSkr5a/Npeor17/WuwM95fywX41NoahaoNNccAt4PsHxYMu0YuCUuvgnZ
	eo676/mnCQKYBOn7+I4si0y3SkJ9egtxskMulkaCfLEz05cqLHMngZRFdP3IlwjxCJG9jyKVzHj4D
	RpbfI5+9BetaIhcfjEf8DGrdYQStbmmI3E0lcT2Sxwp+g86+gCt+ftJmKXox4vRjj5vxfOKWce3zf
	M6xLh0bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lss-008em0-0S;
	Sat, 25 Nov 2023 06:11:18 +0000
Date: Fri, 24 Nov 2023 22:11:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <ZWGQBpRw047hCdu4@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:50:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rebuild the free space btrees from the gaps in the rmap btree.

This commit message feels a bit sparse for the amount of code added,
although I can't really offer a good idea of what to add.

Otherwise just two comments on the interaction with the rest of the
xfs code, I'll try to digest the new repair code a bit more in the
meantime.

> +#ifdef CONFIG_XFS_ONLINE_REPAIR
> +	/*
> +	 * Alternate btree heights so that online repair won't trip the write
> +	 * verifiers while rebuilding the AG btrees.
> +	 */
> +	uint8_t		pagf_alt_levels[XFS_BTNUM_AGF];
> +#endif

Alternate and the alt_ prefix doesn't feel very descriptive.  As far as
I can tell these are about an ongoign repair, so as a at lest somewhat
better choice call it "pagf_repair_levels"?

> +xfs_failaddr_t
> +xfs_alloc_check_irec(
> +	struct xfs_btree_cur		*cur,
> +	const struct xfs_alloc_rec_incore *irec)
> +{
> +	return xfs_alloc_check_perag_irec(cur->bc_ag.pag, irec);
> +}

Is there much of a point in even keeping this wrapper vs just
switching xfs_alloc_check_irec to pass the pag instead of the
cursor?

