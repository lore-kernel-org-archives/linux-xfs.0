Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F21258EFB
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755517358; cv=none; b=UMKJG10jMImPikGmJurtYNisJ6Kpu7FuYUKRk8xLs4UpfkdJGrM7iBgVJ0omJG/LxXqvQsoKwX/wIDw7aDI3tSHMkM/YHGB239C7aFbxpJU+QOi6tBKBIBi+LKRd4bVrPTNh0imc46Cu8PXpHf60PXYgDhR5zWnOhIKS0AJIsuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755517358; c=relaxed/simple;
	bh=RzA+cPFnO21ZwH5sJOmf8zS+rhWeH0urAjbBHduJ+io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thQXci0BTKyTZ3DeYBoVMaRdcia0mDxB6eA/Jy5cHt+nh8YNG2qEV6LRQFRHosOm4vLu4yiEMDYL6l8I92+s0c70bjw6ufRYGn1kqww03vfD6tY3PGiz6/uYK5qqG7Er/qLbcQKuXwjz1fL+QpF4n0mB6DTazVFFxGn1DS0Usag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8Nye5K5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8Nye5K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D33BC4CEED;
	Mon, 18 Aug 2025 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755517358;
	bh=RzA+cPFnO21ZwH5sJOmf8zS+rhWeH0urAjbBHduJ+io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H8Nye5K5JZcmVCRiVqZEbPOvkcAvhh1lUo5ugMhUt5N0roI/rwwbQKSBTPavLjJSb
	 qi5v6gOzfFyfXnH+ijU5kTZ7cs2ToVljsHe/ht6hKaFrB/IRClcwlqDTdE29XfNhDt
	 5MJp35idP9NcRjgMBXmREq0kc9WMxeHFP44KXSEvhSoVhciTTvswEpC3LFWBJKlrT/
	 LubpKsxXnHkMMA2o66C7X9DNDBRJiaOolJhF/xT3DMwZvIX5WGTKMEaYtJALKHShaI
	 wd9aBSkJYZC5ajxhz27LelgmcaM+l8movDEHsh1t1qLmwN7M0XLYUXvkgPMs253Oab
	 hPuPV235pHGlg==
Date: Mon, 18 Aug 2025 13:42:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Fix logbsize validation
Message-ID: <2xxf7mnj2n4p7fflxg6qt2sah5lhvrkmdjyfm4grhajkutnjov@w7zji77angtk>
References: <20250812124350.849381-1-cem@kernel.org>
 <VzwJZeJCfewqXfXxVJpqdGEAufIM-hvNW3ZFrEg7a7UGyCj9WCPjJw1IwnhuH8ZwsqCkWLkKUhoXxRQjm1ir8w==@protonmail.internalid>
 <aJ0QfhQ1kPZRIVUq@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ0QfhQ1kPZRIVUq@dread.disaster.area>

On Thu, Aug 14, 2025 at 08:23:58AM +1000, Dave Chinner wrote:
> On Tue, Aug 12, 2025 at 02:43:41PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > An user reported an inconsistency while mounting a V2 log filesystem
> > with logbsize equals to the stripe unit being used (192k).
> >
> > The current validation algorithm for the log buffer size enforces the
> > user to pass a power_of_2 value between [16k-256k].
> > The manpage dictates the log buffer size must be a multiple of the log
> > stripe unit, but doesn't specify it must be a power_of_2.
> 
> The xfs(5) man page explicitly lists a set of fixed sizes that are
> supported, all of which are a power of two.

Right, but yet if a log sunit is set, mount will automatically set to a
different value (if sunit is not any of those values). This is when it
gets confused.

> 
> > Also, if
> > logbsize is not specified at mount time, it will be set to
> > max(32768, log_sunit), where log_sunit not necessarily is a power_of_2.
> 
> log_sunit is set by mkfs, so the user cannot change that
> dynmaically. LSU is generally something that should not be
> overridden by users - it is set by mkfs for optimal performance on
> devices that require specific write alignment to avoid costly RMW
> cycles...
> 
> > It does seem to me then that logbsize being a power_of_2 constraint must
> > be relaxed if there is a configured log stripe unit, so this patch
> > updates the logbsize validation logic to ensure that:
> >
> > - It can only be set to a specific range [16k-256k]
> >
> > - Will be aligned to log stripe unit when the latter is set,
> >   and will be at least the same size as the log stripe unit.
> 
> Have you tested what happens when LSU is set to, say 72kB and
> logbsize is set to 216kB? (i.e. integer multiple of 3). What about a
> LSU of 19kB on a 1kB filesystem and a logbsize of 247kB?

So far I did test only a 96k logbsize with 32k LSU, I need more time to
test different configurations, but I see where you are getting to.


> 
> These are weird and wacky configurations, but this change allows
> users to create them. i.e. it greatly expands the test matrix for
> these mount and mkfs options by adding an entirely new
> dimension to LSU configuration testing matrix.

Right, agreed.

> 
> Does the benefit that this change provide outweigh the risk of
> uncovering some hidden corner case in the iclog alignment code? And
> failure here will result in journal corruption, and that may be very
> difficult to detect as it will only be noticed if there are
> subsequent recovery failures. That's a pretty nasty failure mode -
> it's difficult to triage and find the root cause, and it guarantees
> data loss and downtime for the user because it can only be fixed by
> running xfs_repair to zero the log.
> 
> So, do the risks associated with greatly expanding the supported
> iclogbuf/LSU configurations outweigh the benefits that users will
> gain from having this expanded functionality?

Agree. It's not worth the increased complexity, I'll update the manpage
only to reflect the current behavior.

Thanks for the review Dave.

Carlos,

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
