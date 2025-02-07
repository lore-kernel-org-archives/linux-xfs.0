Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87681231CB9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902022; cv=none; b=RQRCSFDEcXwBNepeukUjwUv6McOWbrgKyaI0u9u/D33shgE+DjO4xf5JH5RCBbY9Y0H8Q0NlqaCdUhgzwHLRe94szAFIYdU0n8FkcdKI/vDxZLOHbU2paFWUhUAlqOwNkL5Ugf79ZriYASP6yIHlrNkdvfxPs/odimT+KbgK0cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902022; c=relaxed/simple;
	bh=TgQ9CoSQtZar2eLQ+pwTckA/dBBbBOmFWmkkvy8fVXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFN6n4lKn0ZB2TNjqBl4hEoC3uPpRVVDhZNDP7Gnh49AFgfv0MtFvgitpWm4u3En39k/IjfuRuBZtdvACSJugcigx4YK42YNxUhwXMQNITKz1NSbxE72M1ZPpRW9bMRcsW6H7Yll+yLxweMk/OFRrk6r7I4XM/TH+H3clHng8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 22ED668C4E; Fri,  7 Feb 2025 05:20:18 +0100 (CET)
Date: Fri, 7 Feb 2025 05:20:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/43] xfs: export zoned geometry via XFS_FSOP_GEOM
Message-ID: <20250207042017.GE5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-17-hch@lst.de> <20250206210342.GQ21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206210342.GQ21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 01:03:42PM -0800, Darrick J. Wong wrote:
> > +	if (xfs_has_zoned(mp)) {
> > +		geo->rtstart = sbp->sb_rtstart;
> 
> Wait, this is a little startling -- sb_rtstart is declared as an
> xfs_fsblock_t in struct xfs_sb?
> 
> Oh.  That should have been declared as an xfs_rfsblock_t back in the
> ondisk format patch.  Can you go make that change, and then both can be

Will do.

