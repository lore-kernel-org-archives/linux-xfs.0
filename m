Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793267745;
	b=bdwvh9TcHJK1BGRplvlTaSXxsMl9s5dmhw/eWUQU79F6yzgmdem5YAZC+kra/m4ekjxB
	 YNZHhsapXyOun4cp1vLLy3WhLLYu1Q6Kdf6KwqvGUdOYQlwUYmwkIDNMiQftSANGbh8kj
	 6NRx7XWCPFfXvd3u/tUAAwEODmU7r6BaYjFs+rf/LUgXsQWHhUb2QC41KRCEVrqtz9fZA
	 vSyCqA3qgLIfAuM1oEP0bHWanMB1/8xUZoMtriZtO+AVWJHLb4siMa9Aaatt/rzifdi5W
	 w75ZxmHsFaLe/TnhA+f+niDodh4g5dk3QKTNuCZV0ptITf52MG/sFdgLqGgxUzVH5aQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267745;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding;
	bh=6EuRA6Wa/Tbcak5gCutLcN3mIMcymV3mFHDGbjX6Mr0=;
	b=KQlwGV7HNFkL1xuMnP5WVzJpJRwDScXRposC8RH18od100EoZP6bZ410kiAwFlfdjxKi
	 HzJyoltbkBcdo+93EEsRC4V+xpgXGHAYhhT/V+2tCGczNEIGNFhg2xIs0cm59Q21ng45S
	 U+nEaQ5wGawQn+DULNxAC+zvphjA0UIhk411taty2xOhNIackIAnFWvAg4Wv1E6PFD+h2
	 BdHv4sW36v+zJFaOWFGS4mRExWtmLSw1FyfpU+An1n4fbBfvYrlgMAfptq+V5UvdGaoUm
	 RZmpOk4vluyPGPU2nAFsVCcrMlm/VSC9v+DPP/6qUvUFHHOeoIRAUCO2uNEdMJgV/bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LnbJTDgg;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AgjGxZp0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CFD60A2605
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 09:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80CFD60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LnbJTDgg;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AgjGxZp0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793267743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6EuRA6Wa/Tbcak5gCutLcN3mIMcymV3mFHDGbjX6Mr0=;
	b=LnbJTDggM5gGOvG3rmTdZOnmfcQy25gyMIcVOqM5OP3uhLgK+UbMspq0Tb26ndKiEt32Pj
	YIlMnL8rGJnnCuT+YfiYuV0tQCpK9Rzi3cuPwqt+wCYrE1FMkGMoGXETriTh8Jz5EuHpEZ
	RTdt80rXIgpqDBOf5q/SB7wY+mNoYJc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-qjxWeAP7OL-9CvWDlTLZ-Q-1; Thu, 29 Oct 2026 05:55:41 -0400
