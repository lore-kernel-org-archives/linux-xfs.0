Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD8D4C67F6;
	Thu, 24 Sep 2026 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790278477; cv=none; b=DtElUM1jQ3r0/KFqXzr5nU3ZW5SkoOi0foXX5jire9kMWALlJj/q55AsysNyYv+46o+EZxIkq6gh+cUyNedW1vKDUdRjtFdV5e3+MiKTtg98k9fHtW3cZ8ytB8OS44y7MQsmHCAlVlUu0qbKToEEMSSSvbEvtUBOCVaUOhq1g8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790278477; c=relaxed/simple;
	bh=HQf0TdAqwDQEacVHCR3u4gRHpsr8oTiks2l/tvFhJJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nf16kqboR80PjKaQFxc5JxNIz0UNlSlnsWjjbeadjV3VvXK4tjBQ2dtp6LMSOuUKolFdtBnQ/ZGDlWtfXTe6iofSp1oqOUZ/zFwe6n823H091XLeyDtStLuheqpjdTFpnIToHwDKYjR6ZpWt1aXtLHPggJXDvs5HOoWT7ZCFf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogru1OAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogru1OAP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D49831F000FF;
	Thu, 24 Sep 2026 19:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790278471;
	bh=8XMT9M/PHTig4c4MhxCVlBHCwL8rBCmYnEllXmg5IRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ogru1OAPro0BH8/E/gHgBs86ajYlQeO8DbGxNkf0xBKKuAt61pE0wcWzQSLDdIoHp
	 Y73+IaywyKnAqSxwyxu6kycK1C+pExh9BPoZJQHriA6ji6bZq/WFG26XkjTz66Xbp2
	 QKt7rqm8wJJ8C6+XCWkFDQ3PREIG60JOWWRKIF6NnG+ieKXAKnjPmeiDxGDEW+jtMp
	 jrDmlZ2WvJ+NIM1+EdMq4XvmNZ6rXAALB/Kwes39YCFdTe5oj8XQhfkTi+Vf0TllAf
	 40Kg0o6EWcH77trybeo5mbE0KmvKF1tH2Wz6PfNod/JSMJLQQb590SDlfObc+C7PpE
	 u4NpTz5HBzZgA==
Date: Thu, 24 Sep 2026 12:34:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: avoid cross-rtgroup reaping after a repair
Message-ID: <20260924193431.GR2705364@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159798.1875436.7915121855965899039.stgit@frogsfrogsfrogs>
 <arS7tTCQGhyHjoou@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arS7tTCQGhyHjoou@infradead.org>

On Wed, Sep 23, 2026 at 10:57:09PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 22, 2026 at 11:03:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM notices that the extents stored in a xrtb_bitmap (aka xfs_rtblock
> > bitmap) can span multiple rtgroups due to two circumstances.  The first
> > is that the size of an rtgroup is an exact power of two, which means
> > that rtgroups are adjacent in the segmented xfs_rtblock_t address space.
> > This is fairly common to reduce the amount of multiplication and
> > division needed to handle space on the rt volume.
> > 
> > The second is that (unlike in the original rtgroups design), rtgroups do
> > not have fixed-location metadata like AGs do, which means that there's
> > nothing to force a break between rtgroups.
> > 
> > Therefore, we must loop through the rtgroups in xreap_rtmeta_extent to
> > avoid running off the end of an rtgroup while reaping.
> 
> This fix looks good.
> 
> Sashiko complains this could use some additional input sanitization,
> though.

Oh yeah.  If rgbno points into the gap between rtgroups, we should
advance *done to the start of the next rtgroup.

--D
