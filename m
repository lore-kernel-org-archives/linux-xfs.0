Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935532DC762
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 05:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765950141; cv=none; b=UwKQsU0rqQfVH1o3NFAd9TEStXzxe1DaEJqFhQnc13TX/j6xy1gHvLohwJwq9M8ZfiE13Stkf7GeE9knAFGd5c1MA/Ty8ZjuBVYP7fHMzFM/OSuY3sBpUORuBEYrwJgQTq2GnHTGDOel/xPUy02NbYJXhJEBX16QRs+URRnovlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765950141; c=relaxed/simple;
	bh=BEVcAopiX1cIVK5GPlS2wyZo8yXa7xtzDjkNVwK+qQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FX7HdpdmwPXlHkyTsUpKi2/BL99KIxqh7jEvEklMaq104m0ZMf2A6DgcSWVm5XdLu8mbaluG0OfWCBODvZxTcNEgISmYlzY90rI/0O2CAvYGbzUY0zIS1PZ8oqfX3E1rlKZuTEIcpp6YFTUULoXfN+MFyDHbJNxC/TrwWLBHuj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/ET800h; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/ET800h"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so5789705b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Dec 2025 21:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765950139; x=1766554939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dAkttAMSQhuzO2KVPg0QrUEnuB5BL2V0uUPIpVrWlkE=;
        b=H/ET800hqed37crxmp/bpUHeIwf6VpDXmCcKZ3SmUwd5VgccQimbsRsFH0i2OxyCUm
         5L1Hbu4jnONGWjL/M7m6m7CEuoCNeyyNDCZskmFAkK78yYn6EmXfeUOBaaHk7nLI9a2h
         ySWCym88Y4o5wxXD26OTha3dzG28sajhD1LJ86jucTmMIUD5PMmnCJRAulUyAajDxjFw
         5Wf+if0Og+Xm1p/NRPuhpOs6UerATP9F5/8z3FJQ9kHmFpkmB8R7PI+Ihh1IerfwdYhy
         1jLe7dmVptzb/aPFwkfteNiNnx5/5GI6Tc6noov0JhMczcQSczwnEHIjdNApsyzGB1bW
         s3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765950139; x=1766554939;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dAkttAMSQhuzO2KVPg0QrUEnuB5BL2V0uUPIpVrWlkE=;
        b=HebFeZqiHW83b7oQqGVhS86VXd1voXcnpG1WsWQVTtjra3rKWT7RiLZ75SmUTLnLVq
         1aARrMrJNXL+X77etNwyKYaz8qG2s52uVMP1VMeKkNC0kCXSJOu0NirSLaRFeCqeYa11
         q/YfknLIZdSVKeS22KyVFDLZZV5+5/azkB6Exif/iKTNgrSjzIpLNKa5AhpUfXomxrKy
         PK9ZFQ3PkJ5ozfdEt6SLeK2QNXSL6SSn65F1dB2IC5PM/gYpeRPoFUO1wk2UBWQbkO2L
         N9qw6kVHCakA4D5PQSRW6+4Dc3bNi0E+HJpdmoRHvOvW4cz13RvOWvMHwIr5+7ABo59d
         wtNw==
X-Gm-Message-State: AOJu0YyAwgEK9tAhmNYKxtHLEcdtLG/CB4TpRbXkBPiVrjdPXG8zDgj0
	e+P/mboXud0LJ4kRdApcZW6J2+uPBK/WQ1zLl3/k9h7fALinogakl3Zk
X-Gm-Gg: AY/fxX7+Vh+eDPkc+zMWDKu8Q2d7sOnwWM21LMRMKzLROeRu1qbYEwSql9SKu/17GAq
	6p5EyY30OsRAwf3uTsqDgkBrROHwAOyM3XqrndSkD72UhNOZFuLXlRZrocFN1j4U6hL85PKjzeu
	q+W1SSbdM2wde+NlBPqY8GBWMgfO9eMWYmGEZYtEEEFryYBytsrpbSLlAkJKn+QUqAjtfRozQyu
	Mv3DqH1h7ErFdsH6ORIvWqAMxlr3ydZ239xEEw2TcbmQh8/nNBKRKkL6HczTQai518wf9ZBOf24
	m55JB+2jE/071y/UazvlfLBdUJgHmnPaPXNSjVQyLRJE9pgDCTvvV3eGciRk1erOsASNvCIUteo
	EL57QCSmQ5L+9UHxXIbORc+gS+uxxSl08Ifq43+O3K0pySUB4eGO8Ov6Jzi6HdutVcuGIoJv/7Z
	zJZ1129uJhmkzBRUv44N3i6Q==