X-MC-Unique: qjxWeAP7OL-9CvWDlTLZ-Q-1
X-Mimecast-MFC-AGG-ID: qjxWeAP7OL-9CvWDlTLZ-Q_1793267741
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1d43907c2so2508013a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 02:55:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793267740; cv=none;
        d=google.com; s=arc-20260327;
        b=I3BKt4pOYpnZQ80/fPDE6AUaBbIvAd0OEnnd+kSLpLRht4Njq9IpNSH5VAmfG+iXD1
         vVMB18Mlrb6oZxi6N1m+Vl0mqMHXqPYPufOIsgM3UzxtIP6RXu8yPehH9yTrVyZIeVSf
         J4+HQTFc3tcGRtgfsGiEZsU97IdYAnHa2fl1Kyds3e5JxigRjem0Ini2xQ5fYfAkxAq3
         DuRhd/ZEWSo3oR0GADdMca/dM01uZ3yKzcht63Y/U9vOtxJy5xACTEXrmvzDcowfg/sp
         MKurrsfc7V/1EAjmdHAKF6cC7+NQj6hyG3E1Vgd3Moh6OgRvpGA2xvWFkyKvwy5xiLYS
         GjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6EuRA6Wa/Tbcak5gCutLcN3mIMcymV3mFHDGbjX6Mr0=;
        fh=3HCPGF7ySt31hsLXMIkGfXLcUiwazIWtJJh/57wYVnM=;
        b=inlC3X1UE74YSz1Z8eIOH3jXJ0XkWfACNnMMgmF6hb+bgk06qd7ayfkY9BGndD7Zsu
         Vjmc1be/IuLshgaZMdot76bAf4tDGknfR05hCNxDi8OF1SHsG8r5JUpwlkuM+4xF6L4C
         sDypQk7reQTXf+6pHErEh8V2U7s14bUbuN9Qz3SVcgcqtOj9mhzOkBjl/mSeecyLg5ZH
         afMKaOCTsdRzz+bPVoljbIwYFgyCVXdFoPHIi8g+Xut5TWrWCPOeqepIOocJxkbUSBFa
         EiiRq20ba825HOGTtUG4ScGp39GHxq0enVt41z/Uq4w/reGQAVWN5A4oySMya22vOwCC
         43Kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793267740; x=1793872540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6EuRA6Wa/Tbcak5gCutLcN3mIMcymV3mFHDGbjX6Mr0=;
        b=AgjGxZp0fh+Ufv5JXingdZsN5U22WKHPlld/ZJtYB6FQFepBcjJ2OKOmIKcHHW59GJ
         naR8SC7FnwuDCOJezIoZyE1jxKjTGqoYk28d08mPpoVxyH1WEyJmkG9yU6ZD6Bw/IpMg
         Q/sYX8J0FBuw/HTJt1ETTUAR1encMbXaFkxpMwCPEy8u4VUzTgxydOO97Tx+E8sZSQzK
         RbmxIwHqtkvUmVm5TYZGA+uwQRk4ZjD+aZpPF/bcOOYU/LRWm66ZONoL2cwptgz1vuc3
         CA0z5ZAthLquDPgJMXhkF8h9fpMw+/kgidVx1O48qLOnFWfWcvhtYfSicgeVc8Qt18vZ
         hsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793267740; x=1793872540;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6EuRA6Wa/Tbcak5gCutLcN3mIMcymV3mFHDGbjX6Mr0=;
        b=cJLegtpnltjAHHFRf3RZCVVR3er8wtDfTKz25lF9k+8G6mt1IawfH+RwZAI/iUKWOH
         5XV9nV+VsMy87fswTyiqrsEGHFMddGKzWfqWCp6Me37Mklb7cJQ0cKWeS8SWsTO/79KO
         nFIyntFimwWhDJRcl/HJ87XIgyyBwKGD8mLqyakROgAyBM9SIfmHKqjOMd4S/jqtXbKw
         7raH08bfA6kXD688MFA/upee9sBUDrZcMH0RC6uquBv4qY/8tqxnjteANR2k2EeGF1/O
         HN/EWNIE1FRXX5pMNGuQonUXpE7jLHFsunNo7z8cjI6C39XGwiZ+QV+fm8hMcBjcpUsY
         BnLg==
X-Gm-Message-State: AFq9FYIHMS99nv1zhQeawia6+nt71QxQ5wylLcGQNCIxU/DnV9txFo4l
	pqT2EBKshwDlWZ4TAowNgoIawf1/FXLpiU8IAPYah1tiOBgIIcdK7COi51T29ucxZ/xcUvyv8/A
	cxi1shFHg/lQH4eUb9OJ5CB3QHNtVLWKjXgzRE5UGFM2yG2WNE3RPpKuUkdq6uOsI9shIoJDnYM
	yFToh2wr7j3ywc05/kDAH7Hp6jAyAMliWx9pPr
