Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085361EF391;
	Tue, 22 Apr 2025 08:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745309166; cv=none; b=Lq4Gb8tEJGkUV9NtcJ2jMiaAXCWxwzlKiFp9kUu6jgUkPG+9ecc3UEA0CaEKPrm99MzIg8w728YZxZ0ERcwGXwbYE+SkndFx3gPMNmNfD66D4Tw6nK2vEke0k8xid//AgLBGZilcfQoE8QCIQh+yWTHQCN8E/a7ofEzhuLQ1V30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745309166; c=relaxed/simple;
	bh=uSzKucUqknnILhytCX/G092t1KIOajjeDR3YeKyX2rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoExjll6obKoHCRfrLT6qVUZMEmEIAuUQy9irbA6HSm+3kx/0oM1xatdSMGxZ/adupd5YoP318CS7v0ZcgvMBGjaT0zfRlvRANit+phDFgDYOKBttxFjggU+SQ2PmZPKGfP21Pc1oqhKCfaN3SIR9+ObnkwU46wN9DuE4El3rgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8246F68AA6; Tue, 22 Apr 2025 10:05:58 +0200 (CEST)
Date: Tue, 22 Apr 2025 10:05:58 +0200
From: hch <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: hch <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering
 zone GC
Message-ID: <20250422080558.GA305@lst.de>
References: <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net> <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7> <e5ccf0d5-a757-4d1b-84b9-36a5f02e117c@roeck-us.net> <20250421083128.GA20490@lst.de> <c432be87-827e-4ed7-87e9-3b56d4dbcf26@roeck-us.net> <20250422054851.GA29297@lst.de> <c575ab39-f118-4459-aaea-6d3c213819cb@roeck-us.net> <6Vk6jXI2DGWoxaC5fwn8iLCw5Bdelm4TDO1z8FiRamhu_v1yAbbQ-TB6I1p9OQZDcydN5LSY9Kgzb7vhsAaPkg==@protonmail.internalid> <20250422060137.GA29668@lst.de> <vtbzasrb6cx4ysofaeyjus75ptnqrydm24xw7btzeiokqueey3@qamjjgwyubml>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vtbzasrb6cx4ysofaeyjus75ptnqrydm24xw7btzeiokqueey3@qamjjgwyubml>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 22, 2025 at 09:59:52AM +0200, Carlos Maiolino wrote:
> hch, do you want to write a patch for that or should I?

If you have time today please do it.  Otherwise I'll try to get to it
later today.

