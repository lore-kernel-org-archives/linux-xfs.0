Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340762FA0DB
	for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765871426; cv=none; b=MPgVWI0oCKuIMoIwnlfpDwe165fUuzSpOxYKnHUECrTXNxTKxAQom++tDQ+zNVsfJRuRUaM02abWvQJqT1SENYPfSrTYvJ/Tc3cYz3bI2jef8EMG1+rEPaqGmzzL2WRXHNZNyHI3Zj1OhzCcsUaYkq8drvjQ0eivhEG/4WZDFzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765871426; c=relaxed/simple;
	bh=hP8prst8efCgmTp3Dm5iX8iXHvg04HB0khmk3t7oNx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WURduK2iNXsU/xQuEjEfHSJPKrns5+I31yZ0PuCzSIl6Y9/DOw52UalmjbRLvaV/d89tBWQPcEQJzVGXcFc8SLPy+A5sTir47IjktH8ixAjHHUEHPepjxs3PmHtUps/vDM1RYLh+nKxiCDkebcTlNJxTQ+f+LMS/i2CawKhApiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TAuz3Syx; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAuz3Syx"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0a33d0585so24102085ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 23:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765871424; x=1766476224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bev0MisxztKqRKA1C6bDwaDzh/RzveTmQo7Ef1nh9RI=;
        b=TAuz3SyxA0cTAzGad6MzRWuCjhIGeGSU8dMqPC2BTdr3RISSzVhn9taHioqki/iu5b
         o1sZHTuV6gyawsz6ETms6wf8tZ9syJpqo2OlTHDBfrXUfrrsQfGZW25xLm6SWJvIkk47
         FCVFYruUg6Kf+vG263u6AM/JjGJ5hjFYfWConJ6GlZRwAofnGFN78kcy2gsHjQxnKJM3
         oL8TQngT6W/fu8BIbL5rom/MRepQ5zzPcu/F43xtBHjMzdRxmddwmHYRG9yQsrMJbUiM
         E/bnFdZlobqswubXPMlgx5mILKis/GWFEe9E9m2Qmhr7blwtilKUX7HYcf9Bm45tjFtF
         vuVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765871424; x=1766476224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bev0MisxztKqRKA1C6bDwaDzh/RzveTmQo7Ef1nh9RI=;
        b=Mhl+et8Wm9viKHp5Ojmyfg9yYFkZrOJm256izut++cqYOCh1xkhS8qFonXryTviNPi
         p941UoLsaO6WONkeqW8t4k+ijolgKXiIQ8aXehL4NFDDkLYvT/iE5q4ymnx4mmOoGv2H
         wBQkiX+KApOjYwW4GjBPjhRWAfSk1cnSdnzm6an3DuXIc2GGzIAlZOHIg6K5heoHSOEx
         hMBA8DuJdVXKWsL3EGlAZga+L1HRLkqswwZpnV2/peK5NyJZRX8riPVe3WUg79HDcwSm
         2Hm2YIveo0m1cRtfQqRi20MlkVPFMR5CcUyZ8Bo1u2o2/hGn3AJmZ1BNioheYCHsMm5+
         K9Ig==
X-Gm-Message-State: AOJu0YyfUrX5Bu+LKFMkTQKAm33DMzSsluYhP9M00HfiXtJ/P7A6ykK9
	eGZrTriQjaujqkguvBvzszyZibmxf+xxe7erGAYUb/JUIrpqOJvqrZVg
X-Gm-Gg: AY/fxX4TBNzVH6ofn2LsCVHf0b7sCuenAn6dv5jvgDXGyXsJYXNkhRfP4gK6tgBsZFN
	eqYI/LI6Ht/xGeUH0R+R5F01Y0GhwTCQsj0EzZcZY4rVEmI3FnFlx2jV8V3eWR/7ig2oRg/mr7W
	zz+562rVJk+BwPnRcfQddLNRJcpaoqzSj77HM9NTWm0fpBQs6Pm791/Xj2FJfZxgSMVq6SZu4/L
	k1bT+b/TKwmb+k8oKoF6sIETxG8E3q7y7hjuprqndWlUJk8f7wCBl3LK6kmTaiuJY4+1+8mP69d
	XpfSpj4ZE8hQeRj04175waMONDfCMzeTV6DyfZAQNU8+OhiFy9NP7YLW0qLLn8gCV4PTY5vadvX
	tT5GaXAGzfx0P+tp6sZWoAzJYvwBATnMrBhVpHKxppbrn5xA7eKlye/XjSX0GCGKiBkXExDf35J
	PmR77N+qWsmrKyMTviU7XKsA==
