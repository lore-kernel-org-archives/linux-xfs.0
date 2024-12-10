Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10E1223337
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733871366; cv=none; b=qDIuD3i/MZVYm7haeM6cpq83gqA+0T5/4e1rw353TgR2PAU6g/hGLk/GlFsV4MbiDo2Qtjcl0UT/8vKSwVy/RQwLpYW4Fp4pKBUBVEx5YBMe8S3vutj/0uvmqzlp4MkaFmfqxX/pnDwwMPdRpmPDNCE1RlVNYYI4EL8r029sLy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733871366; c=relaxed/simple;
	bh=DKwhg6cV56HT8eq/K5wjigvb1aKd/aDWigOKyLL+o6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4URrXy9MqfTE01aXSNHOVOPjzC2A+rrHenM4sofyOVHRWW0OGgv7E9DCvNe7G3Kh3wFFuIg8iWJkHJfK9cTb52VR6knbqvdrqD2ZL7wg+GZR7WcZ3kWMdsNednbpUi8iKd57wEOdSQh3sYMNdq9ISE/aZ5P/3I8IZpyYiieGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=RsREylPf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="RsREylPf"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21654fdd5daso24444015ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 14:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733871363; x=1734476163; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSw/fybzU6j+5wBnmYrFEdSQbHiLC55G++x8CjiJGh0=;
        b=RsREylPfISzmwcLr6OYrYLbHyfj89YVTIAxNYKcu+tudFl+DtQxZficZb02ONirRAJ
         kSPUCWlHup8VLad9EUVKBo/QVDhZaU9dlCnl4AfVQWK5Z9xfhLJ2JTeHdW1u/bVIYv3e
         ++6Nf5drkJQXqZRdJefmNrb8eYYsF7fh8i8oiF6a0YbM6mkgdVIWLC1PR0Ba6nSs1j8n
         Ous91/Q9fmJG+z8Kre2IMj/F9wfF4OiFXxFn7+HKcPFwkCZlwEk8euIx5rg/fuGa8mqt
         ufHYfYZgmNYPLTTIuN2U69ehBA0/hor3t5wplm7bQvJ/RJf4A1xLeyPUJK54SwGACf5w
         4OSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733871363; x=1734476163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSw/fybzU6j+5wBnmYrFEdSQbHiLC55G++x8CjiJGh0=;
        b=QpobM79tyBPLP0XpCSPaKwaZhBqmE1gVR5Nei66YtMm46f6XFS8sJ3t3+SD+kukOXj
         ZQKW2LjHVeBZ6eqfTwGOcRVre5c2/cYqxFLu04KaIlKLG4LeTz9fgQH+GVPbf/A+ZWsY
         Oas21RSJOOtnV/lU2l259VPfcbr5ug0bcKYGAOzsnNizupf1t9QBvn3jgrRRJ6ziwKsF
         5ErOocH1a0CouURfhEcoXEVzssYl50GiW74q/6BgOR5zroHs71bafJqhwD3wGk2HpvM8
         oT3AMfvSL8s+sqmQfCw1B5XtWYvAlTDbu/dczyohlAzWG6Qk5lzSMyqXVkUoSZ1Djar/
         JmcA==
X-Gm-Message-State: AOJu0YyXnc6S7lWo83cjWAvegErxb0yO8yPf6HHyQHuf/XBu6zsRU9Ro
	EkfiJfjvQOHjia81E8B8XdBhkiE6i+aV1y2klwUIYrOvqa3r2nyS4xXcKKUpygPDCjvqQqMCvW7
	z
X-Gm-Gg: ASbGncvo8ym4hhqoMQXSDvO3rTMZT25aYXZ/QquljJrpsr1xvU959GCVadeBgYr5Q9k
	93kqUbKpBxAU4WZlnntkQPXTj5Mf8fEbrE7FplqPyV778IA0ICav71EPnlwV8P4HYzuRGgg/BTS
	OD5gNpiB0shSCzU8rr28AtlWp4X6kXHaKNtRtyjLvj5E4ZuBaRIB9DM9HGKUnyZrguDTCJyiGxg
	BJmcGGYyhup+BdLmosdnOd3inmMSiJWBRIrIKnQgH104Hk/MQnopCfVTzK/EFNeJs/H0LX48rDo
	WLHmbR/THkuaH7nWcm6Jl3epEPo=
X-Google-Smtp-Source: AGHT+IGZkMwZgur1x80e0s+O95AhAmuyhGsuYkh97UbgbT8pCLorsKqS3mF/aRVJRbHhfeKbfGgr1w==
X-Received: by 2002:a17:902:f68e:b0:216:4e9f:4ec3 with SMTP id d9443c01a7336-21778508dffmr12209035ad.39.1733871362938;
        Tue, 10 Dec 2024 14:56:02 -0800 (PST)
