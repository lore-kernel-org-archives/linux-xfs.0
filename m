Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B191A0730
	for <linux-xfs@vger.kernel.org>; Fri, 28 Mar 2025 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743198079; cv=none; b=XnFLOGhHR1/7Rhtb+ywG+aN/x3qhth8TT9UpcXeWl+KK814UQpi0vvibUuBsu7bdwL85lRYJL/sA119bIHk24MLujugKcx6CYAs+NxslikYeB8/UwH7rCOg0HETv3yFlq4qFArWDm34uJzrd/4M+1+snxq43DnqCbLCbrPqkeW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743198079; c=relaxed/simple;
	bh=+kmbCT/hyKx5K9c9Q16rCdruk6AdMau+RuYuJ2WeReI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+3MkMnBq6FtdROUHXvbsg+LofZ3J2reokjfvgJkZ4CLebwl2d6GL+vSBbVD0yMjw2vBUprYMCvsJCMDXJ2gbdGnzzPamMR58W4UPqYQfH3Iw7IQ3a8nIcqyEjwOxsNEJrtB3h9SQEh7gyTloS/xo67pOrx5G2hsBk6hB2dunmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMSHov2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMSHov2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700F4C4CEE4;
	Fri, 28 Mar 2025 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743198078;
	bh=+kmbCT/hyKx5K9c9Q16rCdruk6AdMau+RuYuJ2WeReI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMSHov2tfWR0qURcWIAv3+wE75lMBB1C5uYdjwvZ/VZ6N8MX2dXs5ecFrM4ne3rfc
	 RsJypx0XO8Bo6XnFzi7b9NHW1Vjp4uys+jktA0jZu+TJwkwgDNhMnbwhbvcCwBgVlL
	 gxiBHQW3xucZ+9ri9OdL5VFckHkTSg1FEI5ZBM+T5NZGAq1vLx0V//Hv46C7u395OK
	 UiGn2WtvavkPZoNb5JN7lFhglu8y2eUC5UOSVTxVHZBonUJwzjqVOq0uG5e16/Dzpj
	 PvIKCNosazt2a51J4ugb2hzzZ4+dWur9GHARsu3OzBCz5b/IC/fu1xmDWXuUgLKp+s
	 zMN+lOyYdOZkw==
Date: Fri, 28 Mar 2025 14:41:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Andrey Albershteyn <aalbersh@redhat.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on
 "make clean"
Message-ID: <20250328214117.GF130059@frogsfrogsfrogs>
References: <Ma-ZKGYU7hIk8eKMYW8jlYh_Z0idBm-GTBibhJ9T1AQdH_B6PFLlAEEOXoTUJ85eBFU_fC2m0pdM3xOdcrf4mg==@protonmail.internalid>
 <20250219160500.2129135-1-tytso@mit.edu>
 <rqpluafkqedqjl3acljv3nugq3gjxpldmglon72a3j3up6cvn3@inq2q6xj5rtb>
 <20250328213910.GA1235671@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328213910.GA1235671@mit.edu>

On Fri, Mar 28, 2025 at 05:39:10PM -0400, Theodore Ts'o wrote:
> On Thu, Feb 20, 2025 at 09:12:46AM +0100, Carlos Maiolino wrote:
> > On Wed, Feb 19, 2025 at 11:05:00AM -0500, Theodore Ts'o wrote:
> > > Commit 6e1d3517d108 ("libxfs: test compiling public headers with a C++
> > > compiler") will create the .extradep file.  This can cause future
> > > builds to fail if the header files in $(DESTDIR) no longer exist.
> > > 
> > > Fix this by removing .extradep (along with files like .ltdep) on a
> > > "make clean".
> > > 
> > > Fixes: 6e1d3517d108 ("libxfs: test compiling public headers with a C++ compiler")
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > 
> > Looks good.
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Looks like this hasn't yet landed in the xfsprogs repo?  Is there
> anything that I need to do?

Poke the maintainer [now added to the To: line], I guess. :)

--D

> Thanks,
> 
> 					- Ted