X-Google-Smtp-Source: AGHT+IFb07HOyWpBwc6h+ZyvcqKi/RqIX5CgCcGIbjlcpjxSeCjdZH0i8ddpKqiPXudhZMq6jFluBw==
X-Received: by 2002:a17:903:3c26:b0:29f:1738:348e with SMTP id d9443c01a7336-29f23e07bafmr147496405ad.15.1765871424388;
        Mon, 15 Dec 2025 23:50:24 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b3850csm157533885ad.17.2025.12.15.23.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 23:50:23 -0800 (PST)
Message-ID: <a653845a-6ae4-4506-a449-95b348e15e70@gmail.com>
Date: Tue, 16 Dec 2025 13:20:19 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix rgcount/rgsize value reported in
 XFS_IOC_FSGEOMETRY ioctl
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org
References: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>
 <20251208174005.GT89472@frogsfrogsfrogs>
 <0f322623-3d1a-47da-92b7-87ef0e40930b@gmail.com>
 <20251209065029.GJ89492@frogsfrogsfrogs>
 <5d28eed2-406e-49ec-9a6b-24f2802628fd@gmail.com>
 <20251209155939.GV89472@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251209155939.GV89472@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/9/25 21:29, Darrick J. Wong wrote:
> On Tue, Dec 09, 2025 at 03:53:34PM +0530, Nirjhar Roy (IBM) wrote:
>> On 12/9/25 12:20, Darrick J. Wong wrote:
>>> On Tue, Dec 09, 2025 at 11:05:21AM +0530, Nirjhar Roy (IBM) wrote:
>>>> On 12/8/25 23:10, Darrick J. Wong wrote:
>>>>> On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
>>>>>> With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
>>>>>> disabled, number of realtime groups should be reported as 1 and
>>>>>> the size of it should be equal to total number of realtime
>>>>>> extents since this the entire realtime filesystem has only 1
>>>>>> realtime group.
>>>>> No.  This (pre-metadir realtime having one group encompassing the entire
>>>>> rt volume) is an implementation detail, not a property of the filesystem
>>>>> geometry.
>>>>>
>>>>> Or put another way: a metadir rt filesystem with one rtgroup that covers
>>>>> the entire rt device is different from a pre-metadir rt filesystem.
>>>>> xfs_info should present that distinction to userspace, particularly
>>>>> since xfs_scrub cares about that difference.
>>>> Okay, got it. A quick question:
>>>>
>>>> A metadir rt filesystem will have 1 bitmap/summary file per rt AG, isn't it?
>>> Per rtgroup, but yes.
>>>
>>>> If yes, then shouldn't functions like xfs_rtx_to_rbmblock(mp,
>>>> xfs_rtxnum_t        rtx) return offset of the corresponding bitmap file of
>>>> the rt AG where rtx belongs?
>>> xfs_rtx_to_rbmblock is an unfortunate function.  Given an extent number
>>> within an rtgroup, it tells you the corresponding block number within
>>> that rtgroup's bitmap file.  Yes, that's confusing because xfs_rtxnum_t
>>> historically denotes an extent number anywhere on the rt volume.
>>>
>>> IOWs, it *should* be an xfs_rgxnum_t (group extent number), which could
>> So the current XFS code with metadir enabled, calls xfs_rtx_to_rbmblock() in
>> such a way that the extent number passed to the function is relative to the
>> AG and not an absolute extent number, am I right?
> Correct.

Okay. A couple of questions regarding realtime fs growth?

