Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F3C1F1520;
	Fri, 25 Apr 2025 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745586417; cv=none; b=KFPvP36xZ9fiA6VhIhb1B4zjaMN5yZYhATehCosMDm5y5dVFMuhlB9SrcKKtP1T96y+k6S7yNoMmnN3D/drlpDIJ4da5jKMp9c2r5uiC3QL4Qr1d/CFFR1tKO2HO5B+uHj21P16c6V6IpqDuMe3kCdHZxWzHZG9AO9VAFhmjBgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745586417; c=relaxed/simple;
	bh=ApC3Fz7SS47wVVaDScbIuP3ELIvp8/AquV2Xg350vMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndmwrE3MnhrZ0tgVDGnQjOqeiq1Jy0+yLREpY8tA4sA51Wf9wIxGbDVYNxuVZU1+DqSvCHvw1E6amxiqEzS1lUZzieeUW5LM9wBZgyxWz8gT/+X0sHpao4jWfjSjjlBIswPiSNQybBnlOO3P9b6sZoJvNYEqJCvG/J/48fG3V2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8401168B05; Fri, 25 Apr 2025 15:06:43 +0200 (CEST)
Date: Fri, 25 Apr 2025 15:06:43 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Message-ID: <20250425130643.GA4686@lst.de>
References: <20250425085217.9189-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425085217.9189-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 25, 2025 at 08:52:53AM +0000, Hans Holmberg wrote:
> Allow read-only mounts on rtdevs and logdevs that are marked as
> read-only and make sure those mounts can't be remounted read-write.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

