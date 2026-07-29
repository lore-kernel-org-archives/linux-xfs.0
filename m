Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D441C3BF7
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 02:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291169; cv=none; b=ZwVwlsLjJukMQLdy4DFW92HkQdZKrM1O87DWbljn2R+dE3/3j9s7Y3IamicsCaUQBt4Pup/d+UJ2Cro0/yz4NkEC3CWy2R8cd5GFon8Od1kOeshvuB+RA60mtTmGfs0A3aASOwNI4Adm7ZEFw8lbum5r8QCJeG0Niusmsq+ONWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291169; c=relaxed/simple;
	bh=8s8l9oLy6san5Ny3YWw4d8plyeV8xyaDAeJydIcNQds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucAz6djXsNAGi8PrF1o0OFUiDA/nc8cYd7ymDKs8l18WUTRF/jbDlK4szaf1sT78p+OWUETssVw1cfICpmc4nfHRDKJAxGYcFQ0gOJkE7R7PDv0k1tbp0dFblXDd/kfl09rvoB4eYxwhauTyC8dYSNglbch7qHGU0RHNe/YD/h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hL6fuc2U; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hL6fuc2U"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cacb8416a1so5110105ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 19:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785291167; x=1785895967; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HGBPMROsgLgbT3byueaN0O0kRbpQFujDR4wkO5Vwjps=;
        b=hL6fuc2UWiRsknAssroGi5tKdpknYZsYwaSfy9U8narnbos8Z6BVoCmvFa7YmbSTjq
         ecRtGMYFDixVvgeP9SGqtsEX/xcIQkLtOYWmg43MTRK3XSq6JOQhtLozIodkCYBd25qP
         e1Y6qtk9PD+m/R6CJRTYtKhSYutXjWdZqXhel0CIETSSMB+xXzeHzGmIswQknCi3RJOl
         Po/9ik6pGZxfL2GbXN0NAhCPtFf8OWDQPW0AvsDtbOMNabqc1KiDrbNRNp31L7nCSYbb
         1OWom9y2Eo3u80IZr0yd2+F8f/PWpeU5Qh6yT7SrvSLVy1D+aj5F6ApoAGPYTsknaV8L
         alGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785291167; x=1785895967;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HGBPMROsgLgbT3byueaN0O0kRbpQFujDR4wkO5Vwjps=;
        b=dIaPzM56tkuuHnvDG9nnIZaUrBzDA3upYxoubO+JJhEjeRp3SnOAXeK5BBlWMPffF5
         PNKi1FsByFJ2N5YQpXeOKM29qNPd9Ik0KhsAUKCchnN+IPJP80shkZq5/z0eBk5yGLSM
         6BdwVvbyEdLELAFiQmDUw4g8+bhpvWsfG0mgQFaWD2WtsqtjAa1vcIWZcTXtChbvrjJ+
         Meas6ph17QPPSq6RsoiCIFvIDRl3lYJcGZSsIglfRKbhczm4OBvf7d60YY9AAtSIkK2c
         Vr46wbMan/iNWGITzd6N6DU2tUrOZU0/ZMGT/CVepi7UEH10yLF2dQ1eEZ/2eXfaeaZM
         NkyQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnmkqJXH0c06iQN1691W5z0FVsPClWIvfuxEj3MI/WUyfM/rVBCDMawCl2y7AtX+lTAGRVhSugYzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsTReryHrlGh/2rlux22QiMFf3dbvBj0tbzDBa7EBkptWG9SLf
	aylRDT9yeBXrVC1jdO8P/6WBB2KVYdSa9aL3AfBsGM4r7yX9Jccv+PqgIyx7uwrcE8Z5Sv7F
X-Gm-Gg: AR+sD12NKceDmK5DBfIuGwNlFIi0R3Nc93wnx4MLkMtAWdfv0O+q2yh8dH+JC/NbNi4
	NW8BHdJgZ3EfJ+hG+raNYMCPgt2JIFpS0ISawyDpg28SxD53y4IvM8beJss7OU8sJ+LgyN7vLlJ
	CTxVN5mCYZKDFMQGt2fZVkzrxIo4oONYPrchmoaPeECnjvmOlvEu2IavMzxCt+PcVCJYGnXPCXT
	/ULq4qbqceti70bkei4w+6n71gbZM5cUr5WCIFNDDqHfM62BimSNzGaAl25lTvnKKZtlHsomDN2
	s6cKoDYOAJ/L2gM6hmd1EB5gTOKsaGga2CbsQKMx5Q6dan/OcMuhJ9SfMiMK8MD9Qxv0JuV7zDp
	ZCJLF+wmMQyESnAUacYxetDxQjBLbdsufyQfkzGaT8c0nU2mqtxUCUUppORElKdTE3LnhYOfXVt
	ReroE+WO+7GdDRsGj2s9poXgaYxK8g21M3j/vCurvL+7U6CnJ+v39rENEKnbhL95qNrxH9H409p
	vZ9X7uCXl88d/Wy3pP4R/ItqlkF4A==
