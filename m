Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3253336AB4A
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 07:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776842608; cv=none; b=cDDRwR/CgIZ6QyayP7trM/UTG1eKj8M7vVatPFE+EKcgIGrS7AF+VcTXw2z/72jCVrwvTVdtERuEqhTRzeScjkN0E/EtrvFd/ISQoxymXHl+5dwEgx5iqbah6FwmSOvLFhGJzqm9QHzwLwKhctuF1/64BG9AHNOO6SSkMW/Irhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776842608; c=relaxed/simple;
	bh=s4a8CirOVZrpCN3aae9qBvi6394BtqHJUVmjyzwIQJg=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=rayfCVu8CTjfzwh+Hl5XcxOdMgn7L7FjbPx28wmBBIDEboBpjtiU97esdhICPweiOHHjpITZm/zIoHfGoqutC8/u3/2D9uZt7MpUcc9Tv0moZwQZjM/VDJZtfZrIb3bn1ffxeleTiTWpFXwBGTqChlJOIDR9sr12n2FZ0+b2ztI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mqbJxBlQ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqbJxBlQ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c70c112cb61so3424504a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776842606; x=1777447406; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6GXQBvjZucb9BRi+RMNkbcMHqj4d7NoOUxb7617xRyM=;
        b=mqbJxBlQm3vy5/hGNsEBm1Yqp+zxNKdAks4pB1D6569DUWD1DM84eWJ5tGqOcp6ooI
         RjB5kDNVpNNhvdJtydUuYZSKcrpsa/H31Tk7eXgPQfmw8wvPTgWIF//aJblHxZYG6VIj
         /SBHxL/xllLOilo6FW0Y3deP/q6MG8EOZXoh22g7JP/fGvH/c2Z5ljB8DmES9ajE+DST
         6KvNMPw1AsLNKc7hrZr0xx/nmubkLMkuNZEnyGQ2TDnmdlUH+0hBOD+JSjpxGfIS2b/Q
         /o4x9KMIXIoR7t3Jl2ieCSz7agE4RTCT3tn9YrxP1rq/4SoMyLwNAA1k/TEnlGtUd/Xa
         1vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776842606; x=1777447406;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GXQBvjZucb9BRi+RMNkbcMHqj4d7NoOUxb7617xRyM=;
        b=JroOsNU8vroPD5rN+ePiA70kEsUwGTvukwSKQ2h/VmuaCAFIb6aGDPwij6Ry5zcsJv
         abrRCNEwNPxliwj24k3ylEnNM9dOwLHDjGb5m3TFsLULDy5iBS9zrFetV4LoM1TA5wm2
         83OOuHdxhbz1TF6OuecFPZ3PGXEOY2MUooiZTCIXtaDOAvNqW7rSbRQCuq2UrZG6cSOM
         DksxJFtFFFcuURjnun7LmpiS1E1V4vK3lf3T0gakgoURw2IQz3ebDdopVVqBplsIgnL7
         5oZrgD3A5oJk1ivanMEgZUrnHv0R97/Ft6dfvjPuzrHuwctHeYzsn5h+F7jM8WDC7BIw
         Bjhw==
X-Gm-Message-State: AOJu0YzO01mS55l9t3a/xB1v6jjHslNjrdBWNGIkrCSPKDxqpR+YczqV
	DotQS5zrszCfrt0U0jJHIU+R1xQ54UabZiZA1IAv16D5GU3hGDCYPOv/
X-Gm-Gg: AeBDieuYgbGoSBrlPBulQJ3PYpjFD+Us1hSNyz3dNoTrb47g2rU1uiFVX9l1fNIU23A
	4xBvwunn3XKX343z1NyDjEs5khZjHK6fqsfhg6MZnQbhJCeMgmyPHJhAMEZO8fmvy+MXZK0VkNV
	Q/F6Z25H9gReQ8cRY9ftNW0oVtHYqT+dx0ufQldfTDh7S3NoXBAHfKf7DFz2CZqNkf3EcMs85vA
	W2UL53tFarq9J2JsU4fXp844K85iuf39Me9o8f5S2gvekxrmN/NOTGJdFjDKdOJt/P6V89/TsOM
	ob33TKZtVewrSyOjO9G21thI3fAb0U8inuNNp7ijuKghlAU6+JDI2SLdvhAKJf5zW/+jXmW/W9w
	b5aQDk4W1N98u4/TQz6stl/WWDAyu1jS7YvYvd7rB7EZqHTtM89XaCy1iLk+M5hawVr8EoJ3LXh
	ow5qmsF2Rta4hmekftioXSKXg6sSqmw0UJ73Oi/Ja2eAU=
X-Received: by 2002:a05:6a21:9992:b0:3a1:76d3:c1b0 with SMTP id adf61e73a8af0-3a176d45c75mr15445512637.22.1776842606435;
        Wed, 22 Apr 2026 00:23:26 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f8f370sm12580681a12.7.2026.04.22.00.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 00:23:25 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, andres@anarazel.de, brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered RWF_WRITETHROUGH
In-Reply-To: <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
Date: Wed, 22 Apr 2026 12:10:20 +0530
Message-ID: <5x5jts4r.ritesh.list@gmail.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com> <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3> <CGME20260421181614eucas1p119dfe990221e6cb397d647cf24dbfa1f@eucas1p1.samsung.com> <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Pankaj Raghav <pankaj.raghav@linux.dev> writes:

