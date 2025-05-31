Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FA81758B
	for <linux-xfs@vger.kernel.org>; Sat, 31 May 2025 23:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748732551; cv=none; b=Gng1bNhrB0bt8DQY7entZQikOOL5W97qCVh3O7l90kJRvGMc2/WWcGla6pKwdQs5RMqMhqctEXzEAhtLoq0xFcJX1buPIpednkxr5TNMO1r2rFm8oMWH2KEPkDzkpq3RxkGOkrRUI20g4aBqGDJdtuEcgx5Sn5oSIloDXW0ct0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748732551; c=relaxed/simple;
	bh=8hugkn2chSzOND8npXGoVju5Aj13/h0hF1UBAmlYIFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKSF1KI7YeE14UMqGSFVX6ux0Yucsrgmz48ihiU77T/lnY2+vfTiUJX1yCmIoDDaduPLXGMLzFVrX9nzzgKqeslGfU6vkCvSFzAVXeV6+CTOoTy/TetA4mLGTdab6Jeo7/tzEdOXHNCVuHVQ44qzLDz3DLeQT/sF5swRhDR+nsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3b5nkaEX; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3b5nkaEX"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-31223a4cddeso2091645a91.1
        for <linux-xfs@vger.kernel.org>; Sat, 31 May 2025 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1748732549; x=1749337349; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ7SV3WId9rdCwdJiGcNR2WyLASNg8zeGEGyr/NQVuk=;
        b=3b5nkaEX6hJLk89QhPGxynPb+mxKnDMX9PwFC+/KtaitzN+gHEDGKxd1UcPzPK822g
         H5/TZG34LmtWl+rnwlNeXG18SJ/nwJzdYxLGY3D6GTSH0LlCxlWEEISL4ofRFSeqmV1U
         Lunl1Tt+zhY2cZURvNXBMEgjjU6RD+OkzY/c2dp3IIU/b55hNC74zU10XiONUqo6b8qF
         maxWSaz20A8pXufG+bjpI/upva8rDoWrIaC5qGLyBY+P/paI+c7hTAMFd7ehmfPf2Tha
         sWNozRCt/jslafDc/uF+LcA5CaqGv4Lp7t0ZT33tV9NsD2aV4xhfGq8be3aQtphSMDDj
         OGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748732549; x=1749337349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJ7SV3WId9rdCwdJiGcNR2WyLASNg8zeGEGyr/NQVuk=;
        b=Z/xlhSN6aBsfEu1m3UmDe0La/ulowV978jPQ/AEdBjrCdf2MfQSmHqe6J+MfOttycF
         RSRx8or4uwCjrDFhV5YSbcs8xTXJwcIhTFHN1hCK5jWce1SCsM2EidWNfKGe9mQkMguv
         +UhJ5Gn1z05fgoE+8wXdLwp7rtJSXzpGWVyoM7sk235HLHwWxseJtU+t2k+i8wVRb5zi
         BAU2vE1xrO7oNs8tFJyCcIgguAag7/2B+mKe4pGgVuyoniWpIo51Jj6LsBYDSXhqPVtX
         ANpgeU1ubdRqu2WC/51UBp7gn87hi2mv4u5pwS6Ud/T1MkmKY/e4x9rRs82XKWDcOM8L
         3E9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrJKT7npe5BD/gYcFIazONzqAMteUYfRLNpACKoilsAbyrCjE8TRrerjEdp5DYVJYsrb/kdBsnwQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/3bvgK/NBFX8sZUpo2TWJ5w6D5JPlofEX1W09HTdpsZa3X2J
	nfwcZedLld1lXFdiEykcQQ6Hd0LdgHbe38GhSs/tfVDP9q5MZ0J5OzBVLTR8P7Gu/9I=
X-Gm-Gg: ASbGnctYxBLiVfz/9XaM+BkyOhV7gWjGLRYo97RUafYK9LShNPvYxJnp3ypscmnmn9s
	0uycf+etbKB88sfb3yl/u3wOED1G86aVF54YqaWkoo5WPBKTMDDPdno4faeXCnY32kFOUcO9gsY
	M9izSOfp6ppi2f0Om/Lghgwmbn+OUf3qQrVrzaB2WGu3WJgdUy+o/+SbYZVUu/p3AJ+UBr+0VIa
	gDlnsRPRhdjcFdhG9HMPlZzmiJ07ZiyWKf1V+kBT/BW2RBzP01leueZRS9OgXE8cZcxaSsdDDFV
	mF8WcCGih9aLBPyPERBfu1yY8WWR7UfFXy+gWyvW0DsuMnzj8QRdLPEOyuvJ4spFjcI/alVGoGM
	nGNlH12FDEoUHnyy0Wa5cu4aHm5o=
X-Google-Smtp-Source: AGHT+IFZYqZ5PtzAZdZsg1MHGy/6eVovqIJGBPyGl53dauoDFxeNxLz5oLRI5+GeA1/WnFZLuoyguw==
X-Received: by 2002:a17:90b:3e84:b0:311:e8cc:424e with SMTP id 98e67ed59e1d1-3127c74306dmr5211843a91.24.1748732549294;
        Sat, 31 May 2025 16:02:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506d14c58sm47506645ad.217.2025.05.31.16.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 May 2025 16:02:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uLVDd-0000000Ae3o-3NPz;
	Sun, 01 Jun 2025 09:02:25 +1000
