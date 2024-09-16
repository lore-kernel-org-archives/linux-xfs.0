Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7593B4C62A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726470220; cv=none; b=hEN/jJHFN2OOsmkYONsccb7mDE1UQQkK/6lqQYShGmddjE8Axm/Dpo0ohuTZ6h0pi2tZq80nHlH+/SP49oOUhWaR3y0mY0ePxQQ7Uvg7QoN5FpOMqxPao0irxerMhtDTM6ngVN0hZEPm0gIoH6vTJaMcAJA2BBCMt5g1e8b+0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726470220; c=relaxed/simple;
	bh=p0HRwb7dckvpqsAEI1/7frDLgt0lW6OPyF4zHs0P8lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gL5DFTvEpTQz3WwZUFbBHbvdARIGtxqy2ud+yzjGkMMVjPDc4NJFYSspFrw0uC1Yq2ns6JU0N2FzMkGypmNu5i2IGg7dfCNsHSrRxAnoECZDqDUKeaqFqvwKlT5eyvfaXdOpGsm4pJ14JSW0ouvnKooM04hcV7DrBqZoQ5gVRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uacM8CBQ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uacM8CBQ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d8a54f1250so2706206a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 00:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1726470218; x=1727075018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rZLEn0Q9zViAeMpnzS+Dnq04taHJPJso6pfVCKuErcs=;
        b=uacM8CBQ2YTGMGXW9M1xXKYXDgwn8/OSFC33WCT3b6kiTcMp5H75DQFyTKUs5LVS6s
         56PPDBTfDxUwfXayNVVF93060ZWqV8Vzi+tomk1ZuAM4A33XwpXXBxbAkr1XaH+HdC1r
         +Z2Tvg1ZEregiWNZWUC4ZVrmfEjnIF5veYQFFP9UDXVvRNiJIuliVWN9RBlvqQpPJv7U
         t+MrxHLqhekD/DChZoSVH6gXtC+ekq8NTzQuYNJwtFRJk3XuodZs0gL5p9+Ph6PMWmtk
         FtHKkRgSXY4do+QrsunPd+Mv96KPaDyokG5CS5vygbIymSn5Duag07JNrJkVKV5vdfzx
         DvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726470218; x=1727075018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZLEn0Q9zViAeMpnzS+Dnq04taHJPJso6pfVCKuErcs=;
        b=uXqPxqvQc8jUjK4UisJyRPmVgvNgyy+0mXhza9tLBcGfbOryEdygumnT4wpqcB9Rf6
         iTHEVGr8wbyvBh2n13q3ByaeQNErfX9Sdr+AkBWr1iMbBbJdwb2htZtSzWlAF0kBlYyz
         WCe7BX6cB2RncdQu2gLuEhei/Cm8y2WjmbM97nGaZwDuVH0epyGLVbvT8G4V3CVbrgOV
         ma0qgYl3xArlCkLm717PiwDE8BKh9ADS3HLWsBrhqFMO3yPbK9JI7uxSWdwAbOuI0ku8
         62Pz+GBqTmv2d+qVDR1Zw0N7JgdbvWsJmyaCtwJcJt61+HVIuDk9Q4+1MLMydgj1I7Vy
         Dt9w==
X-Forwarded-Encrypted: i=1; AJvYcCWwyAuyUVNslAPUU7QAEPJMmurqlVQdAommiw1Jr5u3UPPYtD/nrCRhjdAND2YaXFVMrvXUSYYCX4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YycXYArVZ91/5OdyOggHhle3hETMsg5vrmvsRiczG+P7YnQ+cxY
	wk66G2sDW1DmGyGIvyT/sRPxiFKzqwRGiARaRHRena3eG31WI0rSqnAYp15dRwQ=
X-Google-Smtp-Source: AGHT+IGq42CTY7GghG9ZTc+fqKHl5k23VXJfZNsjb0N1GaK6i7O2LyGs84PhBoOXpuTO1FVLs75q9Q==
X-Received: by 2002:a17:90a:684c:b0:2d3:d414:4511 with SMTP id 98e67ed59e1d1-2db9ffefa37mr16283390a91.24.1726470217587;
        Mon, 16 Sep 2024 00:03:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dbb9c7c7b4sm6581412a91.17.2024.09.16.00.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2024 00:03:37 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sq5lm-005pLT-1M;
	Mon, 16 Sep 2024 17:03:34 +1000
Date: Mon, 16 Sep 2024 17:03:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	djwong@kernel.org, dchinner@redhat.com, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH v4 00/14] forcealign for xfs
Message-ID: <ZufYRolfyUqEOS1c@dread.disaster.area>
References: <20240813163638.3751939-1-john.g.garry@oracle.com>
 <87frqf2smy.fsf@gmail.com>
 <ZtjrUI+oqqABJL2j@dread.disaster.area>
 <877cbq3g9i.fsf@gmail.com>
 <ZtlQt/7VHbOtQ+gY@dread.disaster.area>
 <8734m7henr.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734m7henr.fsf@gmail.com>

On Tue, Sep 10, 2024 at 06:03:12PM +0530, Ritesh Harjani wrote:
> >> Is it something to just prevent users from destroying their own data
> >> by not allowing a rw mount from an older kernel where users could do
> >> unaligned writes to files marked for atomic writes?
> >> Or is there any other reasoning to prevent XFS filesystem from becoming
> >> inconsistent if an older kernel does a rw mount here.
> >
> > The older kernel does not know what the unknown inode flag means
> > (i.e. atomic writes) and so, by definition, we cannot allow it to
> > modify metadata or file data because it may not modify it in the
> > correct way for that flag being set on the inode.
> >
> > Kernels that don't understand feature flags need to treat the
> > filesystem as read-only, no matter how trivial the feature addition
> > might seem.
> >
> 
> 1. Will it require a fresh formatting of filesystem with mkfs.xfs for
> enabling atomic writes (/forcealign) on XFS?

Initially, yes.

>   a. Is that because reflink is not support with atomic writes
>   (/forcealign) today?

It's much more complex than that.

e.g. How does force-align and COW interact, especially w.r.t.
sub-alloc unit overwrites, cowextsz based preallocation and
unwritten extents in the COW fork?

> As I understand for setting forcealign attr on any inode it checks for
> whether xfs_has_forcealign(mp). That means forcealign can _only_ be
> enabled during mkfs time and it also needs reflink to be disabled with
> -m reflink=0. Right?

forcealign doesn't need to be completely turned off when reflink is
enabled and/or vice versa. Both can co-exist in the filesytsem at
the same time, but the current implementation does not allow
forcealign and reflink to be used on the same inode at the same
time.

It was decided that the best way to handle the lack of reflink
support initially was to make the two feature bits incompatible at
mount time. Hence we currently have to make a non-reflink filesystem
to test forcealign based functionality.

However, doing it this way means that when we fix the implementation
to support reflink and forcealign together, we just remove the mount
time check and all existing reflink filesystems can be immediately
upgraded to support forcealign.

OTOH, we can't do this with atomic writes. Atomic writes require
some mkfs help because they require explicit physical alignment of
the filesystem to the underlying storage. Hence we'll eventually end
up with atomic writes needing to be enabled at mkfs time, but force
align will be an upgradeable feature flag.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
