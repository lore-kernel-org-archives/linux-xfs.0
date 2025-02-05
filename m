Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC611DC9B3;
	Wed,  5 Feb 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778625; cv=none; b=hcvLnnLZZLjV5m6oNq0NvNHoRTB5oFoZk3n46/jKHxeG0BUXnnI5AX/tqMLz4c8sXhC4aZ+TS4wOUibgLAHcht6cyGML33YjRbJnTkcPwG6w41FbtFJMV0FG2JlKoCYkfe+RnP7HdRp0gv6rxkgUoA2td9tB899B8PW/rPN1S8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778625; c=relaxed/simple;
	bh=kSdC2hpkIuaE79c68UXxaD70xvHEY+HGajcu+foYtKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5SaRPJnWBBZ+t9Bisoa737BamljvjUXEUTrNykbbTvsFZAGs+ieMDwbkeYLtG5SMl+o8K42K7mwmM0Ir9U3rt9+1m7zkNPov8IoM1RIN0Pa3cWH2CEnc1eCK/Ic4FjpnL9Z7xFrQKx3mD0+STq1k58LoH0p0OXrAFUynxM+dOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqJaY3Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqJaY3Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3D1C4CEDD;
	Wed,  5 Feb 2025 18:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738778624;
	bh=kSdC2hpkIuaE79c68UXxaD70xvHEY+HGajcu+foYtKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqJaY3LkTSE5rzsMzlGdD6R5TPknLc9Lv1fVoQcXJk11gcW/RK2XNQmJ2fEnCHMcq
	 K5cv4SGbp6ukULrMyXQiCRWRFT5JBhFbsewGMH+0C9k7HbiUR60qXzaa0pDPt7qDUt
	 508bN9V1GGDRkGAeaqHNQrU4o1YwmkHWARP1Fd8DAk2zUH2sBdHxGXKsO2gqTxDIl6
	 uwmodP9ChBcY3PQjoHSVMMpiDq/5PT93AmFtWe0krx7AmZ+bD/4P5lXS6Uz9QsS3EL
	 UqqJW/BgqOIaqAfhNByOP6keKZoZpZ/WV/s4cvZmE0HFdIO8GBJGDPr/ObasPY03ah
	 QuXs6jzQomLjg==
Date: Wed, 5 Feb 2025 10:03:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/34] common/rc: return mount_ret in _try_scratch_mount
Message-ID: <20250205180344.GI21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406411.546134.11968180503485222405.stgit@frogsfrogsfrogs>
 <Z6K0EF-wHqwN-68X@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6K0EF-wHqwN-68X@dread.disaster.area>

On Wed, Feb 05, 2025 at 11:42:56AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2025 at 01:27:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make the _try_scratch_mount and _test_mount helpers return the exit code
> > from mount, not _prepare_for_eio_shutdown.
> > 
> > Cc: <fstests@vger.kernel.org> # v2024.12.08
> > Fixes: 1a49022fab9b4d ("fstests: always use fail-at-unmount semantics for XFS")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Ack, missed that. Though:
> 
> > ---
> >  common/rc |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 03603a5198e3b6..56b4e7e018a8e0 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -440,6 +440,7 @@ _try_scratch_mount()
> >  	[ $mount_ret -ne 0 ] && return $mount_ret
> >  	_idmapped_mount $SCRATCH_DEV $SCRATCH_MNT
> >  	_prepare_for_eio_shutdown $SCRATCH_DEV
> > +	return $mount_ret
> 
> These could just be 'return 0' because we've already checked
> for $mount_ret being non-zero.

Will change.

> Regardless, it gives the same result, so:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
