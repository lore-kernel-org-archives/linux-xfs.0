Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D32DEA6B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623230; cv=none; b=farClIiRar3ob95bVEWaJqZVnhvaOUt4z0oGIUbvcPJNoKsAAnODqwUNOHqhBR4MpZzI/IBFVF83OeIyQXl9w0/h+oVkZHhLeZnvUNPkVkwhwZBq0ToMpRkLFrQv8BGH7U0nwH+dFxroSqHmKnDcWzNr+akmWV54QtXIhX3+fhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623230; c=relaxed/simple;
	bh=tOTN8z6+SLV+AnWDfyA8xP9ZoqvXiNv0mAk49Gnfsms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRk5SnYhVaxN+T71X7tr7SgfegCyKbCgpy0blVadMl00VyMMQOLHAJQPqJUmwhN8eEjwytTo3YTgw3/xDGMTP5/a5odjZb1nKZIQ2qeCJKwPdmnLkp5XUCsNVaHyXb2FoyJnVo44X4Sm7cchRj3PuvYEofDbYghjiNiuOBvnIUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3iUt0yZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3iUt0yZ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a09757004cso426555ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769623228; x=1770228028; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mdqVCV9pEkDtK+V5yYimkvCt/KND6VVw+7cHj5KfQ0I=;
        b=b3iUt0yZ09asQXot3IPXF1VuSkeQoWBDexzXSqmHBs0KTTgyjFE7SbmfaDdXinRmaT
         6wsNGW8O/yAmCwBKEr+XhPbolnZ5JM1bIgW/fIxNWkHtg+RIeJVNxUbu29QwhlZBbGWt
         nzK1LR5qm9HJjvwkuNCCpD4TVN9Fsun0wYqH3mmxJTzkDLkKZ7lECbHvXouSaRz1wmat
         xXRJsxw5YKjVSlUZJlVEEvAkdaMhEaBPMIxXs1npoCfgQyRv5MaPyQGG5dnBhUXyaIh9
         MHaDlmv16+6ZdUYhcAks9IvMpS2muJEiiq6Vydz2ACbkOGfc5JYpPkMstnkN/qAgvwLL
         0wJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769623228; x=1770228028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mdqVCV9pEkDtK+V5yYimkvCt/KND6VVw+7cHj5KfQ0I=;
        b=s138y0Rk3zcHKl+zOhenUo5mcHn6G8uQkYW/jp7dEYpKc5G5KPfrI7jvWxx/QT8JTA
         RbAC0xZyVJlsjqejlfv1lgiGPZrVmubN4VH7Xt6kMjifsVLwUtyP1Jtx4VBcPCt90st/
         asyOXfwMLAnlRoiyVogBEO8k1e06l8yyv56/v+/+8OKB4UzPUc/KNAerl6fTKqRI7/Wn
         EEVBGJL31JaK8WP0nXZkRD9a3yTEeE9anBkrEL1E5/qgV5BXKevF7eqrWxIrngsug9KQ
         VgWlzy8/k/b8puU+6HUWhHR41s71TLUCm72kBKzUf41fa1sYEPEF4kkJaFT7qPu3TgkW
         R+1Q==
X-Gm-Message-State: AOJu0YwSx/tpATDlT79Q58iWf2ghpQ64BaFrySrJmXCynTtmBZJTRXVh
	+c9rd0irTB2RNAdXGXdrcYxEUc9b8eq0q+z4TgLfNs8y1v8O4t5l2G3T
X-Gm-Gg: AZuq6aJxqB2LRG5b60E9ZXxBTBTpHnjcdW9v8BrDqA6DmofYHeQXW+o5Q5/VyowtFtU
	hWqO5zsrIPXOljGeqNxrQMpP5vxUZqdn4E3/z5yVczivA9UvWkaYRkWoDZoE4HqthxN3fOzewiV
	B4dui/ax8lzHmsOt7y0dUM7gfk2gPFFF3CzkYtWuGBH3J21/JBZYoOGNYIm0pv89mU6+yv9PGaj
	9S2JhbcOE4ZOMnzEBSxs00MbTctBDPzqT1Ap3XBfpHvXjzYoQdknXtDCVER+7K6EayX4aAsnsWF
	jWWGxZiGFl75VsfF27AqNZkeyLm8asEe1wQYCu1ZiUoC22O1TDdplRhlSeYlT7mJ1MRJikuTNbU
	b/Wv/ollO+LAmB0NmAq5cwTJRLOl4Ot2d++UFFZjmB7C36AkIbfnh3d3KjBfK4Ggh42U5FTmS64
	7cpPAyU0fY04TTTJNTKIZa5A==
