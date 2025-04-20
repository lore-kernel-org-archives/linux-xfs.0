Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB511BF37;
	Sun, 20 Apr 2025 10:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745146409; cv=none; b=eRUcZp05QQLhuH5c2zQzUbuSQSZ5z9qJJYl9orh1+m8mHRFD9wL3YMcdn/rkeOsIua0hkD6ADbRPfsM8Ikq79Sd+Ha2Zal2cCiko5+pV5zcf6jVvCrmq+NkudG2Bl280WNbfyZtLX0z33gjzLtuNMOnp2vZb2sMo1NDQ8T+315g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745146409; c=relaxed/simple;
	bh=w3GPUz20Zg0wYepIr6mudCRKy58RJwen5VNml7NOkdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLDnzJDljbkcphMmiCBSAy0LZlTDzbn8BpOUcguUg4Sf8hEZWZvzWorEFiwon46pKSOX+4FPShn5nZaWErX6X9JCzrIKiUU/m+Okxm7IP5TW8Pkp+AR++4j0Hc9X+gaEtdbgEJVzHz4qqQqJNB7EdqRmNzlk/bzCpo9ap9VNdi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ukFPP9d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ukFPP9d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33703C4CEE2;
	Sun, 20 Apr 2025 10:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745146408;
	bh=w3GPUz20Zg0wYepIr6mudCRKy58RJwen5VNml7NOkdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ukFPP9d+Se0sUld91nc3n08tMfbpzJBP5/vowWPDIRnM4x1p6+XD+AU/qCyuX060o
	 I1StpR3Z+KQANu6ONS0VHgezaOncSnI0cN0AUGbenjzPYw/rLpW+pE817RpPVGxp7D
	 bFXqL3HNV59nHob2sLjRXr89AMo7SNnzRZEQTt2xJb3+LYf0kU8V75Xd9s7tyeMlMX
	 rJZY6c0OtxpZ8kvusJW/WAjOlF/fKM0ApnWpacZ9lnPFm5gpNf9aRNPJODKiWIewbP
	 MYQUT8nZmCZeEwvvyXGcjecYd7/uDfUTNBJ7ldHRZmy7cMnl2/CGazEwWRW/uTjbOO
	 B9FJDKBTxrhvA==
Date: Sun, 20 Apr 2025 12:53:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Message-ID: <mt3tlttnxheypljdkyy6bpjfkb7n5pm2w35wuf7bsma3btwnua@a3zljdrqqaq7>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <iB7R4jpT-AaCUfizQ4YDpmyoSwGWmjJCdGfIRdvTE76nG3sPcUxeHgwVOgS5vFYV0DCeR1L5EINLppSGbgC3gg==@protonmail.internalid>
 <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476cf4b6-e3e6-4a64-a400-cc1f05ea44cc@roeck-us.net>

On Sun, Apr 20, 2025 at 02:47:02AM -0700, Guenter Roeck wrote:
> On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
> > Presently we start garbage collection late - when we start running
> > out of free zones to backfill max_open_zones. This is a reasonable
> > default as it minimizes write amplification. The longer we wait,
> > the more blocks are invalidated and reclaim cost less in terms
> > of blocks to relocate.
> >
> > Starting this late however introduces a risk of GC being outcompeted
> > by user writes. If GC can't keep up, user writes will be forced to
> > wait for free zones with high tail latencies as a result.
> >
> > This is not a problem under normal circumstances, but if fragmentation
> > is bad and user write pressure is high (multiple full-throttle
> > writers) we will "bottom out" of free zones.
> >
> > To mitigate this, introduce a zonegc_low_space tunable that lets the
> > user specify a percentage of how much of the unused space that GC
> > should keep available for writing. A high value will reclaim more of
> > the space occupied by unused blocks, creating a larger buffer against
> > write bursts.
> >
> > This comes at a cost as write amplification is increased. To
> > illustrate this using a sample workload, setting zonegc_low_space to
> > 60% avoids high (500ms) max latencies while increasing write
> > amplification by 15%.
> >
> ...
> >  bool
> >  xfs_zoned_need_gc(
> >  	struct xfs_mount	*mp)
> >  {
> > +	s64			available, free;
> > +
> ...
> > +
> > +	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
> > +	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
> > +		return true;
> > +
> 
> With some 32-bit builds (parisc, openrisc so far):
> 
> Error log:
> ERROR: modpost: "__divdi3" [fs/xfs/xfs.ko] undefined!
> ERROR: modpost: "__umoddi3" [fs/xfs/xfs.ko] undefined!
> ERROR: modpost: "__moddi3" [fs/xfs/xfs.ko] undefined!
> ERROR: modpost: "__udivdi3" [fs/xfs/xfs.ko] undefined!
> 

I opened a discussion about this:

https://lore.kernel.org/lkml/20250419115157.567249-1-cem@kernel.org/