> On 4/21/2026 8:15 PM, Ojaswin Mujoo wrote:
>> On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
>>>> +
>>>> +	if (wt_ops->writethrough_submit)
>>>> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
>>>> +					    len);
>>>> +
>>>> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
>>>
>>> We might want to check if bio_alloc succeeded here.
>> 
>> Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
>> according to comment over bio_alloc()
>> 
>>   * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
>>   * allocate a bio.  This is due to the mempool guarantees.  To make this work,
>>   * callers must never allocate more than 1 bio at a time from the general pool.
>> 
>> And we seem to be following this.
>> 
>
> Makes sense. Thanks for the clarification.
>
>>>
>>>> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
>>>> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
>>>> +	bio->bi_private		= wt_ctx;
>>>> +
>>>> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
>>> In the unlikely scenario where we encounter an error, do we have to also
>>> clear the writeback flag on all the folios that is part of this
>>> bvec until now?
>>>
>>> Something like explicitly iterate over wt_ctx->bvec[0] through
>>> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
>>> on them, and then discard the bvecs by setting the nr_bvecs = 0;
>>>
>>> I am wondering if the folios that were processed until now will be in
>>> PG_WRITEBACK state which can affect reclaim as we never clear the flag.
>> 
>> Hey Pankaj, yes you are right. I think the error handling is a bit buggy
>> and Sashiko has also pointed some of these. I'll take care of this in
>> v3, thanks for pointing this out.
>> 
>
> FWIW, I got the following panic on xfs/011 (not reproducible all the time) when 
> I was running the xfstests with 16k block size with the writethrough patches:
>

Good point. I don't think so we tested large blocksize path currently.

Ojaswin has been running fsx and fsstress and we didn't hit this
scenario. So yes looks to be some corner path missed.

Thanks for testing that.

> [76313.736356] INFO: task fsstress:1845687 blocked for more than 122 seconds.
> [76313.738751]       Not tainted 7.0.0-08885-g97cbd56b7479 #43
> [76313.740650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> [76313.743311] task:fsstress        state:D stack:0     pid:1845687 tgid:1845687 
> ppid:1845685 task_flags:0x400140 flags:0x00080000
> [76313.747137] Call Trace:
> [76313.748000]  <TASK>
> [76313.748830]  __schedule+0xcc2/0x3c40
> [76313.750129]  ? __pfx___schedule+0x10/0x10
> [76313.751479]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.753214]  schedule+0x78/0x2e0
> [76313.754334]  io_schedule+0x92/0x100
> [76313.755597]  folio_wait_bit_common+0x26a/0x6f0
> [76313.757156]  ? __pfx_folio_wait_bit_common+0x10/0x10
> [76313.758873]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.760508]  ? xas_load+0x19/0x260
> [76313.761693]  ? __pfx_wake_page_function+0x10/0x10
> [76313.763386]  ? __pfx_filemap_get_entry+0x10/0x10
> [76313.764948]  folio_wait_writeback+0x58/0x190
> [76313.766499]  __filemap_get_folio_mpol+0x56d/0x800
> [76313.768085]  ? kvm_read_and_reset_apf_flags+0x4a/0x70
> [76313.769899]  iomap_write_begin+0xea7/0x1e90
> [76313.771304]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.773016]  ? asm_exc_page_fault+0x22/0x30
> [76313.774427]  ? __pfx_iomap_write_begin+0x10/0x10
> [76313.776100]  ? fault_in_readable+0x80/0xe0
> [76313.777476]  ? __pfx_fault_in_readable+0x10/0x10
> [76313.779106]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.780765]  ? balance_dirty_pages_ratelimited_flags+0x549/0xcb0
> [76313.782861]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.784457]  ? fault_in_iov_iter_readable+0xe5/0x250
> [76313.786221]  iomap_file_writethrough_write+0x9fd/0x1ce0


Looks like, while we were in iomap_writethrough_iter(), we ended up
looping over the same folio twice w/o submitting the bio.

So this could be a short copy case (written < bytes). I guess, if we
have a short copy, then too we should submit the prepared bio in
iomap_writethrough_iter(), otherwise we will deadlock when we iterate
over the same folio twice. (because previously we changed the folio
state to writeback)


> [76313.787978]  ? __pfx_iomap_file_writethrough_write+0x10/0x10
> [76313.789991]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.791589]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.793314]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.794932]  ? current_time+0x73/0x2b0
> [76313.796132]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.797276]  ? xfs_file_write_checks+0x420/0x900 [xfs]
> [76313.798786]  xfs_file_buffered_write+0x195/0xae0 [xfs]
> [76313.800243]  ? __pfx_xfs_file_buffered_write+0x10/0x10 [xfs]
> [76313.801775]  ? kasan_save_track+0x14/0x40
> [76313.802843]  ? kasan_save_free_info+0x3b/0x70
> [76313.803908]  ? __kasan_slab_free+0x4f/0x80
> [76313.804894]  ? vfs_fstatat+0x55/0xa0
> [76313.805835]  ? __do_sys_newfstatat+0x7b/0xe0
> [76313.806899]  ? do_syscall_64+0x5b/0x540
> [76313.807829]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.809052]  ? xfs_file_write_iter+0x22e/0xa80 [xfs]
> [76313.810451]  do_iter_readv_writev+0x453/0xa70
>
> I have a feeling this has to do with the error handling as we are stuck waiting 
> for writeback to complete. It is not reproducible because it might be dependent 
> on the state of the system before this triggers. Let me see if I can find a way 
> to reliably reproduce this so that we have something to verify against once we 
> make these changes.
>

Maybe we can add a WARN_ON() too to detect and confirm that this only
happens when we have a short copy case.

We will give this a try too at our end. Also the error handling pointed
by you and Ojaswin needs review & fixing in the next revision, to catch
any remaining paths where we may end up like this.

> --
> Pankaj

Thanks Pankaj for giving this a try at your setup.

-ritesh
