Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27168110B
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOvxt7Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B3C433C7;
	Tue, 28 Nov 2023 01:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701133557;
	bh=Q+FEm0XmMfLuSErZbRcVgejhcNdsRPYPX4JmoSP8EMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dOvxt7CdlnQvZaEfsGrBIlUHz3sVZWXSLDcOnvRs002o0WrDJz99kypTT1QJl7qsp
	 dy6xUFozfO/Y2xQTeXbWqO54MXkI9X6PhLFygCCGovwEX07t+XebgU4S2U7wKs53yv
	 FhvlN5WHycydfw46m9ST+IHHWpPDYD+61OCPiVMsHk77xLq/0sV7z2ac75PQIIXBca
	 RVmA78DOHFhFkXCsGbo/UBhZOWRMWBXrQ/oKpzx2TQuW4FQVGP9I2TGe0t/J4EvZTT
	 3QxXyRUcIQpuim+vw6tLKeL/Xrn+k2iS6UrUDxNbQLXLvuVNHfV+LR/3uZH1HS5Q1s
	 sWF9d9B1cmlWQ==
Date: Mon, 27 Nov 2023 17:05:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <20231128010557.GJ2766956@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWGQBpRw047hCdu4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWGQBpRw047hCdu4@infradead.org>

On Fri, Nov 24, 2023 at 10:11:18PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:50:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Rebuild the free space btrees from the gaps in the rmap btree.
> 
> This commit message feels a bit sparse for the amount of code added,
> although I can't really offer a good idea of what to add.

"Refer to the design documentation for more details:

Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html?highlight=xfs#case-study-rebuilding-the-free-space-indices"

?

> Otherwise just two comments on the interaction with the rest of the
> xfs code, I'll try to digest the new repair code a bit more in the
> meantime.
> 
> > +#ifdef CONFIG_XFS_ONLINE_REPAIR
> > +	/*
> > +	 * Alternate btree heights so that online repair won't trip the write
> > +	 * verifiers while rebuilding the AG btrees.
> > +	 */
> > +	uint8_t		pagf_alt_levels[XFS_BTNUM_AGF];
> > +#endif
> 
> Alternate and the alt_ prefix doesn't feel very descriptive.  As far as
> I can tell these are about an ongoign repair, so as a at lest somewhat
> better choice call it "pagf_repair_levels"?

Done.

> > +xfs_failaddr_t
> > +xfs_alloc_check_irec(
> > +	struct xfs_btree_cur		*cur,
> > +	const struct xfs_alloc_rec_incore *irec)
> > +{
> > +	return xfs_alloc_check_perag_irec(cur->bc_ag.pag, irec);
> > +}
> 
> Is there much of a point in even keeping this wrapper vs just
> switching xfs_alloc_check_irec to pass the pag instead of the
> cursor?

Not really.  I'll remove this from the next spin.

--D
