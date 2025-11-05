Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E37350A1E
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 21:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762376717; cv=none; b=kdHhwewDmnkhwNNPSOqYEci3g0nbCqbU1b1PHp6xBRYDLSXfM/kGOEbvUzfnMLpkPDvfXHGldRNXnDUXDIPJCJFJtegnx+xd/eEaQzwe06LJ6yExBQL7+5PiywLiMiXISy8yWtHwt+Nt9F5DSTT4QsFMJ/V5yGun5u2/or4QY7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762376717; c=relaxed/simple;
	bh=Zqi+EHmX8VZ+NkKDW9UECLa1+dxq+lcDC+4j5twTOGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pq12R/mgQgUt5HZzu9ml5IjNNqGTF6NSyhtLV7fXvH+WWwGDMI638N4EDh+rNSo5dQ7HZ2hxr7mf56Ig56FrLbHHvgMMc5KirHqCGcPIdBySevwwshSM1RnfIRLn+cJ6O+ygxskNXKr6b0Ekl4tp7XmKXf8oWe7IbfEEF/esQlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=GI6+o2nG; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="GI6+o2nG"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34188ba567eso282402a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Nov 2025 13:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762376715; x=1762981515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BIo9xG17G3j8cmERq65unkBP4qd3kgxiEc/63J8rEPg=;
        b=GI6+o2nG/KvDqkEGg1Gn+K7SmY7+axp3zjqOP8g2SnVKPdQClvng0O97pyYomlVyM6
         lYkbd4NSXPMiEjVoaNKu0dM2pGqoKBBd8W4Vn08K9BH9MCAX7eBhMwU2TubjN6M0ObVM
         0lpvMJkyEqExZdZUqpL09LdDJ9gSL/bD91aw++yTIkzIWKIDbfCk5Sl/U4JVlYFGapzq
         /FhvyzOk4pNtNFvD0bz6ztwC13fAc9ZEm6BcMMBuJmPj5I+rg5cfGH/4D2GmigWeDcVa
         ePjbnB3p7Yz5DNkjisH95cG9Nr2fVmW3MIKjHuXwGAoZUJCstcEZ4Pf9D9lo8DKfkA6q
         Jnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762376715; x=1762981515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BIo9xG17G3j8cmERq65unkBP4qd3kgxiEc/63J8rEPg=;
        b=O5aZJOu+mwPbhMkD/hZxo7GnYDgt0Tu0go0E1gGrC9UwG4xfJS19cQoGILV89LodjJ
         1+5Tjbefi9x1AZRwiZI+gV1h+W/Ln9KSRgWg2nziVyag6j5F5/M4y8H0LySFDi26MC1b
         t+5aYRP/By7dD++tXEeV36mi81t3+nLTVc5NLgx1WEu2Zd8+IoKh0yR7/vDdrUE2jJ+e
         Rxbg8XmjZV7bKUhEQF2QvKyXIDgXShXJ0AUhC+hNEEoYlzigrtS5Sb2x8GD8msmIvL7j
         rde+43oDhfvohKk8PgIsTACSeMmbZ2cQ4dYp3DmbReroV6yylrmYJPFJAKHyh+n3V2CA
         aRjg==
X-Gm-Message-State: AOJu0YyHd0mtP7zdrOjYP8zlv8nZfKUXbhURGE5qqFXbKcTERU9bqQgE
	iSt8TpS9jD34+ImRt2MgYukb9KwfbH/bC25p+s6LdSYZnt9KqS+aiHbqPh5gOujwSCbffKHI7VC
	YyZA9
X-Gm-Gg: ASbGncsqGksq7+IepaaRpGFy88kzhsqn3GfTkZS9yVV35o+NkMSWrssahkOXUCZd+TK
	6GTAWhyXxY7g5KsKWk4QdLDzJqq3QcA/vMjjlvPbw5yOc71aWRjqvJIlwu/KooZqWCNOgUgY1Vw
	HE1vWDLN0ybCJrWDNH1JJEsLryShDaaTf6Ffz9DGBn3SG/U5GS9zYUEYc3y+B2JaEVej/obI2Fq
	5XzOPjsRvPeS/+kNSmHbk2DRrvdx+nRy3c/sERclkkcoXjDiqjfEv15clRv5bi7meF504i0oEsG
	hKyuWC5Ew/qKwYb261/mmpc40yFZXgJBOM2UmJlBp0KNmEvC2gb+DflE2ivVwaHzwzP3cCiO1mY
	krE6xyUTFF+tcnPKpiLlmbTgKKmJzaU2QL+dvcb9pD7V19XcLHWwBzt2NQiKqXPuhLSYrk1WVbI
	y+JZ4v3/pNk+5H0oQSheVNOOkKcHSVyFZ55HxFP/r/xgifqIBKaI8=
