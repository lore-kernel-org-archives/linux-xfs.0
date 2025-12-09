Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC99B241CB7
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 05:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765258608; cv=none; b=NKjyNny1iWMPwEFpN3+FqISkcD6BCN8EJG4ZJW5OtIDqnjI2gHb4vGObmdCMs8XX1gbUCG0dADmynykfPWP0yQh1nowhW3R+NKVRUY1xcTdSojrZ35QShP4m5mmanvRMhooCg7b7jn3azRwIFWWsX/fUixin5hEQpQtSAHNKeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765258608; c=relaxed/simple;
	bh=bd6hy1lpdxgXpEvS8LrvOVoPfd1VGDUnMGwSup34Q8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uAO8hubYeIwUYZ//GmJy0eH4+IKlCri2V1IDA2wVthOkV6sHZzXClDRKwoUei91Gqq9ST7HJCiaRuvIco5WZzuSiPyJd8L/cip0ZIvVuSHKVIYUurRJ4oErax2ZasQB0QUuNGNwHvDbToAGnbU8Vlg0xDvUr4OSwlbwQQpOfhM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWcRFb5l; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWcRFb5l"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso5998529b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 08 Dec 2025 21:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765258606; x=1765863406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rI1lqRIEmNTmkuZ7+pe1MXnlIUtRi69Ip/2Ia9V7uMo=;
        b=GWcRFb5lKCAtYj/kIuZbgM0APggly/DaPjyh5LOZuYR/kRouqTb15u/emmevrzNMmg
         V9JkPM2eF+0nS/liW61ynZjsdJRqpcP1EStHi5pAMo99UaAOOyshtee1Y5shqP8l/ZAY
         X5/lvRtaAiSjX57Qh1xMHcWCK9I/W2RJvMri4eJq+5Q13QhHlNbYwNv4rWokS5NIugEp
         f40tlVGuJpPh4wm0pZVDuPs1xHtwFT0g4TB/8FdAtIzpCpfIGju43sQNIl16QPyus7KG
         STjdg5vdnZDaxaHDNV63r864hVnSsOLU6QUyWOWoUnhJJY5zI0vM3fftm9wsGo19FcSg
         SzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765258606; x=1765863406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rI1lqRIEmNTmkuZ7+pe1MXnlIUtRi69Ip/2Ia9V7uMo=;
        b=CvCkVgv3CQr4MJYNVvZjoK4hf7xNFSLygrD1C8ZIgHRUiUkJYO7OzKspPfAcAYWnyn
         ObRoxFe+Gmk/9Ku0zEAUk3QDmB5nw8WPrV9A2LBd7YQDdR/9u66Bjb2c8c/Vk8OsNyL0
         /4TFiJSnQLcbcnW/ON/bXg+uqSvJ9uWmE04iccwM2m/Bk4j2Ep/FMwLuqy0JNNUVYQx9
         iNFozA4dFzNqU/orgYKGBCWB9JkEQ/Yn3rukFZQ8z8ICggeUndaGs6K/WHMTVebs4qJA
         PWolTWCEm5ZAtpPzBM1SdPAsx5mZoxYfbrGyBd8g2nKrCh/sct+eRN6Z+a5NBU4tWcpq
         lX6w==
X-Gm-Message-State: AOJu0Yza8/Lm9Gk45/P7gldiHTwXtBronKStKB8lTOIyOJJgEf05n0E0
	1Jz6Atc9FkXwcPbcKMn3k1Rz1X7l+FXcAIM8Uyci4azhtwqlY6WDJ8M1
X-Gm-Gg: ASbGnctEV4S4D2kh/8Crm5stDj3QUdNbnvM+kov43uUxnQJFZz8TsKcEDEoftPWfsNV
	7OXzqGdnEnkdXaouXAQL5DcJGPCC24McsgsLNQs9OgtHUtF7WyApOeMyDPM1qaN+oQi9mX9ESZu
	+uSNlBhvJTdAMZIsN34QtxJVuJFswVWWMm+hX9DKHbo8/HGDfc9rgNi6qMWTMyc19mM81DhsyZq
	+doG/I+sqW9CAvzn0MKHwFepSrgP/U5WugHXt+7rqV3f4Bubzc14Cd32Tkxefu2R3jn4n7KlUJ0
	bcFp9cOnIabEOec41rX9j+/sFgUVXmdtbqMft6xE1rt0wnZkWp2NJcVUoEbCeod0IHMuOtfnyqf
	ffinV33ScJqi3ltYshLjV5vyrUiau3mKS11Z8AVkYuJloPBMzcZWKJcKt1LYDVlS4eWC31s2Eld
	Ta6k+pRAjZrPClwA8sqMIAng==
X-Google-Smtp-Source: AGHT+IHQo0EA9oBpUuBI3eg90ORXnl5EfVP61cwF7KyQeuN30MJ0Ou3j74skq0dJAYhsvhL8iJ8/7g==
X-Received: by 2002:a05:6a00:198e:b0:7ac:edc4:fb82 with SMTP id d2e1a72fcca58-7e8c0ad1cd2mr9229691b3a.5.1765258605970;
        Mon, 08 Dec 2025 21:36:45 -0800 (PST)
Received: from [192.168.0.120] ([49.207.204.153])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e2ade44a0bsm14690830b3a.35.2025.12.08.21.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 21:36:45 -0800 (PST)
Message-ID: <0f322623-3d1a-47da-92b7-87ef0e40930b@gmail.com>
Date: Tue, 9 Dec 2025 11:05:21 +0530
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
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251208174005.GT89472@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/8/25 23:10, Darrick J. Wong wrote:
> On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
>> With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
>> disabled, number of realtime groups should be reported as 1 and
>> the size of it should be equal to total number of realtime
>> extents since this the entire realtime filesystem has only 1
>> realtime group.
> No.  This (pre-metadir realtime having one group encompassing the entire
> rt volume) is an implementation detail, not a property of the filesystem
> geometry.
>
> Or put another way: a metadir rt filesystem with one rtgroup that covers
> the entire rt device is different from a pre-metadir rt filesystem.
> xfs_info should present that distinction to userspace, particularly
> since xfs_scrub cares about that difference.

Okay, got it. A quick question:

A metadir rt filesystem will have 1 bitmap/summary file per rt AG, isn't 
it? If yes, then shouldn't functions like xfs_rtx_to_rbmblock(mp, 
xfs_rtxnum_t        rtx) return offset of the corresponding bitmap file 
of the rt AG where rtx belongs? Right now, looking at the definition of 
xfs_rtx_to_rbmblock() it looks like it calculates the offset as if there 
is only 1 global bitmap file?

--NR

>
> --D
>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_sb.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index cdd16dd805d7..989553e7ec02 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
>>   	} else {
>>   		to->sb_metadirino = NULLFSINO;
>>   		to->sb_rgcount = 1;
>> -		to->sb_rgextents = 0;
>> +		to->sb_rgextents = to->sb_rextents;
>>   	}
>>   
>>   	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
>> @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
>>   
>>   	geo->version = XFS_FSOP_GEOM_VERSION_V5;
>>   
>> -	if (xfs_has_rtgroups(mp)) {
>> -		geo->rgcount = sbp->sb_rgcount;
>> -		geo->rgextents = sbp->sb_rgextents;
>> -	}
>> +	geo->rgcount = sbp->sb_rgcount;
>> +	geo->rgextents = sbp->sb_rgextents;
>>   	if (xfs_has_zoned(mp)) {
>>   		geo->rtstart = sbp->sb_rtstart;
>>   		geo->rtreserved = sbp->sb_rtreserved;
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

