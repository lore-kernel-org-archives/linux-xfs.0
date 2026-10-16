Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242B83D093F;
	Fri, 16 Oct 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792183403; cv=none; b=fvAYCe5lZvrNw/7pdYxNGRhI2nU6aOHCUy0yVlRf3nGkWnvpihSMKhviJOsirVEMywCCLH5K+xrfqSJeyo1Yf4ApLvMaewwS/bd62T13/W03PMxHuUVgAomuoPqXIY+3vucx4oRyJ+1Nh8czBohzScVxUmBYY06K1f8nQMjfIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792183403; c=relaxed/simple;
	bh=bIZH4VF2S1smufUb/Y0z0o1YzZgzasmGi7a+LzrNNdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXWLophbygHTkFhJsQKU87Q2YMYRJDRWzp7dZ6rjz+xWFOQsvjsFpOOqgqRAkfif5wvkkX9GiLfivIBBcPwcaxuuIcIAffycuqhcX7EKvEym1LkV45cn7S9SoHAA+BwTHbx0MC/XAQKOdVxteY9pLvVzuecm/pJLYFHjwppn+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGtIPcW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGtIPcW9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E97FF1F000C4;
	Fri, 16 Oct 2026 20:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183402;
	bh=mA20y9t2rAIlIC+u80dzHCyhwA7TU+kr14wHaaQQU6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WGtIPcW9IgcWOFJoloSUCJ/a/YW1LMnt0Y0Gf9mn1o4yYa3Xje3RX+HB+x0RtHVYR
	 hl9KxOxjdI3+Aav8Ad2blqEAxu5PwOnkEydOJkJaxgMd8LTB5tDEPnrcpP9FEElIg9
	 n/3YOz0IKPvylWC4u9T/wYZjPRwhiFpJXH0HKYc5Ov2chVfij4OmsyVl0HA7ZNo3iI
	 PUZs3jtIscvXKUED8XVuGh9lX4gCokVn1ONwhw8gsAmeCh3AOqU0KMX9r00AY4uUcf
	 Fghi4JbqF4IlpVC6lMbbEVHJpI3OMsX7YM5VosTviw0kfpS/h10R2jMaKJKyW7KSkx
	 TEanbTwAbPm5g==
Date: Fri, 16 Oct 2026 13:43:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, cem@kernel.org,
	jack@suse.cz, axboe@kernel.dk, kbusch@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 0/8] xfs write streams
Message-ID: <20261016204321.GN107986@frogsfrogsfrogs>
References: <CGME20261015063425epcas5p23fd76d70af639f4bb138332ca3a575b0@epcas5p2.samsung.com>
 <20261015063246.103433-1-joshi.k@samsung.com>
 <bf0505d2-115d-43e9-95e8-2ed6a3404799@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf0505d2-115d-43e9-95e8-2ed6a3404799@samsung.com>

On Fri, Oct 16, 2026 at 11:20:41AM +0530, Kanchan Joshi wrote:
> Christoph, Darrick
> 
> The shape of the series is aligned with your feedback on v4 [1]. 
> Possible to take a look and tell if anything should be changed?

I sent a few comments, but the big thing missing here is a design
document -- what problem are you trying to solve by adding the ability
to group files in flocks?  How mandatory vs. opportunistic is the stream
id? etc.  What about Dave's comments about hard constraining files to
particular AGs?

--D

> I can fold that with the fix for the only real issue (partition related) 
> that Sashiko reported in this round.
> 
> On 10/15/2026 12:02 PM, Kanchan Joshi wrote:
> > since v5:
> > https://lore.kernel.org/linux-xfs/20260921093147.59935-1- 
> > joshi.k@samsung.com/
> > 
> > Fixes for issues found by Sashiko review; no changes in UAPI
> > - fix 32-bit build: use do_div() for the inode-number hash in AG and
> >    rtgroup selection
> > - bound the stream pool to U16_MAX, the range of the stream id
> > - cap the hardware stream count at U8_MAX, the most streams the block
> >    layer can tag
> > - tag the iomap_dio_zero() bio with the write stream, so sub-block
> >    direct writes are not split across streams
> > - document that the stream pool must outlive the mount a stream pins;
> >    kernel-doc fixes
> > - rebase on 7.3-rc7
> 
> [1] > since v4:
> > https://lore.kernel.org/linux-xfs/20260717125538.508925-1- 
> > joshi.k@samsung.com/
> > 
> > - stream reservation and fd handling moved to generic code, and the
> >    stream id moved to struct inode from xfs inode (Darrick, Christoph)
> > - stream id no longer shows in uapi: OPEN becomes ALLOC and returns
> >    fd for any (unreserved) stream; OPEN_EXACT and GET are gone (Christoph)
> > - ALLOC requires CAP_SYS_ADMIN (Christoph)
> > - write stream and write life time hint are mutually exclusive at both
> >    setters
> > - stream pool lives on the buftarg (Christoph), which gives the realtime
> >    device streams of its own: new patch to enable RT support (Christoph, Darrick)
> > - software streams come first and work on any device; hardware streams
> >    are enabled in the last (Christoph)
> 
> 
