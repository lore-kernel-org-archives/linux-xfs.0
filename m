Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C735313B59E
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715066576; cv=none; b=BOMw1yUOweCX2gGiLpeilDJ4z302y7qocD16a1sLOVIJgNv4U0qowvPF/+pyBgP2c8GxpSjeBm1jKqrXivIW7G92eUTNiQ3jI4Z0z1VJXFwMbUlym40RwGP4/nWBBfLeHcIhaavbfdJ7np2ae38j6iUC+e14I2r+d23GIDgDjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715066576; c=relaxed/simple;
	bh=xVgaNHPJLgsiEk/ryoBiGClaqXnOKrQ5Mi9tyi+8dWM=;
	h=Date:Message-Id:From:To:Cc:Subject; b=JHmy+KcYS4LbtSxomI2D0p83FlZfnbD0ikJnW+6Z5gusfir3GC/rI8/AumbvP49Tq6Cmw6BHZ/8OQ5w1E4mD0pykfU9lJGnCQTDYUL4pFiCPWg76e90bsuXOavxzy7BS6HA0t3FlK9qupXawoFCItIVrzYnfsAFrBb54oavJNgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iBS5cFS3; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBS5cFS3"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e50a04c317so12862505ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2024 00:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715066574; x=1715671374; darn=vger.kernel.org;
        h=subject:cc:to:from:message-id:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJdwlfmMlvkqHhw/jWIljwqyXstk8vQfORi6cb50OkE=;
        b=iBS5cFS3n7U4d/UQMfaE9siBMl/7pMb2Rbwg0ah9Ny8mYNMy/S/O+U0EftI6Kma8+f
         srOn5ytYTklTWSPanQRLd1INH2KVrDRJd/X6lTx+9cb9HjH6k8VyGIcZddCHTr+BGtGY
         TZ6YUeQiD4dnCgeNiBIsc6wxSsNXbOCUkjmAHSZ4LsFK3MGWqTonoSUIEMp99PJZL21U
         B9B0npP0fex883tJTiSrODeshfQGyb8Xc4kCzs2xR+HJ4eF7xd7FEQeukLiVQRobdH7/
         d9IQp+F5rJ2OLCP0Nijy5w2ajL/O6RisB53cFfbh4oIdSZujtpzrH8lUM1bhTQkMuZXm
         tYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715066574; x=1715671374;
        h=subject:cc:to:from:message-id:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rJdwlfmMlvkqHhw/jWIljwqyXstk8vQfORi6cb50OkE=;
        b=Ci1tSNmqftsQ62e+ZbjEMql8ya7ACfAHen2eVsj/MyxlX5xJ8R9ABwMsAYoefJiSb3
         T1l7Wd227sJbW/q9+1n7qlgsVCJD+iivfwkp7URS6lB0Pz79vl18JnwHUWYsjU2h4yZq
         CoYHuAeq5enkk81EGpRqyhvT6f1z4xGrIYHGPKuBn2yo3tOOe/Sy/TBBDzczcn9sxd6E
         h4wSaJr1ADYo1eP0NaRmUL92wW1IUq2SOyU7c0DunaStmYUb6wZW9qlt1RnkmlJWoWru
         nN71TwX4IQfiKiRelbCn0njEK0Q1ZyZwIAXexWyULrHGoMUYUsU7q35a+Q6UiUIY4lQD
         n/aA==
X-Gm-Message-State: AOJu0YypxzA91IV5r8Ha2bpzFtezuXteTTtGha7WEs8Q72NfStfjgL5H
	NE+WGCvGpBL7+RlgeUMtIndmpCf7Jm1DNQ+6PVElRnyRYkoVKupo
X-Google-Smtp-Source: AGHT+IGE82g8/JQDYACNO+9e5w4emjKG67WIMQTLCI1UlNq2arhTrU6flzb7YUnpZgSbDSetvxN75w==
X-Received: by 2002:a17:903:32c9:b0:1e4:9ad5:7537 with SMTP id i9-20020a17090332c900b001e49ad57537mr12782416plr.34.1715066573868;
        Tue, 07 May 2024 00:22:53 -0700 (PDT)
