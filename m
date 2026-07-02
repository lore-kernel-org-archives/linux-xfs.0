Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B8342A79E;
	Thu,  2 Jul 2026 08:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782981328; cv=none; b=VStAWjeNtOl9GbpowFnYtEEqD/kE3aOYCzPBX+3Qn6HuWj67VImOYYGBPfFW8C3+sgatjkHKfTN+S0dYcDZWG+ZM1VlnvwayVlfYyUphgnQvoSvp9QGm4W4yAwe2idaVG7nNEQNH65n9X8t1B+GFMesRpY+KYwndGBLJc4eO5fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782981328; c=relaxed/simple;
	bh=X7nU3NZX4ivwuLmMSpZqzofriI7H/VdQXKMC6yDd0T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4Ye0lWIo/kVDLLiz2gT+nrZHocD7Eo2QqHlUS6wYY5zlxfL+Tzk7rC45cpH2RyVncUze1F6BYjuwi/PwvAEMkL03KxUW6fXvBiEsELRE3b35VuEYBdYC0OJw99vHjX8NHE+HrnfcFnIVOL6l+rzPvHJ3FB6DGnHmteQnEFHqa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6+PQIzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6+PQIzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8FB1F000E9;
	Thu,  2 Jul 2026 08:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782981326;
	bh=bqzhFRT/zOTIwoSXs7aB52BOZoV6Pnb3N/ORBIiNstU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f6+PQIzbiWf7Zs5REZH0ofgl9h1rYO6Y9PZorndM9BztSyH6ibK/efja2hEtXiQ+/
	 ELpwdFp4WLFoaMi7Sye+Qv3u8cxGfYmrfSFbpEaKPLQU1wuYtAHsQfVUToFcl3N0Uy
	 9t8iQLCEizRV/KkXFVwqDUorcZyP2eZLREOzXNJEi5z6/uKfxUXvHyaya2kfIIgj89
	 7UA+v6qKt/MfptKfypens38b4XUvyWzB6FroR0EEHEYpLeAk3+cKRMF0cAMo5R2t/u
	 3O6UmNXeeC0xmH9t4EPTQEchL9TIxrRI6Ay/gqwfIr/mcNpAwJqZlGZvgjIK5RZLMU
	 A8ZpPeUnQKTMQ==
Date: Thu, 2 Jul 2026 10:35:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, 
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Introduce capable_noaudit
Message-ID: <akYimPrAcHlv7shR@nidhogg.toxiclabs.cc>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260702-alufelgen-belag-tastatur-b666a49f7fc0@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-alufelgen-belag-tastatur-b666a49f7fc0@brauner>

On Thu, Jul 02, 2026 at 09:41:39AM +0200, Christian Brauner wrote:
> On 2026-06-26 13:45 +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > In some cases - filesystems quota specifically here - we'd like to check
> > for effective capabilities without issuing spurious audit messages and
> > without the need to specify a namespace for that.
> > 
> > This series introduce capable_noaudit() which has the same goal as
> > capable() but without firing audit messages.
> > 
> > Also, this updates both generic quota and xfs quota code to use that.
> > 
> > The last patch unexports has_capability_noaudit() which was originally
> > exported to be used in xfs but turns out it does not meet our needs.
> > 
> > Note this is based on top of a current series I have to remove
> > has_capability_noaudit() calls from xfs so the xfs patch won't
> > apply cleanly without that series.
> > 
> > If adding this helper is acceptable, I'll turn this into a non-rfc
> > series with the required changes to apply properly.
> > 
> > Comments? Flames?
> 
> Convert more, please.
> 

Convert what? :) more callers from capable() to capable_noaudit()?