X-Received: by 2002:a17:903:19c8:b0:290:cd9c:1229 with SMTP id d9443c01a7336-2a870d577aamr64320765ad.19.1769623223496;
        Wed, 28 Jan 2026 10:00:23 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4153e4sm30665515ad.39.2026.01.28.10.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 10:00:22 -0800 (PST)
Message-ID: <dad72f2b-1cd6-42de-98f1-8c9bbbb4c8ef@gmail.com>
Date: Wed, 28 Jan 2026 23:30:18 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] xfs: Fix in xfs_rtalloc_query_range()
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <43e717d7864a2662c067d8013e462209c7b2952a.1769613182.git.nirjhar.roy.lists@gmail.com>
 <20260128171443.GL5966@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260128171443.GL5966@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/28/26 22:44, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 08:44:35PM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
>> start == end i.e, when the rtgroup size is 1. This causes incorrect
>> calculation of free rtextents i.e, the count is reduced by 1 since
>> the last rtgroup's rtextent count is not taken and hence xfs_scrub
>> throws false summary counter report (from xchk_fscounters()).
>>
>> A simple way to reproduce the above bug:
>>
>> $ mkfs.xfs -f -m metadir=1 \
>> 	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
>> 	-d size=1G /dev/loop1
>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>           =                       exchange=1   metadir=1
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>> log      =internal log           bsize=4096   blocks=16384, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>           =                       rgcount=4    rgsize=65536 extents
>>           =                       zoned=0      start=0 reserved=0
>> Discarding blocks...Done.
>> Discarding blocks...Done.
>> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
>> $ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>           =                       exchange=1   metadir=1
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>> log      =internal log           bsize=4096   blocks=16384, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>           =                       rgcount=4    rgsize=65536 extents
>>           =                       zoned=0      start=0 reserved=0
>> calling xfsctl with in.newblocks = 262145
>> realtime blocks changed from 262144 to 262145
>> $ xfs_scrub -n   -v /mnt1/scratch
>> Phase 1: Find filesystem geometry.
>> /mnt1/scratch: using 2 threads to scrub.
>> Phase 2: Check internal metadata.
>> Corruption: rtgroup 4 realtime summary: Repairs are required.
>> Phase 3: Scan all inodes.
>> Phase 5: Check directory tree.
>> Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
>> Phase 7: Check summary counters.
>> Corruption: filesystem summary counters: Repairs are required.
>> 125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
>> 64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
>> 18 inodes counted; 18 inodes checked.
>> Phase 8: Trim filesystem storage.
>> /mnt1/scratch: corruptions found: 2
>> /mnt1/scratch: Re-run xfs_scrub without -n.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Yeah, that looks right.  I can also reproduce it with:
>
> # mkfs.xfs -m metadir=1 -r rtdev=/dev/sdb /dev/sda -r rgsize=65536b,size=131073b -f
> # mount /dev/sda /mnt -o rtdev=/dev/sdb
> # xfs_scrub -dTvn /mnt
>
> Cc: <stable@vger.kernel.org> # v6.13
> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you. Will the "Cc" and "Fixes" tag be added from this 
automatically, or do I need to re-send it by updating the commit message?

--NR

>
> --D
>> ---
>>   fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
>> index 618061d898d4..8f552129ffcc 100644
>> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
>> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
>> @@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
>>   
>>   	if (start > end)
>>   		return -EINVAL;
>> -	if (start == end || start >= rtg->rtg_extents)
>> +	if (start >= rtg->rtg_extents)
>>   		return 0;
>>   
>>   	end = min(end, rtg->rtg_extents - 1);
>> -- 
>> 2.43.5
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

