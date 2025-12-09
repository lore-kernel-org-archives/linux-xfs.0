Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E04E2192E4
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 10:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765275872; cv=none; b=uIhhTz7g07UOP4oJpZcvKBuexH70lngOB2ZmgjQlw4UkV7KQR55XL+U8XOAyP1cf2PtGCBqrDl0Ar24uWSITC/tBvgcQmxw/Nro476Qf6ZQYSbX7Z1K6STFxAVHFdL6QBgsDu95HS6RoZy/iUCEyYQKXmYDqRnoYMm29I0ycdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765275872; c=relaxed/simple;
	bh=OhYqIa3GUw88Ljwz3D6O5F4w1CAhq0jZkdBcLGA/ozQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DUQIItnLbTYCqLGN6ZjHmCGiVPS13283ZFrU2tScnCRRFzbk9kIs5w5lrRQ+S7vMlIHkzKkSsRkJUGzDwucAYyGKEduzJyFBv95KZlut3bUdKY4xQURhGoENPDb+tl99cet7xGxS+CoOWcFVaKY5F5mU96zH2Fc6VSfN6I75cYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4bv+gXT; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4bv+gXT"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-343f52d15efso5141261a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 02:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765275871; x=1765880671; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JfTTfr5fNOZYtGY4g415LaT5MOpI3R7GyCmrG99Bqaw=;
        b=e4bv+gXT0vT1Jk9NOmFLMXMEU1Uq/J2OZ0CgSRHIJ2xL/UjbabrG+4Ru4LNwXk9u/R
         DZnv7kyBlWGpi/zfYYPGTvF1H4M1He+fYnulTrOXAOpMDLTPJOuaa4f4ct4Xt3bjRDpm
         /Q/ViO3Vl0C1C9H+J3CntbidTVqjM7WktpcnkU+frAgozA6ufCrPThTmBoXVaxq79Q/U
         x+ST02wJfrdPCCV03xEJ3wE/AVTdziQWUp/rssFSpHhm7pwZKG2ZxCpcVOjct5lQ4/Re
         h6HciNRFzKZ8F60IyLfQG6Y2oyG1QLdVbG/AGOLtGQRB0IbATfRK9DFV071/O52Ho/Zm
         UKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765275871; x=1765880671;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JfTTfr5fNOZYtGY4g415LaT5MOpI3R7GyCmrG99Bqaw=;
        b=jzpXd0q3sVHE8GvIL8LlrqB1Md8rcjqKETq81MKtBr/ES8zes9qCgcj7sRitg5yhBj
         OuRu0W4q85faUvCspdeD4uZRxgEi711v7VChiIzZYwQYQh/w3xeLAhXKWkbQ2JQGRHYi
         4cU/i84RiGL8NJOsDW1e50WFEU/w9VrX4eFwF7S4eRrSUQuu+S8TveTarLiRQSegVjPy
         2//eXmOQMspwWKwR282yBI0Bb+6dhdIO+U5g7YsAr6Tq2AU2I4JFlLFJZ3iH8eguphb2
         Hzoz3lx6hEKoM+CffvFe75w7ndhfzzzgodCy+mufpvHmdRBZEN7AdNsltDdL6vAodY8d
         6Ueg==
X-Gm-Message-State: AOJu0YyVN52gPiREGqV5Blloje/4gixTCga2TRmFIQeBAib1GiF38f5K
	IJ+QiKg44X0PoHrqOXXfQtiMnhOEj1hg8VyecrVNXh3QGKvgKWn9c9TCKu+YbQ==
X-Gm-Gg: ASbGncsNW+rcFmK/Oj6LhFNqlm8vR4ab98CPkzozff4oFDjytlKXkc4tvyCWebLtyxe
	gMRhauk8dlHm3n/6qmqhG9/Cn2BHaOcXTusKXbRIBE52OKMWzuUw66dfeYWh1/UsxTf6c0wLeKs
	0U3yyXycv2hkqoBPHyoXDa+1C9zYPWFhGsApLAiEsQqRfLtDKfEH8v6FDSHekTshJfzVb7HVs65
	Y5DUM16lTQiW5GJd5BHWkqhNF80tYoeyL08b8TCTfU5iOWiuztEZvdpqjSjH0Fr1SbZ0lO5bn9T
	m+v1A7mHtjYk6ctShYntdKMmN2Vnp68NGM3A5KT9iJ4QWV7VixyikJnvEIjy5eg4X6Mevt+tgMF
	CWJfhfdtvEkQEkHDGu2xC7N1FAJ/gnOMFqiCKGnujr2Pxh4Y8XcS7HMC/uLDW2+zkX4d8X1GQSG
	rpD0vHi9qF12TmY83BhB+yRA==