X-Received: by 2002:a17:902:d4cd:b0:2c0:e2ea:6b0c with SMTP id d9443c01a7336-2d015c17676mr52043675ad.21.1785291166863;
        Tue, 28 Jul 2026 19:12:46 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2dfb1sm3645385ad.72.2026.07.28.19.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 19:12:46 -0700 (PDT)
Message-ID: <dbdc8374-7eb2-44b1-9678-a5627d2cb5b5@gmail.com>
Date: Wed, 29 Jul 2026 10:12:43 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org, jiapenglin@tencent.com
References: <20260728071625.79516-1-jiapenglin@tencent.com>
 <20260728145946.GK2901224@frogsfrogsfrogs>
From: m00nb1rd lin <ljp1205831794@gmail.com>
In-Reply-To: <20260728145946.GK2901224@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/28 22:59, Darrick J. Wong Wrote:
> On Tue, Jul 28, 2026 at 03:16:20PM +0800, Lin Jiapeng wrote:
>> When a full-file exchangerange is requested with FILE1_WRITTEN for a
>> fully sparse donor file, every mapping pair is skipped, so no extents
>> actually move.  However, the kernel decides to swap the reflink inode
>> flag based on the request geometry alone, so the target file used to
>> lose its reflink flag while still owning shared extents.  A subsequent
>> write then took the non-reflink write path and modified the shared
>> physical blocks in place, silently corrupting the other file sharing
>> them:
>>
>>   --- tests/xfs/842.out
>>   +++ results/xfs/842.out.bad
>>   @@ -1,2 +1,3 @@
>>    QA output created by 842
>>   +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
>>    Silence is golden
>>
>> This test clones a file so that both share extents, swaps the clone
>> against a sparse donor with FILE1_WRITTEN, writes to the clone, and
>> verifies after a mount cycle that the original file's data is intact,
>> i.e. the write was redirected through CoW.
>>
>> The kernel fix "xfs: fix exchange-range reflink flag clearing issue
>> with INO1_WRITTEN" refuses the reflink flag exchange whenever
>> FILE1_WRITTEN is requested, which makes this test pass.
>>
>> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
>> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
>> ---
>>   tests/xfs/842     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/842.out |  2 ++
>>   2 files changed, 57 insertions(+)
>>   create mode 100755 tests/xfs/842
>>   create mode 100644 tests/xfs/842.out
>>
>> diff --git a/tests/xfs/842 b/tests/xfs/842
>> new file mode 100755
>> index 0000000..6d5bcab
>> --- /dev/null
>> +++ b/tests/xfs/842
>> @@ -0,0 +1,55 @@
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
> 
> Hehe, this is exactly the same sequence as the testcase I wrote
> yesterday afternoon, so the review is easy;
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> (For extra clarity I also had done:
> 
> # Check reflink flags
> _scratch_unmount
> _scratch_xfs_db -c "path /orig" -c 'print' -c "path /donor" -c 'print' | grep reflink
> _scratch_mount
> 
> for direct confirmation of the incorrect inode flag state, but the
> md5sum failure suffices to prove the defect.)
> 
> --D
> 
>> +
>> +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
>> +
>> +# Swap the clone against the sparse donor, claiming the donor is fully
>> +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
>> +# and the clone keeps its shared extents in place.
>> +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
>> +	>> $seqres.full
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
>> +status=0
>> +exit
>> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
>> new file mode 100644
>> index 0000000..643d052
>> --- /dev/null
>> +++ b/tests/xfs/842.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 842
>> +Silence is golden
>> -- 
>> 2.50.1 (Apple Git-155)
>>
>>
Good idea! I will add direct confirmation of the incorrect inode flag 
state in Patch v2.
