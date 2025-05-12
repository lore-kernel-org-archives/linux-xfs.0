Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF14255F5F
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 09:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747042894; cv=none; b=Ms3bBdid++8S5YAXOGmyui68hHuUEM81V9NQC7xNwplG8nm/FIFdqvSQCZsjzMQC6s5Mq0L6XSKaJX7im6l75CaB8nuEJKE/hZw0FiR2Otl6VYJ5GePfvR0wuimnSFb2wurql05owpmQKBmiGfsTRRaEtZF8WayZW5Ea7QQ+VWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747042894; c=relaxed/simple;
	bh=lPosky3mW04k9R2T9T5tphvxk37f3dUi1YuJD1XZ+74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JZWQmaxsy0ls+vfmt0BKvzW4SdJRHvOKN6LAgpsGmTNhqu9JaeIclCI07OLHaTDtA8Sm6Y8jDfw49dEbSN4Yzk+ZPK3Vbf84vcRJKQ3Pmw/cyJaE5qHFe4ZoIsdnDdc4zLOxQvd2qgVZ32nnmxbFevy96tvnnVjkefpOAmda63A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CkXm+p6L; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CkXm+p6L"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22c33e4fdb8so34975575ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 02:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747042892; x=1747647692; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CSTKfwJKPtE7z34HEYlcwWbYtxBa3+6kmLRPaABJAoo=;
        b=CkXm+p6LKuyb1NusrwhqXeqcattDmk8Srf68W7LZvspJyE9gb2hTuhmV6jxAt0bViZ
         ZJa/gGj9E5T+wwEF4EUX0vVCG7A5CcFBkEbMjbX/Wg7AkM1zVR9Crlb81lmf3HpxST/d
         kjcOOtY3Q/EamLawZOXMaYGf5Y4c9edw9IAeIcbjau2JbzR5RTQ5My+NUWDpYUDXgtYL
         KS66XG2CJyuFddd33ixUyI8bUO0z8SQpE2BUhh/VYCQihbUNP4IZgwPruRm42kac8sDT
         6bTN/ybFIWaSP9OBOlsyDIk0PCon4SzHJxlPKO0LMoKL6gp7xM5JxtN59h9PbCF97/Mx
         7vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747042892; x=1747647692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSTKfwJKPtE7z34HEYlcwWbYtxBa3+6kmLRPaABJAoo=;
        b=Oz2qGlsNNs4x2Zv5U3s0L8sXrGqFhfXNlp1YS51WhX9FkGPwcbXPfDskYoB652RaWv
         Y1W2SFwq771APm/9RZEEB5DrJlhRhE+UfEp768kA9ROhRdC8jKKWcSBoqrOrbDBNXnW1
         5oX8jb06LMNhaUvH7mHNlhuaS2pM1SRauB3A/QkJOlVy8gHT/1RxJpGB4rxFQdtAlyH5
         vnwmpyPcNNzXFbmBqpi5O9h043E4F4EJOQ9nzpAhMD/CSt4oFkGQ2airIAdKvAk1WoVi
         +6zHRsbeEEjIsBIKvzvqZKoEsigBSAleoc9sZJ7RV47jxCjJSEHV6/xX0iliU9uWmr6m
         IFRw==
X-Gm-Message-State: AOJu0Ywab960tTOFkNivTYj/IBbAwSh0aiYH43vlTPbOUh4XyfAZs8SJ
	m1da1YAGM8m//bdarWXqB068h8WXnfOBFAOwYlNAOqkyUgyQP2Ly
X-Gm-Gg: ASbGnctOJz4PBOgSlhRhC6vEOGmKSWXRs/H/u4E6cASEJJORSD+bDZez4dV0UMURUqi
	bKdi2ECryd3fH86CxgekYBvMSOKu/xDk7PPrsgcJj7LfstUAL9aAr0h5nBzwpaJjpWsROxFnoy0
	EysS30d5F6KY+Yo1cSM0zd1oP9xDHZ4WhzkOTfSSnlTaMRYcgXXTcwTEdA536w8rgWdhUQbX8Fm
	rW2cgjdDQJbFujqUx1EyBIUU4P654Qn8xF+TsPO0o2KBpb/fl711ezNsn7+aTJbCAq5M9DQZfBA
	QsC7Kke90TMX5boe/vI3Zg0xBSlOEdw9wKIglPe5NgqdtoJ3fs++I5Sd4A==
X-Google-Smtp-Source: AGHT+IExex1rzLmv1heUSNooqQzlV3cXgF/2d/Z65knlomTJmXkXG4lzYRTmIzaq0L3ocdkV2iHj9Q==
X-Received: by 2002:a17:902:d4cf:b0:224:11fc:40c0 with SMTP id d9443c01a7336-22fc8b0f8ffmr194942605ad.11.1747042891835;
        Mon, 12 May 2025 02:41:31 -0700 (PDT)
