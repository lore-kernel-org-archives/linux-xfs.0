Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEF9279DA2
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772030797; cv=none; b=YPnOM+Sy+Au1z1y/U0L6ZW2P1HhbnxlZcfVQeCf1g5Iq/2o4Q1CSd8aM+EewdZrnPiuN0ywnSFBFDdeZ0dRh88LcrGDtgQYyNkfQrBbOTD2giRQwdCk/lge7tfvAry6Vr/uNUTdwTZ/rer1hgK7Ees/9p/HgV4g964ocjUxzNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772030797; c=relaxed/simple;
	bh=Jfqva2OHYUfK2YpBSNdwYv3NI/2RhcR4aJWWb4J5HJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3XYNKUBP95CQ48L6kX996KvR8D4XKaKVYT3qswRYywEljmjwJzAyuaJ9U5gJbzyZe4WT7PYn5S6ZvnDhre0sbWipLZ+6wSzyWq3Zg6xE24pSLDXzQv1Sq3TqttHaO0aySL2DOrFJEZ/ccolB+NRjQQC+3Y/k8EgaT/OM5FXGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLbGTjlC; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLbGTjlC"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8230d228372so3316340b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 06:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772030796; x=1772635596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1K864e157LYFS6D4y/luLtrF2G4nrkfjzO/WjT1kFLA=;
        b=LLbGTjlCQTVMfoOz9E/+jjZplvpEqYUHlj1peF1JXHL4sYv7+DxeVdTXmWJ+nGl9l2
         GwQnOnfugraVdXQPrPUphPI0m4AqTGgacNDhKDvY782B1tIgzZB60IPj23dacTiO0LQp
         UCVZWuNWoBz8Gjti8BwcvzMBrwhZpNkv52tOS2M4EmsX3FZfp9dgug6SiUXO/JRIzWlj
         Kk0UKi9QdJbtEENO4Ki8MkE/2dVTxdX0h2CYuFGXDBMFSMLxDRgV35WLPK2WBGklby1Z
         37JJ4lbNFLNNWKlLipe2vUUuPC8P2ZtmmB5LKgElYfVA81qMMQRsXmYE5J73ldrO2fX2
         qAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772030796; x=1772635596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1K864e157LYFS6D4y/luLtrF2G4nrkfjzO/WjT1kFLA=;
        b=Z2y1nVpvzJH5PVivvE60dzKQZFHpnNo/jEEI8f0Wv+d7IcYVmOstRviVHUAwaOY/cb
         GiDrnVE2D7Qh45BkAGkeBQL7gumvuHbbQN6XAHRovZfC2zRl1Ny7cKasS+mdrOl4kUxP
         xD7V0tTkAPM89Yp5U7z1zGyyiHFR4xekXZIXsXfs27303pVM5EEczs1LtsK/tluXm9nc
         rspni1PMlZYYiN1w0DXHIpAzLHPBJ9iG5FRNU/X1npi4BxjRd4kcMAKs9jaFTnXzLKkz
         gCvHognJbVt2Eiid3FQ4MR50DCcqFlVoKQyjrLNtZ/mDkBJts224JZhQnjAo7fiwlU1X
         SmFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAKzJ8Hsg2gk8bub2fXLWNGVJibev2mCHSRZSkhkWZCVuseNnI/pKl0/4KrdqdhjYUpQCZJvM5ynQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJHoCUf1EiXghIeErbofAjgWu1iM2DVnt45/hAmKrkUu4FgPO
	Ic2HyH6SQIcDHScMdClAto1SJYpQG2aqqOCHxYP8ap7QtWgb0hKH/hDk
X-Gm-Gg: ATEYQzwYsW55I+cVMMOIaMHV3WBCFoUJSKQcacXA/2dVeyO0QaB6BRxPyQP8ABfRiLk
	/2CR1JDu4cuxNUMx+6ne9ezPuQkOB2ai+l32wAixY3toWqy4q1TLuXOeJwi+1P+kvnDBh+Z9EfD
	10lBk0p9exYabm4C/FklwX+P0wn+oKPGVUu/aZJUiG6wvolJUbyipSLCRXJsYKcjRQ97PeNAyj9
	3DppykDemdjFRJoTAnoAFTqGw+bq/WzDLtloBkHFbqt3aQC/2nbCS9+vCQDid+WaTgsXb2phXW+
	bH0htYbECCrDy7WnYDxrjUwB1p2uz020TJpSDMgr9kXk98tQzuUyOeboqL9TUZK3w8MMR6ZR2NL
	05tdKLHuv0X1ryRwQieMBHTEitp92ROgd/Ig8iVDjWaETL3aOOZ+k+SYwbkEgQuZ97t0iYaQtYc
	9rLY06o4IkgCc3NeSGOopGz7oSulbKmEur
X-Received: by 2002:a05:6a00:b94:b0:824:9547:c5cb with SMTP id d2e1a72fcca58-826daab6c29mr13504426b3a.58.1772030795726;
        Wed, 25 Feb 2026 06:46:35 -0800 (PST)
