Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21A7153812
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714080153; cv=none; b=FXVkAdDumpI2bywKd9zUFCHlnZp0i3Ykj6Ck7fcalIr8i7wEhSOP7rOg1vpq/1IkV/MIkfHQLWozxe8j9I/Fhmk79VRgcPCM5Mxf5abvp/ZXOdy7xqLBcjHudPJICInHEtXkffJ6/anP1PuUc538dMLmGTdn74Vr7ffwsBokKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714080153; c=relaxed/simple;
	bh=BVPZb2vEapiUSKzx4LA51Ey9U7CS9GzpQ/kHPP9heEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdlTlVI6P05sESR0LebYy+pPpufpR7bJhkSODE3NI9n4inpufZOihqfV4AdmYrIC85z7xxcgdwAvPzukXkzYOXOt3vfPDbkx4iFqr5r/J2fl9mxVtNGBbeOSvCecH7k3WvLaiNNVxHp+RTe7G+aIaWU28vW36XcON25wybqHp5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cifu1ra8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cifu1ra8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27753C113CC;
	Thu, 25 Apr 2024 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714080153;
	bh=BVPZb2vEapiUSKzx4LA51Ey9U7CS9GzpQ/kHPP9heEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cifu1ra8+6cjYgQuEU+D0YWFkGmvmYSgZjEd1EhnsBJAPGeGUHx1n1X9mE5Og1XSw
	 7GYvJvWssdXC6dtQcucp5LEt4iVnbIHNnkMtYLbocx+DRsrYGCW3uRJxjmHKYYz+iq
	 AJ79speY7MA619VgQPLQUBIEXeAdwwrsKGhrZYeUfiFJHJY7Rus56/qtS+DQ6NF4pA
	 qsAUvq/uR+0syyuSr0Y+3hWZ1fPf6frq2P23RG5IZ2M8uQCiaREQdCZPpFxw6k6dQW
	 YJP5UKgaoFXSwrEFgedHGXCP1vY90hD/SwW08SBzXnSoiqBa0uQpIgQ+tBwLvI/zdy
	 fdCxxwky716aQ==
Date: Thu, 25 Apr 2024 14:22:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: add higher level directory operations helpers
Message-ID: <20240425212232.GB360919@frogsfrogsfrogs>
References: <20240425131703.928936-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425131703.928936-1-hch@lst.de>

On Thu, Apr 25, 2024 at 03:16:58PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> with the scrub and online repair code we now duplicate the switching
> between the directory format for directory operations in at least two
> places for each operation, with the metadir code adding even more for
> some of these operations.
> 
> This series adds _args helpers to consolidate this code, and then
> refactors the checking for the directory format into a single well-defined
> helper.
> 
> It is based on the online repair patchbombs that Darrick submitted
> yesterday.

These all look like straightforward conversions to me, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Diffstat:
>  libxfs/xfs_dir2.c     |  274 +++++++++++++++++++++++---------------------------
>  libxfs/xfs_dir2.h     |   17 ++-
>  libxfs/xfs_exchmaps.c |    9 -
>  scrub/dir.c           |    3 
>  scrub/dir_repair.c    |   58 ----------
>  scrub/readdir.c       |   59 +---------
>  xfs_dir2_readdir.c    |   19 +--
>  7 files changed, 168 insertions(+), 271 deletions(-)
> 
