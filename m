Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49524194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902427; cv=none; b=U6CpEK/iLp8FiKydjbais8/I7ZuDPc0+SB9NzYjUxepnx/WwJYKz7MYYICV/pEJNiMdZItSMrvm0ZXDc/wMPnXcNjFIEPty2nJiFFoHZMVwxRRzUBff8A8irScU080sGpcNWxtnPL6+U90AfUkN5a/ZwdRCus+uXDN5ZvlSrD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902427; c=relaxed/simple;
	bh=VyMJVJpKP5ZhjJEtIQiusfE96+rL4nOiZ0C/5MK7QqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XL8W+wxnK/fhdzxKcb/65P/0RDbmY8LfRHoF0NlWnaLoV2aQeNYMfOWSTpaTJ/UPrs/wN8JG7y6FvUHwCu5nJAEbCSk8rS440KuZAaBsZPUCu6JxMI36/1HYH0i4XV/Fyt7J6lT75nVp8yWtzKlSEqdt20vbDBq8C89LJ8yHzn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+uW7A8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+uW7A8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C988C4CED1;
	Fri,  7 Feb 2025 04:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902425;
	bh=VyMJVJpKP5ZhjJEtIQiusfE96+rL4nOiZ0C/5MK7QqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+uW7A8Yco3oAB/7dPpxcJ+NChqfN7CiYMyQV6QaAXXoBeuLi8rg90aNU65LVWf9j
	 px9MqKIxA2/7Ny7dCrLytZsUBLvilZjn262lcQQw6ROVs5Ai7NXdAMQ/x3jXnwfJ0S
	 B2cz+ON6jGmVp9l37mFmwqCCyozd3nsT8sahbJrd2kmOgqLc03kHWOJ2BcOtlitWZ9
	 i/lZLEPf0WuALljoAszBRrXLELntRv8JZc2+rgVzgCBhhdyPx8oR8U0Jt6dwAZNSHX
	 1A80zEO4fCzmUnfmT1sUu9vFslWmFTxcpGx9it+iY6E0WC2h2ijrktiPVubIleQfR5
	 U9DXdDHugsEDw==
Date: Thu, 6 Feb 2025 20:27:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: export max_open_zones in sysfs
Message-ID: <20250207042704.GJ21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-44-hch@lst.de>
 <20250207005259.GD21808@frogsfrogsfrogs>
 <20250207042345.GG5467@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207042345.GG5467@lst.de>

On Fri, Feb 07, 2025 at 05:23:45AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 04:52:59PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:59AM +0100, Christoph Hellwig wrote:
> > > Add a zoned group with an attribute for the maximum number of open zones.
> > > This allows querying the open zones for data placement tests, or also
> > > for placement aware applications that are in control of the entire
> > > file system.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > It occurs to me -- what happens to all this zoned code if you build
> > without RT support?
> 
> Where this code is all of it, or the sysfs support here?

Both, but mostly the sysfs stuff here. :)

> In general the code is keyed off IS_ENABLED(CONFIG_XFS_RT) wherever
> possible.  But the sysfs code here is missing that, so it should
> be added.

<nod>

--D