X-Google-Smtp-Source: AGHT+IH6gH9nO6v7v7J9gkSl0my9/Dlil8abYIwjnbnSIJXkb2u3NMIuzbBtaKeHq5cZZ2YnqMlUPA==
X-Received: by 2002:a05:6a20:4326:b0:366:584c:62ef with SMTP id adf61e73a8af0-369b708c544mr17810911637.65.1765950138681;
        Tue, 16 Dec 2025 21:42:18 -0800 (PST)
Received: from [192.168.0.120] ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34cfce5d3a3sm1148454a91.0.2025.12.16.21.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 21:42:18 -0800 (PST)
Message-ID: <3e550257-1059-4553-b757-f17317d29f92@gmail.com>
Date: Wed, 17 Dec 2025 11:12:13 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] xfs: Fix rgcount/rgsize value reported in
 XFS_IOC_FSGEOMETRY ioctl
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 hch@infradead.org
References: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>
 <20251208174005.GT89472@frogsfrogsfrogs>
 <0f322623-3d1a-47da-92b7-87ef0e40930b@gmail.com>
 <20251209065029.GJ89492@frogsfrogsfrogs>
 <5d28eed2-406e-49ec-9a6b-24f2802628fd@gmail.com>
 <20251209155939.GV89472@frogsfrogsfrogs>
 <a653845a-6ae4-4506-a449-95b348e15e70@gmail.com>
 <20251216154930.GH7753@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251216154930.GH7753@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/16/25 21:19, Darrick J. Wong wrote:
