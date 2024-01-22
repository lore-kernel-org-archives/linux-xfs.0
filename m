Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6475115CB
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 03:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705893832; cv=none; b=KYJ+o3ntApacyujduCgviJErz+RCbA/ouaSkH8O6VQzVuYUNsewXWeOxaFLvQNN1UkB98Za/Rln/LZptzPfS4hxvTIOGA/flGa65BSBtxz3DcMmA/qAcD6s39VjIm4Mht3Nf2fDfFON42z9GNqLKAAcgtDNAV/unq/tEAVMkZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705893832; c=relaxed/simple;
	bh=5zVODqfQU+ziNTfvRFmFdIpMSOfOzlOrjtf8WT9VjU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XF+NQ4329fksnZX+H3VzMKReU+qZQKdFV5tM2EMrxBpqCZuHAaZDXL+nSX+8YdTac48/N+Q+LQwZg0LXvQE9BjtLQTD+p3NlxjFPCAB/5lWE7xm20KWXdiA3Imnsrye7J4oafYD6HqKkPVefDODN7MAwCVnXBFG0m56i7D17FCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=epqapUf0; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="epqapUf0"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so2155834a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2024 19:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705893829; x=1706498629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TE8QuewfbUhSzbyutpkst4Now3KuO7q0bwyq5Pv+8Z0=;
        b=epqapUf08B3sqfoIWj0pUggtKCy4c4NtiCv8nTSc9KU5u4ZSwDLlBwHQpLc6bJUi7n
         tyAep9drfA1N9uttHTvR87MTAAtwwsySoEmfATyfgtb/2zXq2X2lasanJFzRWPSKcjmY
         3hLel+sdmF28peGSm/kjaKmv33vx9cKehuCTiAuY75e6ttt+w5alqPanE5hIPec7fGja
         SlNj9EaU1c3wXJnGUOSPoSFFBQuURFW/fldDkVIot4/CLIRdPm5+N2Kt5KQotEj2U6dE
         ho1Idhar3Ah0cNMRgsPs/bMr9FSUUahWJQLMDTSuo+A3V2UFhyDR3TQz9KJ0LvYyoii1
         3+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705893829; x=1706498629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TE8QuewfbUhSzbyutpkst4Now3KuO7q0bwyq5Pv+8Z0=;
        b=udqUfLjz+HQHbOppIkMc39J585LkAoGaBiou7RPdXb8uFlwPPhwlTsTzRLctMod8KF
         jEN2ZlFhpz28SNZESnDbzd8/OVSeY4RN0KPERJ0SiEmLs1y84vX6yCS5rti3yTDNYk4g
         gjqmmVBHJb0k3SYjvDHxmTqqDAnSi6xVNqb4vFUvc9sK2TR63+PhRNcIj70Qw+E08ruL
         pcmxexdQeDXO3OAaGlNzUCe0OPfmnQZKGmscT7OH+H43ZUpaCSt55AAs0NOyGbUx6zNt
         a6v4DY5e8wAreRZbMnZXBONY8mLzGsamtlRgnbsRQRG4J+ebcSv7EVl9/W+ljprcTvbY
         Goww==
X-Gm-Message-State: AOJu0Yxi0IJs8Ev/YT38uFvAmRslLA0X8SRAUSXwC2XjvGHra113Zzze
	x8oLKrPWD6CWm93ceM/78elehRRrwLqOQdiSkScNlBIRksnDjxiW4L5hduTmbTI=
X-Google-Smtp-Source: AGHT+IHSHO4rky6/W0hQJOcnznlmWBqktG4R9UmXAWf3O2LE0yZVirqWK8Lv9/JfxrJsp8eV85rvMQ==
X-Received: by 2002:a05:6a20:4daa:b0:19a:3f15:6744 with SMTP id gj42-20020a056a204daa00b0019a3f156744mr4001908pzb.52.1705893829622;
        Sun, 21 Jan 2024 19:23:49 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id qa6-20020a17090b4fc600b0029097447fd6sm1565468pjb.47.2024.01.21.19.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 19:23:48 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRkuW-00DbNF-2A;
	Mon, 22 Jan 2024 14:23:44 +1100