X-Gm-Gg: AYBFou3lE+qbMvrguSPXEMkHY7S9MGXM6PAWXaLBrojBmcPm54ghZ7hKCKq1sqTLSlN
	m5n0yCWpHE9yUpXgPRxXXo7zHl1kHFjUXTR3lyjCITNrAloavbp/SLHwPH+bEw8wbHyihHeTc3+
	g1O08lEHUMEPkPS9i5WBGJZ1aO9pZUgxgrUyi6CkJcqCVXmhTy4dOKdAi8C+qYhs4aJvKi13lLM
	GgebWqoIQfX2A4veCCSjchs0IR8qH589sZHSDPp5ixTjh1jBcXm6Eg4X2MpSucxmlOqz9IcmtQ=
X-Received: by 2002:a05:6402:4506:b0:6b3:d0e9:2e87 with SMTP id 4fb4d7f45d1cf-6b49caee1efmr3148260a12.5.1793267740489;
        Thu, 29 Oct 2026 02:55:40 -0700 (PDT)
X-Received: by 2002:a05:6402:4506:b0:6b3:d0e9:2e87 with SMTP id
 4fb4d7f45d1cf-6b49caee1efmr3148246a12.5.1793267739973; Thu, 29 Oct 2026
 02:55:39 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260819001442.1451892-1-dgc@kernel.org>
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
From: Ravi Singh <ravising@redhat.com>
Date: Thu, 29 Oct 2026 15:25:28 +0530
X-Gm-Features: AclHuK-8Kibk__Ahb2GKcLjZc9GeufGODGIHXI6tm4p09D98CNJJHG2-mG4QIX4
Message-ID: <CAF-d4Ov41k6eM_icGqMW4u_pNcPRXL_jK+rTbAzwN9Chfatryw@mail.gmail.com>
Subject: Re: [PATCH V2 00/38] XFS: Atomic multi-extent operations via rolling transactions
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 5:45=E2=80=AFAM Dave Chinner <dgc@kernel.org> wrote=
:
>
> Hi folks,
>
> This is the second version of the patchset intended to address
> long-standing races in extent manipulation operations throughput the
> IO path. This series addresses the underlying cause of the problem
> Darrick recently fixed in commit 2f4acd0fcd86 ("xfs: resample the
> data fork mapping after cycling ILOCK") - that extent manipulations
> are not atomic w.r.t.  each other and so can race in unexpected and
> unpredictable ways.
>
> This is not a new issue - these code paths have been a source of
> data corruption bugs for a long time. We have several outstanding
> bug reports for intermittent test failures caused by warnings or
> assert failures due to unexpected mismatches in extent state
> (delalloc, data/cow fork inconsistencies, state not matching cached
> imap state, etc) that have resisted attempts to reproduce reliably
> and/or find a root cause.
>
> Hence I decided that it would probably be a good idea to do the work
> necessary to try to address the underlying problems to try to get
> rid of this entire class of bug from the code.
>
> The first problematic pattern this patchset addresses is this:
>
>         - lock ILOCK
>         - map extent
>         - decide what to do
>         - unlock ILOCK
>         - allocate transaction
>         - lock ILOCK
>         - do what was decided
>         - commit transaction
>         - unlock ILOCK
>
> The issue is that the decision on what to do and actually doing it
> is occurring in separate ILOCK contexts - the decision and action
> are not atomic, leading to incorrect actions being taken.
>
> This is further exacerbated by the second problematic pattern -
> extent manipulations being executed in piece-wise manner and hence
> not being atomic with respect to the range over which the action is
> being performed. And example of this is unwritten IO completion. It
> performs a loop like:
>
>         for the range {offset, len} {
>                 - allocate transaction
>                 - lock ILOCK
>                 - convert next extent in range
>                 - update i_disk_size
>                 - commit transaction
>                 - unlock ILOCK
>                 - move offset forwards for next extent in range
>         }
>
> Hence we can have unwritten extent conversion interact with incoming
> writes mapping the same range using the first pattern, and they
> lock-step through the extents in the range and the extent map within
> the range changes with each ILOCK cycle on both sides. The inherent
> raciness of these operations means it is difficult to reason about
> them and the races have caused data corruption issues in the past.
>
> There are similar (but more complex) interactions with COW
> operations as conversion and fork updates are split across incoming
> writes, IO submission and IO completion.
>
> What this patch set is doing is making both patterns atomic with
> respect to the ILOCK. Code that uses the first pattern is adjusted
> to return all the way back to the start if a transaction is
> required. We then allocate a transaction and run the entire
> map-decision-modify operation under a single ILOCK context.
>
> For the second pattern, these are converted to use a rolling
> transaction so the ILOCK is held across the entire set of
> modifications whilst still maintaining the "one extent modification
> per transaction" structure of the operation. Whilst this was always
> possible with some operations, the operations that required a
> physical block reservation for every extent modification (e.g. for
> BMBT block allocation) require renewing the block reservation and
> hence can receive ENOSPC from those reservations.
>
> Historically speaking, handling errors from within rolling
> transactions has been problematic and usually results in a
> filesystem shutdown as we can't cancel a dirty transaction cleanly.
>
> Hence to turn these into rolling transactions we require the
> addition of a new transaction block reservation regrant mechanism
> that can safely return ENOSPC from within a rolling transaction
> context. This means we can only regrant block reservations when the
> transaction is clean.
>
> When we roll a transaction, we have a new transaction that is clean
> after commiting the old transaction, and so this provides a location
> for regranting block reservations whilst being able to handle an
> ENOSPC error safely. However, if we are in the middle of a defer-ops
> chain, we cannot safely unwind even though we have a clean
> transaction. i.e. the "atomic modification" of the extent
> modification has to complete fully before we can regrant block
> reservation space and handle ENOSPC.
>
> We only want to do this block reservation regrant when committing
> the final transaction that finishes deferops processing - the
> original reservation should already be sufficient for the entire
> deferops chain, and so by avoiding regrants in the middle of an
> intent processing chain we avoid seeing ENOSPC errors that would
> cause a shutdown. Hence we only process regrants at the top level
> commit in xfs_defer_finish().
>
> With this mechanism, we can convert the individual transactions in a
> loop like unwritten conversion to a rolling transaction that handles
> ENOSPC in exactly the same way that the individual transaction
> method does. This is how the series makes these multi-extent
> modifications atomic with respect to the ILOCK and hence other
> extent manipulations.
>
> The overall series addresses the most frequently hit instances of
> both patterns.  There are other code paths that have similar
> patterns that could be converted, but it's not immediately clear
> that any of them matter in any material way. If there are such
> instances, they can be addressed in future series.
>
> The patchset is made up entirely of LLM predicted code. I review it
> all and correct any errors, issues, concerns, etc immediately as
> each new hunk of code is predicted by the LLM to prevent errors from
> compounding and multiplying. Thus the code ends up the way I'd write
> it manually, not the way an unchecked LLM would vibe code it.
> Mistakes in the code are mine, not a result of an LLM being used to
> write the code.
>
> The series passed many iterations of the fstests auto group without
> regressions using a v6.19 XFS userspace, and it has survived several
> hundred iterations of the recoveryloop group without an unexpected
> failure.
>
> Feedback, comments and thoughts are welcome.
>
> -Dave.
>
> ----
>
> Version 2:
>
> - Fixed zoned gc remap reservation - needs two extent add
>   reservations because a remap involves two independent extent map
>   modifications.
> - Factored transaction block reservation code to minimise duplicate
>   accounting code.
> - reworked XFS_TRANS_RENEW_BLKRES implementation on top of this
>   factoring
> - New async blockgc flushing infrastructure to allow blockgc to be
>   triggered in ENOSPC/EDQUOT situations where waiting is not
>   possible (e.g. in transaction context).
> - Fix ILOCK leaks on the internal error paths in various
> transitionary state patches.
>
> Version 1:
> - https://lore.kernel.org/linux-xfs/20260729100629.1943710-1-dgc@kernel.o=
rg/
>
> ----
>
> LLM generated summary of the series:
>
> This series of 38 patches fixes several race conditions and bugs in the X=
FS
> extent manipulation code, then reworks the transaction handling to make
> multi-extent operations atomic with respect to the ILOCK.
>
> Bug fixes (patches 1-4):
>
> Four pre-existing bugs are fixed.
>
> A dirty transaction cancellation in xfs_bmapi_convert_one_delalloc() wher=
e
> xfs_iext_count_extend() could dirty a transaction before discovering ther=
e was
> nothing to convert, leading to a filesystem shutdown on the -EAGAIN cance=
l path.
>
> The same dirty transaction cancellation pattern in xfs_attr_set() is fixe=
d by
> moving the attr lookup ahead of xfs_iext_count_extend() so the transactio=
n is
> only dirtied once the operation is known to proceed.
>
> An isize update bug in xfs_iomap_write_unwritten() where i_disk_size was =
set to
> the end of the entire write range rather than the end of the actually con=
verted
> extent, potentially exposing zeroes after a crash.
>
> A block reservation bug in xfs_zoned_end_io() where the reservation only =
covered
> bmbt splits but not the deferred rmap and refcount btree operations, pape=
red
> over by the fragile XFS_TRANS_RES_FDBLKS workaround.
>
> Transaction reservation and async blockgc infrastructure (patches 5-8):
>
> The block reservation accounting in xfs_trans_reserve() is factored into
> reusable xfs_trans_reserve_blocks()/xfs_trans_unreserve_blocks() helpers =
to
> avoid duplicating the accounting code needed by the later regrant mechani=
sm.
> New asynchronous blockgc flushing infrastructure is added so that blockgc=
 can be
> kicked without waiting in contexts where blocking is not possible - in
> particular from within a transaction context holding the ILOCK, where a
> synchronous flush would deadlock against the blockgc workers.
> xfs_trans_reserve_more_inode() gains a retry loop that kicks async block =
and
> quota blockgc on ENOSPC/EDQUOT and retries after a short io_schedule_time=
out()
> rather than failing immediately.
>
> COW direct write atomicity (patches 9-19):
>
> The COW extent allocation path in xfs_direct_write_iomap_begin() is restr=
uctured
> so that the extent lookup and COW allocation are performed atomically und=
er a
> single ILOCK hold. Previously, the ILOCK was cycled between the extent lo=
okup
> and the allocation, leaving a window where racing DIO writes could modify=
 the
> extent tree and cause stale state bugs. Transaction allocation is lifted =
to the
> caller with a -EAGAIN retry mechanism, and xfs_reflink_fill_cow_hole() an=
d
> xfs_reflink_fill_delalloc() are converted to use rolling transactions via
> xfs_defer_finish() to keep the ILOCK held across their entire operation.
>
> Delalloc conversion atomicity (patches 20-22):
>
> The xfs_bmapi_convert_delalloc() loop, which converts delalloc extents to=
 real
> allocations, is converted from per-iteration transaction allocation to a =
single
> rolling transaction using xfs_defer_finish(). This makes multi-extent del=
alloc
> conversion atomic with respect to other concurrent extent operations.

I tested patches 1 and 20-22 (v2) on a 7.2.11 base, CONFIG_XFS_DEBUG, ppc64=
le.

I was checking whether they fix:
https://syzkaller.appspot.com/bug?extid=3D0ce92d16209e30011ebc

which I believe stems from the ILOCK being dropped/re-acquired between
xfs_buffered_write_iomap_begin() and xfs_bmapi_convert_delalloc().

After hours of generic/475 I still hit:
WARNING: fs/xfs/libxfs/xfs_bmap.c:4385 at
xfs_bmapi_convert_one_delalloc+0x4f8/0x6b0 [xfs]

i.e. WARN_ON_ONCE(whichfork !=3D XFS_COW_FORK) -- the data-fork lookup stil=
l
comes up empty.

Are these patches meant to stop this WARN for the data fork, or is that rac=
e
handled elsewhere in the series? Am I testing the wrong subset?

Thanks,
Ravi

> Block reservation renewal infrastructure (patch 23):
>
> New XFS_TRANS_RENEW_BLKRES transaction flag and xfs_trans_regrant_blkres(=
)
> mechanism that automatically restores the block reservation to its origin=
al
> level after xfs_defer_finish() processes deferred operations. This is nee=
ded for
> rolling transaction loops where each iteration requires a block reservati=
on for
> btree splits.
>
> Unwritten extent conversion atomicity (patches 24-25):
>
> The xfs_iomap_write_unwritten() loop, used for buffered writeback and DIO
> completion, is converted from per-iteration transaction allocation to a s=
ingle
> rolling transaction with XFS_TRANS_RENEW_BLKRES for automatic block reser=
vation
> renewal.
>
> COW IO completion atomicity (patches 26-28):
>
> The xfs_reflink_end_cow() loop is converted to a rolling transaction, mak=
ing COW
> extent remapping atomic. The xfs_reflink_end_cow_extent() wrapper is remo=
ved and
> the locked variant renamed since there is no longer an unlocked path.
>
> Zoned IO completion atomicity (patch 29):
>
> The xfs_zoned_end_io() loop is converted to a rolling transaction with th=
e
> corrected XFS_RTEXTENTADD_SPACE_RES() block reservation.
>
> Direct write iomap restructure (patches 30-38):
>
> The xfs_direct_write_iomap_begin() function is restructured with a unifie=
d
> do/while retry loop that handles both COW and non-COW allocation paths
> atomically. A new xfs_direct_write_args struct replaces the long paramete=
r lists
> throughout the call chain. The pNFS block allocation path is reworked to =
perform
> extent allocation and inode update in a single synchronous transaction. D=
ead
> internal transaction paths are removed from xfs_iomap_write_direct() and
> xfs_direct_write_cow_iomap_begin() now that all callers supply transactio=
ns.
>
> ----
>
> Diffstat:
>
>  fs/xfs/libxfs/xfs_attr.c        |  70 ++---
>  fs/xfs/libxfs/xfs_bmap.c        |  80 +++---
>  fs/xfs/libxfs/xfs_defer.c       |  38 ++-
>  fs/xfs/libxfs/xfs_shared.h      |   3 +
>  fs/xfs/libxfs/xfs_trans_space.h |  12 +
>  fs/xfs/scrub/cow_repair.c       |   4 +-
>  fs/xfs/scrub/quota_repair.c     |   2 +-
>  fs/xfs/scrub/rtbitmap_repair.c  |   2 +-
>  fs/xfs/scrub/tempfile.c         |   2 +-
>  fs/xfs/xfs_icache.c             | 172 ++++++++++---
>  fs/xfs/xfs_icache.h             |   2 +
>  fs/xfs/xfs_iomap.c              | 548 +++++++++++++++++++++++-----------=
------
>  fs/xfs/xfs_iomap.h              |  23 +-
>  fs/xfs/xfs_pnfs.c               | 117 +++++----
>  fs/xfs/xfs_reflink.c            | 313 +++++++++--------------
>  fs/xfs/xfs_reflink.h            |   6 +-
>  fs/xfs/xfs_trans.c              | 227 ++++++++++-------
>  fs/xfs/xfs_trans.h              |   7 +-
>  fs/xfs/xfs_zone_alloc.c         |  47 ++--
>  19 files changed, 957 insertions(+), 718 deletions(-)
>

