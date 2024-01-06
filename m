Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6434BE541
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tk0p2NeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1A9C433C8;
	Sat,  6 Jan 2024 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704567135;
	bh=ZY0n2nlUfmOvoxqOrqRdQtyFGeE8b6qCYTm/JSPmNWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tk0p2NeBjNFWgPi7xgpEPs1V5podMCCjv1Csa5BBIbCoP/rebcoqUxR9TMzLlv5VS
	 hO6dXuI0U0fkqIQzxOhJEmhITcnScEmFkflQ8JPFoACd/H3pMwhYPG1P1J6723GrHq
	 m0RM0GnqRKxYLVh1VGU1ueCHF41XksIct6JFvchBf02ptfXmHdEllDI0IN7KE73clX
	 pEfKoVY3V6u0BYfCDdlvZ19snhyZBxyti5+pa/1eV5+7/RKbD0ud4Ex4tkIoTC3QMg
	 J6+7Mmf8VnRdR9ijMJywQ4xulXiXaMxbcvfVQY3zVYNznvdC74HyItQtuRTblb9ubm
	 vH6QWCjFE/GKg==
Date: Sat, 6 Jan 2024 10:52:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair cannot update the summary counters when
 logging quota flags
Message-ID: <20240106185215.GM361584@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827460.1748002.10713217958407192887.stgit@frogsfrogsfrogs>
 <ZZeVIByA69C6XLXt@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZeVIByA69C6XLXt@infradead.org>

On Thu, Jan 04, 2024 at 09:35:28PM -0800, Christoph Hellwig wrote:
> > +	bp = xfs_trans_getsb(sc->tp);
> > +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > +	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> > +	xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> 
> We now have a multiple copies of this code sequence and it would probably
> be good to have a helper for it.  Given that the current xfs_log_sb
> is a bit misnamed I'd be alsmost tempted to use the name just for
> this and split the lazy counter updates into a separate helper.

Since we're really only updating feature flags, how about these three
lines become a new xfs_trans_log_sb_featureset() helper?

That's not a totally precise name since we're logging everything
/except/ the lazysbcount fields though.

> That also makes it very clear that we'd need to explicitly opt into
> syncing them and prvent accidental bugs like this one.  But I'd also
> be fine with another name instead of duplicating it here and in the
> pending imeta code.

If we go ahead with your suggestion not to update the superblock under
the hood in the xfs_imeta.[ch] for !metadir filesystems then there won't
be a third caller.

--D
