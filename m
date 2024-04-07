Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CD44C85
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 22:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712530087; cv=none; b=i552RAq6BZRJmonThGYcqv7M0TqrW5B6YOr2N9b8TQCdpsXvrvlnW+IkE7dl3vFTtN1Izdv2LJ5rC3Rm7HM7LIE/rhwpJzf9JToV0AWkdNQDuk9PjmMmPHzstsE0X36XGp4LnNTxO8qtRHCiGW1e/ypOyP37Df/tPouCdJIAYvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712530087; c=relaxed/simple;
	bh=MmT2p+rgTkwRkLjLCqlnbjLBBImSVpkZ7WgEo8iwvTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ti5GkkRasOAnUOK7PTDaDt1nwoqKGXc+2I20mdwyUrPyKWiScrgB+nSnbCZrvAVY+Io3Njh1XuAj3MHANxFWlADSPMHNKiS2aa0LK8FHAHuGfTyXE+L28qahI8TbHUhKthZdKmrGuReFCcfdHCpANnnSz0OUbwIANBqG+mYR/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0r9725Zr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0r9725Zr"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ed0938cd1dso1870525b3a.2
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712530085; x=1713134885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a9BilUh+84RbGa7/yOUSi5fj5KPvZwdaRGJ+3BKThsk=;
        b=0r9725Zr0RKewXMSJeIvLBITDBh+2E+KeK80/1jLurcjwAQXwQjdsM5dsR5yHXrF9C
         IunyZquUW7eMHpmqmFy7cF/0gWBddSHT5yk3aGMZuNItBs6vKolJx3s4IYXGhOcDwVS/
         W9bOIv15aNH+6xeq3V3A9/25ihDiwWI/6KgokThAkXj2vzVtwX//H0YL25+EBdDe024g
         RmjkMche8TQBSEW15gS7uc0bUR/GEoE79shV0QjxLbA0vIkq3EDY8ueerBb44sqt7x6D
         0Nv23vtAYu4Fxy7OiAHFN7HleVWxYZtE49zZ5p7PTQPS8pj5y9ssesj6fTuYdlbVO9Vt
         EM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712530085; x=1713134885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9BilUh+84RbGa7/yOUSi5fj5KPvZwdaRGJ+3BKThsk=;
        b=qWEV6y8ZvipQ5PVaI8aWghl1sVqdjO/owmpdpKS/7uqHmD49ErNFzyprcbcCVBI7T+
         zx1IoeFcMBVTBcmjjVLOCcnm/GcLcEn6AWmFvYywHFg5A8YDYzrpL5d87B/kief9F5Q5
         62Bh6MZkHjPD1xNqkUzGFP1SLUOfpENQ73J4IuDVIlmIM6g3TKWXLdwPSDKU+CWNV+V6
         3CMyJX6TlO1WfZxnqiWngVruwXnWYjFoEQ/wmN3qORUFh57/+cnXKnsUbFMImLU1k4yt
         aX4FtNj9M5bY6CvTQR5/uTHzHSNaZfyTVMqE8YZ3tMrpC2Fnv3I9fvD+kVx8QfbGD7Sp
         t2AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWmR0E+bch8eOorhp4Hk4ckAj4im6hHs2I2eSmlQAkyIRtQRCglZTFEAzKU+KK/SDtQVLC4d0QKKJSV9GacldHU5OiUW6cBJxN
X-Gm-Message-State: AOJu0Yw6tbRmIcgvG5hSE44bbTzvukkai5ZNcmXEWehwXLZI7SLFCkwy
	wIHuzsRAhvKA2C5+Zw1TYcMCM9xcXcz2rlXdWtpVeUR214z0yOuXPbo7EedpFiI=
X-Google-Smtp-Source: AGHT+IEFjksvzhlTQgY7V73g261U7EYhnqQD34RY3zp7vVyTjBV7uBJIG30v0WT/fh4fBIhU8ytwmg==
X-Received: by 2002:a17:902:ce0c:b0:1e3:f6cb:4e7e with SMTP id k12-20020a170902ce0c00b001e3f6cb4e7emr3758824plg.42.1712530084836;
        Sun, 07 Apr 2024 15:48:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id jw9-20020a170903278900b001e259719a5fsm5464051plb.103.2024.04.07.15.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 15:48:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtbIw-007i8b-01;
	Mon, 08 Apr 2024 08:48:02 +1000
Date: Mon, 8 Apr 2024 08:48:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: only clear log incompat flags at clean unmount
Message-ID: <ZhMioUHDoF9QmI/D@dread.disaster.area>
References: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
 <171150379743.3216346.12598577809015628376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150379743.3216346.12598577809015628376.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 06:50:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the online fsck patchset, someone spied the
> xfs_swapext_can_use_without_log_assistance function and wondered why we
> go through this inverted-bitmask dance to avoid setting the
> XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.
> 
> (The same principles apply to the logged extended attribute update
> feature bit in the since-merged LARP series.)
> 
> The reason for this dance is that xfs_add_incompat_log_feature is an
> expensive operation -- it forces the log, pushes the AIL, and then if
> nobody's beaten us to it, sets the feature bit and issues a synchronous
> write of the primary superblock.  That could be a one-time cost
> amortized over the life of the filesystem, but the log quiesce and cover
> operations call xfs_clear_incompat_log_features to remove feature bits
> opportunistically.  On a moderately loaded filesystem this leads to us
> cycling those bits on and off over and over, which hurts performance.
> 
> Why do we clear the log incompat bits?  Back in ~2020 I think Dave and I
> had a conversation on IRC[2] about what the log incompat bits represent.
> IIRC in that conversation we decided that the log incompat bits protect
> unrecovered log items so that old kernels won't try to recover them and
> barf.  Since a clean log has no protected log items, we could clear the
> bits at cover/quiesce time.
> 
> As Dave Chinner pointed out in the thread, clearing log incompat bits at
> unmount time has positive effects for golden root disk image generator
> setups, since the generator could be running a newer kernel than what
> gets written to the golden image -- if there are log incompat fields set
> in the golden image that was generated by a newer kernel/OS image
> builder then the provisioning host cannot mount the filesystem even
> though the log is clean and recovery is unnecessary to mount the
> filesystem.
> 
> Given that it's expensive to set log incompat bits, we really only want
> to do that once per bit per mount.  Therefore, I propose that we only
> clear log incompat bits as part of writing a clean unmount record.  Do
> this by adding an operational state flag to the xfs mount that guards
> whether or not the feature bit clearing can actually take place.
> 
> This eliminates the l_incompat_users rwsem that we use to protect a log
> cleaning operation from clearing a feature bit that a frontend thread is
> trying to set -- this lock adds another way to fail w.r.t. locking.  For
> the swapext series, I shard that into multiple locks just to work around
> the lockdep complaints, and that's fugly.
> 
> Link: https://lore.kernel.org/linux-xfs/20240131230043.GA6180@frogsfrogsfrogs/
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 -
>  fs/xfs/xfs_log.c                                   |   28 -------------
>  fs/xfs/xfs_log.h                                   |    2 -
>  fs/xfs/xfs_log_priv.h                              |    3 -
>  fs/xfs/xfs_log_recover.c                           |   15 -------
>  fs/xfs/xfs_mount.c                                 |    8 +++-
>  fs/xfs/xfs_mount.h                                 |    6 ++-
>  fs/xfs/xfs_xattr.c                                 |   42 +++-----------------
>  8 files changed, 19 insertions(+), 88 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
