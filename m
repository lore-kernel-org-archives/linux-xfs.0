Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B05739734D
	for <linux-xfs@vger.kernel.org>; Sun,  2 Aug 2026 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785679165; cv=none; b=k8C94LPL9U3G5nwT0uX4I3H10tdsvl+upjSKvhjp8sXnik6lasXasl+ngZ/BPGgzNcIxG3S/4ncUdTRSHNcd5sWyv2zhytQXoMKerVzjZhSvYIkMvgjiG+HgOuUtKUj7Xwnu03uwG0FTbjNiUKywH+IeMygZEW3L+ullGpzCSZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785679165; c=relaxed/simple;
	bh=hdcY4dTGJmw8bqNfVkzvBGt64uAp2SwKZ2pm4E6r6QA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IiK58/JdlpVaDuk0WiEdlTf7NcXqstCN0oV3Qp8S0hKGdNlxP4KGbLx8SOe6KTBVXYotb+YAhTwKyl2Eiw7tVyqCjp5JZ6Eee7MWIsB5KxqU2GEbTwP3nIikYtFOmdRSZgTeNAVt3NzsPxl90PA1kh/WrVkFygxlCaukVJerK3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ggKjL1HN; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggKjL1HN"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d02b4c3601so28326765ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 02 Aug 2026 06:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785679161; x=1786283961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9Da5Mp6cPD9Jb/vLE/PR2MaaVMTY4x6eyKuKP418AzQ=;
        b=ggKjL1HNFrJBysalET7M4Ys1eu4cxroVOo5OOLNA45FW+FrQIfSLTi7A0lNUSEUyCf
         UKoNTJZU0sFLcJzf3dMQV0Sqyj62djYJQie3v8RYTpZr+hpgAcOrqiiUiLtR3isPdDry
         NVK5mVkxe1MOxlp8y+OBZdjqDvro1W3dxCPnw7ceL16tzuq5qKnIodvB4hOkSVAWxbSJ
         TQRliRueLdWIkWOnooeMlaEW3QEFGQLJtTPs6R/fKZBgbA35jWR3nmU+8aRs0t3zpNJm
         Y7cbSxMODzO1qixDn/1V6CeGejOIy7DBiWt3Wd0/S+L2OB8Q7HcZN35aebWQ/jeCMn+K
         eQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785679161; x=1786283961;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Da5Mp6cPD9Jb/vLE/PR2MaaVMTY4x6eyKuKP418AzQ=;
        b=K1cB6meCa8jy3abVpBzpcAW78bWVwnsggeu3ZQXm6O3laAGiffP/YE+TqSUudgSa2E
         BSoqaCuf4sSEcGgx12YiBGdJ0PtfaUYjg6X4dIK+H5Ix64/MaAOeOq6KljGLrTXzbtxc
         CYAS4HFVsxECNbh3b4TMbagpDAEQyRa3wNUltlGFizXfh8cF7oMVcqwj5ghitjPsVLG1
         zOT9M9HvFbGGDW4PXu6lZqzSEfnDBorL3bKi2rChVmt3fCRZOWL6XjwtiWHQ2AwgiZ2S
         ZUrKmQT9caarUjQ7GhBWcG16cXgiZwTYQAYZZFS+zNSklqnIlpfhzpUYJc3iBtxaT5oC
         A+XQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8aVyLqINh0LaST7N9IZKA2DMXTRQMVyaCwZAOQCFezjcpPRkjjWHOj+o4HXrt3M+2Q0hfp4CR6N4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVGJr3+k+iyYf7XQ38jpJaEPtY4w59YFwhcAcYYQjzti2KUGK0
	VfvM/Rf0GJATtQ/xf94SFIsXw8DeznI77277vOqKfjxnbkdGQb9XexEj
