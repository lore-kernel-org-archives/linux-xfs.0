Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71023890E8
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773651724; cv=none; b=WlAcB1EJo4mDw/yJ64unucoe+yD3qidFbS/PVeymqJgXto9/83cv12bDkg5orcnNUNj108ltEX/n4v7JUF7nAj9AmuAoT36HUD5elKINfMkvgRfx3McuwfeGGBQntpIwdIR+ISkwNwkktNBiPaBDzwqoGimMSxXGGMJ3/vZRYV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773651724; c=relaxed/simple;
	bh=84nNILx1hXaMnMuGydWwb2r2Wh8eswuutX6x1P/kbOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrLjJBSYVLqz3qvyv23SPQ71KLEu7zdwO+iKQ4y+DqEJnPRfg+a5ZZEytmpCf2iyPunrly+Z4qcF2s+BT1WNYorGnGi9gPRzN1kVh7pjMQpkBirRRO5WQqNt3X2NpGUIOSBLBQcVMIolt3eR71v/xGTsUcEgbLXm4nz6gfZnwkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5AFC268BEB; Mon, 16 Mar 2026 10:01:52 +0100 (CET)
Date: Mon, 16 Mar 2026 10:01:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH 1/3] xfs: improve xfs_select_zone_nowait()
Message-ID: <20260316090151.GA1952@lst.de>
References: <20260314235508.183984-1-dlemoal@kernel.org> <20260314235508.183984-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314235508.183984-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Mar 15, 2026 at 08:55:06AM +0900, Damien Le Moal wrote:
> Move the check for the return value of the call to
> xfs_select_open_zone_mru() inside the if that controls the call to this
> function, so that we do not uselessly test again the value of oz when
> pack_tight is false.
> 
> While at it, also fix a comment typo.
> 
> No functional changes.

'improve' is a bit of an odd descriptions as it's wage and subjective.

Maybe try to describe what you're doing a bit better, and to do so
split the patch into the separate parts (even if the one liner
spelling fix is a bit silly otherwise).

The actual functional changes looks good, though.