X-Google-Smtp-Source: AGHT+IGLRSeon9wCELzB2HL1qEWm2/ayVHN+T6FFfM3WCJWvvgy9C2mt/VmW3dyWdYOUg1v8aKM4aA==
X-Received: by 2002:a17:90b:164d:b0:343:684c:f8ad with SMTP id 98e67ed59e1d1-349a24dd178mr9446691a91.4.1765275870561;
        Tue, 09 Dec 2025 02:24:30 -0800 (PST)
Received: from [192.168.0.120] ([49.207.204.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a49b2a2f5sm1924336a91.8.2025.12.09.02.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 02:24:30 -0800 (PST)
Message-ID: <5d28eed2-406e-49ec-9a6b-24f2802628fd@gmail.com>
Date: Tue, 9 Dec 2025 15:53:34 +0530
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
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251209065029.GJ89492@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/9/25 12:20, Darrick J. Wong wrote:
> On Tue, Dec 09, 2025 at 11:05:21AM +0530, Nirjhar Roy (IBM) wrote:
>> On 12/8/25 23:10, Darrick J. Wong wrote:
>>> On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
>>>> With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
>>>> disabled, number of realtime groups should be reported as 1 and
>>>> the size of it should be equal to total number of realtime
>>>> extents since this the entire realtime filesystem has only 1
>>>> realtime group.
>>> No.  This (pre-metadir realtime having one group encompassing the entire
>>> rt volume) is an implementation detail, not a property of the filesystem
>>> geometry.
>>>
>>> Or put another way: a metadir rt filesystem with one rtgroup that covers
>>> the entire rt device is different from a pre-metadir rt filesystem.
>>> xfs_info should present that distinction to userspace, particularly
>>> since xfs_scrub cares about that difference.
>> Okay, got it. A quick question:
>>
>> A metadir rt filesystem will have 1 bitmap/summary file per rt AG, isn't it?
> Per rtgroup, but yes.
>
>> If yes, then shouldn't functions like xfs_rtx_to_rbmblock(mp,
>> xfs_rtxnum_t        rtx) return offset of the corresponding bitmap file of
>> the rt AG where rtx belongs?
> xfs_rtx_to_rbmblock is an unfortunate function.  Given an extent number
> within an rtgroup, it tells you the corresponding block number within
> that rtgroup's bitmap file.  Yes, that's confusing because xfs_rtxnum_t
> historically denotes an extent number anywhere on the rt volume.
>
> IOWs, it *should* be an xfs_rgxnum_t (group extent number), which could
So the current XFS code with metadir enabled, calls 
xfs_rtx_to_rbmblock() in such a way that the extent number passed to the 
function is relative to the AG and not an absolute extent number, am I 
right?
> be a u32 quantity EXCEPT there's a stupid corner case: pre-metadir rt
> volumes being treated as if they have one huge group.
>
> It's theoretically possible for the "single" rtgroup of a pre-metadir rt
> volume to have more than 2^32 blocks.  You're unlikely to find one in
> practice because (a) old kernels screw up some of the computations and
> explode, and (b) lack of sharding means the performance is terrible.
>
> However, we don't want to create copy-pasted twins of the functions so
> we took a dumb shortcut and made xfs_rtx_to_rbmblock take xfs_rtxnum_t.
> Were someone to make a Rust XFS, they really ought to define separate
> types for each distinct geometry usage, and define From traits to go
> from one to the other.  Then our typesafety nightmare will be over. ;)
Okay, got it.
>
>> Right now, looking at the definition of
>> xfs_rtx_to_rbmblock() it looks like it calculates the offset as if there is
>> only 1 global bitmap file?
> Right.

Okay, thank you so much for the explanation.

--NR

>
> --D
>
>> --NR
>>
>>> --D
>>>
>>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_sb.c | 8 +++-----
>>>>    1 file changed, 3 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>>>> index cdd16dd805d7..989553e7ec02 100644
>>>> --- a/fs/xfs/libxfs/xfs_sb.c
>>>> +++ b/fs/xfs/libxfs/xfs_sb.c
>>>> @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
>>>>    	} else {
>>>>    		to->sb_metadirino = NULLFSINO;
>>>>    		to->sb_rgcount = 1;
>>>> -		to->sb_rgextents = 0;
>>>> +		to->sb_rgextents = to->sb_rextents;
>>>>    	}
>>>>    	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
>>>> @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
>>>>    	geo->version = XFS_FSOP_GEOM_VERSION_V5;
>>>> -	if (xfs_has_rtgroups(mp)) {
>>>> -		geo->rgcount = sbp->sb_rgcount;
>>>> -		geo->rgextents = sbp->sb_rgextents;
>>>> -	}
>>>> +	geo->rgcount = sbp->sb_rgcount;
>>>> +	geo->rgextents = sbp->sb_rgextents;
>>>>    	if (xfs_has_zoned(mp)) {
>>>>    		geo->rtstart = sbp->sb_rtstart;
>>>>    		geo->rtreserved = sbp->sb_rtreserved;
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

