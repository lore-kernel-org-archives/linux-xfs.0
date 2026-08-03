Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D289A3AEF4E
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 11:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757097; cv=none; b=uJdFfZUHJDEOiuRrdUSjy7TRdKj9LKGZN/trKqpu2DNIqA+gh/cMEl4yclVZT9y7Ugl552cBUaG2OqOEKUV9kJANWDD+5/TQ0pfYgAEVJvfkG+AKcnlukufn9rROl9OPaNz7Bj/0coIOy4JYxwDsgKuWsfTazky7WD1Q3eXQPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757097; c=relaxed/simple;
	bh=uv3Drwy6NPWELqI6AUpG2OKhcUDbVPD+BNw3zD6+7ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rCvzX7ALAWAp80rFOZ9vNnXExlSxJPpbARtuTfy0xXtru0l2V1h5qeNHzPFFI/iByQYPMELVd5YvQxRBOLCbQCjiYq2syxnpWD0/c1wm1AhKtJcCVwVn90oEoUpruvVUvWIrQvMxL2rbvktjV/rnmp92zR0clpYP40vMLWyqEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwUtdkj0; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwUtdkj0"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8423f236418so2512409b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 Aug 2026 04:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785757095; x=1786361895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RmsKNiXhRo1+5gkZXYYoCunr0JEnRYX72khI5jwn+cw=;
        b=NwUtdkj0Pngu8zkCEZNkxWZyf4QV/K2XkvIAkA3IU7hzG2RZeSipnG7XD/Da1qrKHg
         LkhQ7fPCWZJEpsBaAZOvhhzBrocjhWynuDFN0ykMUxykKahIoaQP98ucHD8N+GScOg+G
         jrq8xifeR/yMlGxNZXQxJjUyS6uO7ecA+Toe2pfITaqyJqSz5EFbs3ViMAAvHhu+zm81
         RGwYOybt7j8joGBEw40PONlShu6Rrw5gV8LewDIfXSNaKhXRdyGFiZ8VbTO6MfF95o1a
         xG0PjxrXlRKmhkPWshQNW5rgiRAsjtD6jP03yBzGinx2QXfoVdynzrPUfhjvWug4IhcJ
         KWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785757095; x=1786361895;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmsKNiXhRo1+5gkZXYYoCunr0JEnRYX72khI5jwn+cw=;
        b=JAZqzWu9274m1U0j5PTr5roU/CXUqguabvD5zacp7JeL0hDQn5PjxdBajkl6VlYqMa
         PL9qOFz9QASaO77nZdrxvLcex/A7ju+u3yHPzWgtuI977bZBcYgfbQyLbSSCHavbm2Se
         cRTLRQDN3j8PXnAIknsnpY42PLgqOm1CMABl+XbaDo6dAgKGjfjLWmImbPW15YyoCgwW
         jI9GJY9gn1ylZ1RGveW3aQlc4Xb8QVGQKIUCns7x0FtdxyjccnfVYxGsQlZpBq0gM69I
         bbOJwGFheXcf5p26o2ITYaAcfmsrSo9x97KuSfxZv4he5rcgx3j/eNh8QhfHBIlQ/b5Y
         5T8Q==
X-Forwarded-Encrypted: i=1; AHgh+RpuQ+wZKVmbaAf8IzltjShpEuze5gNNSoIyN+PXy8JCqq7lxr6k7ADdHSbpT+D8ezko7Boj3jiiyhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKdDQGUckdULUibzkYvGsS3fIDSEPE/iFH6fWFGF8D01wzeTyL
	BjiuWmHEqbPRxOKm+xWuMAPcyy8X2ZmoY3otIAv0buVOzpsKB1a+1cQk
X-Gm-Gg: AR+sD12czpQkq4GXJUJmqTG7YFGnmuA5mDWXqUUknN8n3/+burIiBilkmquT6C/inR3
	2WLPQk1njkOcXV55jASGOUZ7Inu6YN2ifGjCQ23XxcBHTT6/FElDX1ZZ09mObAUfABcTE1tasP3
	8CFwIFHP3uI5TVBKsamljXs+Gl3+M54ZvxLH+pDi193o4naf/+8455yWRk0Yz1XMNbmC4LCAcTv
	uXPxGPnt3lgFp4pG/ItcIsMmxzZ8Z7zTBZ9Iqo0/XFP2AhuU/3zkHlUBxFPfMb8+yJ0J9CZSEI7
	IWCu5p+lrhXelmZwQ+Fp02QYa0Y42+He1pLPLkiU7RBv7I/PeNx4pV+qV4R/jQTSVQbagaRZHad
	GpFdYznpo8q9JM+0YXkXzkr6jwPlB0x7Y7Z/NNUxkPDFgUBdNU136Ns6xho3rhNDPHo4NgERwZC
	D7ABU64KsgZG/ZedfPxPfYcc9rBv7yRWGbhhqwh8iAnjX1Z/IxQTuCN0ad6mdy6rL9sOA6u0t0z
	DC+pHHILw3/q03JkRlc
