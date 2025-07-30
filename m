Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1735A15AF6
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 05:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753851855; cv=none; b=F5FVVclEHCCjhJZfiVTJZmjGHz9qJGOzV1V/PzWcueRc7uqHUvppOZXQZ3JQMoV10uz+mJlTtjFZ8gp0n7v842y8GNbalC7RngnvFm5qDmQsC8Xqx0QeWc4hpBejMjMPqpQpkRMV4GUhzApFOIeh+zxmfU1F5GEVKqSYVAh+Em4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753851855; c=relaxed/simple;
	bh=aQX53xIhwJe9brEO62BzAqu0ZdiUIiZpnttndSHcBt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PYnr9gXxxOUkWlKi69r+2g93V1bcZN+mAhh6yGX5IjE5j2kbjCLrFgaPFqUs/4lDIWJnYoBxWPFycahXMbBymZXWqjK7ZqxZ8tdodfULSxcikUu5hEKJBGFwQsM+3FKHMls10Ld+8h+u5DwMaYRMAZzj8fjkQrX6kNBjbdVzliA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntoAZOGv; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntoAZOGv"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b3508961d43so5464617a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 22:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753851853; x=1754456653; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEHbwIEGFHBxKkLb81Dz6X2+3GVrkmbATEhPnt047GQ=;
        b=ntoAZOGvLW2yh1w9Ibdhwubpd7bk0M1G0E2jxpDFIls3Eglp9jrvxV+rQEkBrCBA7q
         E0Je8YKoKnJynGeofajJ6ovXVTE/3H7gI/H5ff5cQ/bM8vpC49BUg4CtSIMjOgq4KNv5
         680Jif4bA8+Bo/oKy+GJnrs3ac88EcgB7igv0HXwQTMPitCdQYZwSLNjdcVo8rxlSjCH
         mYR7wRbYxr+MDq8yVf09GrAvTqWIGKE1vG8QdVrJ6A5TRYaNp3r/4KbxoL0Up6iW61xV
         CNs3XhE8zLgVH5AsiGftpukTp1q+TfLTWwbd1L4bPYPK+ynQPfiVf67H8nnA7mDZtq3f
         F3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753851853; x=1754456653;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEHbwIEGFHBxKkLb81Dz6X2+3GVrkmbATEhPnt047GQ=;
        b=hSpWYh7/HD/Lh8ARE4eRcS5yKWZEJxOEz+aNtPtQYB6bV4tFNN9RYRJKoeg/OZjhUy
         vkSUkyhxakEOjh72gEvue3+DrOu+dppO4hhI654b1uWegnI0Qz09TQTdaPd6brEMAC7D
         Ws2yiIn5lCEk7wl1eJQS4BEtE15rYHkQ6BWiLRQKrRkgew0LV6tqci4QfLIIY8PJzSP9
         BJOs7Bc89ZTA7HVx/PkJ4ACkALwgQW2G3aeVTS4zXHY8IWWbSu0tzUGG+vcRN7MoH4/f
         pnGws86hRZwdY2iemhdd15Mk6Sx/Bstv7T7pjkD79n+jh5o1CjNn7A6rXKbqlUmARhbw
         jn9Q==
X-Gm-Message-State: AOJu0YwT6/n2cqNSGnaqgPATgYjV+b+g7kUk2vkW+EznB0Q9OlGmoVC9
	8AuW5noWb3B5E726AWKNy9nDN0B6k2QbPy0aQorLPsEX2riLbn2DD3yd
X-Gm-Gg: ASbGncslOOmpvpU7QtI5mC7cx4aeyY46Cv/kS7d+wOudRN9IyFoZlRtOw4y0tyzz73K
	iQZ6QiBqAf96qnETH/q0AGf+fiBBT8ZsJgUigRv+eZC9B7xYH2xd8QPmpiNcRLmOq7doLnXB0Zr
	6QUh1cSm8JdsPh6RQQsHKEl1NA+/1+gvZWOn/zcTiNXYMZLO9kAahkYlgzNyTGvr8aT4p+gWakt
	bQBOvhMWz+4Qs4wFo2+JCzYUon/3roO33vB2UsrUg84+/9c+5j+UNiCcGeU5IwwZ8ddB7cc6Z3H
	dfyzSU8ELZmIxe3k0AGx/eZdmWXVgo7R4WAsLW0KHwnV3fpHJvlhQlOv8ruUiUQsXciwSe34rdS
	QmtuG6CuSLy6I2tUfp0y6jAyENsPikJ5DEQ==
X-Google-Smtp-Source: AGHT+IFoH26t5/Q8y247tqvVTeyae5wIPDwFoUFAKf1B1B/6X1HrGnXSF3dknTEM6f/hJWANoVFQnQ==
X-Received: by 2002:a17:903:190d:b0:240:2145:e527 with SMTP id d9443c01a7336-24096b1791cmr24049285ad.25.1753851853260;
        Tue, 29 Jul 2025 22:04:13 -0700 (PDT)
