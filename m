Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E389718C011
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747261022; cv=none; b=CWdTjUC3wxdqncxE1P9hihkYpTS743dym1fXTXI0vLHpRlrgO1wW4x3SxTQzf7Vfn660f7fmToeg4WTVbs6tDeMqDgQ6/B10Wb1ePDORpL89/aElwZcvt5cBdHTfxnTpZbUBdDDp5QAcpLKFPbssO+MiikKzhDtAJNCsnlbPolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747261022; c=relaxed/simple;
	bh=PkrQTx8TEbBB1JrAOdOjyVlxp0j9o3FA7f6jcBYQ/MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lksGazZx9xA12AUznIZuUStJNniuLSOGjwUthz4O9dRYiHebq9fBt1naPLXHVHKJz+/3EsOJjcwiWjnNG+kWfNivd/u09b2YwPSAXnlB4ze1smKWSwQtuHJyWPXIQnWY5IDE0SnNaZ4ixASR3izL0LC6w5+Qm1iqTuLvw0VxtCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DvbM47jE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DvbM47jE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22e4d235811so3887745ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 15:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1747261020; x=1747865820; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mTXW/b5AGrSthg3xhTu8NtwS/HDi+o41c2Sy8mzRhBM=;
        b=DvbM47jEIrBpj+68ChRKpB94OLsP+SgPs+FHteoTF3UJuS/Ugbp4nnYhsKeHknJcGK
         tMT8jTm8+63gaPdO/rHBoRsDEwHSoUnlLdq6nYQYnfFl4uHjxHEoUjxWqao0BCLIUfyP
         OomJQtEkZhST1QAA2idEH8izxGHnLoMZNhP2n+Z5/DPdVkyv55XKhU+lCeIWGO16gTCG
         k8N+c/YLKoymTXLShwv3bj9dfRvMoHV/h2HIXaLqcHbl3zyW95FS0yZW56EtpdA+oqVv
         /twFKYXxDwZH6wyuQ44WLViaRBSDVZtamYkm45x+kkGum1LmutBwAdFaj960vokijd9L
         wr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747261020; x=1747865820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTXW/b5AGrSthg3xhTu8NtwS/HDi+o41c2Sy8mzRhBM=;
        b=NRa9zCtI1sfltMxQSnRAkEIkTaGrPIy1JRVb2v63yPOunmI2mqB6Tj/tjnlYFVngf/
         JqtiQ0oQzfwTPyMFEDCt86TjvFoGbO8w82VD0Tr90tJZwScUEi53GOpZPUo7xqo9mGXE
         r+tyVucicUDfQA79+wGZkVAvt/u24NtmOYpzcifd/QdwIn78k8cBIfCd7gp6y3kQD7nZ
         u2LvkGaimavYjngloSHC68TjGOsBQtB1yNFwo9hrXOsqJ//2BLPLXpXoKzPUqJ+fTyhc
         rFLLrJr0A8NKfEr1X4qXXqmsjdlmR6qjwWkEfrkv3Q950v5QODt8l056J7qo58SdQKRV
         WTfA==
X-Forwarded-Encrypted: i=1; AJvYcCWYXOqAuJlaoUoYBjBT9+WQ7liTLBQwgO6+lSQ+b5EjPA6jB41L9/AYL/FsfLkHUabHTFg/whMeIqA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw3W6hM4YM4yYmR3Eu3qhHRKtHLqg5wIm3x4slMouN7vALzT+C
	IOtsQB4kD7Zc7nFKyF0PBV0Er2YceUtOqa7Lffb2iF2XHlLuiTbDM8WASS17ptg=
X-Gm-Gg: ASbGncvMiSMtLvXznG1OscPQbOYTQc0Q7pXgDjZmBMH3cV4MscWohtrCxv7sMH+AhOB
	QizWWpGVFAsDjTu3vobwdXTlK2+mtSy3TrSc/On0kSkiVXn0fpoziHm1qayw8o2yMayQ0IKlOTr
	eeQpBL7dYef2bvpSfvCHfaLvwQep2rADUg/FDGS00PD8GrpqEA054WZZYYtMvPSj//JhWoxpH0C
	hUqX8ZebyaQK7Z3jo18uV8776E42lr+9uNnvRq002pwTf8ZSfpgzRCaG9jfCZCp9gtkQLwkwM3s
	hU1w2pvkRfOGhOctf/VP/EBEBWzvv/6UIzOn3c24cHgXFikkw/aN1yr8Z7KH/XD5jUynG1DJLva
	Ay/rqwUiqFSmnuVnsX7kVEdMoH4I=
X-Google-Smtp-Source: AGHT+IFtcfkKFcQ1y+IU/YHQJ/jTy6H/ktxEDim05gdbCjo9IqgU4jwoQElOEDUYKNcIwPuaGsEN6A==
X-Received: by 2002:a17:902:e747:b0:224:a96:e39 with SMTP id d9443c01a7336-2319810e266mr67798885ad.9.1747261019967;
        Wed, 14 May 2025 15:16:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc8271c17sm104954665ad.121.2025.05.14.15.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 15:16:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uFKPI-00000003ZxT-1fNQ;
	Thu, 15 May 2025 08:16:56 +1000
Date: Thu, 15 May 2025 08:16:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: cen zhang <zzzccc427@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, zhenghaoran154@gmail.com
Subject: Re: Subject: [BUG] Five data races in in XFS Filesystem,one
 potentially harmful
