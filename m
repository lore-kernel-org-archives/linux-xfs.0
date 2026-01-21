Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8536D4FF;
	Wed, 21 Jan 2026 07:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979163; cv=none; b=T9kOcN+oWGCNHgUvQSQc7UIbIj0EaRx1OKNg4vL1K/MZTLrC5Vxvrq+qNd5I3Rk0oPCblJWVct94khxe+J+iXasSWuaFGb+YsBZ8G0zrMoywbjtnFg8+EZEx1hB/BmGbHvY+hXidpyN/ljnboEnESBiwQAtN/efF+Imuw2Mulyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979163; c=relaxed/simple;
	bh=A2KfSkJuhESCLyE4jZ0Ge4N1CSVaBszfju+1MHdCnvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTLSvE2q8yq8H8KP5q68HjVW4oetEI2COlYjv2ntPMesujtgqeqj8gMHYVKIuKN9D6tuiTTUuTGHMmMRlfIhGZ93l96tNmp31ycBENDmvxbfhtpaPDcC1sJOO/3KNIw9gJY1OMSOz4eb23DW7F0Q0OZQ1XBzqfk4NYjW/Fyw/ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A902227AAC; Wed, 21 Jan 2026 08:05:57 +0100 (CET)
Date: Wed, 21 Jan 2026 08:05:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6.1 11/11] xfs: add media verification ioctl
Message-ID: <20260121070556.GA11882@lst.de>
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs> <176852588776.2137143.7103003682733018282.stgit@frogsfrogsfrogs> <20260120041226.GJ15551@frogsfrogsfrogs> <20260120071830.GA5686@lst.de> <20260120180040.GU15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120180040.GU15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 20, 2026 at 10:00:40AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 20, 2026 at 08:18:30AM +0100, Christoph Hellwig wrote:
> > 
> > > +		unsigned int	bio_bbcount;
> > > +		blk_status_t	bio_status;
> > > +
> > > +		bio_reset(bio, btp->bt_bdev, REQ_OP_READ);
> > > +		bio->bi_iter.bi_sector = daddr;
> > > +		bio_add_folio_nofail(bio, folio,
> > > +				min(bbcount << SECTOR_SHIFT, folio_size(folio)),
> > > +				0);
> > 
> > You could actually use bio_reuse as you implied in the previous mail here
> > and save the bio_add_folio_nofail call.  Not really going to make much
> > of a difference, so:
> 
> Hrm.  Is that bio_reuse patch queued for upstream?  Though maybe it'd be
> easier to make a mental note (ha!) to clean this up once both appear
> upstream.

It is queued up in the xfs for-next tree.

