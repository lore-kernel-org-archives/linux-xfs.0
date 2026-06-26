Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506627FD75;
	Fri, 26 Jun 2026 02:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782440550; cv=none; b=SeD4tF247b8iZoX6qwS3aeeo+Hxi0Geqr09PbZ4SaCha9jJs4PZsYFQjFVcJLJPLuPtOACOzHxOiO9Fe/or9jMImqk/105PgRQGYh/oVBXKjb8vImeIcr72O5h6r9OQnXnJYsHd0ltRxlzLVysHAm/vIMjSj+Q0Eq2ZzOYh5wgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782440550; c=relaxed/simple;
	bh=EarH9ORv04FlFTNvJDy+Xju9cTY3lIAT9rJb2Va27a0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VBvPPxZUY56pAiIAjm4ULYsA7zRugEntlmvPQqitUAsgEEf+hYCUjeZ8DpQ5+73R2kzWjOBzNwhKCjK5NLv+P5ixkjHlNfv/cjiKKVHnNsjMUGoscsQL4HGpIsy383/SE/ZrRUheFUWAOFfbl1NzL694uT6ECGTzKtmvMfa/NkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f2UC8l0A; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f2UC8l0A"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782440539; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iH0u+zG2bf/AQezPGWtl+8ZPYaxCxQkGVduyn89k3rU=;
	b=f2UC8l0AIJbGIu8lrywVhnKVQ0SYHSJVaLJkB4xrJ51JsNG+1a2Smm9iWpZrhxnms6ONRCm78R/U95gz2+T9L+AFgDhzDu/Ydi/8fANtuJ0dplo3y2gK9bpzyJ5kiPMood0zn3M4c5ufch3uacWeUGV6wDSScbMAIiwxztiv7D4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5d5DGY_1782440537;
