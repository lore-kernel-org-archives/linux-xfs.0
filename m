Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6510013BC3F;
	Thu, 13 Mar 2025 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741851213; cv=none; b=N0XuBHS4niO7M3Km/SRPrcSOwbJZj73VeyqxP2GqWdcGrfvOiAOgQLH9DEaMiroRllhcMoyFMXt9LdWJ44381chzm85afRGv6TD14yE5EdPmKFn2ctbI3xzH0otL5WvAq1kMLXRn/uS4+/JX7PGhxvvaaOC0WIqqYceT5EEHiYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741851213; c=relaxed/simple;
	bh=ypKfXL6msz26AoRQe8N2igitvM+UxB1C2GnmI7/IiCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeqnTChaVp3jxP8NjOfpQlAbWyGdcWD26AI3Fsrt5cZp+lAbfk/Uy8q4hzYDVcpCtTfATMBrAhN3IfmgFhAUfwFPUkQa6nM4tjgf7pofluEhzqBjuPLpqfvQc/pH7Qolc8hTrnKjWeNNybRA1A/D1pV7b1yzZau7620D6Ka/2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A263D68C4E; Thu, 13 Mar 2025 08:33:28 +0100 (CET)
Date: Thu, 13 Mar 2025 08:33:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs: skip various tests when using the zoned
 allocator
Message-ID: <20250313073328.GI11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-17-hch@lst.de> <20250312203008.GQ2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312203008.GQ2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:30:08PM -0700, Darrick J. Wong wrote:
> > +
> > +# This test tries to grow the data device, which doesn't work for internal
> > +# zoned RT devices
> > +if [ -z "$SCRATCH_RTDEV" ]; then
> > +	_require_xfs_scratch_non_zoned
> > +fi
> 
> Does growfs work for external zoned rt devices?

It works, but the amount grown needs to be aligned to the zone
size.  So this test won't work either and the above comment needs to
be correct.  A test based on this one that tests zoned grows will
follow in the next series.

