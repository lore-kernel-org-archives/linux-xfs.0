Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCAD18FC86
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737530574; cv=none; b=Z+hM6QClXkOQDYRXXAsVcucCBFmukpf3tKT6kfTImlJaV6Qz8J9EtwcMeGFtdq3ivEXcxCIikGCWs1afJ8i+2pbymltiHnAuSELPfzg3ItOhb8uuxeRL239Vf9JWu3rk0C9nZ8QZm/o0tfgAVOrrkvFTM3CPCd0W2g5BMkQDPOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737530574; c=relaxed/simple;
	bh=WP2iUn6xgur69CN+YNq0de3AJAwZ8h2jClNwAWV63vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCtgpPHS/A8HFLAW/nMXucyoG/yNQfzvUBi56sdMoEQOgqJU/P1dyniJ3GCBlu7wWFzvhxXyrTWvLHMoYDNkRlx3yHQ/NKZI0gmx83Ef4Vaji+OzHFO/UFQsQsgOw2wDrc4DkYQIEcZPxLgqu4AzBDNzcBi9L0KHkvvRy91o4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2C7E68BEB; Wed, 22 Jan 2025 08:22:47 +0100 (CET)
Date: Wed, 22 Jan 2025 08:22:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250122072247.GA32211@lst.de>
References: <20250122020025.GL1611770@frogsfrogsfrogs> <20250122060230.GA30481@lst.de> <20250122071829.GW3557553@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122071829.GW3557553@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 21, 2025 at 11:18:29PM -0800, Darrick J. Wong wrote:
> Eh, it's mostly to shut up systems where even /var/lib is readonly.

What are those systems?  They must still provide some place writable
for semi-persistant data, so we should look for that?

> IIRC systemd's volatile mode isn't quite that silly, but it'd be nice
> to avoid xfs_scrub_all repeatedly failing every time the timer fires.
> 
> OTOH maybe a better solution is just to run scrub in media scan mode if
> the media scan stamp file can't be opened for writing?

Or not run it at all?  Either way I'd like to understand what causes
this.