Received: from 30.221.130.253(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5d5DGY_1782440537 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 10:22:18 +0800
Message-ID: <9bfa2c7a-1b17-41c5-9846-340e6a5b4b66@linux.alibaba.com>
Date: Fri, 26 Jun 2026 10:22:17 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next() model
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, willy@infradead.org, djwong@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
 <6446cb94-a005-4e4c-8034-d7bf2a4b402b@linux.alibaba.com>
 <20260625130206.GC22620@lst.de>
 <4da9a5ac-2a53-4fe2-9283-2e0f6181c248@linux.alibaba.com>
 <CAJnrk1Y_RLezfBq7sfgErGq3uT1t3czA+EWHg44zEXp9VrYF=Q@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAJnrk1Y_RLezfBq7sfgErGq3uT1t3czA+EWHg44zEXp9VrYF=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Joanne,

On 2026/6/26 05:33, Joanne Koong wrote:
> On Thu, Jun 25, 2026 at 6:21 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>> On 2026/6/25 21:02, Christoph Hellwig wrote:
>>> On Thu, Jun 25, 2026 at 11:25:54AM +0800, Gao Xiang wrote:
>>>> As I mentioned a year ago, I really hope this way can be proceed
>>>> to avoid iomap iter-callback models:
>>>>
>>>> https://lore.kernel.org/r/20250905152118.GE1587915@frogsfrogsfrogs
>>>
>>> Oh, I guess this is where passing the iomap and srcmap separately
>>> from the iter come from.  But for this to make sense we'd have to
>>> be able to pass a const iter.
>>
>> ... anyway, I hope iomap folks could consider my humble
>> suggestion, since I'm afraid that this callback model in
>> the long term won't scale well in very slightly different
>> details (along with more and more iomap users), so rather
>> than just converting more callers, I guess it might be
>> better to consider non-callback model as a direction
>> anyway.
> 
> Thanks Gao. I don't think the callback and helper models are as far
> apart as it might look though after the ->iomap_next() change. Once
> all the callers have been converted, there'll be no iomap_ops
> indirection left and callers can just pass in the direct function
> pointer for iomap_next(). You had mentioned something about having
> callers own the iter and drive the loop to get rid of indirect calls -
> I think the inline patch in this series does what you had in mind.

Thanks for the reply.

I partially agree since it's much closer, but what I meant is
the design model difference as below.

> 
> I think the difference is that under your proposal, the loop body
> logic for pre/postprocessing the read/write/etc ranges is also moved
> out into helper functions, which each caller would then have to put
> together / reassemble. It seems like a lot of duplicate code and I'm
> not sure I see the benefit of open-coding that when none of the
> callers right now need special logic interjected between the
> fine-grained helpers and and their callback. imo it seems more
> advantageous to only add that in the future if there's a caller that
> has that special need, where only that caller would need to do that,
> instead of making all callers have to do that.

If you take a look at the initial commit of iomap ae259a9c8593
("fs: introduce iomap infrastructure"), the starting point was
to provide `struct iomap_ops` (two callbacks) to get the filesystem
extent mapping and unique entrypoints: iomap_file_buffered_write(),
iomap_page_mkwrite() for buffer writes (write and mmap write).

And then iomap applies to DAX, direct I/O, writeback, buffer read,
etc.  basically for block-based filesystems, and that is why
`struct iomap_ops` is always _one important part of iomap core_
until FUSE adapted.


But if we take a look at the overall requirement, I think what we
need is to provide an easy-use high-level fs helper library to
wrap up the following stuffs:

  1. page cache management (mainly sub-page tracking) and DAX pages;

  2. IO management (buffer I/O, direct I/O, DAX access);

  3. others (like fiemap, bmap, lseek, etc.)


For example, most block filesystems could use them of all, and for
FUSE and networking filesystem, basically they only need 1 and
maybe partial 3.

The recent implementation (including ->iomap_next()), is still
a callback-based model, the main loop is inside `fs/iomap` itself,
and you have to:

  - still arrange the mapping logic into an unique callback, which
is .iomap_next() now, if the mapping logic needs more information
rather than `struct inode *`, they have to add private pointer
somewhere.

  - Take a recent example (buffered read refactoring), need
    `struct iomap_read_folio_ctx` for FUSE and maybe other future
    networking filesystems to callback into their filesystem to
    provide new I/O contexts and submit I/Os.

But actually take a simple example of iomap_read_folio, you:
could change into (just a very rough sketch):

  xxxfs_read_folio {
    struct xxxxfs_private priv;

    iomap_iter(&iter) {   /// it could be a macro
        if (iomap_iter_outofrange(&iter))
		xxxfs_map_extent(&iter, &priv);

        // to maintain the page cache <-> struct iomap_folio_state
        // and handle some type of mapping
        if (iomap_read_folio_iter(&iter) == NEED_NEW_IO_CONTEXT) {
            xxxfs_new_io (&iter, &priv);
        }
    }
    if (xxxfs_if_any_available_io(&iter, &priv))
	xxxfs_submit_io(&iter, &priv);
}

In this model, I really think `struct iomap_read_folio_ctx` and
similar doesn't need any more (another set of callback avoidness),
and both xxxfs_map_extent() and xxxfs_new_io()/ xxxfs_submit_io()
can pass in their per-fs private without need to bother
the iomap-core to add various `private` pointers.

and in the iomap_iter() loop you can omit/change/add any part if
it doesn't fulfill to the filesystem timing.

As for "a lot of duplicate code", I think with proper new designs,
the common part could be wrapped up into macros (for example,
for bdev filesystems, xxxfs_new_io() and xxxfs_submit_io() calls
can be wrapped up into macros, and only leave:

	if (iomap_iter_outofrange(&iter))
		xxxfs_map_extent(&iter, &priv);"

can be customized for each fs as the common macro helpers.

It's just my rough thought, as I said in the previous year, I
still don't have a strong tendency but it's my suggestion over
these years.

Anyway since you're actively working/changing on iomap, so
it's fine to just respect your ideas/efforts if you don't
think it's worth, but as a record of my thoughts here again.

Thanks,
Gao Xiang

> 
> Thanks,
> Joanne

