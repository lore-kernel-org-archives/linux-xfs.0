Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CD6FC0A;
	Mon, 24 Nov 2025 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764005656; cv=none; b=IxdHNS0olr6SpDlIfb0GyEbgPwpZFpJdh15+lsaOXtsdC/pVvEZosGWtS5EE1NWkoNG9RqcJoNsw4MRdIIu/GeIK368nulm8hsYk4xIJv7p4tUoATnU+rJOWBse5XWvgmOoCvoY283YOwxPEB3Mf6Ax4/Lr9Ml54y29MSBNTw4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764005656; c=relaxed/simple;
	bh=EdJndIpDhu1AsIgDT/t21XDtlgAyGGmzW56RQEbN/SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dbdV0ddAIgJHxbRrYKOaIGKsIiO2Wh7yKObyfL/eBM4OV+xNiUq5WVvxyaq3Y7q3ESEWoUO8AeqQlP0lfHyCDAjFKIMvK4JGfeiTKFyuZILswSxVS2+2p15IbSfRRTmoSRXZQrol0N2+0+f9+jfR39ZUBHLn8vgBjUpUA1m1bwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46C0768B05; Mon, 24 Nov 2025 18:34:09 +0100 (CET)
Date: Mon, 24 Nov 2025 18:34:08 +0100
From: hch <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, "zlang@kernel.org" <zlang@kernel.org>,
	hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <20251124173408.GA30299@lst.de>
References: <20251120160901.63810-1-cem@kernel.org> <20251120160901.63810-3-cem@kernel.org> <EffPQB_WQabsgl7V1GQULuAp9QQGB7KoH0wN5tHOvQUWRriHZorc1NPnsGnKEV1obcisN1kjuXM0KzubUhxk5Q==@protonmail.internalid> <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com> <ba3tbnjq2dernii2n6leyc6z76lcezsjemomtm54mrbm2xcnz5@kx3qp3qgrtqe> <becfce20-3948-40db-bdb5-7dc64438da26@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <becfce20-3948-40db-bdb5-7dc64438da26@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 05:31:03PM +0000, Johannes Thumshirn wrote:
> > I do think a mount/unmount might add some value to the test, but I fail
> > to see why issuing a random amount of I/O would prove the correctness of
> > mkfs properly dealing with small capacities.
> 
> 
> fstests does a fsck after each test, doesn't it? So that should be 
> sufficient as well.

But only for well defined devices, not those made up from thin
air.  So we'd need to do that manually here.