Received: from [192.168.0.120] ([49.207.206.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-240355c4152sm56649975ad.114.2025.07.29.22.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 22:04:12 -0700 (PDT)
Message-ID: <4da61d7e-3e69-4661-af29-ea17615612d2@gmail.com>
Date: Wed, 30 Jul 2025 10:34:07 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/3] xfs: Refactoring the nagcount and delta calculation
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1752746805.git.nirjhar.roy.lists@gmail.com>
 <35b8ee6d2e142aeda726752a9197eb233dc44e6d.1752746805.git.nirjhar.roy.lists@gmail.com>
 <20250729202428.GE2672049@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20250729202428.GE2672049@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/30/25 01:54, Darrick J. Wong wrote:
> On Thu, Jul 17, 2025 at 04:00:44PM +0530, Nirjhar Roy (IBM) wrote:
>> Introduce xfs_growfs_get_delta() to calculate the nagcount
>> and delta blocks and refactor the code from xfs_growfs_data_private().
>> No functional changes.
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_ag.c | 25 +++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_ag.h |  3 +++
>>   fs/xfs/xfs_fsops.c     | 17 ++---------------
>>   3 files changed, 30 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
>> index e6ba914f6d06..dcaf5683028e 100644
>> --- a/fs/xfs/libxfs/xfs_ag.c
>> +++ b/fs/xfs/libxfs/xfs_ag.c
>> @@ -872,6 +872,31 @@ xfs_ag_shrink_space(
>>   	return err2;
>>   }
>>   
>> +void
>> +xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,
> /me suggests xfs_growfs_compute_deltas() but otherwise this hoist looks
> fine to me;
Okay. I will make the change in the next revision.
>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Thank you.
>
> --D
>
>> +	int64_t *deltap, xfs_agnumber_t *nagcountp)
>> +{
>> +	xfs_rfsblock_t nb_div, nb_mod;
>> +	int64_t delta;
>> +	xfs_agnumber_t nagcount;
>> +
>> +	nb_div = nb;
>> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>> +		nb_div++;
>> +	else if (nb_mod)
>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>> +
>> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>> +		nb_div = XFS_MAX_AGNUMBER + 1;
>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>> +	}
>> +	nagcount = nb_div;
>> +	delta = nb - mp->m_sb.sb_dblocks;
>> +	*deltap = delta;
>> +	*nagcountp = nagcount;
>> +}
>> +
>>   /*
>>    * Extent the AG indicated by the @id by the length passed in
>>    */
>> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
>> index 1f24cfa27321..190af11f6941 100644
>> --- a/fs/xfs/libxfs/xfs_ag.h
>> +++ b/fs/xfs/libxfs/xfs_ag.h
>> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>>   int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>>   int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>>   			xfs_extlen_t delta);
>> +void
>> +xfs_growfs_get_delta(struct xfs_mount *mp, xfs_rfsblock_t nb,
>> +	int64_t *deltap, xfs_agnumber_t *nagcountp);
>>   int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>>   			xfs_extlen_t len);
>>   int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 0ada73569394..91da9f733659 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -92,18 +92,17 @@ xfs_growfs_data_private(
>>   	struct xfs_growfs_data	*in)		/* growfs data input struct */
>>   {
>>   	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
>> +	xfs_rfsblock_t nb = in->newblocks;
>>   	struct xfs_buf		*bp;
>>   	int			error;
>>   	xfs_agnumber_t		nagcount;
>>   	xfs_agnumber_t		nagimax = 0;
>> -	xfs_rfsblock_t		nb, nb_div, nb_mod;
>>   	int64_t			delta;
>>   	bool			lastag_extended = false;
>>   	struct xfs_trans	*tp;
>>   	struct aghdr_init_data	id = {};
>>   	struct xfs_perag	*last_pag;
>>   
>> -	nb = in->newblocks;
>>   	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
>>   	if (error)
>>   		return error;
>> @@ -122,20 +121,8 @@ xfs_growfs_data_private(
>>   			mp->m_sb.sb_rextsize);
>>   	if (error)
>>   		return error;
>> +	xfs_growfs_get_delta(mp, nb, &delta, &nagcount);
>>   
>> -	nb_div = nb;
>> -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>> -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>> -		nb_div++;
>> -	else if (nb_mod)
>> -		nb = nb_div * mp->m_sb.sb_agblocks;
>> -
>> -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>> -		nb_div = XFS_MAX_AGNUMBER + 1;
>> -		nb = nb_div * mp->m_sb.sb_agblocks;
>> -	}
>> -	nagcount = nb_div;
>> -	delta = nb - mp->m_sb.sb_dblocks;
>>   	/*
>>   	 * Reject filesystems with a single AG because they are not
>>   	 * supported, and reject a shrink operation that would cause a
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

