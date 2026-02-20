Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B51D555
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771569194; cv=none; b=jYfMOw3Cp+g1OyM/FhsfHVKh98VX2lOTkrZWSccEoSyBFoapjNcNWltSa7ydQ3PecSgicvN1r5LST/P5BY7oMsG5yIzt3TWfEs7XOlnwZwrnwGLEvbPvKaZkBHh+DqS6x9f3OKdBpfCq2hcmFcH4juIf7g4uT84xyK/Vv/J0enA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771569194; c=relaxed/simple;
	bh=oy7gfsw4Zq25QI6VjcmlpIUQSas5AY2M2PSXe9DVOMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LVnvaFtf8s/ifqs01E1FlV4bVGOqEP/gNw4s/CCmuehqC+eleCwc90ozexlcMSvdlhjaQCMoa2jGRmJq38q8mfLletmS1g8ItqRqxDGxRRInGANj0EKwt9gHxkp8T+9KYoyk5Qx1YxCv45A7VEUqo+VBydIBSaLeH6j2LrFA9iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ly6dr1nW; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ly6dr1nW"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a8a7269547so17251605ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 22:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771569192; x=1772173992; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VjeQ9YrxaebVnfiGh9szd2nBEBwU234Up/QNgCKlAl8=;
        b=Ly6dr1nWHiaUSU9ZvWVxBclmCGKDRUxfXQhBXyoPOWlNFWjRWUfXSTs7sLA/t9itu6
         +PkOIT6WUKxSWPHATxhWcJGYMFtCw7LzMDmqiIEClwlqZn6Tb1FD0St8euEbPP2wu9VY
         lp7yUJEzGyVnbpyONUoRSn58ZBRA6x5rT9lZzGOsOBOu3EWhbeArXmA3QFxsAHADk7nh
         SVTPjN76OFgH8HESYDenMPXpIdR0B8oOyQX/waY2fNNeDseIHW3/26QusziXJRWrbd7K
         HyyVcwObCVRGHmP2f4FZoSMucliR4S9w3nu3qDFD+E3Ej9HnpVa1xdwcsWK+jPgzVn5I
         g5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771569192; x=1772173992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VjeQ9YrxaebVnfiGh9szd2nBEBwU234Up/QNgCKlAl8=;
        b=L7r+4NV9vOvns2BxQjENfQ3C2GyOxV5D+1i4gC/Wm5ZL28hbHKryP0ICYaQZTTGQbp
         5XaD7Dl93MfKI+feKFf+Vmx27vN0beSeKnayH/1+QUgc9WtfRyzgY44dHXb9vVbnYBeL
         ugB8eJGVjDA9JVv6HaPADILnotmQkOGAIIR+f4gXbYGMwoTUnckqveZ7ZMtfOPfdaqkT
         BEDpu2O7FYF9Bma8dECw60fIMLtr0FI7tHj/ab0egKY1k+d6c28GDRRdrE2McpvV6INm
         d465DLe3Lo0PL6FgiBbBTE7zsIwlqd+vwoQbVpb1TXPrKUxf5b19PIKgDih5KoVryUgN
         y4FQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/O7aLW2jmqLC9F11utphFIb8YEI8cWE4DUVibR/zgIjfD5kyGuJLzBRXdpRgReYcDcz59dQ9innY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjfr8PBz3lvA2rnZBwNnk7kqtZsZMvnG23+EzFUejnwDph+CP3
	wGGYFSQbMbSI4VPl90gk9TONBrbsk6JJFXrHnw7cioAt8b9Kqeos5bp1
