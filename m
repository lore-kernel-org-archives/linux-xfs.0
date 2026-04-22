Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCE236EAAE
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 07:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776842284; cv=none; b=bkfvoalyRp8NJv9dcwchZy2F4MkFpFnv8aZZKYYUkBNb3+p8BOLbY8RQ1mqxvKBgfLwYF7TUMlMzjTbiwv/7ZFcE8SeMqGzIoPoX37vy2lxPsgOGLxfYAdEitItOxHnsncojf6gFUZdHS/JWvBEfjzJ/nRlNAYopKNkn7VJ/yWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776842284; c=relaxed/simple;
	bh=quJcFa0Gd9iIQ3N2DIsZ3BLpERBqiWahjcoqgafZ0ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pr4V4wefLdcgvIV4lA4NcDUpYFb1Xa1YBYnTYe3EGVdbfyG92w1Tu30WANEOU+Sxv9RhmGU8c+l9DvtnLj9Gvp5/u2JVbWEo+OO/Gl/P+9S9CMonggZHi4eKcVltzuBtWNtiG/JeOVipvavo73fDLZYW8PA6Cnb/U35UUJVs96U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJiaGnVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJiaGnVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA190C2BCB3;
	Wed, 22 Apr 2026 07:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776842284;
	bh=quJcFa0Gd9iIQ3N2DIsZ3BLpERBqiWahjcoqgafZ0ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JJiaGnVqpZvKd2AEt2lmhRsG5pJOzhiDrZrCcs6Q/bNr7hLO7oS682kJe45iqBq2+
	 4UAqtEtIJfSGA7hT2XZrGRBYzN8j7lKrTW/v7cr/IIVxbZPRiHwq6yR3IEG+ElTsqx
	 S90TYdzK9sin1ebQrsuy1nzufLEQ5+d+a0Sjmuu+ySwAnrxWFqC9d7PAuSevNlbapa
	 3eUmUrqyr1cQP5AoMMyOIc29KDC62oB8JsSBHsCao48da9JA3w6M4BJYG5w7mAbRb0
	 /UzGa/yTr9WCxMBUL0t+C9XdAlbUH7OMDK/6M3nCb5nEr4MU2zH6mhXzK27APBKuhk
	 LVQ6GHhLrLPUg==
Date: Wed, 22 Apr 2026 09:17:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: add additional zoned sysfs attributes
Message-ID: <aeh1_o_12LSI71TI@nidhogg.toxiclabs.cc>
References: <20260420135011.624587-4-cassel@kernel.org>
 <20260422060228.GB5391@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422060228.GB5391@lst.de>

On Wed, Apr 22, 2026 at 08:02:28AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 20, 2026 at 03:50:12PM +0200, Niklas Cassel wrote:
> > Hello all,
> > 
> > This series adds:
> > /sys/fs/xfs/<dev>/zoned/nr_free_zones
> > and
> > /sys/fs/xfs/<dev>/zoned/zonegc_required
> > 
> > These values are already available in /proc/<pid>/mountstats, however,
> > mountstats will unconditionally print the stats for all mounted zoned XFS
> > filesystems.
> > 
> > Making the same information in /sys/fs/xfs/<dev>/zoned/ makes it easier
> > for monitoring tools software to read the values for a specific filesystem.
> 
> What monitoring tools software are you aiming for?

Zonar perhaps?

> 
> 
