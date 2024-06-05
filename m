Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529181755A
	for <linux-xfs@vger.kernel.org>; Wed,  5 Jun 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597078; cv=none; b=jWLnaDQdWdRxdBZ9Tdz+cPBtZyaqxVpE3a1G8mykQExu0/DgCAsJBc0Dw/mUc/TNmPWD9vPVveAOyLZCQF9lok1VoRNiG2DMuZFhoCVJs+DsTvogDTf2U5cSeVXB/bnPsqvcxjFRiUAbq7F4QzcQ+GSeYjyvMXxp51gCHEfeW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597078; c=relaxed/simple;
	bh=KDoWvzM41r5+rpscN0UnqCP/V3KSgnFvOYxBao/ScWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3BD+iTzqikpZnYmQ86rkrqHXMVsYu2Mg3mlIootWYkygmOkSm7MkG7EviXb1KpVPCBALPElNVWhDmzWp6A5FHFP5yrdUs3hXJ1HM8FEy2CT3cY8w32Qdf3gJ5u8pAy/jdFwLEdCIRac9+aXgkFQx7WPTM7KUXynxk8tlViG8C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mz4LAIDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mz4LAIDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C210FC2BD11;
	Wed,  5 Jun 2024 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717597077;
	bh=KDoWvzM41r5+rpscN0UnqCP/V3KSgnFvOYxBao/ScWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mz4LAIDphiWtiptuXt+u0lMpGCuDZAzE46XBq/BcCwneqpSZ69I9A27zkMEQ4QvT6
	 cW53eUH4JdzT1ozH4LdkZRAcoXYgIt352yS9QvhCpb7mVY+J6EpZQS1HXgsJZoTJ4y
	 DMzVCspnGQOrMj3UXxkf2PGAOWsXxN2MrGVDKv10QQaZEstt0RUpavTHlI193IzjbU
	 P+W+apxqwgarJkScqdJFtShQVXdFez5szfUYET5wngo1o3jSAIAe7QxzWiUm55dZUr
	 BYa5bsHQ7KjSjZj1UJ+0EthiDSdVfksMcsUbz3fNiFzztGrbXSqPe2epHfGaiyP2bm
	 p83WMf3dVAzGw==
Date: Wed, 5 Jun 2024 16:17:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_repair: detect null buf passed to duration
Message-ID: <2dj7u3vn6flm2wutci5wddfles2k4uks3mevughgu7saqzkmai@lmkdahpn7b2b>
References: <20240531201039.GR52987@frogsfrogsfrogs>
 <WgLbGibmOXGXNXCoy90SomamGGdmPDxkXmpXjSQ5RZF1JSNK9--cUD0gjslOvqF14KG5inSv81x6OIcWI3j_gQ==@protonmail.internalid>
 <20240601175853.GY52987@frogsfrogsfrogs>
 <myn5kmvijvegbg5k2i2rvt3ioawnm4bzyls6fn42bvufr4x664@ovy7iysu7pjk>
 <5q5Faxi_Ae-igDHiFcJGtxBbE5QgpKWjW1Syaxx0ZaBmPxWIdibCiYs3UV4EKcCxJsoGOkGfjpuyAmFKDJaaxg==@protonmail.internalid>
 <20240603161446.GA52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603161446.GA52987@frogsfrogsfrogs>

On Mon, Jun 03, 2024 at 09:14:46AM GMT, Darrick J. Wong wrote:
> On Mon, Jun 03, 2024 at 02:42:20PM +0200, Carlos Maiolino wrote:
> >
> > > diff --git a/repair/progress.h b/repair/progress.h
> > > index 0b06b2c4f43f..c09aa69413ac 100644
> > > --- a/repair/progress.h
> > > +++ b/repair/progress.h
> > > @@ -38,7 +38,7 @@ extern void summary_report(void);
> > >  extern int  set_progress_msg(int report, uint64_t total);
> > >  extern uint64_t print_final_rpt(void);
> > >  extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
> > > -extern char *duration(time_t val, char *buf);
> > > +char *duration(time_t val, char *buf) __attribute__((nonnull(2)));
> >
> > Once nonnull() is used here, shouldn't we also set -Wnonnull to CFLAGS?
> 
> Already set via -Wall, at least if you're using gcc 12.2:
> 
>        -Wnonnull
>            Warn about passing a null pointer for arguments marked as
>            requiring a non-null value by the "nonnull" function
>            attribute.
> 
>            -Wnonnull is included in -Wall and -Wformat.  It can be
>            disabled with the -Wno-nonnull option.

Ok, thanks for letting me know :) feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/include/builddefs.in?h=for-next#n113
> 
> > Please don't take it as a review, it's just a question that came to my mind as I don't fully
> > understand the implications of using nonnull here.
> 
> <nod>
> 
> --D
> 
> > Carlos
> >
