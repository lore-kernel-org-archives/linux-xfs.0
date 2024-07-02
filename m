Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5296F06A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 19:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719949913; cv=none; b=ZObX8mwY2PawosHd9X+70y4hlZnn4ACrbgPovAne8B1qZS9FiI2IFXDe+ZjE1q60sr2W+pDT7ezD1Ad/JjKnpWuWJtISlC8TUyZ9wYGp4CyfLVSbdljPmLsoeNCtLjqVSMFkqescHywD0517ZVjn+GvVZ2e0aduY/X+dupFGTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719949913; c=relaxed/simple;
	bh=tuE5R/Gd7NOro7vDaQfgylNOd4oyoiOg5JEK8EPQaY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uihg4yrsmodIjrQ2YROYKv+e3+kXY6ylYEa4EbTMyciQDBdKzwDAPaskxy3juuN1bNSu5dWBBV4WghD5CI1EReP20gQ0x2/3dgC0P+ns98uGhSfTKK+Jfsp9Fb9VzLJv0Z7wyFg/X/rLUR0RWBh/jDQkkcewmNurRq24BSIqzhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1WcSoBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1WcSoBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE2C116B1;
	Tue,  2 Jul 2024 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719949913;
	bh=tuE5R/Gd7NOro7vDaQfgylNOd4oyoiOg5JEK8EPQaY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e1WcSoBhL/obvAMIkQLEnuY/2cR+TMkmEoPk0iA9Ldgj31pxaTgHUoWFUwBhfWbGD
	 wNkAn4wfk6I94U1IlF8y4d1NLf5doPP2mqjKBmm+l2UVAdvOt88Izu+IBVdop0BcuS
	 VWqmYDNVuh1M2wMDBnj7lwS0SlyKypOnRBmQhEY994HXi9c6HCZmilwMf/ReWOiZIk
	 gdquUy29gb5v1X+Kf7F7ITORSQMizQxRLIH2mch3aeuMJQmH87syeBX5Nz+j5yW+9p
	 bEqVMCNsDr/MSuj3qWlcXsXnx4aHL3jNBLEyAGUY/SBjeGxyF7jeJbPCmlRQt6cEBw
	 5X5GrBjyNlmlg==
Date: Tue, 2 Jul 2024 12:51:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs_fsr: convert to bulkstat v5 ioctls
Message-ID: <20240702195152.GP612460@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
 <171988116816.2006519.15287670811039475666.stgit@frogsfrogsfrogs>
 <20240702051346.GG22284@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702051346.GG22284@lst.de>

On Tue, Jul 02, 2024 at 07:13:46AM +0200, Christoph Hellwig wrote:
> > +			if (lseek(file_fd->fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
> >  				fsrprintf(_("could not lseek in file: %s : %s\n"),
> 
> Maybe avoid the overly long lines here?
> 
> > -int	read_fd_bmap(int fd, struct xfs_bstat *sin, int *cur_nextents)
> > +int	read_fd_bmap(int fd, struct xfs_bulkstat *sin, int *cur_nextents)
> 
> Maybe fix the weird formatting here while you're at it?

Both fixed.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
