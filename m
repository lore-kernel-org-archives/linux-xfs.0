Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F72238C29
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625066; cv=none; b=sw9BzBAF4Y96wDa168DHS6t4MiKDqS7xQQoesaap6T0ZuBbUOyKIk2CG5QgQkbwFB+W3aVhm4t5/7UBIDLr+ZgC/XYwaxe4qy6wPjAs7Dc0mPEB2r/wUCqi5jXOanGE/RVwAAC+bQDonvyLj4NKUdPVhWuRBEuxenyca3rhdX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625066; c=relaxed/simple;
	bh=IWVsyMAZBY2s2mW6om389dqeNbmO/972FHHW+ScYeNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ridH2j2T2CPs32ofbQXAMfDUfGZ9zliQigEyQ2aFlzME05T0NMzJwQbMBiV1HEpyGsYC1T9+o0CbixAXT+VQZHjIpJGuZ2MXDZ0ckckDU1YUcUhU8xLl8v1WclXMCurX6LdBEKKYE4FOZzJFq3DFDuZyqJZBGrj0oyU9ni3wlsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlIswqp5; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlIswqp5"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso77017b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769625064; x=1770229864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CapwaP+whNrAYWtsfjK14HnQEoPz7M3C8JQMxP+OEZ0=;
        b=MlIswqp5KNqktiTH4CxhW7Z8VR9IRJCdau+OdZtGxF5C0jebwCQd+VfRLi9jKbpjre
         qNDNk8U+xp5y2luytCrAWV2JvHErCG4hUWHYVn1PPIv8y+O6fmgJGHm/7ti/o4gpYQwy
         xRi3/37iEBJIUgOTvNSR3U67NFByG/et6wNgNW4TpeFgFEs+/sbFC7DGrt9Blkoxj1SX
         mTr0Gb9tMFZ1NLf41VQMfdwJCauyvho0NUlv+NKBfGOQv3NRGCVON8FT+ST/9WpzPCri
         q073DZHSzaK3sxSsRT/VUhvwTllLjFH7CyY0JokikGy47OYZe1SMo3ILE+mCXVp0qZlg
         LdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769625064; x=1770229864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CapwaP+whNrAYWtsfjK14HnQEoPz7M3C8JQMxP+OEZ0=;
        b=eeFsCeJO4cGyNI7hlKF0ZEn1z3raTAIX6lAIMhNtOCbBQNrCnpbFpqJOJDbH6BUztv
         e56NccogaF5l6dlqgkUwrrFYGheiz/EnpplxxKKpqWKbgAGZOgwIUYO8zBoytnwWpDJ7
         Nm2RYPXK7rcIEHTOhHkCizV0hgiDyOBIasBZcpB2BWte/MpSKxFLYLJoE4qfiKfEgmYF
         azKLNRyq9ABK+uIBror6jjgrAWPYwdrDs08j3lVRwL3E4wrKxogXosgcqHNVjUu0PDwW
         qlViY8hX26kGH7G8Cvj8aXrXVVVJXqUFU5ALTj6NYnAZQgVkmvXuhXgvmTLwKppuixlw
         ggZA==
X-Gm-Message-State: AOJu0YwNncnZJR1Z6HxTjlmQL+caAh5rO81sKIhxZjGJyjbF5GNx8ia1
	CaiNq/B/4u7Hr5OI+MsqGx3xV2b3ff0l9XsvD/FLWRdqOndE+MQmmhhu
X-Gm-Gg: AZuq6aKW/bRjvN/BjGYB3bzEBqr3Cf1pfdQPBYR55GnEXwqQRTDJDXi5MRqOws+Gdc8
	RfoXdljWsBvbb/yONzclyRe8rMfqhUqOFVcRHTbGM5U3StY1mcy1Yk5nJNwHiDm4O5+zIQOvS8X
	G3sxYai7cgBEr20i1wNa2FqoZ/fotKAeuNJTcJWpIY+EEIi0TaT8JpjLIuZaR7QmiT0cHsFQPg0
	oYHSpnmvA+zBlMEWGb5IVgYZNQvXj19xDEh9Q2VrJp4yhZnWgn8FVvXdI7zF0igFuSpo2fj//jX
	V8DOOQbvP+w32ovxFVWvyMt4mWhZTPsZIDUQHZl5fi6E4fgY6PaIPnJgHjn+4glAD4wIUKulwkA
	8/jN4WU60wyvvdFe7lVk/GhQPbs46PoPfGw4fkUdUJKhxyjReiPRUGWCbGsdmvE3M2aM5cd0P0I
	4l/pWgJwdMWfuB4M0JWIsw7w==
X-Received: by 2002:a05:6a21:68c:b0:38b:e944:3e90 with SMTP id adf61e73a8af0-38ec640fac7mr5718912637.46.1769625064076;
        Wed, 28 Jan 2026 10:31:04 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6558a1a5c9sm138795a12.8.2026.01.28.10.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 10:31:03 -0800 (PST)
Message-ID: <ef17beb6-f279-4b8c-af46-6326720d42a6@gmail.com>
Date: Thu, 29 Jan 2026 00:00:59 +0530
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
 <dad72f2b-1cd6-42de-98f1-8c9bbbb4c8ef@gmail.com>
 <20260128182944.GZ5945@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260128182944.GZ5945@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/28/26 23:59, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 11:30:18PM +0530, Nirjhar Roy (IBM) wrote:
>> On 1/28/26 22:44, Darrick J. Wong wrote:
>>> On Wed, Jan 28, 2026 at 08:44:35PM +0530, Nirjhar Roy (IBM) wrote:
>>>> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
>>>> start == end i.e, when the rtgroup size is 1. This causes incorrect
>>>> calculation of free rtextents i.e, the count is reduced by 1 since
>>>> the last rtgroup's rtextent count is not taken and hence xfs_scrub
>>>> throws false summary counter report (from xchk_fscounters()).
>>>>
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
>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>> Yeah, that looks right.  I can also reproduce it with:
>>>
>>> # mkfs.xfs -m metadir=1 -r rtdev=/dev/sdb /dev/sda -r rgsize=65536b,size=131073b -f
>>> # mount /dev/sda /mnt -o rtdev=/dev/sdb
>>> # xfs_scrub -dTvn /mnt
>>>
>>> Cc: <stable@vger.kernel.org> # v6.13
>>> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
>>>
>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Thank you. Will the "Cc" and "Fixes" tag be added from this automatically,
>> or do I need to re-send it by updating the commit message?
> cem might add it on his own, but you could also resubmit with all three
> trailers added, to keep things simple for him.

Sure, I can do that. Thank you.

--NR

>
> --D
>
>> --NR
>>
>>> --D
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
>> -- 
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