X-Google-Smtp-Source: AGHT+IFk9/GHHLVjzQ6wdwGOe2R5pZXfbIvNxS2I1p9ArqiF2j+26xJKWXmOOx8LdVKc1NsF1oq8YQ==
X-Received: by 2002:a17:902:f546:b0:270:4964:ad82 with SMTP id d9443c01a7336-2962ad88b8fmr69118615ad.38.1762376714881;
        Wed, 05 Nov 2025 13:05:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c7c5ccsm4459745ad.57.2025.11.05.13.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 13:05:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vGkgp-00000006tZD-1ys8;
	Thu, 06 Nov 2025 08:05:11 +1100
Date: Thu, 6 Nov 2025 08:05:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: fs-next-20251103 reclaim lockdep splat
Message-ID: <aQu8B63pEAzGRAkj@dread.disaster.area>
References: <aQux3yPwLFU42qof@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQux3yPwLFU42qof@casper.infradead.org>

On Wed, Nov 05, 2025 at 08:21:51PM +0000, Matthew Wilcox wrote:
> In trying to bisect the earlier reported transaction assertion failure,
> I hit this:
> 
> generic/476       run fstests generic/476 at 2025-11-05 20:16:46
> XFS (vdb): Mounting V5 Filesystem 7f483353-a0f6-4710-9adc-4b72f25598f8
> XFS (vdb): Ending clean mount
> XFS (vdc): Mounting V5 Filesystem 47fa2f49-e8e1-4622-a62c-53ea07b3d714
> XFS (vdc): Ending clean mount
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.18.0-rc4-ktest-00382-ga1e94de7fbd5 #116 Tainted: G        W
> ------------------------------------------------------
> kswapd0/111 is trying to acquire lock:
> ffff888102462418 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x14b/0x2b0
> 
> but task is already holding lock:
> ffffffff82710f00 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x3e0/0x780
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        fs_reclaim_acquire+0x67/0xa0
>        __kmalloc_cache_noprof+0x4d/0x500
>        iomap_fill_dirty_folios+0x6b/0xe0
>        xfs_buffered_write_iomap_begin+0xaee/0x1060
>        iomap_iter+0x1a1/0x4a0
>        iomap_zero_range+0xb0/0x420
>        xfs_zero_range+0x54/0x70
>        xfs_file_write_checks+0x21d/0x320
>        xfs_file_dio_write_unaligned+0x140/0x2b0
>        xfs_file_write_iter+0x22a/0x270
>        vfs_write+0x23f/0x540
>        ksys_write+0x6d/0x100
>        __x64_sys_write+0x1d/0x30
>        x64_sys_call+0x7d/0x1da0
>        do_syscall_64+0x6a/0x2e0
>        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> -> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
>        __lock_acquire+0x15be/0x27d0
>        lock_acquire+0xb2/0x290
>        down_write_nested+0x2a/0xb0
>        xfs_ilock+0x14b/0x2b0
>        xfs_icwalk_ag+0x517/0xaf0
>        xfs_icwalk+0x46/0x80
>        xfs_reclaim_inodes_nr+0x8c/0xb0
>        xfs_fs_free_cached_objects+0x1d/0x30
>        super_cache_scan+0x178/0x1d0
>        do_shrink_slab+0x16d/0x6a0
>        shrink_slab+0x4cf/0x8c0
>        shrink_node+0x334/0x870
>        balance_pgdat+0x35f/0x780

As I said on #xfs: false positive on the inode lock.

Reclaim is running in GFP_KERNEL context, so it's allowed to lock
unreferenced inodes.

The inodes that the allocation context holds locked are referenced
inodes, so it cannot self-deadlock on the inode locks it holds
because reclaim does not access or lock referenced inodes.

That being said, looking at this patch:

https://lore.kernel.org/linux-xfs/20251003134642.604736-4-bfoster@redhat.com/

I think the allocation that iomap_fill_dirty_folios() should
probably be using mapping_gfp_constraint(mapping, GFP_KERNEL) rather
than a hard coded GFP_KERNEL allocation. This is deep in the
buffered write path and the xfs ILOCK is held when
iomap_fill_dirty_folios() and it does folio lookups in that
context.

Huh - that kinda feels like a lock order violation. ILOCK is not
supposed to be held when we do page cache operations as the lock
order defined by writback operations is folio lookup -> folio lock
-> ILOCK.

So maybe this is a problem here, but not the one lockdep flagged...

Brian?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
