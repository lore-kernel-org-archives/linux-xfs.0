Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7553E928C;
	Thu, 28 May 2026 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779970815; cv=none; b=Ehbu7MgQu/jCeez/CHTIotCxYYB22h3Pl8P9fVZe8mE/jQSUTaxI1EYC0JCOi29NFO+e3LWkQKix7TkbR/PkfN5MdqlJCjmk+CUV9XnYKU9LyT4TXzGFn8zJKX2NMuUhrkXWVIs7MQZdY+AfP/k9VPwdVEqEETTzQ14JqtVJzi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779970815; c=relaxed/simple;
	bh=KBjHBm6+FMUZTNQGaz9411xTcFVD7lUMw7HDcOvZjE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB8iS+hHkOy0+GX1oEQrnoOVssuQUx9v3ZO8YRyfD8EAdFdfcuRSKkb6EVTFLsdsH1coI0adShYIJ2vs4eRgU+nWA/1Rr0Fi1DtRIwXSedL27n7lYA2L/SNiqWPLFvPzLyZGvkRiuoaitqMr8rmFmoGUbP4+Rxrvz9zw0TCQ/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7HGiqwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7HGiqwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9937F1F00A3A;
	Thu, 28 May 2026 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779970814;
	bh=VKwY9ioZhVoPUqtTyA0BwlFjGKc+POdWjVXqGmhMxaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y7HGiqwAUe1nf03HOJRK6Iaw755bslZammK1+0efrRGASVM6Ws69wszEvqTmNRgm8
	 gnzzpdYOH706bywHqbKXllSClMMYk+jGuvHGtklya9XlCeVKCLEzxPEF5//Ru4tSZh
	 SQrQd3bOLYpqaWM/X3vsFncLmhfGWnK0R3q2LtIF/Klss5lyJ4Zw5osf4I3wOSeaSH
	 qLlSc+y4JQFjgXhLOOtkxCZD7efPEhYbMSaPhkdOpo1L2mhlKOx4i+ml9UfuLbNFdh
	 5eqKj2tWGIQ18hH0H+u3gk8kdqHBaj53qmnIgqfoIMY9CJZi7W+nAkNjMxcj8U4Yrd
	 xS5kNLPeHFY/Q==
Date: Thu, 28 May 2026 14:20:08 +0200
From: Christian Brauner <brauner@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@redhat.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>

On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > agree.
> > > 
> > > You may take it through the xfs tree if there are no conflicts with
> > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > vfs-7.2.iomap that you can pull in.
> > 
> > Merging the iomap bits through the iomap branch might make sense, given
> > that iomap usually tends to see quite a bit of activity.
> > 
> 
> That sounds good to me. If you want to go ahead and pull in the iomap
> bits, do so, and give me a heads up when you do it so I'll pull your
> branch locally.

Great, can the series please be resent based on current vfs-7.2.iomap
then please? Because the iomap changes in this series don't apply
cleanly on vfs-7.2.iomap so we already have merge conflicts...
