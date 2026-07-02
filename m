Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33C741D777;
	Thu,  2 Jul 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783003867; cv=none; b=SxHxmFieK5ftmiYBMvjRp3e50ISeXqureQopMnFN/brZcFu+WRMMpBwUXzFVnsrvtUt0ZjzXHzxJgqE7zpnXjZfMsuRYo7z968h0yxWpvXxMfJ3gLSkOeZ04LydvrKAV6PVwtuhfIxhAiFmN8r1eXA1MxdP+Ha7jAYxk47YD/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783003867; c=relaxed/simple;
	bh=+teDQnmp9brRFj1zs6hXifmWQhD2Sv4TNJX11xkWD5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gfqdnj7Ee//npuYtV9mX+XQfmgz2E6YAeDDftCpB0OEKv3+pqQLYSVUuABhNt5q5wsVOvWfrIC7YTI6pw2Jp1HyXG07IQztYbV/zzrCMu4RUCj3bGSBL8YlPgeHXLLLk90csdqY+BKr+SW9ERODCKIyBWRqHMjYCBtpGSHjq044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpywpTRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpywpTRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4605A1F000E9;
	Thu,  2 Jul 2026 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783003866;
	bh=vM9+qGckBI3ZB5sIe3KU97TZcXYa6afqIkCQ42YlBEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PpywpTRs6/CjsHQw+HKGTbGzxH2NSJFWzeg86ZIZEVaAxdk5fH1qdBL2YGffGmlai
	 PrX+VZgWANirK1szWt+Sg2252aGbYE1ITMRCg7yY9qS/FWOq35PZPsHePdVKfvqX/r
	 QsI8uv619toLrQnZGP0A+IV+dANilKOIa+yCpahetPXiusF5RNIq2SZin8QUFhWO5n
	 m6ncWyG7+Y8bn8QGkz06LWvrQ/JHlbQnGJUOG0vhXGYNSRxamu5rCcjUnXKMOfb1lx
	 k9zPUJZ9urfR4+seyBwcaGeRAMsaPhrYWSAjE3NZTDaXueTjG63O2HQTUdHoa+aXbG
	 5sqR/SO2OUlBQ==
Date: Thu, 2 Jul 2026 16:51:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, 
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Introduce capable_noaudit
Message-ID: <akZ6yxZ0p54l9Dwg@nidhogg.toxiclabs.cc>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260702-alufelgen-belag-tastatur-b666a49f7fc0@brauner>
 <akYimPrAcHlv7shR@nidhogg.toxiclabs.cc>
 <20260702-fortsetzen-verarbeiten-abfertigung-ead54cb2e597@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-fortsetzen-verarbeiten-abfertigung-ead54cb2e597@brauner>

On Thu, Jul 02, 2026 at 03:47:37PM +0200, Christian Brauner wrote:
> On 2026-07-02 10:35 +0200, Carlos Maiolino wrote:
> > On Thu, Jul 02, 2026 at 09:41:39AM +0200, Christian Brauner wrote:
> > > On 2026-06-26 13:45 +0200, cem@kernel.org wrote:
> > > > From: Carlos Maiolino <cem@kernel.org>
> > > > 
> > > > In some cases - filesystems quota specifically here - we'd like to check
> > > > for effective capabilities without issuing spurious audit messages and
> > > > without the need to specify a namespace for that.
> > > > 
> > > > This series introduce capable_noaudit() which has the same goal as
> > > > capable() but without firing audit messages.
> > > > 
> > > > Also, this updates both generic quota and xfs quota code to use that.
> > > > 
> > > > The last patch unexports has_capability_noaudit() which was originally
> > > > exported to be used in xfs but turns out it does not meet our needs.
> > > > 
> > > > Note this is based on top of a current series I have to remove
> > > > has_capability_noaudit() calls from xfs so the xfs patch won't
> > > > apply cleanly without that series.
> > > > 
> > > > If adding this helper is acceptable, I'll turn this into a non-rfc
> > > > series with the required changes to apply properly.
> > > > 
> > > > Comments? Flames?
> > > 
> > > Convert more, please.
> > > 
> > 
> > Convert what? :) more callers from capable() to capable_noaudit()?
> 
> Yes, there's more code that should use the noaudit variant. Future
> work...

/me writes to his todo list
