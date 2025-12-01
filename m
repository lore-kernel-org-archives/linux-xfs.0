Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3425D26D4C7
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570166; cv=none; b=dH7fZDQKVC5+SSHZ7MH54AkKSZBYqa0IoTUl+XgNNHEWLXOK6kFpag+nXwgQRZNobID9Dezqdt6TBzuBLbHn/dQCOQt4TEc/HKNFZVBeqY5bneJ6UrScXpGrElWlWY2tfh0c0vwgYzZJ+TpJvXPIDR0XLlqupTnw9k4MFY6gK+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570166; c=relaxed/simple;
	bh=4rZpMEza4TabEgTpc5m6+wxJqvyjMrvS4OpIEYGITsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0bX0dHCLHCwd/wEUP5jhd5gF0XOZOBZ8qZ/7TMOlR3oFw6L99KNDbwgnqrcr5rmq90zksMGwJW9GsoZDjdJ4vzoGTakJRYYiORC+D2RS/4DPPLMzE4CY4JceqbHRp65ZWDfAM4ptHTI47z5+6WAT0QCFKDqnvmaMtCWA8Wxb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4099B68AA6; Mon,  1 Dec 2025 07:22:42 +0100 (CET)
Date: Mon, 1 Dec 2025 07:22:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: add a enum for the XR_INO_* values
Message-ID: <20251201062241.GA19310@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <z-56E7SJXYuGLyhwMv_kupA6P2PsSlno3ZFbm0ZBF9Txb-n4NCMjzm45G45l18LisGhRfSQjDFf3YyOKUNVgPw==@protonmail.internalid> <20251128063719.1495736-2-hch@lst.de> <gsry5zrjmrda6m6yj7o2wifqgf5gg4hpbcaej7ehon3aqdbswt@lewg6qgjizhx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsry5zrjmrda6m6yj7o2wifqgf5gg4hpbcaej7ehon3aqdbswt@lewg6qgjizhx>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 28, 2025 at 08:53:16AM +0100, Carlos Maiolino wrote:
> I think those comments are redundant as the enums are mostly
> self-descriptive, but independent of that the patch looks good.

Most seem on their own, but given that this is mixing file type, data vs
rt device, and magic metafiles into a single enum I think it's worth
keeping.