Q1. Looking at the loop in "xfs_growfs_rt()"

     for (rgno = old_rgcount; rgno < new_rgcount; rgno++) {
         xfs_rtbxlen_t    rextents = div_u64(in->newblocks, in->extsize);

         error = xfs_rtgroup_alloc(mp, rgno, new_rgcount, rextents);
         if (error)
             goto out_unlock;

         error = xfs_growfs_rtg(mp, rgno, in->newblocks, delta_rtb,
                        in->extsize);
         if (error) {
             struct xfs_rtgroup    *rtg;

             rtg = xfs_rtgroup_grab(mp, rgno);
             if (!WARN_ON_ONCE(!rtg)) {
                 xfs_rtunmount_rtg(rtg);
                 xfs_rtgroup_rele(rtg);
                 xfs_rtgroup_free(mp, rgno);
             }
             break;
         }

     }

So are we supporting partial growth success i.e, if we are trying to 
increase the size from 4 rtgs to 8 rtgs, and we fail (let's say) after 
6th rtg, so the new realtime fs size will be 6 rtgs, right? The reason 
why I am asking is that I don't see the rollbacks of the previously 
allocated rtgs in the 2nd error path i.e, after error = 
xfs_growfs_rtg(mp, rgno, in->newblocks, delta_rtb, in->extsize);


Q2. In the function xfs_rtcopy_summary(), shouldn't the last line be 
"return error" instead of "return 0"? If yes, then I will send a patch 
fixing this.

--NR


>
> --D
>
>>> be a u32 quantity EXCEPT there's a stupid corner case: pre-metadir rt
>>> volumes being treated as if they have one huge group.
>>>
>>> It's theoretically possible for the "single" rtgroup of a pre-metadir rt
>>> volume to have more than 2^32 blocks.  You're unlikely to find one in
>>> practice because (a) old kernels screw up some of the computations and
>>> explode, and (b) lack of sharding means the performance is terrible.
>>>
>>> However, we don't want to create copy-pasted twins of the functions so
>>> we took a dumb shortcut and made xfs_rtx_to_rbmblock take xfs_rtxnum_t.
>>> Were someone to make a Rust XFS, they really ought to define separate
>>> types for each distinct geometry usage, and define From traits to go
>>> from one to the other.  Then our typesafety nightmare will be over. ;)
>> Okay, got it.
>>>> Right now, looking at the definition of
>>>> xfs_rtx_to_rbmblock() it looks like it calculates the offset as if there is
>>>> only 1 global bitmap file?
>>> Right.
>> Okay, thank you so much for the explanation.
>>
>> --NR
>>
>>> --D
>>>
>>>> --NR
>>>>
>>>>> --D
>>>>>
>>>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>>>> ---
>>>>>>     fs/xfs/libxfs/xfs_sb.c | 8 +++-----
>>>>>>     1 file changed, 3 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>>>>>> index cdd16dd805d7..989553e7ec02 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_sb.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_sb.c
>>>>>> @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
>>>>>>     	} else {
>>>>>>     		to->sb_metadirino = NULLFSINO;
>>>>>>     		to->sb_rgcount = 1;
>>>>>> -		to->sb_rgextents = 0;
>>>>>> +		to->sb_rgextents = to->sb_rextents;
>>>>>>     	}
>>>>>>     	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
>>>>>> @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
>>>>>>     	geo->version = XFS_FSOP_GEOM_VERSION_V5;
>>>>>> -	if (xfs_has_rtgroups(mp)) {
>>>>>> -		geo->rgcount = sbp->sb_rgcount;
>>>>>> -		geo->rgextents = sbp->sb_rgextents;
>>>>>> -	}
>>>>>> +	geo->rgcount = sbp->sb_rgcount;
>>>>>> +	geo->rgextents = sbp->sb_rgextents;
>>>>>>     	if (xfs_has_zoned(mp)) {
>>>>>>     		geo->rtstart = sbp->sb_rtstart;
>>>>>>     		geo->rtreserved = sbp->sb_rtreserved;
>>>>>> -- 
>>>>>> 2.43.5
>>>>>>
>>>>>>
>>>> -- 
>>>> Nirjhar Roy
>>>> Linux Kernel Developer
>>>> IBM, Bangalore
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

