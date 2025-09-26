Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9109026C3BD
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904037; cv=none; b=TGeBI9i713qTFCfd/nXaJoIkjuvIVCkmGJjvb2eRV3Ud1W3eFAdggN/tF6vn6BevM7LKHc3DK+i8EakBssdaUcKW2GfR/FrSqwmQDIqjuS08liR0m9iwo6GmqQukSSoFIeJ8XKOQsxaWuD+BHebmvgMsNYz+4cV7ruuMZldEIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904037; c=relaxed/simple;
	bh=X2/P6qRoSiDvcmEzPnGkRqJRuVDQMHNMkugOshU3ogo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgCuzu3FCeHjdBbq4qQv/B0R9DyX4IVdP9n9p2o1fr5rYGmy4ZpSyApla2aGA3/RWGG1y8Mv5keFQhMbzOsy4dtUW2zYWSkFWxd3sWFSjVgyzVDJ6DvntT+PpS3DjdOgZ/7I3LL7yurnx2h817B0S8Oy46sTFw+s5FnRDHcU8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAkDlNIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAkDlNIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094F8C4CEF4;
	Fri, 26 Sep 2025 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758904037;
	bh=X2/P6qRoSiDvcmEzPnGkRqJRuVDQMHNMkugOshU3ogo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rAkDlNITxZozxyMACwzSwWXg8oRopJxNGKt1WWZOvQU88HzMjUafnptCNsC9D9yU9
	 xuv2QRib3Z8EOM3jYNNaEHCW6qMpU6+m9BBuEjfk2FTPJLoVQd0J/5bWUpky+L5CSz
	 957TEqhyLmF9i+qJnF84HB+FGo6S0/czZsixMpQExE4wajNevQvOg403QjXfolgw7L
	 ak4dW/Fuy0YudyilFEThpv1qqvi7eejY9+qmJp5vl0VvxJq/01J8IWqTS/EjvYd14A
	 FuMSn+7A9yvcWTzVDIsCOiw/pr77h0lSPl84+venHJOjKwhtBK4DUF9Qihmnqk6drU
	 hNZG8xW2ytIYw==
Date: Fri, 26 Sep 2025 09:27:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250926162716.GA8096@frogsfrogsfrogs>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
 <20250924005353.GW8096@frogsfrogsfrogs>
 <aNTuBDBU4q42J03E@infradead.org>
 <20250925200406.GZ8096@frogsfrogsfrogs>
 <64881075-46f0-ec0a-f747-dbea46fc5caf@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <64881075-46f0-ec0a-f747-dbea46fc5caf@applied-asynchrony.com>

On Thu, Sep 25, 2025 at 10:58:38PM +0200, Holger Hoffstätte wrote:
> On 2025-09-25 22:04, Darrick J. Wong wrote:
> > Has strerror() been designated as thread-safe at a POSIX level, or is
> > this just an implementation quirk of these two C libraries?  strerror
> > definitely wasn't thread-safe on glibc when I wrote this program.
> 
> It still is not:
> https://pubs.opengroup.org/onlinepubs/9799919799/functions/strerror.html
> 
> Pretty safe to say that this particular train has sailed.

Sailed off the end of the pier, yeah. ;)

Andrey: could you pick this one up, please?

--D

> cheers
> Holger
> 