Message-ID: <aCUWWBmhAOFHDszj@dread.disaster.area>
References: <CAFRLqsVtQ0CY-6gGCafMBJ1ORyrZtRiPUzsfwA2uNjOdfLHPLw@mail.gmail.com>
 <aCSX29o_xGAUWtIl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCSX29o_xGAUWtIl@infradead.org>

On Wed, May 14, 2025 at 06:17:15AM -0700, Christoph Hellwig wrote:
> > 1. Race in `xfs_bmapi_reserve_delalloc()` and  `xfs_vn_getattr()`
> > ----------------------------------------------------------------
> > 
> > A data race on `ip->i_delayed_blks`.
> 
> This is indeed a case for data_race as getattr is just reporting without any
> locks.  Can you send a patch?

No, please don't play data_race() whack-a-mole with
xfs_vn_getattr().

Please introduce infrastructure that allows us to mark entire
functions with something like __attribute__(data_race) so the
sanitiser infrastructure knows that all accesses within that
function are known to be potentially racy and should not be warned
about.

We can then mark every ->getattr method in every filesystem the same
way in a single patch, and knock out that entire class of false
positive in one hit. That's a much more efficient way of dealing
with this problem than one false positive at a time.

> > 2. Race on `xfs_trans_ail_update_bulk` in `xfs_inode_item_format`
> > -------------------------------------.
> > 
> > We observed unsynchronized access to `lip->li_lsn`, which may exhibit
> > store/load tearing. However, we did not observe any symptoms
> > indicating harmful behavior.
> 
> I think we'll need READ_ONCE/WRITE_ONCE here to be safe on 64-bit
> systems to avoid tearing/reordering.  But that still won't help
> with 32-bit systems.

We had problems with LSN tearing on 32 bit systems 20-odd years ago
back at SGI on MIPS Irix systems. This is why
xfs_trans_ail_copy_lsn() exists - LSNs are only even updated under
the AIL lock, so any read that might result in a critical tear (e.g.
flush lsn tracking in inodes and quots) was done under the AIL
lock on 32 bit systems.

> Other lsn fields use an atomic64_t for, which
> is pretty heavy-handed.

They use atomic64_t because they aren't protected by a specific lock
anymore. This was not done for torn read/write avoidance, but for
scalability optimisation. There is no reason for lip->li_lsn to be
an atomic, as all updates are done under the same serialising lock
(the ail->ail_lock).

As for reordering, nothing that is reading the lip->li_lsn should be
doing so in a place where compiler reordering should make any
difference. It's only updated in two places (set on AIL insert,
cleared on AIL remove) and neither of these two things will race
with readers using the lsn for fsync/formatting/verifier purposes.

I think that even the old use of xfs_trans_ail_copy_lsn() is likely no
longer necessary because flushing of dquots/inodes and reading the
LSN are now fully gated on the objects being locked and unpinned. The
LSN updates occur whilst the object is pinned and pinning can
only occur whilst the object is locked. Hence we -cannot- be doing
simultaneous lip->li_lsn updates and reading lip->li_lsn for
formatting purposes....

We extensively copy LSNs into the V5 on disk format with "racy"
reads and these on disk LSNs are critical to correct recovery
processing. If torn lip->li_lsn reads are actually happening then we
should be seeing this in random whacky recovery failures on
platforms where this happens. The V5 format has been around for well
over a decade now, so we should have seen somei evidence of this if
torn LSN reads were actually a real world problem.

> > Function: xfs_alloc_longest_free_extent+0x164/0x580
> 
> > Function: xfs_alloc_update_counters+0x238/0x720 fs/xfs/libxfs/xfs_alloc.c:908
> 
> Both of these should be called with b_sema held.

Definitely not. Yes xfs_alloc_update_counters() must be called with
the AGF locked, but that's because it's -modifying the AGF-. The
update of the perag piggybacks on this so we don't lose writes. i.e.
we get write vs write serialisation here, we are explicitly not
trying to provide write vs read serialisation.

That's because the AG selection algorithm in
xfs_bmap_btalloc_select_lengths() is an optimistic, unlocked
algorithm. It always has been. It uses the in-memory
pag variables first to select an AG, and we don't care if we race
with an ongoing allocation, because if we select that AG we will
recheck the selection (i.e. the free space info in the pag) once
we've locked the AGF in xfs_alloc_fix_freelist().

IOWs, this is simply another unlocked check, lock, check again
pattern. it's a lot further apart than your typical single logic
statement like:

	if (foo) {
		lock(foo_lock)
		if (foo) {
			/* do something */
		}
		unlock(foo_lock)
	}

But it is exactly the same logic pattern where no binding decision
is made until all the correct locks are held.

As I've already said - the patterns are endemic in XFS. They may not
be as obvious as the common if - lock - if structure above, but
that's just the simplest form of this common lock avoidance pattern.

IOWs, these data races need a lot more careful analysis and
knowledge of what problem the unlocked reads are solving to
determine what the correct fix might be.

To me, having to add READ_ONCE() or data_race() - and maybe comments
- to hundreds of variable accesses across the code base adds noise
without really adding anything of value. This isn't finding new
bugs - it's largely crying wolf about structures and algorithms we
intentionally designed to work this way long ago...

> Does your tool
> treat a semaphore with an initial count of 1 as a lock?  That is still
> a pattern in Linux as mutexes don't allow non-owner unlocks.

If it did, then the bp->b_addr init race wouldn't have been flagged
as an issue.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
