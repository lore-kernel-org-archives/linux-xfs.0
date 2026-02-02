Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA325BEE8
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770051237; cv=none; b=RP0U47PPy3eN9s2fPWT/vdcC5wUv/8r0qWRG+4J0+TG4NXWxSgKcU9jbtQMD9wzs0aW4c3TZNBaDCMEK73LNSk5OtY+PvZaGx7qBUHd9yxl0rKLfzazkiD9jSjwJcL1a5yGEoHY6V6Y2KOMiDwV7zaeHNFBXuBjND7GI8tBb8Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770051237; c=relaxed/simple;
	bh=yiLswqMyUqlwvAVwk7ZsxuJ9dBi8qaiGERbAPIuBDN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OiVKLjwszMQ2SmkskeVxxVlEUs9y+exCBJxJB9RPuH4kP3HXq4Tgsoi9ngdbydvN8nUQtKfffHVQn2YwuWfZlirUOJAAOdkFDmwTQDwH60zdkfDNfF9e5HA31oAA36fus41y/F2wJziJqY0cO1p+rDL2doszZtKyCOmChR8Kqqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=drOd9v8R; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drOd9v8R"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81e821c3d4eso3854218b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Feb 2026 08:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770051235; x=1770656035; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3mDhM2WbPJ2eNZDWGr+CCKvgBAhzPhmhrSeX9chFUik=;
        b=drOd9v8RsXhgSVgbchfVIS7i0IVCqdmfgfriq7/ZUt42LCc777KERCZEkPWM2MNxDK
         X7QUr5jhq8VTjGvo1nipAyrunWBI0EheBkqb900Zs3uvaVt0dwaii+NJnKkNr/i5PYLm
         j58ZzLFEA9mdGNkdFUqLDh8bK8R5uINxFS+gFAWIBAYjcAeX5bkWNVZ1j0meDahf0Frs
         855H7b1IoauT7LNA92qRnBA/GmUxXwJc6QTJkRuxpZ5h0sx8x/xY44lyz1kx50d9DGvH
         eZbi3nVZuSl+pyg5gFiEW61LQrpbNjvaYLnsI/xfu3rZppxwsgt4tDubzfxj9aHjP3fY
         XR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770051235; x=1770656035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3mDhM2WbPJ2eNZDWGr+CCKvgBAhzPhmhrSeX9chFUik=;
        b=QSbgd5SCsLv2K8HHKXIxxaPcOOhpXFRfciTFdbex6F8i5grKNq/YQ4qgrrXF1fWFGV
         rkNeCp0BxbSCKOrsjmPmM0S+NI31bGAGyXQnhbiJXDWpSgKmRkx3cY0CI+adV3cWl+aJ
         1/M1eSKTr4b0L+VfZdVhiNmsrX58iiuH2Xbh4VhOC48Y9u/OlFOUe97c2f8z/wbnEzBv
         Ce6MDqRN/J6mI2eZvAcrBJHXIsW+yFadCdoLrfrwuKTi+qTD4r9ViNQTfYOuod35HV5S
         wcuHCjTqNEi2TicbVs5jewwmsGNGHLZ0JsMSgLBxM27BF2ozLSUDxfeeV/1U2LKS+39s
         kHyg==
X-Gm-Message-State: AOJu0YwIqbL+eB9A7J1JFtxzdlhAdb4BHnAcxz3Jfnf22hrx315FCgTw
	XZ2xFFEFD5o5k4ovZaOcpcvU0q848Prxgo0+H6/WuoEIzFvvhZOVkFdj
X-Gm-Gg: AZuq6aJa6dspA98hVN5eHvpOL6pCc4RJx0xbcntyTBcF5d78QRN2rJ0fviqcEXhtXz0
	FWAonQqaP4lpCbLHh82KSBsHGthIpqs/0QE9eEGznmT+jcNATuHd1axLLrmYSrAeqkubTmcAs3Q
	5GHqNjtG+3L8gethlBieuj9+fQdBWKTHKnVuxlC2Z7IAR+sBTpX96bgxrejTdLsZ4AhndMiK17m
	yZb/W1WHoI1w+z/HrvL02F8vMo8LRR66DIvcr8vYYQXVwAY+sOw08CRpWOtfhJ/TwI0ArgPa6IA
	RNkW4r8nsjyI6O+Rfeqs49JB1gsUWMzOA0rmckzqn5tCX3iXCry41+IRRM9eLVh5Y5PEVZKeHSU
	8ew8EmoqmqJ4UcPgAvvAesmI3WWfrM5qVmRuhYizhf776zW9WbVkv1cwdhci2WnNQDGtav5gPl+
	ckUeabJaGfzAhu5N+i3Ey2oA==
X-Received: by 2002:a05:6a00:1c90:b0:81f:3ae9:3f71 with SMTP id d2e1a72fcca58-823ab69239bmr13486594b3a.28.1770051235510;
        Mon, 02 Feb 2026 08:53:55 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379c53f6bsm19831580b3a.63.2026.02.02.08.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 08:53:55 -0800 (PST)
