Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88314EC56
	for <linux-xfs@vger.kernel.org>; Wed, 29 May 2024 00:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716942522; cv=none; b=p1Jh4Gx47NAOBKhSfaivqV+hs7sDBH22rEImauJ+eNlUHV5Puyxhohq8rpKR5c/6iptztlBcKnD/aX/PY9IpNweNvTaoGFid5Aghvkdi+jOHGLU4TXDZSPts5wlpA2IK4yDYXO2R4hjQ3HtGttPBBLoLwrCCsuGBSgs/SV5ewpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716942522; c=relaxed/simple;
	bh=yCC2XhdoqcrVGPVCuuGH8xc+X7lrIWtkAzs8ln3HmvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rrpfj1H2W87fIaOnUCLM3cNpsPKiyHhxBdu4aEgNu82dWmVZD4rUNRpbaPTy2Jz6PVje4L+ChX+Lg2vaV0iFQxvt4p7XjIdC6Rxrbk+1OP+3rdQCYnEdpDoTctF5HyieBGO9WmMlNTjt2NH4jeVpCWQYxB1snimYISuNIGl4hPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bcVG4bbz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bcVG4bbz"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f44b42e9a6so11959745ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 May 2024 17:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716942520; x=1717547320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1c9G1Yasw8H462EyOiSehnDLVP9jP7KmNiDzPxioqSM=;
        b=bcVG4bbzPffUJ9a1vsCUPfHHsUlQYfch95/Fn3dwGqZXwkOyHjdm6ftWU5IPmyLwX9
         EcLrk+oyiB2uESqRQXA26J102VxfYZA4H1NiQ+Di+DJrgHrLoXtq8k2yweD+SpqR1PB1
         O5krVgrm/PSHDjknVEcRZETCezvCKhRPmz9yJyxVNU0SIzRJcotS0owEnvmD5vK+uY73
         CCo39PzeLIqYjIir0PkDXWnNLzw/rRrGrs8IfoobHaEVveU700RP8vJL4MpVU/rPZpDE
         ltP4jujFS5OgFuwGIpRg+GLRvvBCks7T51pNSdlgtB2gOv3aGg/V1NUARp8oxs5GX2Va
         jJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716942520; x=1717547320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1c9G1Yasw8H462EyOiSehnDLVP9jP7KmNiDzPxioqSM=;
        b=AdnivHW/ZRoL8RQlMKlRs58GD1C6XE54c15Y3hW0nP5IjIXfh5cRLfnDpmX7lzNlW0
         9yD1+44tpboaqfAswQfmF9PgIOiaJ1KDTVbtlwor7HBRrhvIF+GNLl67fdR8+kHlrHZ3
         J/HCb/NUH4pgRzI1zy2QpzE8YloHCnpLEUZ+kBnrx5W4adjBG6s9zlUjPEJ6NUxtDF9s
         JTfZi/KgmOQpUbEQMEyu3IAckFNHydJTBy96F/B+tBNIYBvgfIjOhl/FYr+tpUtJENH9
         nlLHi1UgGK94eism9EZJTE3CPREz4prpiQPHtIuLM2EhU9binqB/XkKQXBH2svNGDaPs
         QeYg==
X-Gm-Message-State: AOJu0YyY/8qIlb7XNC4y2vWYRK5i3i4zit5SmNguZsLNfHZe6DnWzUHz
	mRq13k6/nZNwpK4WjS4qpbrjbmVqAnoBT4sST0bRcjhLoYFHQ8bbZwaqUy9zNlbJ7whBvWqKer8
	v
X-Google-Smtp-Source: AGHT+IErol/Kf7s7IaV5INq5x9HrKvgHUI68JV/sh0AcH0N8qryzCBp/1solrCqXc/0XR6QAWHV1RQ==
X-Received: by 2002:a17:902:ecc7:b0:1f4:8190:33a5 with SMTP id d9443c01a7336-1f481903723mr100631945ad.56.1716942520407;
        Tue, 28 May 2024 17:28:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c967ab5sm86402065ad.162.2024.05.28.17.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 17:28:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sC7BF-00E344-0H;
	Wed, 29 May 2024 10:28:37 +1000
