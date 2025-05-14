Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43627AC28;
	Wed, 14 May 2025 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230952; cv=none; b=h1yXLb9x6+Fe+BUOwLMhl9FjA+BsNG+c5bA5sX2FPX7e9mhio3AAIlUrJDL4VmfmoRXaek/kF63ipKe1TruxsybGZm27A0psQwq/lmeGnWVEQWtgR/A0lUn2rJO/43/+e1g3g3zDWvWAVp1UUVRGYRWZ9c6SIDOFGQregQEaauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230952; c=relaxed/simple;
	bh=Rus+q0+IHnEpaPvrltx0pXMmQktuV7jJi0fubp/w/tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wu3IzgVnPmYsDtrRIhW7po4U23cSCbnwp7rLVMGQTB5Yq25ArKteIaQaXZZ7Vj5bc6O2ReMIRrkEyZslegk6ji06S5G3kWNThXrf8cAWqVLk7R5RkF2hHlpfj1Ty4HgwMZf3S7wqHKLPEjNW7M0C71hfPPUfhEt51aWpNWKMTAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D38468AFE; Wed, 14 May 2025 15:55:46 +0200 (CEST)
Date: Wed, 14 May 2025 15:55:46 +0200
From: hch <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add mru cache for inode to zone allocation mapping
Message-ID: <20250514135546.GA25476@lst.de>
References: <20250514104937.15380-1-hans.holmberg@wdc.com> <crz1SUPoyTcs_C4T6KXOlfQz6_QBJf7FI8uzRE_ItAzp5Z89le5VY4LXGEG4TkFkSxntO97kOVPJ8a-8ctZdlg==@protonmail.internalid> <20250514130014.GA20738@lst.de> <sa3yttklz3onf627vxqcjysgyoa455r3z7mgmbzmn3pgs7eawb@43tke54bauuz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sa3yttklz3onf627vxqcjysgyoa455r3z7mgmbzmn3pgs7eawb@43tke54bauuz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 14, 2025 at 03:51:54PM +0200, Carlos Maiolino wrote:
> Absolutely. Could you RwB patch 1? I just got your RwB on patch 2.

I wrote it, so I can't review it.  But Hans has reviewed it as part
of passing it own, but that's designated by a signoff.

I'd be happy to wait for another review, though.
