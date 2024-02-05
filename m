Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F367F
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 01:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707095369; cv=none; b=p6aO087wbEMmnCMuGLQyadXdgUWtV+Z/qumNJyQoIRu0GNk/2uu5YWsVKh4pRM+FcY9+u1jFlol9klRi+Pt8jxKou6ZQA/mc1ZgFCpxVSoHpBPqG3g3OQANyUoKYJ2yUSsGJeNwji1Vy5fM0k7ttwaCgS0jgvLGcIiVJO8dtqdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707095369; c=relaxed/simple;
	bh=qHwcm0UvIPA9FYXXuT2M95BUDqSZ5dvPOEiAWLAbFco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgghY+5OY5Me6nunoUH5Tq7LPhyYr1P8aE1Z5vynd7zmOVOSRYO7Jr91ejs0mTtjQaa2lCcV/UJYe+7+0NmB6P44GkrFNZSFKZMqWd13tbVZuOheAHyvA3F32JvZh20zyDhlWWkZOHFCvEsh4rKzhnOur/C7h0wBNKbhbCDs+Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=UErtXYym; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="UErtXYym"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-290da27f597so2521774a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 04 Feb 2024 17:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707095367; x=1707700167; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EG6/RP2h7A+7P/E7FSYGMx3jmoH/EYtHdAI3GdvYNEE=;
        b=UErtXYymmJfyM73yfb8mrzyAd13JABd9xz7hmYrjuRuZaPaKjIE2lnA3ybPOrc2h7L
         kfP14Ru7KYwcBQIerqaQTwjGlY7E+AZtwoiY+PAlTuJbxuZkS/zs2rVLC/pTRBUORe8T
         9VYHdCC49v072+IWbiNPQUEwhyvqmSCheZl63y9Brjr1qyM9tRlNB2Nic9TAaGFMUbtv
         kjePYpjMenE5xXJUmNzl84O339xj/HoL9new+M6XrZ4SaBSJMYGYommvuX8QtaCVCq0o
         xJrg4kMQwmYr670qJnePju/NlWAnwt2X2tHHhxj/UnnbX9F+7l1rjRigNK4mM6AZhZno
         XlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707095367; x=1707700167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EG6/RP2h7A+7P/E7FSYGMx3jmoH/EYtHdAI3GdvYNEE=;
        b=gJAsKDrwuGwIv4E6D8U9vTu5PmYTxhxR9GCBJANvjqE+ydSS2HOUBb9mFXw3WRVINg
         ENt3M/3KaF6/SA5uMXRUw2YRcKDTGX3W6gdb557KRaDnZUABA+jy7vb0ZbfKIMxLxQxU
         qgQ096Z5uKXpIIjvzaCNTz0y8I0WzSkRteCkxHio5Q7ubSzNYYw8Lbe1Itp9T5fGwl95
         l60Io8CpCbKBki5Jk+rl5LhK93ucN3tKjYTj886uKgMwoK2GuIMnQhqK0Io7AsZ/MilA
         wu6zUuM9Dbk61tyrvzF59WGKkOIaKCatv0V3BLe8kQXppsSdADtDSVtlgtJoG8byExhv
         DgFA==
X-Gm-Message-State: AOJu0YyaugWOk3evE/OTHC67KPC2MxrxswaRm2CEsktXIa+4K+6Gr3kS
	ljlPMZ038HGBqGtX+KUEV67lNtcUAXzcSm6oz3kxEUJDzoDm6S0PCbNd8luiuTG4rDQ7LqUrF7U
	M
X-Google-Smtp-Source: AGHT+IGUSj7e+5TehF8rZW7VJWwICidxk9obdCgvJIp7VwLAWn7g2OfXgDsvXDH4lnirTMLHsvm3zQ==
X-Received: by 2002:a17:90a:6fc5:b0:296:1e3d:a98 with SMTP id e63-20020a17090a6fc500b002961e3d0a98mr8274628pjk.3.1707095367089;
        Sun, 04 Feb 2024 17:09:27 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVt6nz0XXhuXgU3k9Y1wgMsT4WOVLH2/vFS97A+AOLeKOeL6DQl5CAXRRE2PMbhtlun5DLMqYmpSWeDp991sqVPHSuWwcPf6+l5
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id nd7-20020a17090b4cc700b0029688ca65basm1509333pjb.29.2024.02.04.17.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 17:09:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rWnUB-002ApP-1d;
	Mon, 05 Feb 2024 12:09:23 +1100
