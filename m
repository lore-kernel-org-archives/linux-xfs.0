Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB61DF75D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614086; cv=none; b=OqEcUHuPDIRxbRLpU1O4BCTCmivRlEBlYXG1K7Ls2aTGa9bbsaHLUKlfWIQg3Sc7XPQmrpiX5D1TRNHoL6XrL0Pla791mpUB6pB+DhVuKwclCsI/EB+WkYq31hfSPgoZ+BR1IY1sZ4p0PhPVWXThTN/ofoH+7LykPtiGl0M6ozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614086; c=relaxed/simple;
	bh=kju48dnN77sFszu3yMeWl/guuAyb+E3W8Vy9/Zvh1Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEWCrp6FWemDnmOxALFiiOqvLo3ygmK2gBiujB3wU/QkczGeZrbhpj9xEYmayRxylSpSdaBWNmj6ENfgKOQDaOZrh9aTlNjLD+vEzRdk0TqBwqC6si+WKJs0Cd/jbftRgrY7jXdGjT7uFKSQsZdycc3Vpm2A87bDJDZCFKgeY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vR9gSvXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vR9gSvXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60675C4CEF1;
	Tue, 19 Aug 2025 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755614084;
	bh=kju48dnN77sFszu3yMeWl/guuAyb+E3W8Vy9/Zvh1Fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vR9gSvXAWD07i6WtGwM9U01Sr3LaHPyA02tBdXlXZMdFlvzc0mMIw3up+6vLiuyQB
	 lV7ZnOoVkbunZylBd86zMbPp9HWSIC1MNc7i7+gSYC5YsdoT0IXY0N7CBGWtAjY2BO
	 3ANK8LVAxZcNhM4b1YB6RvMCSoADGCur/Ei1LJSNvLCN6N1ryN+h4goIBfv9W0/txi
	 lMQYa9Ez5SvFodM+oGK5oWyrXn6oXpTW2njti3ewUrAXMjQ6yi264C3/hW2HU+xmQX
	 tAhzMs40cxM00T4NRdFnTfjZ+maNHWaVcjvLzjbnl1Q3WFE8p0I+BgjwyDPULLfxpt
	 8M7KGcdjpNocw==
Date: Tue, 19 Aug 2025 07:34:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
Message-ID: <20250819143443.GA7965@frogsfrogsfrogs>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKQxD_txX68w4Tb-@infradead.org>

On Tue, Aug 19, 2025 at 01:08:47AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index f9ef3b2a332a..6ba57ccaa25f 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -747,6 +747,9 @@ xfs_buf_read_map(
> >  		/* bad CRC means corrupted metadata */
> >  		if (error == -EFSBADCRC)
> >  			error = -EFSCORRUPTED;
> > +		/* ENODATA == ENOATTR which confuses xattr layers */
> > +		if (error == -ENODATA)
> > +			error = -EIO;
> 
> I think we need to stop passing random errors through here (same
> for the write side).  Unless we have an explicit handler (which we
> have for a tiny number of errors), passing random stuff we got through
> and which higher layers use for their own purpose will cause trouble.
> 
> Btw, your patch is timely as I've just seen something that probably
> is the same root cause when running XFS on a device with messed up
> PI, which is another of those cases where the block layer returns
> "odd" error codes.

Maybe xfs should translate bi_status into whatever error codes it wants
directly instead of relying on blk_status_to_errno, which can change in
subtle ways?

Though how many of those status codes actually need a different error?
BLK_STS_MEDIUM (ENODATA) and BLK_STS_NOTSUPP (EOPNOTSUPP) are the only
ones that look (to me) like they could be confused easily.

--D
