Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A762505AA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616836; cv=none; b=QeSW+7QeQt4Lzkk3ffCYYqC+hAKQaGiJscqObvduiKpjHekWyHLt3SzdNJ3OZj4HCs6btFIiXn/e30a7l3Ux/2imW1x2IT9ARrboaXsOYRy8n8LJZpq9AwJZV1aIgkv2Hy1ys2ObhscOWzYXbHbUSMqSDddwcP82ZsOdeQ/TmCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616836; c=relaxed/simple;
	bh=XxVCyJIpNBT6GzM0EAuVFEZp/4BVZjqvkTrinz1NSWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rf36wq8HGemwLgWLBw4lXhR3qZHaq8D+1P45Jh3ztT4cvWAvdE32kxc/wmcoAVWWl0di8G0TqN/Fs3uwbaD1JU4rCHCmz9N1IwsK9EKPBTAjjm2MS18nph5fz1qRCbNml2reOrAU3DiaRCzoPMuZ30N2+tRkdOc1GDEy5QRzLfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7ED6227A88; Wed, 28 Jan 2026 17:13:51 +0100 (CET)
Date: Wed, 28 Jan 2026 17:13:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <20260128161351.GA12914@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-7-hch@lst.de> <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc> <20260128161142.GT5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128161142.GT5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 28, 2026 at 08:11:42AM -0800, Darrick J. Wong wrote:
> Should we explicitly state here that the errortag=XXX will /not/ be
> echoed back via /proc/mounts?

Sure, I'll add that.

> Seeing as we recently had bug reports
> about scripts encoding /proc/mounts into /etc/fstab.

WTF?

