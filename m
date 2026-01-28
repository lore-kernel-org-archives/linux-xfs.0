Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BD51373
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571961; cv=none; b=K1HbeAQKdG9rxDtQrCI6z9Q8p+9i424nR0aDhvDZ3SQSFkl0FnmI9cKkMQRkSo/NzCXyj0baS+Z8gIvpiffPi2TTZCNdJCLAxowjg+Yx4biXxipY/QCzQ2xc+zZikMDex5kwvBegBPc845DvwbK+kRk4gbgDPM3i+m7Ti1e1QxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571961; c=relaxed/simple;
	bh=l77ycwbI1Cd5cGt0AcihFBkw80dyHpbykfu8bE+Vwy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc3/MpL2k/b1Dt5f2n/dCAnJRKYBSbFhlF4V4i/1Vf86+fRY7oyh7dI4X/tUIDTEZcFpQuZxJYDSGt1vgHzNtu8gs8od/VII7imlpMa6I1vgDanClL7nsiwqi6fW//jC/TMde+5a0HbCOdmNGTXeetjhVLr+lGgJRmE+9zvG0Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F6FE227A8E; Wed, 28 Jan 2026 04:45:58 +0100 (CET)
Date: Wed, 28 Jan 2026 04:45:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128034557.GC30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-7-hch@lst.de> <20260128013730.GF5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013730.GF5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:37:30PM -0800, Darrick J. Wong wrote:
> > +  errortag=tagname
> > +	When specified, enables the error inject tag named "tagname" with the
> > +	default frequency.  Can be specified multiple times to enable multiple
> > +	errortags.  Specifying this option on remount will reset the error tag
> > +	to the default value if it was set to any other value before.
> 
> Any interest in allowing people to specify the value too?  Seeing as we
> allow that the sysfs version of the interface.

I don't need it for my uses yet, but it would be nice in general.
The reason I didn't do it is because it adds complex non-standard
parsing, and I'd have to find a way to separate the tag and the value
that is not "=", which is already taken by the mount option parsing.

