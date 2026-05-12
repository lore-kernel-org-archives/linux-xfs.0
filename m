Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668E21ACEDE
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778602184; cv=none; b=mw9b0TZ3+H2lmk49ocKNDA00FexRx22nxbDdfQmWhp+UjjDVkwRxCKAN8tmiBwkbXZoGLJrz2hVDevAyjBAsyH9yVS4ixufNZmC+uVUzebIE33DrTZSnB5/5ghRtMkfYnTX/avjNI9mj4s/5DHsXIZT4alNJ85fm92ugbMH1Lyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778602184; c=relaxed/simple;
	bh=JCuv2/lKPK6zHHl1YHSDAioafTJNTGBT4hrPWh+9peg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1CaQUStY3N367oEDgheagwqa91GegFPmYirnAQOn5/k0F4pa6SHSKhHl2s5JEDkqLx9Dk4I2XXOlbUzhy9kppqc7TDHhjV+fQNboV7Ip8F/YWG+URSPRG1adSRbKM8Nfi0/oz6jCXCndAAKm8am27rVG7eQ+DLgeh1CyCWxWdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkGgME+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkGgME+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CF0C4AF0B;
	Tue, 12 May 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778602184;
	bh=JCuv2/lKPK6zHHl1YHSDAioafTJNTGBT4hrPWh+9peg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZkGgME+qa/Kyp4DZ98LVpW38+pKxew7nKNyyuawmikzOt7mPnNmKFBbHF7UAMApZ1
	 4LByGp0OP8sL6L4vPFJxByOtwlE5zbJakp3eQyyzEaQXkvFPWh111KKbQ0JLDOl/i2
	 fYsZaiBujLmEP1Wtx7By14/cADpNz7rcsnxJpUoy3ZKKB/eKXKyKZx+mrhSmFMQ294
	 dS8JUr4nYZWxxESFAQBVabCSb0NoWOXAgiPYcC2R8PrqJ4CKhOr9xxxCHvL+YfI7uK
	 gb0ZtZuzcXuqOShYXFinmjlk4lb175zYv39YcHqjmIfY6T0+IOfB76KZngvYr4RhI4
	 0K0x6lfeebTdg==
Date: Tue, 12 May 2026 09:09:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] platform_defs.h: fix __counted_by_ptr annotation
Message-ID: <20260512160943.GA9555@frogsfrogsfrogs>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
 <qnp7uxdaslz5u2pb5rvvb577opgw5xrcqbeplob4ukgakbcggp@htp7i6k432xx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qnp7uxdaslz5u2pb5rvvb577opgw5xrcqbeplob4ukgakbcggp@htp7i6k432xx>

On Tue, May 12, 2026 at 01:48:25PM +0200, Andrey Albershteyn wrote:
> On 2026-05-07 15:11:27, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The kernel userspace headers for Linux 7.0 provide the __counted_by_ptr
> > macro, so we shouldn't define it separately on those platforms:
> > 
> >   In file included from radix-tree.c:11:
> >   ../include/platform_defs.h:334:9: error: "__counted_by_ptr" redefined [-Werror]
> >     334 | #define __counted_by_ptr(member)
> >         |         ^~~~~~~~~~~~~~~~
> >   In file included from /usr/include/linux/posix_types.h:5,
> >                    from /usr/include/linux/types.h:9,
> >                    from /usr/include/linux/sched/types.h:5,
> >                    from /usr/include/x86_64-linux-gnu/bits/sched.h:63,
> >                    from /usr/include/sched.h:43,
> >                    from /usr/include/pthread.h:22,
> >                    from ../include/platform_defs.h:19:
> >   /usr/include/linux/stddef.h:73:9: note: this is the location of the previous definition
> >      73 | #define __counted_by_ptr(m)
> >         |         ^~~~~~~~~~~~~~~~
> > 
> > Do the customary ifndef wrapper thing.
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> > Fixes: df91bc3bdc9b81 ("xfs: annotate struct xfs_attr_list_context with __counted_by_ptr")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> ops, I haven't tried with new headers

To be fair, I hadn't either -- I hadn't tried with the kernel 7.0 uapi
headers until after you'd pushed the release.  Oops.

> do you have -Werror enabled by default?

Yep.

> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks!

--D

> -- 
> - Andrey
> 
> 