> On Tue, Dec 16, 2025 at 01:20:19PM +0530, Nirjhar Roy (IBM) wrote:
>> On 12/9/25 21:29, Darrick J. Wong wrote:
>>> On Tue, Dec 09, 2025 at 03:53:34PM +0530, Nirjhar Roy (IBM) wrote:
>>>> On 12/9/25 12:20, Darrick J. Wong wrote:
>>>>> On Tue, Dec 09, 2025 at 11:05:21AM +0530, Nirjhar Roy (IBM) wrote:
>>>>>> On 12/8/25 23:10, Darrick J. Wong wrote:
>>>>>>> On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
>>>>>>>> With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
>>>>>>>> disabled, number of realtime groups should be reported as 1 and
>>>>>>>> the size of it should be equal to total number of realtime
>>>>>>>> extents since this the entire realtime filesystem has only 1
>>>>>>>> realtime group.
>>>>>>> No.  This (pre-metadir realtime having one group encompassing the entire
>>>>>>> rt volume) is an implementation detail, not a property of the filesystem
>>>>>>> geometry.
>>>>>>>
>>>>>>> Or put another way: a metadir rt filesystem with one rtgroup that covers
>>>>>>> the entire rt device is different from a pre-metadir rt filesystem.
>>>>>>> xfs_info should present that distinction to userspace, particularly
>>>>>>> since xfs_scrub cares about that difference.
>>>>>> Okay, got it. A quick question:
>>>>>>
>>>>>> A metadir rt filesystem will have 1 bitmap/summary file per rt AG, isn't it?
>>>>> Per rtgroup, but yes.
>>>>>
>>>>>> If yes, then shouldn't functions like xfs_rtx_to_rbmblock(mp,
>>>>>> xfs_rtxnum_t        rtx) return offset of the corresponding bitmap file of
>>>>>> the rt AG where rtx belongs?
>>>>> xfs_rtx_to_rbmblock is an unfortunate function.  Given an extent number
>>>>> within an rtgroup, it tells you the corresponding block number within
>>>>> that rtgroup's bitmap file.  Yes, that's confusing because xfs_rtxnum_t
>>>>> historically denotes an extent number anywhere on the rt volume.
>>>>>
>>>>> IOWs, it *should* be an xfs_rgxnum_t (group extent number), which could
>>>> So the current XFS code with metadir enabled, calls xfs_rtx_to_rbmblock() in
>>>> such a way that the extent number passed to the function is relative to the
>>>> AG and not an absolute extent number, am I right?
>>> Correct.
>> Okay. A couple of questions regarding realtime fs growth?
>>
>> Q1. Looking at the loop in "xfs_growfs_rt()"
>>
>>      for (rgno = old_rgcount; rgno < new_rgcount; rgno++) {
>>          xfs_rtbxlen_t    rextents = div_u64(in->newblocks, in->extsize);
>>
>>          error = xfs_rtgroup_alloc(mp, rgno, new_rgcount, rextents);
>>          if (error)
>>              goto out_unlock;
>>
>>          error = xfs_growfs_rtg(mp, rgno, in->newblocks, delta_rtb,
>>                         in->extsize);
>>          if (error) {
>>              struct xfs_rtgroup    *rtg;
>>
>>              rtg = xfs_rtgroup_grab(mp, rgno);
>>              if (!WARN_ON_ONCE(!rtg)) {
>>                  xfs_rtunmount_rtg(rtg);
>>                  xfs_rtgroup_rele(rtg);
>>                  xfs_rtgroup_free(mp, rgno);
>>              }
>>              break;
>>          }
>>
>>      }
>>
>> So are we supporting partial growth success i.e, if we are trying to
>> increase the size from 4 rtgs to 8 rtgs, and we fail (let's say) after 6th
>> rtg, so the new realtime fs size will be 6 rtgs, right? The reason why I am
>> asking is that I don't see the rollbacks of the previously allocated rtgs in
>> the 2nd error path i.e, after error = xfs_growfs_rtg(mp, rgno,
>> in->newblocks, delta_rtb, in->extsize);
> Yes, I /think/ we're supposed to end up with a partially grown
> filesystem if there's an error midway through... assuming the fs doesn't
> go down as a result cancelling a dirty transaction, etc.
Okay, thank you for the confirmation.
>
>> Q2. In the function xfs_rtcopy_summary(), shouldn't the last line be "return
>> error" instead of "return 0"? If yes, then I will send a patch fixing this.
> That's definitely broken.

Okay. I have sent a fix[1] for this.

[1] 
https://lore.kernel.org/all/d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com/

--NR

>
> --D
>
>> --NR
>>
>>
>>> --D
>>>
>>>>> be a u32 quantity EXCEPT there's a stupid corner case: pre-metadir rt
>>>>> volumes being treated as if they have one huge group.
>>>>>
>>>>> It's theoretically possible for the "single" rtgroup of a pre-metadir rt
>>>>> volume to have more than 2^32 blocks.  You're unlikely to find one in
>>>>> practice because (a) old kernels screw up some of the computations and
>>>>> explode, and (b) lack of sharding means the performance is terrible.
>>>>>
>>>>> However, we don't want to create copy-pasted twins of the functions so
>>>>> we took a dumb shortcut and made xfs_rtx_to_rbmblock take xfs_rtxnum_t.
>>>>> Were someone to make a Rust XFS, they really ought to define separate
>>>>> types for each distinct geometry usage, and define From traits to go
>>>>> from one to the other.  Then our typesafety nightmare will be over. ;)
>>>> Okay, got it.
>>>>>> Right now, looking at the definition of
>>>>>> xfs_rtx_to_rbmblock() it looks like it calculates the offset as if there is
>>>>>> only 1 global bitmap file?
>>>>> Right.
>>>> Okay, thank you so much for the explanation.
>>>>
>>>> --NR
>>>>
>>>>> --D
>>>>>
>>>>>> --NR
>>>>>>
>>>>>>> --D
>>>>>>>
>>>>>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>>>>>> ---
>>>>>>>>      fs/xfs/libxfs/xfs_sb.c | 8 +++-----
>>>>>>>>      1 file changed, 3 insertions(+), 5 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>>>>>>>> index cdd16dd805d7..989553e7ec02 100644
>>>>>>>> --- a/fs/xfs/libxfs/xfs_sb.c
>>>>>>>> +++ b/fs/xfs/libxfs/xfs_sb.c
>>>>>>>> @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
>>>>>>>>      	} else {
>>>>>>>>      		to->sb_metadirino = NULLFSINO;
>>>>>>>>      		to->sb_rgcount = 1;
>>>>>>>> -		to->sb_rgextents = 0;
>>>>>>>> +		to->sb_rgextents = to->sb_rextents;
>>>>>>>>      	}
>>>>>>>>      	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
>>>>>>>> @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
>>>>>>>>      	geo->version = XFS_FSOP_GEOM_VERSION_V5;
>>>>>>>> -	if (xfs_has_rtgroups(mp)) {
>>>>>>>> -		geo->rgcount = sbp->sb_rgcount;
>>>>>>>> -		geo->rgextents = sbp->sb_rgextents;
>>>>>>>> -	}
>>>>>>>> +	geo->rgcount = sbp->sb_rgcount;
>>>>>>>> +	geo->rgextents = sbp->sb_rgextents;
>>>>>>>>      	if (xfs_has_zoned(mp)) {
>>>>>>>>      		geo->rtstart = sbp->sb_rtstart;
>>>>>>>>      		geo->rtreserved = sbp->sb_rtreserved;
>>>>>>>> -- 
>>>>>>>> 2.43.5
>>>>>>>>
>>>>>>>>
>>>>>> -- 
>>>>>> Nirjhar Roy
>>>>>> Linux Kernel Developer
>>>>>> IBM, Bangalore
>>>>>>
>>>> -- 
>>>> Nirjhar Roy
>>>> Linux Kernel Developer
>>>> IBM, Bangalore
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

