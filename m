Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4D8266576;
	Wed, 21 Jan 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025486; cv=none; b=DUVvKFGeuKhyiaI7EJfpzxZNTuwBLLwn44zBDnkCQhJo785xVFQrRHVptobbtDIvDANeTiYzUaT8pG2bu6bCXAk3QUsBcU5hYS+QeIRNCFK2YSGUj7IKvh8Da6rdPxCSwbrv1F6ROall7C5/EE7iTxTUZxf0yvqKNyCqZmtRnjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025486; c=relaxed/simple;
	bh=SNBl8r/pbRZCG1RY6JbZ5jzqxMoWTxTfezH1cYgsxLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyKNHfsuPGZRl23TN1bqooZiaQJwplNCxXR1ZuzVadObi+F9nEiO65YrBKCK+IYJGLnePlnO5FQ2lPnOI3Ew7OAQhdTARXTDXSRm//SlrsfuNBQcdOXc2O4A1RwbWe1Jc7WUbRzeSpkrPO20pq367B+VYZ8Zvya3qvLfn5O4aDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=seIeDb45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="seIeDb45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B585C4CEF1;
	Wed, 21 Jan 2026 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769025486;
	bh=SNBl8r/pbRZCG1RY6JbZ5jzqxMoWTxTfezH1cYgsxLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=seIeDb45gHORXtp0FHpcl97ggAXk/ZchYWyW1BVXj8mdCKBh5z1f6FyMVWtYTsiAF
	 hTU40FRtMWicVCywYCGwX0iL3Dqu6gWscPy4gTLHuWcefB9r+UUr3zYkc4Y6f4darO
	 wtjBf2qifF3sMl4a1B6X+VVw4KsCETIaezPTp6Dg3CkR03G7FQtrY+xsBThhYZJnJQ
	 kGZqgrMwz7CAGQPya8C6mEU5RIFU8EGNN7+9odMnjW9hA7i4XL1p8kXURsrYgyRW94
	 w97BukyQPfKGNLGj4/4P6SQOJ7+8VDyzN82ylkukKkl/L7MaIirjY0hhyWaqMvWSZv
	 1h5v/crwdADiQ==
Date: Wed, 21 Jan 2026 11:58:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6.1 11/11] xfs: add media verification ioctl
Message-ID: <20260121195805.GK5945@frogsfrogsfrogs>
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs>
 <176852588776.2137143.7103003682733018282.stgit@frogsfrogsfrogs>
 <20260120041226.GJ15551@frogsfrogsfrogs>
 <20260120071830.GA5686@lst.de>
 <20260120180040.GU15551@frogsfrogsfrogs>
 <20260121070556.GA11882@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121070556.GA11882@lst.de>

On Wed, Jan 21, 2026 at 08:05:56AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 20, 2026 at 10:00:40AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 20, 2026 at 08:18:30AM +0100, Christoph Hellwig wrote:
> > > 
> > > > +		unsigned int	bio_bbcount;
> > > > +		blk_status_t	bio_status;
> > > > +
> > > > +		bio_reset(bio, btp->bt_bdev, REQ_OP_READ);
> > > > +		bio->bi_iter.bi_sector = daddr;
> > > > +		bio_add_folio_nofail(bio, folio,
> > > > +				min(bbcount << SECTOR_SHIFT, folio_size(folio)),
> > > > +				0);
> > > 
> > > You could actually use bio_reuse as you implied in the previous mail here
> > > and save the bio_add_folio_nofail call.  Not really going to make much
> > > of a difference, so:
> > 
> > Hrm.  Is that bio_reuse patch queued for upstream?  Though maybe it'd be
> > easier to make a mental note (ha!) to clean this up once both appear
> > upstream.
> 
> It is queued up in the xfs for-next tree.

Ah, heh.  I'll see if cem merges the series atop his xfs-7.0-merge
branch and send a followup.  As it is I'm already going to ask Linus if
I can remove the old fsnotify error function (and any new callers that
might pop up) right before -rc1.

--D