Received: from dread.disaster.area (pa49-195-9-235.pa.nsw.optusnet.com.au. [49.195.9.235])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-8010613439esm1436683a12.0.2024.12.10.14.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 14:56:02 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tL995-00000009AKe-1F2o;
	Wed, 11 Dec 2024 09:55:59 +1100
Date: Wed, 11 Dec 2024 09:55:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	dchinner@fromorbit.com
Subject: Re: [PATCH] xfs: fix integer overflow in xlog_grant_head_check
Message-ID: <Z1jG_4IRUaFmwT_E@dread.disaster.area>
References: <20241210124628.578843-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210124628.578843-1-cem@kernel.org>

On Tue, Dec 10, 2024 at 12:54:39PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> I tripped over an integer overflow when using a big journal size.
> 
> Essentially I can reliably reproduce it using:
> 
> mkfs.xfs -f -lsize=393216b -f -b size=4096 -m crc=1,reflink=1,rmapbt=1, \
> -i sparse=1 /dev/vdb2 > /dev/null

So that's a 1.2GB log, well within the log size overflow point of
2^31 - 1 bytes.

What version of xfsprogs are you using here?

> mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> xfs_io -x -c 'shutdown -f' /mnt

Ok, so a shutdown with a log flush to leave the log dirty. What is
in the log at this point?

> umount /mnt
> mount -o usrquota,grpquota,prjquota /dev/vdb2 /mnt
> 
> The last mount command get stuck on the following path:
> 
> [<0>] xlog_grant_head_wait+0x5d/0x2a0 [xfs]
> [<0>] xlog_grant_head_check+0x112/0x180 [xfs]
> [<0>] xfs_log_reserve+0xe3/0x260 [xfs]
> [<0>] xfs_trans_reserve+0x179/0x250 [xfs]
> [<0>] xfs_trans_alloc+0x101/0x260 [xfs]
> [<0>] xfs_sync_sb+0x3f/0x80 [xfs]
> [<0>] xfs_qm_mount_quotas+0xe3/0x2f0 [xfs]
> [<0>] xfs_mountfs+0x7ad/0xc20 [xfs]
> [<0>] xfs_fs_fill_super+0x762/0xa50 [xfs]
> [<0>] get_tree_bdev_flags+0x131/0x1d0
> [<0>] vfs_get_tree+0x26/0xd0
> [<0>] vfs_cmd_create+0x59/0xe0
> [<0>] __do_sys_fsconfig+0x4e3/0x6b0
> [<0>] do_syscall_64+0x82/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> By investigating it a bit, I noticed that xlog_grant_head_check (called
> from xfs_log_reserve), defines free_bytes as an integer, which in turn
> is used to store the value from xlog_grant_space_left().
> xlog_grant_space_left() however, does return a uint64_t, and, giving a
> big enough journal size, it can overflow the free_bytes in
> xlog_grant_head_check(),

I can see that an overflow definitely appears to be occurring, but I
cannot explain how it is occurring from the information in commit
message.

That is, the return value of xlog_grant_space_left() is supposed to
be clamped to 0 <= space <= log->l_logsize. If the return value is
out of that range, (i.e. can overflow a signed int) it means there
is some other problem with the xlog_grant_space_left() calculation
and the overflow of the return value is a downstream symptom and
not the root cause.

i.e. by definition xlog_grant_space_left() must be returning
free_bytes > log->l_logsize to overflow an int. The cause of that
behaviour is what we need to find and fix....

We should have enough trace points in the AIL and log head/tail
accounting to see where the head, tail or space calculation is going
wrong during the mount - do you have a trace from the failed mount
that I can look at?  i.e. run 'trace-cmd record -e xfs\* sleep 60'
in one terminal, then run the reproducer in another. Then when
the trace finishes, run `trace-cmd report > t.txt` and point me at
the generated report...

> in xlog_grant_head_check() to evaluate to true and cause xfsaild to try
> to flush the log indefinitely, which seems to be causing xfs to get
> stuck in xlog_grant_head_wait() indefinitely.
> 
> I'm adding a fixes tag as a suggestion from hch, giving that after the
> aforementioned patch, all xlog_grant_space_left() callers should store
> the return value on a 64bit type.
> 
> Fixes: c1220522ef40 ("xfs: grant heads track byte counts, not LSNs")

I'm not sure this is actually the source of the issue, or
whether it simply exposed some other underlying problem we aren't
yet aware of....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
