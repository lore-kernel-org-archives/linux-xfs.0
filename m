Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E8B418373
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 15:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819305; cv=none; b=d6cQk+lm4nVBs7MJsbSU2rGR5YDlXnhMmwR/CcpHByJ7kAcSexTrBmXEsG62pGqnh7bZ/qnE1Kq3SWwvIs76dZuBoHsQ6cAqL3qiX7CLMKgdroVvQXcbDm91mux5tt2ZAU+Ln8qHg3K66XAf5nndCb3Ts7Njmi7sMlMd3TNCZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819305; c=relaxed/simple;
	bh=J6/n6DbK0wS0AOF1bxyvKII5qhZaT7Xx19BbfI99+r4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiJkGDyuivugwoevi+1+ETAL5XI192HPEK3nFc20ax1MvSyoeaedi/X0ELAW/e+ScRJVKs913ORc1MeN/H0w5v6tVnl1a8nEsjf8jEtOpq3YDPWbgnnpdsvm9wdj69y48odQyhJzodjLeu+5RXGWDEG69OVZDQKZtckoqth8JQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFDlJ9pd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFDlJ9pd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E76D81F0089B;
	Mon, 12 Oct 2026 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791819304;
	bh=QYggyRJmekueGhdKquk6XSWjJ9hZs5S3eLT1YBJ4E3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bFDlJ9pd38lSRS7dFKAWJvpuHpvkt4w2BA4qvc9DxW4fnvdDfmDSaoXWaIV/vXGmy
	 8gMJUERvV00KF5djudJu7bMhJMID6ZBjujpo/R39UcZaJbqG3jqxDL3QOqg8odKvJD
	 9hBqQ/X8vlflM0hxA2vhVusGH5EPEljQfKzdi/3AJvje9SIhzdMKXGLcefiGPEBmej
	 tvjAdAWAdYxaSmGiWqgjYjkJ0JrZcb34UP6KR2BISovxCZ64wZmQutO4/TZfOSG6kk
	 n+ZRmqf4c/HO0UM96gmyeLhy6NEoBTGdrWBpJIZ/Ock/d1FvBKHRauz3SDL2U7XYHJ
	 TNu9Cr+7ke3og==
Date: Mon, 12 Oct 2026 08:35:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: hide b_flags manipulation from code outside
 of xfs_buf.c
Message-ID: <20261012153503.GY2705364@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
 <179158947495.3719791.6891995032675051951.stgit@frogsfrogsfrogs>
 <asze5x4ZrCI-Clss@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asze5x4ZrCI-Clss@infradead.org>

On Mon, Oct 12, 2026 at 06:21:43AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 09, 2026 at 04:47:27PM -0700, Darrick J. Wong wrote:
> > +static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
> > +{
> > +	bp->b_flags |= LIBXFS_B_UPTODATE;
> > +}
> 
> propagating the kernel flag to the libxfs one might be a good idea.
> But please don't hide it in the resync, but make it an explicitly
> documented separate patch so that it is properly described and
> easily bisectable.

Hrmm.  Looking at the existing XBF_DONE usage in libxfs:

libxfs/rdwr.c:1428: * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
libxfs/rdwr.c:1437:     ASSERT(bp->b_flags & XBF_DONE);
libxfs/xfs_platform.h:323:#define XBF_DONE                      0

I'm gonna guess that if I replace the helper with:

static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
{
	/* does nothing, XBF_DONE is not LIBXFS_B_UPTODATE */
}

Everything will be all right.  How's that sound?

--D
