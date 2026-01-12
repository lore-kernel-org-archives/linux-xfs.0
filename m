Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3E28C2DD
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 10:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212764; cv=none; b=DUzTZhExMPQAHqlHC6V0+Zq28HI5OMbmKBWTyBmgNj3sdzskcCrUd1uEC6wQ84UDCFdWi+IpLndCRFpsANMrI3eL0lFGMyE3E0F5RY62TfEg7D2YXEQTZKrNtybTaMhw9BRZ+FtgfLfN1Su75XP0xYRmvA/Sr2dzAIGfhjR8J1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212764; c=relaxed/simple;
	bh=Jr1yOc0ndhrv7oisYdfDQR8jyGWCjn1/NQbJoJPp6cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yh8lkw68WxNZee7KsY7pEyGvtNiicKH7WiBA43szv11sQoOHQSiyZusMqSJ+rfDAgaawZxi2Zyq6P8Mi0Q/sICyj4CNog0WMHpR6GLU+5aWrXD98nhvNF+Ej4rNCg7WIYbi5n8Zb0rcln3/F47Ke+ohpyjfqUvNuV4Zvy3dsqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2CA09227A88; Mon, 12 Jan 2026 11:12:39 +0100 (CET)
Date: Mon, 12 Jan 2026 11:12:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: split and refactor zone validation
Message-ID: <20260112101238.GA7719@lst.de>
References: <20260109172139.2410399-1-hch@lst.de> <20260109172139.2410399-5-hch@lst.de> <20260110014413.GA15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110014413.GA15551@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 09, 2026 at 05:44:13PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 09, 2026 at 06:20:49PM +0100, Christoph Hellwig wrote:
> > Currently xfs_zone_validate mixes validating the software zone state in
> > the XFS realtime group with validating the hardware state reported in
> > struct blk_zone and deriving the write pointer from that.
> > 
> > Move all code that works on the realtime group to xfs_init_zone, and only
> > keep the hardware state validation in xfs_zone_validate.  This makes the
> > code more clear, and allows for better reuse in userspace.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hrmm.  There's a lot going on in this patch.  The code changes here are
> a lot of shuffling code around, and I think the end result is that there
> are (a) fewer small functions; (b) discovering the write pointer moves
> towards xfs_init_zone; and (c) here and elsewhere the validation of that
> write pointer shifts towards libxfs...?

Yeah.  I initiall had this split up a bit more, but that made things
even harder to follow..
