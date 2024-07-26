Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BCC1B970;
	Fri, 26 Jul 2024 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013912; cv=none; b=DY8XtoF07eVThwg1Vv/AFy/2knn4keA8oClGGRavJzCdkbloidne4zhh2z2Z0N2IFyzZFYCnbjB5cTk/V928ZR8JVp2YOdejcyyatsJyPFZQwuNM8w6aUlTI5eNTxkUzzKgPIT0ADotYGM5UtzkIO9pMPDGka8b9yWvWRE3hKak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013912; c=relaxed/simple;
	bh=Z7mCE8fL4jS0Cy1f3ka4sx3B1FzkY0+YEcTzyf4S6ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3sXzRkpiAAL/swA3rd40+yesEH5dDJkLGxf6BDkjGicFd2gw814SMIqb+klYRdA55RIkR00tQrOJKRt/A9bsLzyle9+48LdYmsp8SfUgtlygUdbLswGv4rBp3Rm6tFI6I54HHmEIfDtE8oRR231LQbRQYK2XSkPA5rekbXHDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4EF5D68AFE; Fri, 26 Jul 2024 19:11:45 +0200 (CEST)
Date: Fri, 26 Jul 2024 19:11:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240726171145.GA27555@lst.de>
References: <20240723000042.240981-1-hch@lst.de> <20240723035016.GB3222663@mit.edu> <20240723133904.GA20005@lst.de> <20240723141724.GB2333818@mit.edu> <20240726162014.GQ103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726162014.GQ103020@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 26, 2024 at 09:20:14AM -0700, Darrick J. Wong wrote:
> The big question I have is: for at least the standard -g all runs, does
> this decrease the number of tests selected?

For a -g auto / -g quick run without any extra options it does not
change test coverage at all.  It only kicks in if you add "problematic"
mkfs options.

