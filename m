Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE832DCF55
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018913; cv=none; b=G/sYFQ9wpOcu7t68HhX/z5HW3DjHEInknPUTygi9WRg/s6umGY9o3b5e+S6a5n9UmOSOVa2X9z/6A1WqC3sW2HodpxDr6+K8QzsTRrcBj3NLBPLlsetHmh4gZt4UCT4PLHWVPG0SkxS3XMoU76Foi9yQlwUzoHM2CGdqT4K0Ugo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018913; c=relaxed/simple;
	bh=ewYD648kLi7ijie2pNUMnth8sXjhOPk+cRPf64eMpnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C5EAo7uuuKV3uQ8hk1p20KAs9hpg2sRscwm4kFdCUUKNiB6uDny+T1Fn2J3Gtn/mKkKbBQHlj8lYrmQ3JcDkBBVNgx0hPtw/mtzFvV5Xl7zFZ1aUOuWj6rFgocioX4GALV7aj/aPRM7DoVQyD+eDlDsO6yN7njmqTgGDqdfE9Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CP+qkHJo; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP+qkHJo"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2add623cb27so4435925ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 03:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772018912; x=1772623712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Stbx3cENyh1ajuB+343ZQUu77ZJEen/rrolLO4a9Mn8=;
        b=CP+qkHJocjIBy1T2c9qMEgVDzklqDQiO2dyxANUll15pyj9iytmLcz9MXQHyHGB+Ua
         CGm9s0W4jU5x11z0G7KKvvFXduu19wTcASlxJ1C3vQ7oglsa6sZmgh0TLeoxoFu9IwDW
         CDzm74IB5ejZdVv3VI/wQNIjHzgy948IRIkVNEYm6CPZfEgg6vKnK3GSasypyGPLFzp1
         F7vXPIFuUROrtChnKbvA9OwFfth6uwNleQ3m0peG1jnwBon2tL6sdoSJHwDx9sF5Vij7
         FietDY11lCPx6aw9zkEeEOsFAReoU3az6Gpo/5/0E8Qek8ePAW116DanZsmEKyjUmBkD
         4iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772018912; x=1772623712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Stbx3cENyh1ajuB+343ZQUu77ZJEen/rrolLO4a9Mn8=;
        b=ev4eYC/i7cskU9wvlEGn7UxyXhHL/Ag8DxEp/dsZEC1Rvs8G4GseJfwQWPbi32kocB
         fUsDLZyGmtmq0R7hoM4FiZlHePQHGG3qRAZCZru3i3g8leNv7VjUv+Dzqrpor/zk7LUw
         w8EIsyuAGpF/8G2aTsnKoswrDBeFUy+SAJJyBQ+1s5fHO21nEdxscJzAkOI6Th6nOV9h
         S17E45OqkP/3yBkjiSHvyShQHVcEj8c4cxsnhgtjUuzccCzt1blq1WGfzAnDtim89Mgx
         Ni2Kg1hSE4Mtl542WhKFjzVnnsZjIOrBI7zykuDCld/i1gSzFD+P2qxMXH12UpkOfJO+
         JZ7g==
X-Forwarded-Encrypted: i=1; AJvYcCUneCH2bvnIK5dSEsZG62eHdOgFODy+DR4Ms9Jx7aHMi7itrBGayuMjhH+rJ9VTffmELrcD2dXJZTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN0DchBDBrCm43/T44As4R7aKYO6QB3oo+pYO6awkIMcQJA/JT
	faXsCfN+UwbRCukNv8pUZFziSc4FthAghqJN/AmdAYFVHRKdZ+HQ1RRn
X-Gm-Gg: ATEYQzw98vlckd7C3K8WAkF+IP5mS9fixiAecEknJpBWg+nm79yZPeFLGsL9fOKOKQa
	Hi67fx8BhdOhQq7QRTubSg7WoZiVqD4PGDxwQz7HOFq5QlLiIS8+CmkGtzoDAc/+8kIVgepKJqP
	6IkV8lkINPXVfehl8YQBUM01stlK6j8vXbKc3blQ4btbi6rN+DwLyEW6Zzpqwbn/b5ogH3JxyRl
	p9yIMRzLtyXtlWg9sC8HVk7lDo6NMf549Ntp8B0MkmtXFTHPgPRcasQeS0oIP4JW+EbOv50AXkH
	ozuL2hBLTk+n4eojKzM+ZMFJL9HLfWtsOjnSdwXfBMancFhiKRFjyVDl8bZfjgMAcSj9wrHTc1G
	43gPxYMvjx/OWuAH3PWUmWULSl5np3krn8Him/7xpSwe3eBkI2y6UHTeclZjCjKJQj6nPQbxwJb
	iX1C0EklMzTeh566Abmw2muMLy7G2ThF5M
X-Received: by 2002:a17:903:2a83:b0:2a9:5c0b:e5dc with SMTP id d9443c01a7336-2ad745698cfmr137564345ad.54.1772018911704;
        Wed, 25 Feb 2026 03:28:31 -0800 (PST)
Received: from [192.168.0.120] ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adaa3b2b9csm50320705ad.1.2026.02.25.03.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 03:28:31 -0800 (PST)
Message-ID: <7f4591c2-d1c6-46a3-83b8-c6f6626cc7e4@gmail.com>
Date: Wed, 25 Feb 2026 16:58:26 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v4 2/2] xfs: Fix in xfs_rtalloc_query_range()
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <4215ff7fc2efcf2e147d2d413e5b0505ab332ec3.1770133949.git.nirjhar.roy.lists@gmail.com>
 <aZ7Q6oTr9-WyPQ0r@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZ7Q6oTr9-WyPQ0r@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/25/26 16:10, Carlos Maiolino wrote:
> On Wed, Feb 04, 2026 at 08:36:27PM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
>> start == end i.e, when the rtgroup size is 1. This causes incorrect
>> calculation of free rtextents i.e, the count is reduced by 1 since
>> the last rtgroup's rtextent count is not taken and hence xfs_scrub
>> throws false summary counter report (from xchk_fscounters()).
> This causes a regression in xfstests's generic/475 running on a RT
> device.
>
> I'm dropping this patch until I have time to investigate what's wrong.


I just took a quick glance at generic/475 - It does something related to 
recovery. I am not sure how this fix is affecting this test. Maybe this 
fix is triggering some other bug which needs to be fixed. Can you please 
share the error logs and the local.config you used?

--NR

>
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
>> Cc: <stable@vger.kernel.org> # v6.13
>> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
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
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