X-Gm-Gg: AZuq6aI7oKLb2BudZXiUQamMT+s9H8Mk40ywtBbOf1izpfzBIWlsd7tfgA8EHIfa3lZ
	zYXKRhlcLP/PYSpy8nKr1iRJVF8kcD67ykYkEVv+7rctkB/SCHfB0zCJQhk1xZtM4Osi2VLren/
	fyxp77X9uA0Eqa0ksSwc8JVt3VYJ9/lRX6XFC6NK1UmXsWdcpkTQgZqpBM9NH2Cpt/F2wByePsM
	afEgy28kK/zV7cV+GNyfgHDsF6EBN3ubr/H92lPhvtmoDqC/jle5QWgMsQGV6rUSOQqW2WWpv1F
	oeBEla3g+LVMbUewCW3ia13UvoXyT2qmi+a0EuxN9fhYla73+eIyHF+w2Q8w6cD3LDqCvwqEjfT
	cKI0GAHDdepnOGPd5G6Xmgux3zQu4m2n05fUlcM6R0vvp8KUywW2iT3MBL6spnnV8qt38LmA/cY
	H3q6ACrt92COmTGRrhZROpiMCiFOu3S0vtBg==
X-Received: by 2002:a17:903:37cd:b0:2a9:5db8:d651 with SMTP id d9443c01a7336-2ad6cd8aef7mr9016045ad.25.1771569192035;
        Thu, 19 Feb 2026 22:33:12 -0800 (PST)
