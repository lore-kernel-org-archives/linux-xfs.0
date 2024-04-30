Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5381798C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714453471; cv=none; b=jZ8/tgdOHu3DN+FCpgb0pJi8rRnYvNFU4Pqwy6NoV3OfEE/fG+1tfYYtE3YU2nkZ+fVGnXnGF7+in8E2fg9OA4apMENpM+L5ghzxzLTISeiNj6swRfgSImBtpirLzn4K0yCAUw0waEWuB2p3JbDxiv2YLHtRl2peuvwaZZoHJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714453471; c=relaxed/simple;
	bh=Gyiqjdft3kwboe6j67hA6giwCdKgP/Tn9HzDIUpANlM=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=ALEFQ0I0LnDv3TNl8WNVy8Fn2Zay1UlWo/vIPQAHReQrRtwN2c9P4LYTMGk0PDGUKSgFgJQ2RnAkIqdZ8RzsM5KkLvboCBNAQcFT7p6bVnnbRWwEEUJN8K+Nogi0SnO3B3R7PwaPblSG7lytcBYICPC3C77sARFuJ9w4Q+2tnJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PyhfMWmh; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PyhfMWmh"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f043f9e6d7so5397630b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 22:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714453469; x=1715058269; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YZZb5mDEPlXVuhF8iIebB9q7qRC3qdn+tymXYKsgyfc=;
        b=PyhfMWmhIh4CMHBpJ/4Up2wDuH+6RWBLwWWSTf8v1u0r1Qmv/OoexuEv+9ytEDnv4s
         aGh/D8EH8ZCKXnvK64LluTBptt6vM9UUYqH5GiAKGb+6Azod+zC8AyfERzaEbAQDWnBJ
         vDHp81MyZGAz0odEqVgO223lNCbQ5DfP7+LiiLwLcrmtA5uL69r4poTa5UHkpzeHvmgd
         tQ0vn+fl/ncUA0G/NStX8DQEYb8vfHyScb2tabmdEYQR99CLsOoxPdWWsWftmjwP2k32
         wYYkVU+Ypj1iTGee3/k+6dvsxXOdC4ch5UiYTJaly3eH8nefwAVMlke9I+pBv+t8sWKc
         lVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714453469; x=1715058269;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZZb5mDEPlXVuhF8iIebB9q7qRC3qdn+tymXYKsgyfc=;
        b=E2/eUVkLWEUXIOwG3NA70GSGXRpIJPWoFdn4HdPLl4F2Mi3nRLzgYVDUF86/9QS7Zb
         gWThxRNyJZIpAjWj9ClGo5gFPfyCgKHaprJcn9pZ6ELWs9jpcIJlPmZWJHu1wSpBl4d9
         +KQgd9/9bKmQkHh9EBex8tSpQR652B8u1v56Qi582rHgL+c5Jkpazbsb8ZR0Onpw71yV
         pvEhidPU94wEovtkQDi8lvUewWAn3o0xIVhGplnqCYsrAhAVO3tHnYr19mA59j25Yd71
         O1/6UM/jvlOTBMeIOT1521qiIpGPy7IuoKslcnBxau6/k2vww2bwQE0pjIfD5LvaZvi/
         aZFw==
X-Gm-Message-State: AOJu0Yxi8RWJ5qiYWk9U6Ofk5gyL0a2A2P24E4KHeQNapJgy6sYSRyUO
	iaMPxPOO3/rYm4C4u+q+pa2tcOn2PvHg84OcjO6nA198oZOHReQk
X-Google-Smtp-Source: AGHT+IEFhTV8Uh6RgFSxtO2FMkHrg2H0KTdqPJerfxJWCvSbQ9Zz25z6KIFCGgxKXXQi0cHkrRvGyA==
X-Received: by 2002:a05:6a00:2d8e:b0:6f3:1be8:ab68 with SMTP id fb14-20020a056a002d8e00b006f31be8ab68mr1560598pfb.32.1714453469276;
        Mon, 29 Apr 2024 22:04:29 -0700 (PDT)
Received: from dw-tp ([171.76.84.250])
        by smtp.gmail.com with ESMTPSA id p25-20020aa78619000000b006e647716b6esm20901940pfn.149.2024.04.29.22.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 22:04:28 -0700 (PDT)
