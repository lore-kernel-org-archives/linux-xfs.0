Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A688BFD
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718991838; cv=none; b=MfNNnwFS447JgpWC9qbdSWXuXf3WR8Pi3T4aCyemJWWoUJly4Ctcs2oMmDgG1r2jBQP7OsZer5o/BGdxb18kNctQRvVClydc4T8XEbjymdJveauWAv2vdnRZP8ulee6D3AzVp9NoxUDZoDyzwKbrYHRqpLBlYi0ODNW7YSxjWOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718991838; c=relaxed/simple;
	bh=7vO996esIlixTV3FmbbQiqLNPXqiQPkDs9MINzzw/kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COi9GdawoUjsHbhmkkST1UQkmNHeU4UTkkubuKeB/4dna/XcglwjyaoxMaT6HXzgkqT7Oy0SzM1O4c0m8OVnx6BQem/ZtNDkRaBH64hWCiaOruMqOYOJIwK7kfDsPCIhOw+ueB5skJfx+VJ/D23d6g9De1mEu5BEL97Qh6FeDGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9d4F4LX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9d4F4LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B228C2BBFC;
	Fri, 21 Jun 2024 17:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718991838;
	bh=7vO996esIlixTV3FmbbQiqLNPXqiQPkDs9MINzzw/kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y9d4F4LXKUsuwfDywo7Db9ZPmsv5cgOKNniTI/rlOSr/cp1ilmpoOnaTGfYMtYdna
	 6hE7X0NFmyYeXypQ95MTo1R/0rKHOgtcKR0K89Ga6lBroMVeQQ/M+qE935BmqkQT0s
	 INQ20p2awhOo7Rq0ylw0K8L4WfLgdzE2605FgiJPDUbZuX6Oj8rp7qLo0Smy19alCs
	 AKflhGDOifZJVF98cA1zZPIIY0ce2Ri4Gits77NyEYf3S+6NFn5fz7qVVH696Z39my
	 RqN4i7XYSQZllpQU0wOegS3b0zm9h4lGiBPpwURKT5IihtFQbM7MBOOYuwCIPgL0tc
	 8Om4zy9jObM9Q==
Date: Fri, 21 Jun 2024 10:43:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: simplify xfs_dax_fault
Message-ID: <20240621174357.GE3058325@frogsfrogsfrogs>
References: <20240619115426.332708-1-hch@lst.de>
 <20240619115426.332708-4-hch@lst.de>
 <20240620185026.GA103034@frogsfrogsfrogs>
 <20240621050558.GB15463@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621050558.GB15463@lst.de>

On Fri, Jun 21, 2024 at 07:05:58AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2024 at 11:50:26AM -0700, Darrick J. Wong wrote:
> > > +	if (!IS_ENABLED(CONFIG_FS_DAX)) {
> > > +		ASSERT(0);
> > > +		return VM_FAULT_SIGBUS;
> > 
> > Does this actually work if FS_DAX=n?  AFAICT there's no !DAX stub for
> > dax_iomap_fault, so won't that cause a linker error?
> 
> IS_ENABLED expands to a compile time constant, so the compiler eliminates
> the call and no stub is needed.

Huh, that actually links.  I am astonished.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