X-Gm-Gg: AR+sD13F9zjp7oNW6lk5NIC7oxbQg8VSlx9Kx0Oj0HJhsWeZkcK8HXh3F3apOgRfU70
	T+l079tXRpEbDKSiIFutEi/cUUGs9OEFJSXJHckA5Yft+p/dRQ5xJCHmhKC8EwT99OAMcso5V8M
	PsOIPS49GgGX6Zte4tNJzlg4yAntNt9PdNhuQVQlVQXGGnBOGma3F4KkjEnp+T0K/KobzDkjFdL
	z5MiuAZ8NvZSSN6lXxXeWek+ZAfbxXK0agOJZU2L24TMMfKW+7RtZWB0tiKt3G5/1TYYsReGZha
	8OFro0K6531SqemeK5qrR9yAH9w41FNJkA9l7SAJ0wGv6MFS5Q+jAZObzoZZwoVU2hTBFPn0+XT
	qcDwJiMZLT2yhDjzFiOJTQwG7VySTK3uKkQgtMZ63cQaK2K1IggG64DCnTt1vVNrmGjegqhnR1t
	fmxWYUky+xdpy2J40ERPCUHqwL/E6386yheP9mmWTEOcRi3qxN9VKkAujJgs/33aNkNWnBQ2SQC
	bFaqKJt
X-Received: by 2002:a17:902:e945:b0:2cc:9179:335 with SMTP id d9443c01a7336-2d0521e87a4mr67586515ad.8.1785679161335;
        Sun, 02 Aug 2026 06:59:21 -0700 (PDT)
