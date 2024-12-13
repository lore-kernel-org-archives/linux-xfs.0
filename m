Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEB21632FA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066489; cv=none; b=OTcfrRxGp6hWAcLgLtQoXw0BQhHDm6D+zA/0uX99qrrtN530UrbnhcE1theGunerkQNHWGgkLLsSDUB8B6Zovqey+C58JNEVa0p49W+xOcLVk8HkuLHQyfDCDQsM9MSKqMO/YrvnGEXJlE2VKQ5gMGuaQmRP0epr5Dtck7mDBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066489; c=relaxed/simple;
	bh=1xjx6XhB6NroN1B6BhSXrYs4GFKknbc9foXgUh6AbwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXsGEcANIXptqu88ZuKZuUZ/elpSeHtTwcwipTixfSzhJmC6j04dLAnNvG+3OEeK00H0/Cr6g+g25yotQbF1q0RS39DJ+PGun86On92U/MZPtF080SRXVoIFzbxdrH5zxHKIXBk2IUjJiQ3s5Kh+fbMc8xcj5E46aJyPRbZ5ufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3457068BEB; Fri, 13 Dec 2024 06:08:04 +0100 (CET)
Date: Fri, 13 Dec 2024 06:08:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: refactor xfs_fs_statfs
Message-ID: <20241213050803.GD5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-7-hch@lst.de> <20241212212400.GR6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212212400.GR6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:24:00PM -0800, Darrick J. Wong wrote:
> > +	 * XFS does not distinguish between blocks available to privileged and
> > +	 * unprivileged users.
> > +	 */
> > +	st->f_bavail = st->f_bfree;
> 
> Not relevant to this patch, but I noticed that (a) the statfs manpage
> now tells me to go look at statvfs, and (b) statvfs advertises a
> f_favail field that nobody in the kernel actually sets.

The kernel doesn't implement statvfs and thus doesn't have the field.
This is what glibc does for it:

  /* XXX I have no idea how to compute f_favail.  Any idea???  */
  buf->f_favail = buf->f_ffree;

