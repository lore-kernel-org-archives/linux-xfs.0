Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7E2D9792
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 22:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030622; cv=none; b=QEduozUhJinLvLtvPXydge3iYlJmE2CzlnW0kIanKaHYKINFKYfH+SnhluIBi2F3WT6GC/Gj8jQdcJJVhUgqq2K2jtcfxI66UE/XCH7jNcIZXd1bFB57tTMXxMoE9D9HC/Fv53JkuwM3/WhO1d/iq6LFuz9yoYxfaWNZNOdBA4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030622; c=relaxed/simple;
	bh=TVqp4Vwl5PAtuq1ruW9x4QZn48sHY/O7x1yxil5S/tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HnnkM6OfXllMSNdulxxa23dzmLYbyEhbmpeIROF6evdAJK7mlcb0Ibf50LDyBPA0bqkjCZq/9+HcG/+semXBmmGrFDDDg8XWSfcILtiVDV8Hjp1/Y0YcBaDCviAMqYuTeS5e6shWkxDISvh8fE7F91R4kkQXRxSk2LhKvz4/DP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/U0RLmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/U0RLmq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1C6D61F000FF;
	Mon, 21 Sep 2026 22:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790030621;
	bh=TdD2FYsQODMN6EI9waFIG12xw+lnAhj3tmzhEAuLYQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C/U0RLmq9gHilRttIupDeJ7ikiV359DFtQAFP1XeJU2aQ7hzu1uoXedNLHEQ/qqX6
	 EV+Vf5SBYXtcXZhkRoxvndHfHx+kydEdXpXTMWXvXnfZeFskmTifrThwFhj2SHGXm9
	 PQyfwxSU+vpwq4+dvCsH6qnbNNlxkq3Rtb0D1TyPLzriXOocE8Wpnmchcab8Eak7gD
	 xcvPVMf+VOSfMkln1D7LU124zbB79VsxO+zuWruj2GzoNEbp5At9X68VLIDHJ+OsB9
	 yscv3CQ2FqJBS7EHL++YAG3X9TKl9BKcWfaCXli5JKmglEp3nIZ1XYyuVz26EWGujC
	 OBRQc5Jx7ZtAg==
Date: Mon, 21 Sep 2026 15:43:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_quota: fix XFS_GETQSTAT parameter pointer
Message-ID: <20260921224340.GP6283@frogsfrogsfrogs>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
 <178996057694.169604.2071446642858108847.stgit@frogsfrogsfrogs>
 <arDq3c43kg9hFhL7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arDq3c43kg9hFhL7@infradead.org>

On Mon, Sep 21, 2026 at 01:29:17AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:14:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that XFS_GETQSTAT is supposed to take a pointer to a
> > struct fs_quota_stat, not a struct fs_quota_statv.  However, quotactl
> > call throws away all such nuance by accepting any void pointer, so this
> > got broken by the recent refactoring.  Fix all that.
> 
> Heh.  Should we replace xfrog_quotactl with typed variants for each
> argument?

That sounds like a good idea.  I think these are the only quota
commands?

#define Q_XQUOTAON	XQM_CMD(1)	/* enable accounting/enforcement */
#define Q_XQUOTAOFF	XQM_CMD(2)	/* disable accounting/enforcement */
#define Q_XGETQUOTA	XQM_CMD(3)	/* get disk limits and usage */
#define Q_XSETQLIM	XQM_CMD(4)	/* set disk limits */
#define Q_XGETQSTAT	XQM_CMD(5)	/* get quota subsystem status */
#define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
#define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
#define Q_XGETQSTATV	XQM_CMD(8)	/* newer version of get quota */
#define Q_XGETNEXTQUOTA	XQM_CMD(9)	/* get disk limits and usage */

> For now this fix itself looks good, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
