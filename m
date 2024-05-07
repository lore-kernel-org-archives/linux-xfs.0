Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C058F6E602
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 06:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062012; cv=none; b=iMAgrYJq6sUk3fTI/yTrV+Ob1H6IanEeCd4yVeI+TTzf++LhLXaAZCvDN/bIvu2opcwG0BCFKfCnyRAJZ3RTLGlq/GN2CfSF2BaMJgkRIRNIQ9YP+yfDjl/wKumLQRcg+/8+afX0SWcB9fouk/kaU71x7ESyEbFN36IHFBdq9VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062012; c=relaxed/simple;
	bh=lQYYYnFuZb0FVGTjxbTBD+oeHBIl4ptIrXvhRg5NLkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIe5YB7Lnlo/J0gsiofOfNO9VfnXbngnVcQ0jmQYEspFD/OcKXMsD5O3zG7zHd+cCDEnEY/N1n+iRKJ+5GW0i2ebrBELquTJeKq6glu1X2mHLTbqa2cf+N8LkK8jb1aRID+/ucHIv3gZuilbHtM20/6XsCcKiFaF1Dn01zZHlHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3gCFCrwX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3gCFCrwX"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1edf506b216so12086985ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 23:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715062010; x=1715666810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hr/vqVTVirs4e/t4nH25XALKU9fg2bjHNf2nyj8ESKc=;
        b=3gCFCrwXKZvfd8rbBAlarjE3bTlf+irSZlgMjUCdO7iDy6E/a/BrNRqDjB5VGF1zJF
         s+dLbOc1ol1T7umVaAZkjTpXJ9RoE9AoqYmgsRkPikSt0J+qdyu1hukURDn+55+C3Sjp
         IdPaut2Gaj5MMH6Nm0ovWeMas1GBePHjdjvtrPn1z9KsqENSJy2UDY2AWxTowTRkaV2e
         C6BGSCLsN4/1ONH4mG1QnwFs74TH9PBjlqbmkPOIgV1Xok+ZBO6nNB0Ec8U08NTLYb9R
         8txCbXoZ2UXFNzpCQVtfXZgqXO8kTKMbVfaW3pNSKRNSatseAHQIOEK4sjOjiXBgyTZl
         WHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715062010; x=1715666810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hr/vqVTVirs4e/t4nH25XALKU9fg2bjHNf2nyj8ESKc=;
        b=MxR4smaVKqqiEf0AIBW0V1NjAFSJ9gySrfjGX+UxbZySrVbjakI1tRLjunFavZMmKu
         8MInTIVGhGiu+Zz5SbZ9c+4M5B9RIjkZX2wCYvWFQ2HySZtLhqvTRGCBhjBlcPjygiXD
         5vy6JPPiaruhkN1ltnw5iW/6T+gIftEY/NVu0WoiPsScEVOMC623ihwuMxmSP8Dpb1sG
         gVEr/z/C5ksGuJnrTvOPNK1rahA5CGtW/LKI3L9fP7vvVK9WtG6v2rodaAb93SA5TEAW
         Qn3qUfXM2xrjQylJ8+e5XeZsdC2fgCKdORSWRU70fwdVojK/+gyCh20wxk57pCMyktv8
         BtPw==
X-Gm-Message-State: AOJu0YwvrvQ9yOy9Mk1OFqVp4FT1LLPWk7LD8cGexw9t2cekfYROPwMC
	C59FVjbvm6goKCRV2j1rJ7bBKSRBltN22yRXA/HV7qgLStMcm2QxkzknbY1/wbO3Jb1DvtkSSqC
	S
X-Google-Smtp-Source: AGHT+IFGivGEZxX4b2X4o9bUWipv/tsc3h2qnb/p4kYWVLa2UE/gp0o2ClR11JCglAjMqOVo36Xl/g==
X-Received: by 2002:a17:902:ce81:b0:1e2:194a:3d22 with SMTP id f1-20020a170902ce8100b001e2194a3d22mr12885559plg.32.1715062009838;
        Mon, 06 May 2024 23:06:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902d48400b001e4fdcf67desm9288357plg.299.2024.05.06.23.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 23:06:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s4DyQ-006OzI-2U;
	Tue, 07 May 2024 16:06:46 +1000