Date: Tue, 30 Apr 2024 10:34:24 +0530
Message-Id: <87le4vxwyv.fsf@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv2 1/1] xfs: Add cond_resched in xfs_bunmapi_range loop
In-Reply-To: <20240429151146.GU360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Mon, Apr 29, 2024 at 02:14:46PM +0530, Ritesh Harjani wrote:
>> "Ritesh Harjani (IBM)" <ritesh.list@gmail.com> writes:
>> 
>> > An async dio write to a sparse file can generate a lot of extents
>> > and when we unlink this file (using rm), the kernel can be busy in umapping
>> > and freeing those extents as part of transaction processing.
>> > Add cond_resched() in xfs_bunmapi_range() to avoid soft lockups
>> > messages like these. Here is a call trace of such a soft lockup.
>> >
>> > watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
>> > CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
>> > Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
>> > NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
>> > LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
>> > Call Trace:
>> >   xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>> >   xfs_alloc_compute_aligned+0x5c/0x144
>> >   xfs_alloc_ag_vextent_size+0x238/0x8d4
>> >   xfs_alloc_fix_freelist+0x540/0x694
>> >   xfs_free_extent_fix_freelist+0x84/0xe0
>> >   __xfs_free_extent+0x74/0x1ec
>> >   xfs_extent_free_finish_item+0xcc/0x214
>> >   xfs_defer_finish_one+0x194/0x388
>> >   xfs_defer_finish_noroll+0x1b4/0x5c8
>> >   xfs_defer_finish+0x2c/0xc4
>> >   xfs_bunmapi_range+0xa4/0x100
>> >   xfs_itruncate_extents_flags+0x1b8/0x2f4
>> >   xfs_inactive_truncate+0xe0/0x124
>> >   xfs_inactive+0x30c/0x3e0
>> >   xfs_inodegc_worker+0x140/0x234
>> >   process_scheduled_works+0x240/0x57c
>> >   worker_thread+0x198/0x468
>> >   kthread+0x138/0x140
>> >   start_kernel_thread+0x14/0x18
>> >
>> 
>> My v1 patch had cond_resched() in xfs_defer_finish_noroll, since I was
>> suspecting that it's a common point where we loop for many other
>> operations. And initially Dave also suggested for the same [1].
>> But I was not totally convinced given the only problematic path I
>> had till now was in unmapping extents. So this patch keeps the
>> cond_resched() in xfs_bunmapi_range() loop.
>> 
>> [1]: https://lore.kernel.org/all/ZZ8OaNnp6b%2FPJzsb@dread.disaster.area/
>> 
>> However, I was able to reproduce a problem with reflink remapping path
>> both on Power (with 64k bs) and on x86 (with preempt=none and with KASAN
>> enabled). I actually noticed while I was doing regression testing of
>> some of the iomap changes with KASAN enabled. The issue was seen with
>> generic/175 for both on Power and x86.
>> 
>> Do you think we should keep the cond_resched() inside
>> xfs_defer_finish_noroll() loop like we had in v1 [2]. If yes, then I can rebase
>> v1 on the latest upstream tree and also update the commit msg with both
>> call stacks.
>
> I think there ought to be one in xfs_defer_finish_noroll (or even
> xfs_trans_roll) when we're between dirty transactions, since long
> running transaction chains can indeed stall.  That'll hopefully solve
> the problem for bunmapi and long running online repair operations.
>
> But that said, the main FICLONE loop continually creates new transaction
> chains, so you probably need one there too.

We need not right, as long as we have one in xfs_defer_finish_noroll(),
because we commit everything before returning from
xfs_reflink_remap_extent(). And we do have XFS_TRANS_PERM_LOG_RES set,
so xfs_defer_finish_noroll() should always be called. 
(Apologies, if I am not making sense. I new to XFS code)

I gave generic/175 an overnight run with cond_resched() call inside
xfs_defer_finish_noroll() loop. I couldn't reproduce the soft lockup bug.

So does it sound ok to have cond_resched() within
xfs_defer_finish_noroll(). I can submit the new version then.

This should solve the soft lockup problems in both unmapping of extents
causing large transaction chains and also reflink remapping path.

> Hence the grumblings about cond_resched whackamole.
> Thoughts?

Yes, I agree that life will be easy if we don't have to play with the
hacks of putting such calls within tight loops. But until we have such
infrastructure ready, I was hoping we could find a correct fix for such
problems for current upstream and old stable kernels.


Thanks for the review and suggestions!

-ritesh