X-Received: by 2002:a05:6a00:9094:b0:847:7a61:e68e with SMTP id d2e1a72fcca58-84ee482cf83mr9255616b3a.31.1785757094976;
        Mon, 03 Aug 2026 04:38:14 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d45e5sm3521856b3a.42.2026.08.03.04.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 04:38:14 -0700 (PDT)
Message-ID: <9cf63689-3105-49aa-95ef-9cc398d79775@gmail.com>
Date: Mon, 3 Aug 2026 19:38:11 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
To: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 djwong@kernel.org, jiapenglin@tencent.com
References: <20260729025504.54586-1-jiapenglin@tencent.com>
 <am8xmal5nCP4ZvlN@zlang-mailbox>
 <ddc3741c-612a-4d0b-bc58-bc5f54a4080b@gmail.com>
 <anBTKpvN_N7rA6Vu@zlang-mailbox>
From: Lin Jiapeng <ljp1205831794@gmail.com>
In-Reply-To: <anBTKpvN_N7rA6Vu@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/3 17:07, Zorro Lang 写道:
> On Sun, Aug 02, 2026 at 09:59:16PM +0800, Lin Jiapeng wrote:
>>
>>
>> 在 2026/8/2 20:12, Zorro Lang 写道:
>>> On Wed, Jul 29, 2026 at 10:54:54AM +0800, Lin Jiapeng wrote:
>>>> When a full-file exchangerange is requested with FILE1_WRITTEN for a
>>>> fully sparse donor file, every mapping pair is skipped, so no extents
>>>> actually move.  However, the kernel decides to swap the reflink inode
>>>> flag based on the request geometry alone, so the target file used to
>>>> lose its reflink flag to the donor while still owning shared extents.
>>>> A subsequent write then took the non-reflink write path and modified
>>>> the shared physical blocks in place, silently corrupting the other
>>>> file sharing them:
>>>>
>>>>    --- tests/xfs/842.out
>>>>    +++ results/xfs/842.out.bad
>>>>    @@ -1,4 +1,5 @@
>>>>     QA output created by 842
>>>>    +vX.reflink = 0
>>>>     vX.reflink = 1
>>>>    -vX.reflink = 1
>>>>    +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
>>>>     Silence is golden
>>>>
>>>> This test clones a file so that both share extents, swaps the clone
>>>> against a sparse donor with FILE1_WRITTEN, and then checks the defect
>>>> twice.  First it inspects the inodes directly with xfs_db: the clone
>>>> must still be flagged reflink after the exchange (the donor carrying
>>>> the flag too is the conservative outcome of the fix and is harmless).
>>>> Then it writes to the clone and verifies after a mount cycle that the
>>>> original file's data is intact, i.e. the write was redirected through
>>>> CoW.
>>>>
>>>> The kernel fix "xfs: fix exchange-range reflink flag clearing issue
>>>> with INO1_WRITTEN" refuses the reflink flag exchange whenever
>>>
>>> So this patch/case uncovers a known bug which is fixed by:
>>>     "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN" ?
>>>
>>> If so please add:
>>>     _fixed_by_fs_commit xfs xxxxxxxxxxxx \
>>>           "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"
>>>
>>>> FILE1_WRITTEN is requested, which makes this test pass.
>>>>
>>>> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
>>>> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
>>>> Suggested-by: Christoph Hellwig <hch@lst.de>
>>>> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
>>>> ---
>>>>    tests/xfs/842     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>    tests/xfs/842.out |  4 +++
>>>>    2 files changed, 69 insertions(+)
>>>>    create mode 100755 tests/xfs/842
>>>>    create mode 100644 tests/xfs/842.out
>>>>
>>>> diff --git a/tests/xfs/842 b/tests/xfs/842
>>>> new file mode 100755
>>>> index 0000000..c4c2be9
>>>> --- /dev/null
>>>> +++ b/tests/xfs/842
>>>> @@ -0,0 +1,65 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0-or-later
>>>> +# Copyright (c) 2026 Tencent.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test No. 842
>>>> +#
>>>> +# Make sure that a full-file exchangerange under FILE1_WRITTEN does not strip
>>>> +# the reflink flag from a file that still owns shared extents.  When the
>>>> +# donor file is fully sparse, every mapping pair is skipped, so no extents
>>>> +# actually move; the target file must keep its reflink flag, and a later
>>>> +# write must go through CoW instead of modifying the shared blocks in place.
>>>> +
>>>> +. ./common/preamble
>>>> +_begin_fstest auto quick fiexchange
>>>> +
>>>> +# Import common functions.
>>>> +. ./common/filter
>>>> +. ./common/reflink
>>>> +
>>>> +_require_xfs_io_command exchangerange
>>>> +_require_scratch_reflink
>>>> +_require_scratch
>>>
>>> _require_scratch_reflink contains _require_scratch, so you can save the
>>> _require_scratch.
>>>
>>>> +
>>>> +_scratch_mkfs >> $seqres.full
>>>> +_scratch_mount
>>>> +
>>>> +# Create the original file with a known pattern and clone it, so that both
>>>> +# files share the same extents.
>>>> +_pwrite_byte 0x41 0 1m $SCRATCH_MNT/orig >> $seqres.full
>>>> +_reflink $SCRATCH_MNT/orig $SCRATCH_MNT/clone >> $seqres.full
>>>> +
>>>> +# Create a fully sparse donor file of the same size.
>>>> +$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/donor
>>>> +
>>>> +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
>>>> +
>>>> +# Swap the clone against the sparse donor, claiming the donor is fully
>>>> +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
>>>> +# and the clone keeps its shared extents in place.
>>>> +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
>>>> +	>> $seqres.full
>>>> +
>>>> +# Directly confirm the inode flag state after the exchange: the clone
>>>> +# must still be flagged reflink.  The donor may also carry the flag, which
>>>> +# is the conservative outcome of refusing the flag exchange under
>>>> +# FILE1_WRITTEN; the extra flag is harmless and can be dropped later by
>>>> +# the regular reflink flag cleanup path.
>>>> +_scratch_unmount
>>>> +_scratch_xfs_db -c "path /clone" -c print -c "path /donor" -c print | \
>>>> +	grep reflink | sed -e 's/^v[0-9]*/vX/g'
>>>> +_scratch_mount
>>>> +
>>>> +# Overwrite part of the clone.  With the reflink flag correctly retained,
>>>> +# this must go through CoW and leave the shared blocks of orig untouched.
>>>> +_pwrite_byte 0x42 0 64k $SCRATCH_MNT/clone >> $seqres.full
>>>> +_scratch_cycle_mount
>>>> +
>>>> +md5_after=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
>>>> +
>>>> +test "$md5_before" != "$md5_after" && \
>>>> +	echo "orig changed: md5 $md5_before -> $md5_after (write hit shared blocks in place)"
>>>> +
>>>> +echo Silence is golden
>>>
>>> This case has expected output, so it's not "Silence is golden",
>>> please remove this line.
>>>
>>>> +status=0
>>>> +exit
>>>
>>> I remember we've changed xfstests/new script, it should give "_exit 0" at here.
>>>
>>> Thanks,
>>> Zorro
>>>
>>>> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
>>>> new file mode 100644
>>>> index 0000000..1e6345a
>>>> --- /dev/null
>>>> +++ b/tests/xfs/842.out
>>>> @@ -0,0 +1,4 @@
>>>> +QA output created by 842
>>>> +vX.reflink = 1
>>>> +vX.reflink = 1
>>>> +Silence is golden
>>>> -- 
>>>> 2.50.1 (Apple Git-155)
>>>>
>>
>> Thanks a lot for your review!
>>
>> Yes, this test case uncovers the bug fixed by "xfs: fix exchange-range
>> reflink flag clearing issue with INO1_WRITTEN". However, that fix is still
>> under review on linux-xfs and has not landed in for-next / xfs-7.2-fixes
> 
> Generally, we don't merge a test case before its corresponding kernel patch
> is guaranteed to be merged. However, given that Darrick has already acked
> this patch, I feel like that xfs fix has strong backing, so merging this
> test case now should be fine.
> 
>> yet, so there is no stable commit ID to reference. I will add the
>> _fixed_by_fs_commit annotation as soon as the fix is merged.
> 
> Thanks, actually we can write:
> 
> _fixed_by_fs_commit xfs xxxxxxxxxxxx
>      "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"
> 
> Before the fix is officially merged into mainline Linux, "xxxx..." can serve
> as a placeholder for the commit ID to remind us to update it later.
> 
> Don't need one more patch, I'll help to add that it when I merge your v4,
> please feel free to update it after that fix is merged.
> 
> Thanks,
> Zorro
> 
>>
>> The other comments will be addressed in v4.
>>
>> Lin Jiapeng
>>
>>
Thanks for offering to add the _fixed_by_fs_commit annotation when merging.

And I will keep tracking the xfs tree and send a follow-up patch to fill 
in the real commit ID as soon as the fix is merged.

Best regards,
Lin Jiapeng