Date: Tue, 7 May 2024 16:06:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv3 1/1] xfs: Add cond_resched to xfs_defer_finish_noroll
Message-ID: <ZjnE9huCrF61JpTn@dread.disaster.area>
References: <cover.1715057896.git.ritesh.list@gmail.com>
 <fe5326ac64e9ba3e10e5521fa97061b45632e516.1715057896.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe5326ac64e9ba3e10e5521fa97061b45632e516.1715057896.git.ritesh.list@gmail.com>

On Tue, May 07, 2024 at 10:43:07AM +0530, Ritesh Harjani (IBM) wrote:
> An async dio write to a sparse file can generate a lot of extents
> and when we unlink this file (using rm), the kernel can be busy in umapping
> and freeing those extents as part of transaction processing.
> 
> Similarly xfs reflink remapping path also goes through
> xfs_defer_finish_noroll() for transaction processing. Since we can busy loop
> in this function, so let's add cond_resched() to avoid softlockup messages
> like these.

You proposed this change two weeks ago: I said:

"The problem is the number of extents being processed without
yielding, not the time spent processing each individual deferred
work chain to free the extent. Hence the explicit rescheduling
should be at the top level loop where it can be easily explained and
understand, not hidden deep inside the defer chain mechanism...."

https://lore.kernel.org/linux-xfs/ZiWjbWrD60W%2F0s%2FF@dread.disaster.area/

> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
> CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
> Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
> NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
> LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
> Call Trace:
>   xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>   xfs_alloc_compute_aligned+0x5c/0x144
>   xfs_alloc_ag_vextent_size+0x238/0x8d4
>   xfs_alloc_fix_freelist+0x540/0x694
>   xfs_free_extent_fix_freelist+0x84/0xe0
>   __xfs_free_extent+0x74/0x1ec
>   xfs_extent_free_finish_item+0xcc/0x214
>   xfs_defer_finish_one+0x194/0x388
>   xfs_defer_finish_noroll+0x1b4/0x5c8
>   xfs_defer_finish+0x2c/0xc4
>   xfs_bunmapi_range+0xa4/0x100
>   xfs_itruncate_extents_flags+0x1b8/0x2f4
>   xfs_inactive_truncate+0xe0/0x124
>   xfs_inactive+0x30c/0x3e0

This is the same issue as you originally reported two weeks ago. My
comments about it still stand.

>   xfs_inodegc_worker+0x140/0x234
>   process_scheduled_works+0x240/0x57c
>   worker_thread+0x198/0x468
>   kthread+0x138/0x140
>   start_kernel_thread+0x14/0x18
> 
> run fstests generic/175 at 2024-02-02 04:40:21
> [   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>  watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>  CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
>  NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
>  LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
>  Call Trace:
>   0xc000000014107c00 (unreliable)
>   __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
>   xfs_btree_update_keys+0x150/0x170 [xfs]
>   xfs_btree_lshift+0x534/0x660 [xfs]
>   xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
>   xfs_btree_insrec+0x4e4/0x630 [xfs]
>   xfs_btree_insert+0x104/0x2d0 [xfs]
>   xfs_rmap_insert+0xc4/0x260 [xfs]
>   xfs_rmap_map_shared+0x228/0x630 [xfs]
>   xfs_rmap_finish_one+0x2d4/0x350 [xfs]
>   xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
>   xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
>   __xfs_trans_commit+0x1f4/0x400 [xfs]
>   xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
>   xfs_reflink_remap_blocks+0x154/0x320 [xfs]

And this is the same case of iterating millions of extents without
ever blocking on a lock, a buffer cache miss, transaction
reservation, etc. IOWs, xfs_reflink_remap_blocks() is another high
level extent iterator that needs the cond_resched() calls.

I can't wait for the kernel to always be pre-emptible so this whole
class of nasty hacks can go away forever. But in the mean time, they
still need to be placed appropriately.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
