Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41F917BDA
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2024 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720592323; cv=none; b=QU1vBrKGe2S9LpKro+HzDys/cL1jrFg9HcpRlYBBYJ3b2aHXhsYezCf3PJrKd7u5zvcqQO7bDqCujXpbmXvUj/khFjD0JgSS7LX6fTD63FUPObDpBwXDhWy8Q8NU89QhcFTvHP2D/4pIjvAj0OkLgip9lcWnlfAtgvJqVnhfXjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720592323; c=relaxed/simple;
	bh=FoAjn+utokBGqDMvaMBKcp8bDFy/a3ecH92rKlHRfz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UZp3y89r6DrLekVyxn1x7QiC4GLmc0vkYHCR8ZmgQJ6IQh287S178b3QibEoOYYd4ks8yPbxZScilcYpxrsNlYYZLpv292qnnaSv9PI6woo9H1FdJUHni5zPANMQtyQbjEaw64oXvVDWkhzdr7Bln4GEF7LioJ0LdPvdORrul7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 015BD227A87; Wed, 10 Jul 2024 08:18:38 +0200 (CEST)
Date: Wed, 10 Jul 2024 08:18:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240710061838.GA25875@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709225306.GE612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 09, 2024 at 03:53:06PM -0700, Darrick J. Wong wrote:
> Though I guess we /could/ decide to ship only the
> xfs_scrub_all.{service,timer} files in a totally separate package.  But
> that will make packaging more difficult because now we have to have
> per-package .install files so that debconf knows where to put the files,
> and then we have to split the package scripts too.
> 
> On Fedora it's apparently the other way 'round where one has to turn on
> services manually.

Heh.  I'm still worried about scrub just being automatically run without
the user asking for it.

How about something different:  add a new autoscrub mount option, which
the kernel simply ignores, but which the scrub daemon uses to figure out
if it should scrub a file system?