Message-ID: <24e1f719-b1e9-4a54-b5f5-6f229d8ba951@gmail.com>
Date: Mon, 2 Feb 2026 22:23:49 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 2/3] xfs: Refactoring the nagcount and delta calculation
Content-Language: en-US
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 djwong@kernel.org, bfoster@redhat.com, david@fromorbit.com,
 hsiangkao@linux.alibaba.com
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <b84a4243ee87e0f0519e8565b1da5b8579ed0f64.1760640936.git.nirjhar.roy.lists@gmail.com>
 <1659bd90-2fbc-42df-abbe-3da52402feb6@gmail.com>
 <aYDVGFsUCjJr9T9i@nidhogg.toxiclabs.cc>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aYDVGFsUCjJr9T9i@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/2/26 22:20, Carlos Maiolino wrote:
> Hi!
>
> On Mon, Feb 02, 2026 at 07:45:56PM +0530, Nirjhar Roy (IBM) wrote:
>> On 10/20/25 21:13, Nirjhar Roy (IBM) wrote:
>>> Introduce xfs_growfs_compute_delta() to calculate the nagcount
>>> and delta blocks and refactor the code from xfs_growfs_data_private().
>>> No functional changes.
>>>
>>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Hi Carlos, Darrick,
>>
>> Can this be picked up? This is quite independent of the rest of the patches
>> in this series.
> If you tag a series as RFC, don't expect the maintainer to pick it up.
>
> Please, re-send it again without the RFC tag. We don't have more
> time for this merge window though, I'll pick it up for the next.

Sure, I will re-send it without the RFC tag. Thank you.

--NR

>
> Cheers.
>
>> --NR
>>
>>> ---
>>>    fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>>>    fs/xfs/libxfs/xfs_ag.h |  3 +++
>>>    fs/xfs/xfs_fsops.c     | 17 ++---------------
>>>    3 files changed, 33 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
>>> index e6ba914f6d06..f2b35d59d51e 100644
>>> --- a/fs/xfs/libxfs/xfs_ag.c
>>> +++ b/fs/xfs/libxfs/xfs_ag.c
>>> @@ -872,6 +872,34 @@ xfs_ag_shrink_space(
>>>    	return err2;
>>>    }
>>> +void
>>> +xfs_growfs_compute_deltas(
>>> +	struct xfs_mount	*mp,
>>> +	xfs_rfsblock_t		nb,
>>> +	int64_t			*deltap,
>>> +	xfs_agnumber_t		*nagcountp)
>>> +{
>>> +	xfs_rfsblock_t	nb_div, nb_mod;
>>> +	int64_t		delta;
>>> +	xfs_agnumber_t	nagcount;
>>> +
>>> +	nb_div = nb;
>>> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>>> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>>> +		nb_div++;
>>> +	else if (nb_mod)
>>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>>> +
>>> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>>> +		nb_div = XFS_MAX_AGNUMBER + 1;
>>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>>> +	}
>>> +	nagcount = nb_div;
>>> +	delta = nb - mp->m_sb.sb_dblocks;
>>> +	*deltap = delta;
>>> +	*nagcountp = nagcount;
>>> +}
>>> +
>>>    /*
>>>     * Extent the AG indicated by the @id by the length passed in
>>>     */
>>> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
>>> index 1f24cfa27321..f7b56d486468 100644
>>> --- a/fs/xfs/libxfs/xfs_ag.h
>>> +++ b/fs/xfs/libxfs/xfs_ag.h
>>> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>>>    int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>>>    int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>>>    			xfs_extlen_t delta);
>>> +void
>>> +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
>>> +	int64_t *deltap, xfs_agnumber_t *nagcountp);
>>>    int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
>>>    			xfs_extlen_t len);
>>>    int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
>>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>>> index 0ada73569394..8353e2f186f6 100644
>>> --- a/fs/xfs/xfs_fsops.c
>>> +++ b/fs/xfs/xfs_fsops.c
>>> @@ -92,18 +92,17 @@ xfs_growfs_data_private(
>>>    	struct xfs_growfs_data	*in)		/* growfs data input struct */
>>>    {
>>>    	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
>>> +	xfs_rfsblock_t		nb = in->newblocks;
>>>    	struct xfs_buf		*bp;
>>>    	int			error;
>>>    	xfs_agnumber_t		nagcount;
>>>    	xfs_agnumber_t		nagimax = 0;
>>> -	xfs_rfsblock_t		nb, nb_div, nb_mod;
>>>    	int64_t			delta;
>>>    	bool			lastag_extended = false;
>>>    	struct xfs_trans	*tp;
>>>    	struct aghdr_init_data	id = {};
>>>    	struct xfs_perag	*last_pag;
>>> -	nb = in->newblocks;
>>>    	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
>>>    	if (error)
>>>    		return error;
>>> @@ -122,20 +121,8 @@ xfs_growfs_data_private(
>>>    			mp->m_sb.sb_rextsize);
>>>    	if (error)
>>>    		return error;
>>> +	xfs_growfs_compute_deltas(mp, nb, &delta, &nagcount);
>>> -	nb_div = nb;
>>> -	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>>> -	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>>> -		nb_div++;
>>> -	else if (nb_mod)
>>> -		nb = nb_div * mp->m_sb.sb_agblocks;
>>> -
>>> -	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>>> -		nb_div = XFS_MAX_AGNUMBER + 1;
>>> -		nb = nb_div * mp->m_sb.sb_agblocks;
>>> -	}
>>> -	nagcount = nb_div;
>>> -	delta = nb - mp->m_sb.sb_dblocks;
>>>    	/*
>>>    	 * Reject filesystems with a single AG because they are not
>>>    	 * supported, and reject a shrink operation that would cause a
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

