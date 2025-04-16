Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECD4224B05
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744782917; cv=none; b=scEgUyz/lT9ykttiz8Ocykn63vLpLssyES72ej4ZBnlWQCX+Txb6IiwzniH71lRFtSf1d1Q7VUHghHEGWGZWWuLgW66Y8nEjDhxLFPhx0DV78ACDI8ODmh4jWjJR0KbZ5eicCgvrbpAn/N8qIfc9snxFz4LyW829JWKXUtVwonM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744782917; c=relaxed/simple;
	bh=tM+liSZrS/hX+wvVbg2+t5Wvw4EnbItBTmDm/BnhxoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkFuNeIpr3MmXzelWGJNgrxteuG1wf4sSiGJgOr0EVkOzdjBlDhJjS2g7ckwaKiUOciTO0f+zWIvdWgZYrBS3niwG3QCdnvq89uXXbw2ac0sw+4M4C5CIWnCaSrh/3EkCwJSzfmE/HSnatAwQuAfx/LD9bntq4pfdCOFg6Yos0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFA+InG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFA+InG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06632C4CEE2;
	Wed, 16 Apr 2025 05:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744782917;
	bh=tM+liSZrS/hX+wvVbg2+t5Wvw4EnbItBTmDm/BnhxoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HFA+InG5WMGB3xMVIuxrpjTSzmZb6IZICq+swM0d3M6yEzwlJ90gTSDkIbxG/Ltla
	 A6ImfwtV6ot/yybhYWtbFHMYVjHXTxEL40dIp6Fff+kCiay32PRmVVwf0Rkw0Vlvlk
	 9Y1W4ZVeesUTRBY2tiv/41Wyy4LpCKI4I9eMdHwOOzM9zejMWyGInexsOkg+zY1j0R
	 ZUQoduQIv1pnvoBIlhyLUkiwykySpSYOyUBcX5MiaqU9keRIzqrfWhick3PO92uPsU
	 IwTsRA5wWgk20lU6CDzniSuui6rj7e6gPv3aN4qhhUhSxmMYrBUiNGB/t9xuKv808J
	 w71oSP6Ei6B3A==
Date: Tue, 15 Apr 2025 22:55:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Luca DiMaio <luca.dimaio@chainguard.dev>, linux-xfs@vger.kernel.org,
	Scott Moser <smoser@chainguard.dev>,
	Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Subject: Re: Reproducible XFS Filesystems Builds for VMs
Message-ID: <20250416055516.GE25675@frogsfrogsfrogs>
References: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
 <Z_yffXTi0iU6S_st@infradead.org>
 <CAKBQhKWr_pxBT+jXpaitY3gz6wd1WLqyU4JwQoaRhzKWye8UgQ@mail.gmail.com>
 <Z_9Bas9rRB4cMibh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_9Bas9rRB4cMibh@infradead.org>

On Tue, Apr 15, 2025 at 10:34:34PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 14, 2025 at 06:53:35PM +0200, Luca DiMaio wrote:
> > This is a huge step ahead, but we still are facing some missing features/bugs:
> > 
> > - we lose the extended attributes of the files
> > - we lose the original timestamps of files and directories
> > 
> > I see that the prototype specification does not include anything about
> > those, are there plans to
> > support xattrs and timestamps?
> 
> I don't think anyone has concrete plans to write this.  But patches
> would be happily accepted.

xattrs mostly work as of mkfs.xfs in 6.13.  If you have more than 64k
worth of attr names (aka enough to break listxattr) then there will be
problems.

--D
