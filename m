Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C91211A14
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 04:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448587; cv=none; b=h1dwFXxtRhYhzSuAmGcIS4aqgI0Lt1M0wk7rhRZdpRau5DsRuQcrZbaoUpuD47MQ2CM2shnbrpGAVq5WHC2R54EcNOTYnqE6nfOjcwP4BLejgPbJ0lXbdyaht8cnH69nVkyzu657W/bW6xY1C7kuMRIsT+inb8n0kLEu3xQeoWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448587; c=relaxed/simple;
	bh=sH3CHlkWTGYgAO2VrZoaN12Yon0sPeKeVyoLKp+njlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atBF/u1VHpGrdTKdNA22IlbHB0jyrNx8QnAvPZwpxrdaV9Uv9AyDAb71K7ltTzs6EIS6VazNfMJRXsAOAGYI2GDzk0Iwtetav4EvXjApp19F/juHsP4SnokugQ+DE/Exve4CE5Xo19Mh2IWJGuBSAMKTGcId+fgnJgXMTyHaX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2D7468BEB; Fri, 26 Jun 2026 06:36:23 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:36:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, OM@magnolia.djwong.org,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] xfs: fix handling of synchronous errors in
 xfs_buf_submit
Message-ID: <20260626043623.GE8078@lst.de>
References: <20260625135849.2494779-1-hch@lst.de> <20260625135849.2494779-6-hch@lst.de> <20260625181303.GJ6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625181303.GJ6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 11:13:03AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2026 at 03:58:35PM +0200, Christoph Hellwig wrote:
> > Synchronous readers and writers already run __xfs_buf_ioend from
> > xfs_buf_iowait after being woken through bp->b_iowait, so we
> > should not call it here, which can lead to double completions.
> 
> How hard is it to trip the double completion?  I guess all you need is
> an IO failure (or a verifier failure) on a synchronous read?

Yes.  Or synchronous write for that matter.  Note that due to what the
completion handling does, the double completion might not be that
harmful for synchronous I/O, but it sure as hell is wrong..