Received: from [192.168.255.10] ([223.74.150.56])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045022sm26754534eec.18.2026.08.02.06.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 06:59:20 -0700 (PDT)
Message-ID: <ddc3741c-612a-4d0b-bc58-bc5f54a4080b@gmail.com>
Date: Sun, 2 Aug 2026 21:59:16 +0800
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
From: Lin Jiapeng <ljp1205831794@gmail.com>
In-Reply-To: <am8xmal5nCP4ZvlN@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/2 20:12, Zorro Lang 写道:
> On Wed, Jul 29, 2026 at 10:54:54AM +0800, Lin Jiapeng wrote:
>> When a full-file exchangerange is requested with FILE1_WRITTEN for a
>> fully sparse donor file, every mapping pair is skipped, so no extents
>> actually move.  However, the kernel decides to swap the reflink inode
>> flag based on the request geometry alone, so the target file used to
>> lose its reflink flag to the donor while still owning shared extents.
>> A subsequent write then took the non-reflink write path and modified
>> the shared physical blocks in place, silently corrupting the other
>> file sharing them:
>>
>>   --- tests/xfs/842.out
>>   +++ results/xfs/842.out.bad
>>   @@ -1,4 +1,5 @@
>>    QA output created by 842
>>   +vX.reflink = 0
>>    vX.reflink = 1
>>   -vX.reflink = 1
>>   +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
>>    Silence is golden
>>
>> This test clones a file so that both share extents, swaps the clone
>> against a sparse donor with FILE1_WRITTEN, and then checks the defect
>> twice.  First it inspects the inodes directly with xfs_db: the clone
>> must still be flagged reflink after the exchange (the donor carrying
>> the flag too is the conservative outcome of the fix and is harmless).
>> Then it writes to the clone and verifies after a mount cycle that the
>> original file's data is intact, i.e. the write was redirected through
>> CoW.
>>
>> The kernel fix "xfs: fix exchange-range reflink flag clearing issue
>> with INO1_WRITTEN" refuses the reflink flag exchange whenever
> 
> So this patch/case uncovers a known bug which is fixed by:
>    "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN" ?
> 
> If so please add:
>    _fixed_by_fs_commit xfs xxxxxxxxxxxx \
>          "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"
> 
>> FILE1_WRITTEN is requested, which makes this test pass.
>>
>> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
>> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
>> ---
>>   tests/xfs/842     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/842.out |  4 +++
>>   2 files changed, 69 insertions(+)
>>   create mode 100755 tests/xfs/842
>>   create mode 100644 tests/xfs/842.out
>>
>> diff --git a/tests/xfs/842 b/tests/xfs/842
>> new file mode 100755
>> index 0000000..c4c2be9
>> --- /dev/null
>> +++ b/tests/xfs/842
>> @@ -0,0 +1,65 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +# Copyright (c) 2026 Tencent.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 842
>> +#
>> +# Make sure that a full-file exchangerange under FILE1_WRITTEN does not strip
>> +# the reflink flag from a file that still owns shared extents.  When the
>> +# donor file is fully sparse, every mapping pair is skipped, so no extents
>> +# actually move; the target file must keep its reflink flag, and a later
>> +# write must go through CoW instead of modifying the shared blocks in place.
>> +
>> +. ./common/preamble
>> +_begin_fstest auto quick fiexchange
>> +
>> +# Import common functions.
>> +. ./common/filter
>> +. ./common/reflink
>> +
>> +_require_xfs_io_command exchangerange
>> +_require_scratch_reflink
>> +_require_scratch
> 
> _require_scratch_reflink contains _require_scratch, so you can save the
> _require_scratch.
> 
>> +
>> +_scratch_mkfs >> $seqres.full
>> +_scratch_mount
>> +
>> +# Create the original file with a known pattern and clone it, so that both
>> +# files share the same extents.
>> +_pwrite_byte 0x41 0 1m $SCRATCH_MNT/orig >> $seqres.full
>> +_reflink $SCRATCH_MNT/orig $SCRATCH_MNT/clone >> $seqres.full
>> +
>> +# Create a fully sparse donor file of the same size.
>> +$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/donor
>> +
>> +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
>> +
>> +# Swap the clone against the sparse donor, claiming the donor is fully
>> +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
>> +# and the clone keeps its shared extents in place.
>> +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
>> +	>> $seqres.full
>> +
>> +# Directly confirm the inode flag state after the exchange: the clone
>> +# must still be flagged reflink.  The donor may also carry the flag, which
>> +# is the conservative outcome of refusing the flag exchange under
>> +# FILE1_WRITTEN; the extra flag is harmless and can be dropped later by
>> +# the regular reflink flag cleanup path.
>> +_scratch_unmount
>> +_scratch_xfs_db -c "path /clone" -c print -c "path /donor" -c print | \
>> +	grep reflink | sed -e 's/^v[0-9]*/vX/g'
>> +_scratch_mount
>> +
>> +# Overwrite part of the clone.  With the reflink flag correctly retained,
>> +# this must go through CoW and leave the shared blocks of orig untouched.
>> +_pwrite_byte 0x42 0 64k $SCRATCH_MNT/clone >> $seqres.full
>> +_scratch_cycle_mount
>> +
>> +md5_after=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
>> +
>> +test "$md5_before" != "$md5_after" && \
>> +	echo "orig changed: md5 $md5_before -> $md5_after (write hit shared blocks in place)"
>> +
>> +echo Silence is golden
> 
> This case has expected output, so it's not "Silence is golden",
> please remove this line.
> 
>> +status=0
>> +exit
> 
> I remember we've changed xfstests/new script, it should give "_exit 0" at here.
> 
> Thanks,
> Zorro
> 
>> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
>> new file mode 100644
>> index 0000000..1e6345a
>> --- /dev/null
>> +++ b/tests/xfs/842.out
>> @@ -0,0 +1,4 @@
>> +QA output created by 842
>> +vX.reflink = 1
>> +vX.reflink = 1
>> +Silence is golden
>> -- 
>> 2.50.1 (Apple Git-155)
>>

Thanks a lot for your review!

Yes, this test case uncovers the bug fixed by "xfs: fix exchange-range 
reflink flag clearing issue with INO1_WRITTEN". However, that fix is 
still under review on linux-xfs and has not landed in for-next / 
xfs-7.2-fixes yet, so there is no stable commit ID to reference. I will 
add the _fixed_by_fs_commit annotation as soon as the fix is merged.

The other comments will be addressed in v4.

Lin Jiapeng

