Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9C8339847
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386292; cv=none; b=oHwTl0TZHAxO++0jiHqNVXXIr4xcBNnjJtNvm0eIK3cbQMSF95ar6rlQS+7hDksiOQrQT/lQUeO1KByPytEVkiraFoubP1f4iQfMCIlWEQKTNf/7XzaWzEVy2fmnidrMYb9BCSdYZRywPFAYScU7ee+u98yctyy6ZupDIAqI2Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386292; c=relaxed/simple;
	bh=x3vf+L/2F/jKO10BkDAdBbrFDDz5US362G5os5FUR10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qY3pF6XjKGFW6FWYENiIV/xVVD2c6nu8K2/FKPNnKCrKHOGNuT3EPY1ypNa61nuYvpFRKMj96X6GDYsPQXL+9HkWi/8CheTrNNEQiPqF8NM2+yL/F0AHeslVB7wyw90QHqT4My0LXpC+nYrn8hLcRZ2UN+tT+caEC2PSHyKqWx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoWdyuZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoWdyuZa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5A291F000FF;
	Wed,  7 Oct 2026 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791386288;
	bh=T2V8g9mhelX4x/kUo1RJamBE+LlB/iG+8tHwcaQJp4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VoWdyuZapLsSRGxwjk0sokwd+lStwriGMHeSxXhKRwg7ZSKWfh1VgjnYlnoY6QwmF
	 s4/NBg3zL6QBzul3dCHDuEsJwwv5hx4YU38/Tqigcfw0Sd/44aYgvXjCO8NK6x/7rE
	 rOBCxL6bG+sjhcFofKKnPXUKJRAtc1hE9tsFxTK1bqxnKIRwYPLbLiQk+PRrfwl2kn
	 iQTMbiRRK2zHuJR3JRxW4ghEVOm36qomlEXW0y+p7uRe5xSRkv+3VOETn5Fmo8bO30
	 oOVOo0V3hipyZWDPyPBBxgiOm1Db7dw5NbzjRYF43RNnajbNcD/ownsgf+o4sVDbCg
	 QQNgEBft1Jriw==
Date: Wed, 7 Oct 2026 08:18:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Message-ID: <20261007151808.GB2705364@frogsfrogsfrogs>
References: <20261005125637.1340355-1-hch@lst.de>
 <20261005125637.1340355-13-hch@lst.de>
 <20261005214939.GR2705364@frogsfrogsfrogs>
 <20261007134105.GA507@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007134105.GA507@lst.de>

On Wed, Oct 07, 2026 at 03:41:05PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 05, 2026 at 02:49:39PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 05, 2026 at 02:56:22PM +0200, Christoph Hellwig wrote:
> > > Replace the the existing xfs_trans.h with a copy of the kernel versions.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Much nicer to have the same header, though I wonder if we ought some day
> > to move the kernel xfs_trans.h into libxfs/ ?
> 
> That's what the:
> 
>     small cleanups to help code sharing with xfsprogs
> 
> kernel series sent on Sep 25th does.  It got your reviews, so maybe it's
> time to just merge it.

Yeah, I can't keep all your patches and all my patches in my context
window. ;(

--D
