Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9090E17BA6
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 06:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838799; cv=none; b=RxIsiKP+NrNzLTAsiN593JwbQ/knQt5U8vlqB66J0XBe0EA8AUkUIbnlCEFv3bGzmQYecjtvv2LElUPzSPcT035i+ERRj/vxPRPLJS/a+GI0sa1nL2rOXVQ1yUpHvt4VbHTiW722R6LqmGvXE3sJyQu9h7lXJtVPBH4yMrjX3ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838799; c=relaxed/simple;
	bh=VD7+Ylw/WGJg3ZBIkcg4EC8MZmBD4qsZHEAn5JKYjgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uKNYVIj8e0FA+sU4TRMxpbu9linbXX2w1NSqqdbjqhUnvHoOT7wuidGCfFCm3DbQxKKPiL4Ep6nv3js2n5BvrHCEMgifSzlAY8Dk2AfJrYd+O/g0q5uLSkJfS2d8hrWdOb5wKiVjFw9jGv2PJ7okfCass3Tm8qcYyIOZMuWJ1KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cuWdkhNp; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cuWdkhNp"
Message-ID: <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776838795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRaB+OWmnSSxx73xju1MkZZdS0Vkq8bRebe1BLSfkZ4=;
	b=cuWdkhNpwy23S+cgY6T70/mYCiTj1dgyTqYd+knUz0WoPwtDYGMKV9PVgEfO2v2EePxWIu
	udohEpiaDN0Oy/ed2XRsfqeEtQ/3mYItnQNxm64g2eoUwk40sBW89qxNuAv3w16I7EmnvO
	duuHVtDyHrv73yfuMc13KdbIaMcrKTk=
Date: Wed, 22 Apr 2026 08:19:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dgc@kernel.org, tytso@mit.edu, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>,
 Pankaj Raghav <p.raghav@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
 <CGME20260421181614eucas1p119dfe990221e6cb397d647cf24dbfa1f@eucas1p1.samsung.com>
 <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 4/21/2026 8:15 PM, Ojaswin Mujoo wrote:
> On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
>>> +
>>> +	if (wt_ops->writethrough_submit)
>>> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
>>> +					    len);
>>> +
>>> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
>>
>> We might want to check if bio_alloc succeeded here.
> 
> Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
> according to comment over bio_alloc()
> 
>   * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
>   * allocate a bio.  This is due to the mempool guarantees.  To make this work,
>   * callers must never allocate more than 1 bio at a time from the general pool.
> 
> And we seem to be following this.
> 

Makes sense. Thanks for the clarification.

>>
>>> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
>>> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
>>> +	bio->bi_private		= wt_ctx;
>>> +
>>> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
>> In the unlikely scenario where we encounter an error, do we have to also
>> clear the writeback flag on all the folios that is part of this
>> bvec until now?
>>
>> Something like explicitly iterate over wt_ctx->bvec[0] through
>> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
>> on them, and then discard the bvecs by setting the nr_bvecs = 0;
>>
>> I am wondering if the folios that were processed until now will be in
>> PG_WRITEBACK state which can affect reclaim as we never clear the flag.
> 
> Hey Pankaj, yes you are right. I think the error handling is a bit buggy
> and Sashiko has also pointed some of these. I'll take care of this in
> v3, thanks for pointing this out.
> 

FWIW, I got the following panic on xfs/011 (not reproducible all the time) when 
I was running the xfstests with 16k block size with the writethrough patches:

[76313.736356] INFO: task fsstress:1845687 blocked for more than 122 seconds.
[76313.738751]       Not tainted 7.0.0-08885-g97cbd56b7479 #43
[76313.740650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
message.
[76313.743311] task:fsstress        state:D stack:0     pid:1845687 tgid:1845687 
ppid:1845685 task_flags:0x400140 flags:0x00080000
[76313.747137] Call Trace:
[76313.748000]  <TASK>
[76313.748830]  __schedule+0xcc2/0x3c40
[76313.750129]  ? __pfx___schedule+0x10/0x10
[76313.751479]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.753214]  schedule+0x78/0x2e0
[76313.754334]  io_schedule+0x92/0x100
[76313.755597]  folio_wait_bit_common+0x26a/0x6f0
[76313.757156]  ? __pfx_folio_wait_bit_common+0x10/0x10
[76313.758873]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.760508]  ? xas_load+0x19/0x260
[76313.761693]  ? __pfx_wake_page_function+0x10/0x10
[76313.763386]  ? __pfx_filemap_get_entry+0x10/0x10
[76313.764948]  folio_wait_writeback+0x58/0x190
[76313.766499]  __filemap_get_folio_mpol+0x56d/0x800
[76313.768085]  ? kvm_read_and_reset_apf_flags+0x4a/0x70
[76313.769899]  iomap_write_begin+0xea7/0x1e90
[76313.771304]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.773016]  ? asm_exc_page_fault+0x22/0x30
[76313.774427]  ? __pfx_iomap_write_begin+0x10/0x10
[76313.776100]  ? fault_in_readable+0x80/0xe0
[76313.777476]  ? __pfx_fault_in_readable+0x10/0x10
[76313.779106]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.780765]  ? balance_dirty_pages_ratelimited_flags+0x549/0xcb0
[76313.782861]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.784457]  ? fault_in_iov_iter_readable+0xe5/0x250
[76313.786221]  iomap_file_writethrough_write+0x9fd/0x1ce0
[76313.787978]  ? __pfx_iomap_file_writethrough_write+0x10/0x10
[76313.789991]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.791589]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.793314]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.794932]  ? current_time+0x73/0x2b0
[76313.796132]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.797276]  ? xfs_file_write_checks+0x420/0x900 [xfs]
[76313.798786]  xfs_file_buffered_write+0x195/0xae0 [xfs]
[76313.800243]  ? __pfx_xfs_file_buffered_write+0x10/0x10 [xfs]
[76313.801775]  ? kasan_save_track+0x14/0x40
[76313.802843]  ? kasan_save_free_info+0x3b/0x70
[76313.803908]  ? __kasan_slab_free+0x4f/0x80
[76313.804894]  ? vfs_fstatat+0x55/0xa0
[76313.805835]  ? __do_sys_newfstatat+0x7b/0xe0
[76313.806899]  ? do_syscall_64+0x5b/0x540
[76313.807829]  ? srso_alias_return_thunk+0x5/0xfbef5
[76313.809052]  ? xfs_file_write_iter+0x22e/0xa80 [xfs]
[76313.810451]  do_iter_readv_writev+0x453/0xa70

I have a feeling this has to do with the error handling as we are stuck waiting 
for writeback to complete. It is not reproducible because it might be dependent 
on the state of the system before this triggers. Let me see if I can find a way 
to reliably reproduce this so that we have something to verify against once we 
make these changes.

--
Pankaj