Received: from [9.109.247.80] ([129.41.58.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc828b303sm58575355ad.176.2025.05.12.02.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 02:41:31 -0700 (PDT)
Message-ID: <d99b34bf-cbba-4997-91fe-b2a3980e936a@gmail.com>
Date: Mon, 12 May 2025 15:11:28 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] xfs: Fail remount with noattr2 on a v5 with v4
 enabled
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
References: <cover.1746600966.git.nirjhar.roy.lists@gmail.com>
 <eaL7yzt3CizUmfISa3-LHlCNyHTKpX8yNsEZgf0kBACfqG5XKp_WsNrb-2495PC1CbxtR0IG3esvYOe_vJEwxA==@protonmail.internalid>
 <9110d568dc6c9930e70967d702197a691aca74e7.1746600966.git.nirjhar.roy.lists@gmail.com>
 <zgl5yk2hmsdjox3sfzqkbumb7lv2hihl4bvnxlkj2znk26xpvg@dq6vdhy4nv7p>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <zgl5yk2hmsdjox3sfzqkbumb7lv2hihl4bvnxlkj2znk26xpvg@dq6vdhy4nv7p>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/12/25 15:06, Carlos Maiolino wrote:
> Hi Nirjhar.
>
> The patch looks fine, with a caveat below.
>
> On Wed, May 07, 2025 at 12:59:13PM +0530, Nirjhar Roy (IBM) wrote:
>> Bug: When we compile the kernel with CONFIG_XFS_SUPPORT_V4=y,
>> remount with "-o remount,noattr2" on a v5 XFS does not
>> fail explicitly.
>>
>> Reproduction:
>> mkfs.xfs -f /dev/loop0
>> mount /dev/loop0 /mnt/scratch
>> mount -o remount,noattr2 /dev/loop0 /mnt/scratch
>>
>> However, with CONFIG_XFS_SUPPORT_V4=n, the remount
>> correctly fails explicitly. This is because the way the
>> following 2 functions are defined:
>>
>> static inline bool xfs_has_attr2 (struct xfs_mount *mp)
>> {
>> 	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) ||
>> 		(mp->m_features & XFS_FEAT_ATTR2);
>> }
>> static inline bool xfs_has_noattr2 (const struct xfs_mount *mp)
>> {
>> 	return mp->m_features & XFS_FEAT_NOATTR2;
>> }
>>
>> xfs_has_attr2() returns true when CONFIG_XFS_SUPPORT_V4=n
>> and hence, the following if condition in
>> xfs_fs_validate_params() succeeds and returns -EINVAL:
>>
>> /*
>>   * We have not read the superblock at this point, so only the attr2
>>   * mount option can set the attr2 feature by this stage.
>>   */
>>
>> if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
>> 	xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
>> 	return -EINVAL;
>> }
>>
>> With CONFIG_XFS_SUPPORT_V4=y, xfs_has_attr2() always return
>> false and hence no error is returned.
>>
>> Fix: Check if the existing mount has crc enabled(i.e, of
>> type v5 and has attr2 enabled) and the
>> remount has noattr2, if yes, return -EINVAL.
>>
>> I have tested xfs/{189,539} in fstests with v4
>> and v5 XFS with both CONFIG_XFS_SUPPORT_V4=y/n and
>> they both behave as expected.
>>
>> This patch also fixes remount from noattr2 -> attr2 (on a v4 xfs).
>>
>> Related discussion in [1]
>>
>> [1] https://lore.kernel.org/all/Z65o6nWxT00MaUrW@dread.disaster.area/
>>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   fs/xfs/xfs_super.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index b2dd0c0bf509..58a0431ab52d 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -2114,6 +2114,21 @@ xfs_fs_reconfigure(
>>   	if (error)
>>   		return error;
>>
>> +	/* attr2 -> noattr2 */
>> +	if (xfs_has_noattr2(new_mp)) {
>> +		if (xfs_has_crc(mp)) {
>> +			xfs_warn(mp,
>> +			"attr2 and noattr2 cannot both be specified.");
> This message doesn't seem to make sense to me. Your code checks the attr2 option
> is not being changed on a V5 FS, but your error message states both mount
> options are bing specified at the command line, confusing the user.
>
> V5 format always use attr2, and can't use noattr2. So, this message is
> misleading.
>
> IMO this should be something like:
>
> "attr2 is always enabled for for a V5 filesystem and can't be changed."

Okay, makes sense. Thank you for pointing it out. I will make the change 
and send a v5.

--NR

>
> Carlos
>
>> +			return -EINVAL;
>> +		}
>> +		mp->m_features &= ~XFS_FEAT_ATTR2;
>> +		mp->m_features |= XFS_FEAT_NOATTR2;
>> +	} else if (xfs_has_attr2(new_mp)) {
>> +		/* noattr2 -> attr2 */
>> +		mp->m_features &= ~XFS_FEAT_NOATTR2;
>> +		mp->m_features |= XFS_FEAT_ATTR2;
>> +	}
>> +
>>   	/* inode32 -> inode64 */
>>   	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
>>   		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
>> @@ -2126,6 +2141,17 @@ xfs_fs_reconfigure(
>>   		mp->m_maxagi = xfs_set_inode_alloc(mp, mp->m_sb.sb_agcount);
>>   	}
>>
>> +	/*
>> +	 * Now that mp has been modified according to the remount options,
>> +	 * we do a final option validation with xfs_finish_flags()
>> +	 * just like it is done during mount. We cannot use
>> +	 * xfs_finish_flags()on new_mp as it contains only the user
>> +	 * given options.
>> +	 */
>> +	error = xfs_finish_flags(mp);
>> +	if (error)
>> +		return error;
>> +
>>   	/* ro -> rw */
>>   	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
>>   		error = xfs_remount_rw(mp);
>> --
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

