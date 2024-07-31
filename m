Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8E038DCC
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722447932; cv=none; b=sSRKsOQt/5fF66VS2weHdZyfOh3AYv6tJXZqe8VHyc/fYLQJ8kSdX+CacDaAWYnbcg9KvIOfV62N/pCfYQ90opK3iDYluE5Ev8wcLisio3gOAaZhJP4zOAIIEmzyY/JeK5L82TN271DNBLrFyOPz/ii0MXBsPQhvcc6iQ15o3IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722447932; c=relaxed/simple;
	bh=rj+jvHJPAgBL4vW7U123WqZVke0fl576Ggjy/HZJ/Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMe/J4D/5E9D4S9UGmwIJfd25sDfcN0PFckQGrqG3hPK6C/LXWijq2cknNtRc8mSoC/7ljwfy59Xd2OZ/Wr2/9PNpdJibFoUPIQbEQhDVxPTlYSTRFbs5DpyB0WlZ3JYYvKTwMJhzBbbS2sGaEerk9n5OLhLAReTYesOTDujYXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GpI21bCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpI21bCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F05BC4AF0F;
	Wed, 31 Jul 2024 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722447932;
	bh=rj+jvHJPAgBL4vW7U123WqZVke0fl576Ggjy/HZJ/Ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GpI21bCyW80vPDUh6n6z+y/PSWVXw73w0ef/96HtpOl8mP16i5cOOf74FXIeyWfCv
	 mZo78xcNE3JGojlb7c9nY3fli/uF3p94UMs5/LRffd6IrjBoSNpU2632eUHiqSU+3l
	 2drbSg28b4EXZNKPFqh1IJXJbaJPiZZSpHk/utIDQMdfFR1ml6wNV5VcKZPBGcmOn2
	 p5pgG8F/gy9B8d3rMyQZlVVFtktA7QhkEys/xX/Lymr7GyfGB+GEK66P6AWu6AVXPx
	 BQBWkzsb3V8L0qI7tBxmd04C3awI8GnIpCzAs1tvvoZJSxi8bh+aT6XLSFxiFGcDxX
	 iUNtwG9DRDvFQ==
Date: Wed, 31 Jul 2024 10:45:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libfrog: define a self_healing filesystem property
Message-ID: <20240731174531.GJ6374@frogsfrogsfrogs>
References: <172230940983.1544039.13001736803793260744.stgit@frogsfrogsfrogs>
 <172230941003.1544039.14396399914334113330.stgit@frogsfrogsfrogs>
 <ZqlhopUMJNAyxuSw@infradead.org>
 <20240730235103.GM6352@frogsfrogsfrogs>
 <Zqpbl9cc_nM60I1A@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zqpbl9cc_nM60I1A@infradead.org>

On Wed, Jul 31, 2024 at 08:43:19AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 30, 2024 at 04:51:03PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 30, 2024 at 02:56:50PM -0700, Christoph Hellwig wrote:
> > > self-healing sounds a little imposterous :)
> > 
> > Do you have a better suggestion?
> 
> Heh.  Maybe actually make it to separate ones?
> auto_scrub and auto_repair?

I don't want multiple attributes because that enables sysadmins to give
us mixed messages.  What happens if we encounter this:

auto_scrub=no
auto_repair=yes
auto_optimize=paula

?

Better just to have one attribute and make them pick the one they want.

How about auto_fsck={none,check,optimize,repair} ?

--D