Received: from dw-tp ([171.76.81.176])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b001e434923462sm9443878plg.50.2024.05.07.00.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 00:22:53 -0700 (PDT)
Date: Tue, 07 May 2024 12:52:49 +0530
Message-Id: <87h6fanl12.fsf@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv3 1/1] xfs: Add cond_resched to xfs_defer_finish_noroll
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> On Tue, May 07, 2024 at 10:43:07AM +0530, Ritesh Harjani (IBM) wrote:
>> An async dio write to a sparse file can generate a lot of extents
>> and when we unlink this file (using rm), the kernel can be busy in umapping
>> and freeing those extents as part of transaction processing.
>> 
>> Similarly xfs reflink remapping path also goes through
>> xfs_defer_finish_noroll() for transaction processing. Since we can busy loop
>> in this function, so let's add cond_resched() to avoid softlockup messages
>> like these.
>
> You proposed this change two weeks ago: I said:
>
> "The problem is the number of extents being processed without
> yielding, not the time spent processing each individual deferred
> work chain to free the extent. Hence the explicit rescheduling
> should be at the top level loop where it can be easily explained and
> understand, not hidden deep inside the defer chain mechanism...."
>
> https://lore.kernel.org/linux-xfs/ZiWjbWrD60W%2F0s%2FF@dread.disaster.area/
>
>> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
>> CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
>> Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
>> NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
>> LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
>> Call Trace:
>>   xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>>   xfs_alloc_compute_aligned+0x5c/0x144
>>   xfs_alloc_ag_vextent_size+0x238/0x8d4
>>   xfs_alloc_fix_freelist+0x540/0x694
>>   xfs_free_extent_fix_freelist+0x84/0xe0
>>   __xfs_free_extent+0x74/0x1ec
>>   xfs_extent_free_finish_item+0xcc/0x214
>>   xfs_defer_finish_one+0x194/0x388
>>   xfs_defer_finish_noroll+0x1b4/0x5c8
>>   xfs_defer_finish+0x2c/0xc4
>>   xfs_bunmapi_range+0xa4/0x100
>>   xfs_itruncate_extents_flags+0x1b8/0x2f4
>>   xfs_inactive_truncate+0xe0/0x124
>>   xfs_inactive+0x30c/0x3e0
>
> This is the same issue as you originally reported two weeks ago. My
> comments about it still stand.
>
>>   xfs_inodegc_worker+0x140/0x234
>>   process_scheduled_works+0x240/0x57c
>>   worker_thread+0x198/0x468
>>   kthread+0x138/0x140
>>   start_kernel_thread+0x14/0x18
>> 
>> run fstests generic/175 at 2024-02-02 04:40:21
>> [   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>>  watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>>  CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
>>  NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
>>  LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
>>  Call Trace:
>>   0xc000000014107c00 (unreliable)
>>   __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
>>   xfs_btree_update_keys+0x150/0x170 [xfs]
>>   xfs_btree_lshift+0x534/0x660 [xfs]
>>   xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
>>   xfs_btree_insrec+0x4e4/0x630 [xfs]
>>   xfs_btree_insert+0x104/0x2d0 [xfs]
>>   xfs_rmap_insert+0xc4/0x260 [xfs]
>>   xfs_rmap_map_shared+0x228/0x630 [xfs]
>>   xfs_rmap_finish_one+0x2d4/0x350 [xfs]
>>   xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
>>   xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
>>   __xfs_trans_commit+0x1f4/0x400 [xfs]
>>   xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
>>   xfs_reflink_remap_blocks+0x154/0x320 [xfs]
>
> And this is the same case of iterating millions of extents without
> ever blocking on a lock, a buffer cache miss, transaction
> reservation, etc. IOWs, xfs_reflink_remap_blocks() is another high
> level extent iterator that needs the cond_resched() calls.

ok. I was thinking if we add this to xfs_defer_finish_noroll(), then we
can just take care of all such cases. But I agree with your point here.

I will test adding cond_resched() to xfs_relink_remap_blocks() loop
and will re-submit this patch.

>
> I can't wait for the kernel to always be pre-emptible so this whole
> class of nasty hacks can go away forever. But in the mean time, they
> still need to be placed appropriately.

Sure Dave. Thanks for the review!

-ritesh
