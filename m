Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5FA7F48C
	for <linux-xfs@vger.kernel.org>; Tue,  6 Feb 2024 05:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707197011; cv=none; b=BxOjs4D3nAdgraSjN3NV5S7XAk4tV58zch91e9fMVjBg/7qfFjpEeXYiNdnQBNW3TXifYHmCI+w3mHBSUSmpAJmVkSCGBF2R3fr89Vsf8qTVzGjQ6vpZA9MDfASjOjhpaeEp0Uq7WvLwGelo9/tUHVBOsIuCwY44krhk7rTyajk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707197011; c=relaxed/simple;
	bh=L1r0BvywqiO5hKHjomAN90wC0c+SOF7G1ZcENdhZBtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAoS1CFnmNp6E2zApQ5v5ZcP1T1XO1CjYCOFuHqcbG2OuvRDwNJ3Mi4Ab7xmPcZyEY9iJhaH+QENFyxbSiLp4m2ZlAx0GixKH+1mztsFUHTKV1yxS/+ItpM32vSpyigFMMUGl/b3QZbyZUEw5+36SUXYWsI0kz+IwOUvntWOCgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWBknzwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWBknzwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B90BC433C7;
	Tue,  6 Feb 2024 05:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707197010;
	bh=L1r0BvywqiO5hKHjomAN90wC0c+SOF7G1ZcENdhZBtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWBknzwzsdxkf0Hir3wAU5ooaae4T6+N/VcT/zvFLOUkDgTMvTcCjGxUFNlkPOnQg
	 Jpn0p0GaE7Ey6gSWtBWRoqAq1aWqm42W5DMy9At+fUSdze/cU0YA5WQETQlugdIUxn
	 EcDUv++obMvOpxTp+YMvwDsbxDTEwsU7Y793eR8Ax6d7bDAFyxQj9IzzjuiHvr7vby
	 l7ltWyXOaTAEZ/Zqxa3PZDFcOd/IG2icKiEFYFbz1qOTefX1LHnudZrk6j7K5CSw5B
	 swzVWesfD9jsmPWCkYDU1HUzUqXCvGCGn/Lk1QU/0yQdAM1Vucn+SoVWmEBi6fFcDb
	 FK80MV+8ZDw8w==
Date: Mon, 5 Feb 2024 21:23:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <20240206052329.GR616564@frogsfrogsfrogs>
References: <20240131230043.GA6180@frogsfrogsfrogs>
 <ZcA1Q5gvboA/uFCC@dread.disaster.area>
 <ZcCEBkVrMUBeXu78@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcCEBkVrMUBeXu78@infradead.org>

On Sun, Feb 04, 2024 at 10:45:26PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 05, 2024 at 12:09:23PM +1100, Dave Chinner wrote:
> > The issue arises if the host tries to mount the guest VM image to
> > configure the clone of a golden image prior to first start. If there
> > are log incompat fields set in the golden image that was generated
> > by a newer kernel/OS image builder then the provisioning
> > host cannot mount the filesystem even though the log is clean and
> > recovery is unnecessary to mount the filesystem.
> 
> Well, even with the current code base in Darrick's queue a mount alone
> won't upgrade features, you need to do an explicit exchrange or online
> repair operation.  And I think we should basically never do log or
> other format incompatible changes without an explicit user action.

Should I add a flags bit to the ioctls so that programs can force them
on if the process has CAP_SYS_ADMIN?  Or would you rather a mount option
"-o allow_log_upgrades=1" so that's totally under control of whoever
writes fstab?

The first option probably turns into an "and now everyone sets this"
thing; the second one clutters up the mount options.

> The only exception would be if the feature is so old that we finally
> want to get rid of the old implementation, in which case we can think
> of automatically doing the upgrade with a big fat warning.

Heh, we're probably going to have to do that with bigtime come 2035.

> > Hence on unmount we really want the journal contents based log
> > incompat bits cleared because there is nothing incompatible in the
> > log and so there is no reason to prevent older kernels from
> > mounting the filesytsem.
> 
> Doing the clearing at unmount time only (and maybe freeze if someone
> really cares) sounds perfectly fine.

Ugh, I only want to do this at umount time if I can get away with it.
Freeze is already hard enough to grok.

--D