Received: from [192.168.0.120] ([49.207.233.55])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82721446197sm3167851b3a.58.2026.02.25.06.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 06:46:35 -0800 (PST)
Message-ID: <f9ff2fbb-bcae-4a36-95c5-9d12d24d4a35@gmail.com>
Date: Wed, 25 Feb 2026 20:16:29 +0530
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
 <7f4591c2-d1c6-46a3-83b8-c6f6626cc7e4@gmail.com>
 <aZ7on3baf3v3qh0z@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aZ7on3baf3v3qh0z@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/25/26 17:49, Carlos Maiolino wrote:
> On Wed, Feb 25, 2026 at 04:58:26PM +0530, Nirjhar Roy (IBM) wrote:
>> On 2/25/26 16:10, Carlos Maiolino wrote:
>>> On Wed, Feb 04, 2026 at 08:36:27PM +0530, Nirjhar Roy (IBM) wrote:
>>>> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
>>>> start == end i.e, when the rtgroup size is 1. This causes incorrect
>>>> calculation of free rtextents i.e, the count is reduced by 1 since
>>>> the last rtgroup's rtextent count is not taken and hence xfs_scrub
>>>> throws false summary counter report (from xchk_fscounters()).
>>> This causes a regression in xfstests's generic/475 running on a RT
>>> device.
>>>
>>> I'm dropping this patch until I have time to investigate what's wrong.
>>
>> I just took a quick glance at generic/475 - It does something related to
>> recovery. I am not sure how this fix is affecting this test. Maybe this fix
>> is triggering some other bug which needs to be fixed. Can you please share
>> the error logs and the local.config you used?
> I will get the info and let you know, I don't have access to my test
> system right now to get the details.


Okay sure, thank you.

>
> What config did you use? I'll give it a try later tonight and see if I
> spot any differences.


I haven't run it yet. But I usually use the following configuration

[xfs_4k]
export TEST_DEV=/dev/loop0
export TEST_DIR=/mnt1/test
export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt1/scratch
export SCRATCH_RTDEV=/dev/loop2
export USE_EXTERNAL=yes

Most of the options are the default ones and/or used by the test script 
itself.

--NR

>
>
>> --NR
>>
>>>> A simple way to reproduce the above bug:
>>>>
>>>> $ mkfs.xfs -f -m metadir=1 \
>>>> 	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
>>>> 	-d size=1G /dev/loop1
>>>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>>>            =                       sectsz=512   attr=2, projid32bit=1
>>>>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>>>            =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>>>            =                       exchange=1   metadir=1
>>>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>>>            =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>>>> log      =internal log           bsize=4096   blocks=16384, version=2
>>>>            =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>>>            =                       rgcount=4    rgsize=65536 extents
>>>>            =                       zoned=0      start=0 reserved=0
>>>> Discarding blocks...Done.
>>>> Discarding blocks...Done.
>>>> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
>>>> $ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
>>>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>>>            =                       sectsz=512   attr=2, projid32bit=1
>>>>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>>>            =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>>>            =                       exchange=1   metadir=1
>>>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>>>            =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>>>> log      =internal log           bsize=4096   blocks=16384, version=2
>>>>            =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>>>            =                       rgcount=4    rgsize=65536 extents
>>>>            =                       zoned=0      start=0 reserved=0
>>>> calling xfsctl with in.newblocks = 262145
>>>> realtime blocks changed from 262144 to 262145
>>>> $ xfs_scrub -n   -v /mnt1/scratch
>>>> Phase 1: Find filesystem geometry.
>>>> /mnt1/scratch: using 2 threads to scrub.
>>>> Phase 2: Check internal metadata.
>>>> Corruption: rtgroup 4 realtime summary: Repairs are required.
>>>> Phase 3: Scan all inodes.
>>>> Phase 5: Check directory tree.
>>>> Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
>>>> Phase 7: Check summary counters.
>>>> Corruption: filesystem summary counters: Repairs are required.
>>>> 125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
>>>> 64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
>>>> 18 inodes counted; 18 inodes checked.
>>>> Phase 8: Trim filesystem storage.
>>>> /mnt1/scratch: corruptions found: 2
>>>> /mnt1/scratch: Re-run xfs_scrub without -n.
>>>>
>>>> Cc: <stable@vger.kernel.org> # v6.13
>>>> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
>>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>>>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
>>>> index 618061d898d4..8f552129ffcc 100644
>>>> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
>>>> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
>>>> @@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
>>>>    	if (start > end)
>>>>    		return -EINVAL;
>>>> -	if (start == end || start >= rtg->rtg_extents)
>>>> +	if (start >= rtg->rtg_extents)
>>>>    		return 0;
>>>>    	end = min(end, rtg->rtg_extents - 1);
>>>> -- 
>>>> 2.43.5
>>>>
>>>>
>> -- 
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