Received: from [192.168.0.120] ([49.207.235.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a738220sm184069125ad.37.2026.02.19.22.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 22:33:11 -0800 (PST)
Message-ID: <bc266490-f78d-4326-89ae-e83deb3af0a5@gmail.com>
Date: Fri, 20 Feb 2026 12:03:06 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] xfs: Fix xfs_last_rt_bmblock()
To: "Darrick J. Wong" <djwong@kernel.org>,
 "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <018c051440dc24200a223358b7ec302b88a8fde4.1771512159.git.nirjhar.roy.lists@gmail.com>
 <20260219214215.GP6490@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260219214215.GP6490@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/20/26 03:12, Darrick J. Wong wrote:
> On Thu, Feb 19, 2026 at 08:16:47PM +0530, Nirjhar Roy (IBM) wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> Bug description:
>>
>> If the size of the last rtgroup i.e, the rtg passed to
>> xfs_last_rt_bmblock() is such that the last rtextent falls in 0th word
>> offset of a bmblock of the bitmap file tracking this (last) rtgroup,
>> then in that case xfs_last_rt_bmblock() incorrectly returns the next
>> bmblock number instead of the current/last used bmblock number.
>> When xfs_last_rt_bmblock() incorrectly returns the next bmblock,
>> the loop to grow/modify the bmblocks in xfs_growfs_rtg() doesn't
>> execute and xfs_growfs basically does a nop in certain cases.
>>
>> xfs_growfs will do a nop when the new size of the fs will have the same
>> number of rtgroups i.e, we are only growing the last rtgroup.
>>
>> Reproduce:
>> $ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
>> 	-r rgsize=32768b,size=32769b -f
> /me is confused by metadir=0 and rgsize, but I think that's a red
> herring, the key here is to create a filesystem with an rt bitmap that's
> exactly one bit larger than a full bitmap block, right?  And the
> reproducer also seems to work if you pass metadir=1 above.
Yeah, right. The logic works with both metadir=0/1. I tried with 
metadir=0 just to keep things simple. Also, rgsize with metadir=0 was a 
mistake. I will update the commit message in the next revision.
>
>> $ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
>> $ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
>> $ xfs_info /mnt/scratch | grep rtextents
>> $ # We can see that rtextents hasn't changed
>>
>> Fix:
>> Fix this by returning the current/last used bmblock when the last
>> rtgroup size is not a multiple xfs_rtbitmap_rtx_per_rbmblock()
>> and the next bmblock when the rtgroup size is a multiple of
>> xfs_rtbitmap_rtx_per_rbmblock() i.e, the existing blocks are
>> completely used up.
>> Also, I have renamed xfs_last_rt_bmblock() to
>> xfs_last_rt_bmblock_to_extend() to signify that this function
>> returns the bmblock number to extend and NOT always the last used
>> bmblock number.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/xfs_rtalloc.c | 30 ++++++++++++++++++++++++------
>>   1 file changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index 90a94a5b6f7e..decbd07b94fd 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -1079,17 +1079,27 @@ xfs_last_rtgroup_extents(
>>   }
>>   
>>   /*
>> - * Calculate the last rbmblock currently used.
>> + * This will return the bitmap block number (indexed at 0) that will be
>> + * extended/modified. There are 2 cases here:
>> + * 1. The size of the rtg is such that it is a multiple of
>> + *    xfs_rtbitmap_rtx_per_rbmblock() i.e, an integral number of bitmap blocks
>> + *    are completely filled up. In this case, we should return
>> + *    1 + (the last used bitmap block number).
> Let me try to work through case #1.  In this case, there are 32768 rtx
> per rtbitmap block and the rt volume is 32768 extents.
> xfs_rtbitmap_blockcount_len turns into:
>
> 	howmany_64(32768, 32768) == 1
>
> In the new code, bmbno will be set to 1-1==0, and mod will be 0, so we
> bump bmbno and return 1.  IOWs, the growfsrt starts expanding from
> rtbitmap block 1.
>
>> + * 2. The size of the rtg is not an multiple of xfs_rtbitmap_rtx_per_rbmblock().
>> + *    Here we will return the block number of last used block number. In this
>> + *    case, we will modify the last used bitmap block to extend the size of the
>> + *    rtgroup.
> For case 2, there might be 32768 rtx per rtbitmap block, but now the rt
> volume is 32769 rtx.  _blockcount_len becomes:
>
> 	howmany_64(32769, 32768) == 2
>
> In the new code, bmbno will be set to 1.  mod will be 1, so we don't
> increment bmbno and return 1, so the growfs again starts expanding from
> rtbitmap block 1.
>
> Now let's say the rt volume is 32767 rtx.  _blockcount_len becomes:
>
> 	howmany_64(32767, 32768) == 1
>
> bmbno is set to 0.  mod now is 32767, so here we also leave bmbno alone.
> We return 0, so the growfsrt starts at block 0.
>
>>    *
>>    * This also deals with the case where there were no rtextents before.
> What about this case?  There are 32768 rtx per rtbitmap block, but the
> rt volume is 0 rtx.  I think in this case sb_rgcount will be 0, so we
> don't do any of the division stuff and simply return 0.
>
> (This is effectively case #3)
>
> I think the logic is correct.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thank you for the dry run here.

--NR

>
> --D
>
>>    */
>>   static xfs_fileoff_t
>> -xfs_last_rt_bmblock(
>> +xfs_last_rt_bmblock_to_extend(
>>   	struct xfs_rtgroup	*rtg)
>>   {
>>   	struct xfs_mount	*mp = rtg_mount(rtg);
>>   	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
>>   	xfs_fileoff_t		bmbno = 0;
>> +	unsigned int		mod = 0;
>>   
>>   	ASSERT(!mp->m_sb.sb_rgcount || rgno >= mp->m_sb.sb_rgcount - 1);
>>   
>> @@ -1097,9 +1107,16 @@ xfs_last_rt_bmblock(
>>   		xfs_rtxnum_t	nrext = xfs_last_rtgroup_extents(mp);
>>   
>>   		/* Also fill up the previous block if not entirely full. */
>> -		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext);
>> -		if (xfs_rtx_to_rbmword(mp, nrext) != 0)
>> -			bmbno--;
>> +		/* We are doing a -1 to convert it to a 0 based index */
>> +		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext) - 1;
>> +		div_u64_rem(nrext, xfs_rtbitmap_rtx_per_rbmblock(mp), &mod);
>> +		/*
>> +		 * mod = 0 means that all the current blocks are full. So
>> +		 * return the next block number to be used for the rtgroup
>> +		 * growth.
>> +		 */
>> +		if (mod == 0)
>> +			bmbno++;
>>   	}
>>   
>>   	return bmbno;
>> @@ -1204,7 +1221,8 @@ xfs_growfs_rtg(
>>   			goto out_rele;
>>   	}
>>   
>> -	for (bmbno = xfs_last_rt_bmblock(rtg); bmbno < bmblocks; bmbno++) {
>> +	for (bmbno = xfs_last_rt_bmblock_to_extend(rtg); bmbno < bmblocks;
>> +			bmbno++) {
>>   		error = xfs_growfs_rt_bmblock(rtg, nrblocks, rextsize, bmbno);
>>   		if (error)
>>   			goto out_error;
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