Date: Mon, 22 Jan 2024 14:23:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <Za3fwLKtjC+B8aZa@dread.disaster.area>
References: <20240119193645.354214-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119193645.354214-1-bfoster@redhat.com>

On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> We've had reports on distro (pre-deferred inactivation) kernels that
> inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> lock when invoked on a frozen XFS fs. This occurs because
> drop_caches acquires the lock and then blocks in xfs_inactive() on
> transaction alloc for an inode that requires an eofb trim. unfreeze
> then blocks on the same lock and the fs is deadlocked.

Yup, but why do we need to address that in upstream kernels?

> With deferred inactivation, the deadlock problem is no longer
> present because ->destroy_inode() no longer blocks whether the fs is
> frozen or not. There is still unfortunate behavior in that lookups
> of a pending inactive inode spin loop waiting for the pending
> inactive state to clear, which won't happen until the fs is
> unfrozen.

Largely we took option 1 from the previous discussion:

| ISTM the currently most viable options we've discussed are:
| 
| 1. Leave things as is, accept potential for lookup stalls while frozen
| and wait and see if this ever really becomes a problem for real users.

https://lore.kernel.org/linux-xfs/YeVxCXE6hXa1S%2Fic@bfoster/

And really it hasn't caused any serious problems with the upstream
and distro kernels that have background inodegc.

Regardless, the spinning lookup problem seems pretty easy to avoid.
We can turn it into a blocking lookup if the filesytsem is frozen
simply by cycling sb_start_write/sb_end_write if there's a pending
inactivation on that inode, and now the lookup blocks until the
filesystem is thawed.

Alternatively, we could actually implement reinstantiation of the
VFS inode portion of the inode and reactivate the inode if inodegc
is pending. As darrick mentioned we didn't do this because of the
difficulty in removing arbitrary items from the middle of llist
structures.

However, it occurs to me that we don't even need to remove the inode
from the inodegc list to recycle it. We can be lazy - just need to
set a flag on the inode to cancel the inodegc and have inodegc clear
the flag and skip over cancelled inodes instead of inactivating
them.  Then if a gc cancelled inode then gets reclaimed by the VFS
again, the inodegc queueing code can simply remove cancelled flag
and it's already queued for processing....

I think this avoids all the problems with needing to do inodegc
cleanup while the filesystem is frozen, so I leaning towards this as
the best way to solve this problem in the upstream kernel.

> This was always possible to some degree, but is
> potentially amplified by the fact that reclaim no longer blocks on
> the first inode that requires inactivation work. Instead, we
> populate the inactivation queues indefinitely. The side effect can
> be observed easily by invoking drop_caches on a frozen fs previously
> populated with eofb and/or cowblocks inodes and then running
> anything that relies on inode lookup (i.e., ls).

As we discussed last time, that is largely avoidable by only queuing
inodes that absolutely need cleanup work. i.e. call
xfs_can_free_eofblocks() and make it return false is the filesystem
has an elevated freeze state because eof block clearing at reclaim
is not essential for correct operation - the inode simply behaves as
if it has XFS_DIFLAG_PREALLOC set on it. This will happen with any
inode that has had fallocate() called on it, so it's not like it's a
rare occurrence, either.

The cowblocks case is much a much rarer situation, so that case could
potentially just queue inodes those until the freeze goes away.

But if we can reinstantiate inodegc queued inodes as per my
suggestion above then we can just leave the inodegc queuing
unchanged and just not care how long they block for because if they
are needed again whilst queued we can reuse them immediately....

> Finally, since the deadlock issue was present for such a long time,
> also document the subtle ->destroy_inode() constraint to avoid
> unintentional reintroduction of the deadlock problem in the future.

That's still useful, though.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
