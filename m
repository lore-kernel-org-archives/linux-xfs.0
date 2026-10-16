Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CC95476D1;
	Fri, 16 Oct 2026 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167816; cv=none; b=aJybUt/qo3S7KpxPwHKi/J7hZv4LZ2nDJDiNL6VLqAeJvci/oUupMpouI9ZuZar2hM03Y0SBN3kefiNzaC0khPmfNAB5jrNKSUuA2lXpMKr8dN8wQSH2IpzXoecL8Rl6qT8im4/lk4PPNsfdBqajS7VxIrcWexryXVNT1Sryy6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167816; c=relaxed/simple;
	bh=E9SRiSCM5yvhN1VP+wX+5EYFn3iDrwTrFprS3qu6ZZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WsRD3B1bcE8GgJ818UeQrWk9k+Gln6qZV16bCQYTGc1MnL8iqG7KcFM5qekfHTY1J2OHIEiY+YbdrE13qsUuzDlHYfSdtuNQZVPLPbLIrrHg+pvlSV08SiDHnHdQ4Egeyoh4X5jHgVvgxSGXyOIZg2aUORYSeYENZCiQuYX+PDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxOlIOYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxOlIOYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02811F000C4;
	Fri, 16 Oct 2026 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167814;
	bh=i4/9iMqN/LtDPDrWWJiced64myxgoKMh3yjV3ekiXsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bxOlIOYQ1QaSQRJK6xcCgnGaxv40MKTV5pCSwlpFIFE9jV1+XqQ+GkUjI/RISXBSn
	 UCB+qpzG0AQxwpsZJG7RDpbnykduyXhnvsGnUlLUga/q44GfVTerH7g4YH9pnw3tbz
	 pCQe8JTRUmbtqqHVcUvDrQ4jCB3TjAvjahf3SxUgQk/h0EQzH1L7A7ZlLdiIygxljR
	 YeVWTr8PfujENgcgcXc7GNvxKTjMN2EPaSrUACotiWsApBM5I31ieFg5ltpvEfrml7
	 i8IimwvfmuafalADmp7IVZun7Iol49oVCwL9lV4okfHP8uhKFgpmhSAbh4XczoFN4+
	 L8siCdp3NC9TQ==
Date: Fri, 16 Oct 2026 17:23:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <atJOVQbVNH6MHcom@gremlin>
References: <20261016160037.GA107919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>

On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.

Oh man.

I totally understand you needing a break, and I hope you have a restful time
away from the noise and fury of the mailing list :)

Though we didn’t do much together on-list, I always enjoyed your
contributions, and really enjoyed working with you while we were both at
Oracle.

I'm sad to see you go, but I want what’s best for you.

>
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.

I hope it'll be kept for you to come back to if you feel like it :)

>
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!

You also, thank you so much for all your contributions and best of luck with
whatever comes next!

>
> --Darrick
>

--
Cheers, Lorenzo