Date: Sun, 1 Jun 2025 09:02:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [QUESTION] xfs, iomap: Handle writeback errors to prevent silent
 data corruption
Message-ID: <aDuKgfi-CCykPuhD@dread.disaster.area>
References: <CALOAHbDm7-byF8DCg1JH5rb4Yi8FBtrsicojrPvYq8AND=e6hQ@mail.gmail.com>
 <20250529042550.GB8328@frogsfrogsfrogs>
 <20250530-ahnen-relaxen-917e3bba8e2d@brauner>
 <20250530153847.GC8328@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250530153847.GC8328@frogsfrogsfrogs>

On Fri, May 30, 2025 at 08:38:47AM -0700, Darrick J. Wong wrote:
> On Fri, May 30, 2025 at 07:17:00AM +0200, Christian Brauner wrote:
> > On Wed, May 28, 2025 at 09:25:50PM -0700, Darrick J. Wong wrote:
> > > On Thu, May 29, 2025 at 10:50:01AM +0800, Yafang Shao wrote:
> > > > Hello,
> > > > 
> > > > Recently, we encountered data loss when using XFS on an HDD with bad
> > > > blocks. After investigation, we determined that the issue was related
> > > > to writeback errors. The details are as follows:
> > > > 
> > > > 1. Process-A writes data to a file using buffered I/O and completes
> > > > without errors.
> > > > 2. However, during the writeback of the dirtied pagecache pages, an
> > > > I/O error occurs, causing the data to fail to reach the disk.
> > > > 3. Later, the pagecache pages may be reclaimed due to memory pressure,
> > > > since they are already clean pages.
> > > > 4. When Process-B reads the same file, it retrieves zeroed data from
> > > > the bad blocks, as the original data was never successfully written
> > > > (IOMAP_UNWRITTEN).
> > > > 
> > > > We reviewed the related discussion [0] and confirmed that this is a
> > > > known writeback error issue. While using fsync() after buffered
> > > > write() could mitigate the problem, this approach is impractical for
> > > > our services.
> > > > 
> > > > Instead, we propose introducing configurable options to notify users
> > > > of writeback errors immediately and prevent further operations on
> > > > affected files or disks. Possible solutions include:
> > > > 
> > > > - Option A: Immediately shut down the filesystem upon writeback errors.
> > > > - Option B: Mark the affected file as inaccessible if a writeback error occurs.
> > > > 
> > > > These options could be controlled via mount options or sysfs
> > > > configurations. Both solutions would be preferable to silently
> > > > returning corrupted data, as they ensure users are aware of disk
> > > > issues and can take corrective action.
> > > > 
> > > > Any suggestions ?
> > > 
> > > Option C: report all those write errors (direct and buffered) to a
> > > daemon and let it figure out what it wants to do:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring_2025-05-21
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring-rust_2025-05-21
> > > 
> > > Yes this is a long term option since it involves adding upcalls from the
> > 
> > I hope you don't mean actual usermodehelper upcalls here because we
> > should not add any new ones. If you just mean a way to call up from a
> > lower layer than that's obviously fine.
> 
> Correct.  The VFS upcalls to XFS on some event, then XFS queues the
> event data (or drops it) and waits for userspace to read the queued
> events.  We're not directly invoking a helper program from deep in the
> guts, that's too wild even for me. ;)
> 
> > Fwiw, have you considered building this on top of a fanotify extension
> > instead of inventing your own mechanism for this?
> 
> I have, at various stages of this experiment.
> 
> Originally, I was only going to export xfs-specific metadata events
> (e.g. this AG's inode btree index is bad) so that the userspace program
> (xfs_healer) could initiate a repair against the broken pieces.
> 
> At the time I thought it would be fun to experiment with an anonfd file
> that emitted jsonp objects so that I could avoid the usual C struct ABI
> mess because json is easily parsed into key-value mapping objects in a
> lot of languages (that aren't C).  It later turned out that formatting
> the json is rather more costly than I thought even with seq_bufs, so I
> added an alternate format that emits boring C structures.
> 
> Having gone back to C structs, it would be possibly (and possibly quite
> nice) to migrate to fanotify so that I don't have to maintain a bunch of
> queuing code.  But that can have its own drawbacks, as Ted and I
> discovered when we discussed his patches that pushed ext4 error events
> through fanotify:
> 
> For filesystem metadata events, the fine details of representing that
> metadata in a generic interface gets really messy because each
> filesystem has a different design.

Perhaps that is the wrong approach. The event just needs to tell
userspace that there is a metadata error, and the fs specific agent
that receives the event can then pull the failure information from
the filesystem through a fs specific ioctl interface.

i.e. the fanotify event could simply be a unique error, and that
gets passed back into the ioctl to retreive the fs specific details
of the failure. We might not even need fanotify for this - I suspect
that we could use udev events to punch error ID notifications out to
userspace to trigger a fs specific helper to go find out what went
wrong.

Keeping unprocessed failures in an internal fs queue isn't a big
deal; it's not a lot of memory, and it can be discarded on unmount.
At that point we know that userspace did not care about the
failure and is not going to be able to query about the failure in
future, so we can just throw it away.

This also allows filesystems to develop such functionality in
parallel, allowing us to find commonality and potential areas for
abstraction as the functionality is developed, rahter than trying to
come up with some generic interface that needs to support all
possible things we can think of right now....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