Date: Wed, 29 May 2024 10:28:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: avoid redundant AGFL buffer invalidation
Message-ID: <ZlZ2tfqvagRusmVv@dread.disaster.area>
References: <1b2be7fa-332d-4fab-8d36-89ef7a0d3a24@linux.alibaba.com>
 <20240528041239.1190215-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528041239.1190215-1-hsiangkao@linux.alibaba.com>

On Tue, May 28, 2024 at 12:12:39PM +0800, Gao Xiang wrote:
> Currently AGFL blocks can be filled from the following three sources:
>  - allocbt free blocks, as in xfs_allocbt_free_block();
>  - rmapbt free blocks, as in xfs_rmapbt_free_block();
>  - refilled from freespace btrees, as in xfs_alloc_fix_freelist().
> 
> Originally, allocbt free blocks would be marked as stale only when they
> put back in the general free space pool as Dave mentioned on IRC, "we
> don't stale AGF metadata btree blocks when they are returned to the
> AGFL .. but once they get put back in the general free space pool, we
> have to make sure the buffers are marked stale as the next user of
> those blocks might be user data...."
> 
> However, after commit ca250b1b3d71 ("xfs: invalidate allocbt blocks
> moved to the free list") and commit edfd9dd54921 ("xfs: move buffer
> invalidation to xfs_btree_free_block"), even allocbt / bmapbt free
> blocks will be invalidated immediately since they may fail to pass
> V5 format validation on writeback even writeback to free space would be
> safe.
> 
> IOWs, IMHO currently there is actually no difference of free blocks
> between AGFL freespace pool and the general free space pool.  So let's
> avoid extra redundant AGFL buffer invalidation, since otherwise we're
> currently facing unnecessary xfs_log_force() due to xfs_trans_binval()
> again on buffers already marked as stale before as below:
> 
> [  333.507469] Call Trace:
> [  333.507862]  xfs_buf_find+0x371/0x6a0       <- xfs_buf_lock
> [  333.508451]  xfs_buf_get_map+0x3f/0x230
> [  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
> [  333.509751]  xfs_free_agfl_block+0xa1/0xd0
> [  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
> [  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
> [  333.511871]  xfs_defer_finish+0xc/0xa0
> [  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
> [  333.513253]  xfs_inactive_truncate+0xb8/0x130
> [  333.513930]  xfs_inactive+0x223/0x270
> 
> xfs_log_force() will take tens of milliseconds with AGF buffer locked.
> It becomes an unnecessary long latency especially on our PMEM devices
> with FSDAX enabled and fsops like xfs_reflink_find_shared() at the same
> time are stuck due to the same AGF lock.  Removing the double
> invalidation on the AGFL blocks does not make this issue go away, but
> this patch fixes for our workloads in reality and it should also work
> by the code analysis.
> 
> Note that I'm not sure I need to remove another redundant one in
> xfs_alloc_ag_vextent_small() since it's unrelated to our workloads.
> Also fstests are passed with this patch.
> 
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> changes since v1:
>  - Get rid of xfs_free_agfl_block() suggested by Dave;
>  - Some commit message refinement.
> 
>  fs/xfs/libxfs/xfs_alloc.c | 28 +---------------------------
>  fs/xfs/libxfs/xfs_alloc.h |  6 ++++--
>  fs/xfs/xfs_extfree_item.c |  4 ++--
>  3 files changed, 7 insertions(+), 31 deletions(-)

Looks fine - it appears to me that all the places that put blocks
onto the freelist will have already invalidated any buffers over
those blocks, so we don't need to do it again when moving them from
the freelist to the freespace btrees.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
