Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B9225F99F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609425; cv=none; b=c5kdED2wtEx1jJyOa5pZTsjTtGC/xFVTCeQMSoRcBRXg8kTya828P593jquuW8rEXh1a2Hv8QumNlcSmHKlyM01v41cRA1HG+8e2tL8sndbzflwt/wpyudHF002pWmCbArL1Lrnq5owXvUIjR4uhUKMIwekmTKvelqLMVnvxLSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609425; c=relaxed/simple;
	bh=LyJoKJL4Ttl0gCwh3zRKYKICz11BBosjSpvNKYf+efQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAxzl0k2q/dGDFlTbmVwC+meLVkmOPWlTyzeNVg0SGUf4LDDtWBnVGdPvxSJNX+xFNTwJwwI2GKdfpe1tWVefNzV4wMvscopDksIwjZUhFFu4GtNNytB89i6smdTxJqJfUVT0uW1lLhrX21hAM4aKqD02Tf+vq645crKdt2XBsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9885C227AAC; Wed, 28 Jan 2026 15:10:16 +0100 (CET)
Date: Wed, 28 Jan 2026 15:10:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <20260128141016.GA2054@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-5-hch@lst.de> <20260128013525.GD5945@frogsfrogsfrogs> <aXnv3tWiFlHwOheE@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXnv3tWiFlHwOheE@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 28, 2026 at 12:18:38PM +0100, Carlos Maiolino wrote:
> I'm curious though if is there any reason why those are ratelimited?
> It's not like users would be running with error injection enabled or,
> they would be flooding the message ring buffer with it.

Good question.  I'd rather not open that can of worms in this series,
though.

