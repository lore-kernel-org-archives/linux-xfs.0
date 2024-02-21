Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B237133F7;
	Wed, 21 Feb 2024 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708533238; cv=none; b=qcrTm1r5s+Psjh+sXu0cKFbHRn2rNf3UCaB/A19WwVaLWTmQQhMWJ3H63/BnF4YDiF8Mj5557+4P5Y9oyksUiSnSXmtQxyA0xXbjNtXEsikBjuZqWbWf4KZ4rieUjulVzCaEcfAI3oi8SbWfcrEU0bQPQ4D+5aAXPxaH2ZU9784=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708533238; c=relaxed/simple;
	bh=K8TkU8VEGRGPpgxmWotAHrzxJL9B4kDIQylUeado+as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VoLLJ3S0kRclB/Mod6Wo6z9oSRWHUReQt5PMIRl1CcLur4cdl4uw72pJKLnjkqG5/EmwmTqx2e8CRKxX2BVR0wDJm6gtmDaHMmyP+KLDQ49aKDhF+OyVlQwTBiWiQyPoqKvMjsjSzb59ik9N6bxIBeYCuBDK1+kauMO0Sjw2jYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E3EA68B05; Wed, 21 Feb 2024 17:25:15 +0100 (CET)
Date: Wed, 21 Feb 2024 17:25:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/449: don't run with RT devices
Message-ID: <20240221162515.GA25439@lst.de>
References: <20240221063524.3562890-1-hch@lst.de> <20240221155338.GF616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221155338.GF616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 21, 2024 at 07:53:38AM -0800, Darrick J. Wong wrote:
> Odd... this test only takes ~50s on my rt testing rig.
> 
> _scratch_mkfs_sized should restrict the size of both the data device and
> the rt volume to 256M, right?  Looking at tot, it sets "-d size=$fssize"
> and "-r size=$fssize", so I don't think I understand what's going on
> here.

You are right.  I have some local patches that messed things up and
increased the data device size based on paramters of the RT device
in _scratch_mkfs_sized.  I've fixed this up now.

