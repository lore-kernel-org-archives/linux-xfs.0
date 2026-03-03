Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB848C8DB;
	Tue,  3 Mar 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772556542; cv=none; b=WgjJotzOVk31n+PjSQU0haCQscvuUBuIyRNugYQ86eta2GPeTNh+Ek9vhTUP2hpGG6D7modxoDcIwxL+n14G1FxbPoqmJ8k/yVER3Nq74EWLERzIy1HljTTZDR7g+oL70x35/REvCxR6DGPwmVX+PW68cHXLjoRBSaSNpywEOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772556542; c=relaxed/simple;
	bh=AxGT7UfkHl60FW2EHZgPq+1ZuWUwh4rOVv4rGfzflqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwDBdPW8vd9UKbOFGQRgCrpP2RcwqR1xCXJsI30GxNKZu+GZc8qbX+HKSoizcVUETomM7IZaHcMJ4/i8KmEVu8VHzVBFOiJUBO1RksEiE7o9RSh99GR4tRyROPJJqdJgt5ECGHFauBlGFwQCE1uTvA3Z2htBQuPOmtKEd1Yad8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJZ9Sr0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJZ9Sr0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29ADC19422;
	Tue,  3 Mar 2026 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772556541;
	bh=AxGT7UfkHl60FW2EHZgPq+1ZuWUwh4rOVv4rGfzflqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJZ9Sr0Hpnc593ZYUofSa4PnU2VYtynYI/y27n4sHiShcrVIVWXsL9fA5m+EFDWo+
	 tEK5TEUGrZBkxj4mVVqGzJ0zrNGZ1PDtC2Kl4BxpJalo6A4bSMxB2YbCkZc2wWp6I2
	 9/WP4pWNOWVeyfRsDNUAADIIUr1y8DxstVaC/NdmDus6dNISTA3LkwJgpjy0pA2sAL
	 4Jv9Bhr1nJfTD2EkfCMu64peXz5nb35b398+ki93nTIB+6cOleq2TM8ZXXbR7XAylp
	 mbvuoJzX7m+rEEL7SEyWgb9bskL7pabssmUqG1Fam9mJXJc1fGAnbJDKnO+6FSyaSC
	 +pu2icF3Jq62Q==
Date: Tue, 3 Mar 2026 08:49:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de,
	gabriel@krisman.be, amir73il@gmail.com, jack@suse.cz,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260303164901.GJ57948@frogsfrogsfrogs>
References: <177249785452.483405.17984642662799629787.stgit@frogsfrogsfrogs>
 <177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
 <aab2JbAZI8RFq_XE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab2JbAZI8RFq_XE@infradead.org>

On Tue, Mar 03, 2026 at 06:54:29AM -0800, Christoph Hellwig wrote:
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright 2021, Collabora Ltd.
> > + */
> 
> Where is this coming from?
> 
> > +#ifndef __GLIBC__
> > +#include <asm-generic/int-ll64.h>
> > +#endif
> 
> And what is this for?  Looks pretty whacky.
> 
> > +case "$FSTYP" in
> > +xfs)
> > +	# added as a part of xfs health monitoring
> > +	_require_xfs_io_command healthmon
> > +	# no out of place writes
> > +	_require_no_xfs_always_cow
> > +	;;
> > +ext4)
> > +	# added at the same time as uevents
> > +	modprobe fs-$FSTYP
> > +	test -e /sys/fs/ext4/features/uevents || \
> > +		_notrun "$FSTYP does not support fsnotify ioerrors"
> > +	;;
> > +*)
> > +	_notrun "$FSTYP does not support fsnotify ioerrors"
> > +	;;
> > +esac
> 
> Please abstract this out into a documented helper in common/

Ok.  I'm not sure how to check for feature support on ext4 anymore since
the uevents patch didn't get merged, and then I clearly forgot to rip
that out of this helper here.

> > +#
> > +# The dm-error map added by this test doesn't work on zoned devices because
> > +# table sizes need to be aligned to the zone size, and even for zoned on
> > +# conventional this test will get confused because of the internal RT device.
> > +#
> > +# That check requires a mounted file system, so do a dummy mount before setting
> > +# up DM.
> > +#
> > +_scratch_mount
> > +test $FSTYP = xfs && _require_xfs_scratch_non_zoned
> > +_scratch_unmount
> 
> Hmm, this is a bit sad.  Can we align the map?  Or should we carve in
> and add proper error injection to the block code, which has been
> somewhere on my todo list forever because dm-error and friends are
> so painful to setup.  Maybe I need to expedite that.

I think it's theoretically possible to figure out that there's a zone
size and then round outwards the error-target part of the dm table to
align with a zone.  I have a lot more doubts about whether or not doing
that in bash/awk is a good idea though.  It'd be a lot easier if either
the block layer did error injection or if someone just fixes those
limitations in dm itself.

--D