Date: Mon, 5 Feb 2024 12:09:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <ZcA1Q5gvboA/uFCC@dread.disaster.area>
References: <20240131230043.GA6180@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131230043.GA6180@frogsfrogsfrogs>

On Wed, Jan 31, 2024 at 03:00:43PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> Christoph spied the xfs_swapext_can_use_without_log_assistance
> function[0] in the atomic file updates patchset[1] and wondered why we
> go through this inverted-bitmask dance to avoid setting the
> XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.
> 
> (The same principles apply to xfs_attri_can_use_without_log_assistance
> from the since-merged LARP series.)
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
> bits at cover/quiesce time.  At the time, I think we decided to go with
> this idea because we didn't like the idea of reducing the span of
> kernels that can recover a filesystem over the lifetime of that
> filesystem.

I don't think that was the issue - it was a practical concern that
having unnecessary log incompat fields set would prevent the common
practice of provisioning VMs with newer kernels than the host is
running.

The issue arises if the host tries to mount the guest VM image to
configure the clone of a golden image prior to first start. If there
are log incompat fields set in the golden image that was generated
by a newer kernel/OS image builder then the provisioning
host cannot mount the filesystem even though the log is clean and
recovery is unnecessary to mount the filesystem.

Hence on unmount we really want the journal contents based log
incompat bits cleared because there is nothing incompatible in the
log and so there is no reason to prevent older kernels from
mounting the filesytsem.

> 
> [ISTR Eric pointing out at some point that adding incompat feature bits
> at runtime could confuse users who crash and try to recover with Ye Olde
> Knoppix CD because there's now a log incompat bit set that wasn't there
> at format time, but my memory is a bit hazy.]
> 
> Christoph wondered why I don't just set the log incompat bits at mkfs
> time, especially for filesystems that have some newer feature set (e.g.
> parent pointers, metadir, rtgroups...) to avoid the runtime cost of
> adding the feature flag.  I don't bother with that because of the log
> clearing behavior.  He also noted that _can_use_without_log_assistance
> is potentially dangerous if distro vendors backport features to old
> kernels in a different order than they land in upstream.

This is what incompat feature bits are for, not log incompat bits.
We don't need log incompat bits for pp, metaddir, rtgroups, etc
because older kernels won't even get to log recovery as they see
incompat feature bits set when they first read the superblock.

IOWs, a log incompat flag should only be necessary to prevent log
recovery on older kernels if we change how something is logged
without otherwise changing the on disk format of those items (e.g.
LARP). There are no incompat feature bits that are set in these
cases, so we need a log incompat bit to be set whilst the journal
has those items in it....


> Another problem with this scheme is the l_incompat_users rwsem that we
> use to protect a log cleaning operation from clearing a feature bit that
> a frontend thread is trying to set -- this lock adds another way to fail
> w.r.t. locking.  For the swapext series, I shard that into multiple
> locks just to work around the lockdep complaints, and that's fugly.

We can avoid that simply by not clearing the incompat bit at cover
time, and instead do it only at unmount. Then it only gets set once
per mount, and only gets cleared when we are running single threaded
on unmount. No need for locking at this point holding the superblock
buffer locked will serialise feature bit addition....


> Going forward, I'd make mkfs set the log incompat features during a
> fresh format if any of the currently-undefined feature bits are set,
> which means that they'll be enabled by default on any filesystem with
> directory parent pointers and/or metadata directories.  I'd also add
> mkfs -l options so that sysadmins can turn it on at format time.

At this point they are just normal incompat feature bits. Why not
just use those instead? i.e. Why do we need log incompat bits to be
permanently sticky when we've already got incompat feature bits for
that?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
