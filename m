Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24D1E552
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 01:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744679343; cv=none; b=OgY9w0M4HJ8n9moW8hYp3PbXoxcexlFvthNpElvlVxlxK2FNj72Gtl+WiJZBPNqidZJHipwDODs+XG/GkIUZE51jMU3LO3Mn4/kePaZK3D2ZJvjmfecLVbsrUfjS/nZNNtzDf47D2+SKaqP9UgifG/t90R0dXrUTwlo1TTAy2G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744679343; c=relaxed/simple;
	bh=FuTM6gRQya84npgDpMLnySLZi5ndPrsQR1RKMSLyiDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNWg7F3gldJIdO9LuuR5LMMQTb6TvkVteSil7H1Dc6wtclgU9NpMaxVRzuzj+bIt9vaW6AcPLCeSJh8EniRNkWX1JMH8x/0FflKPy3NZaGwf61kKoZ7FNrI7gEs4uqRXWvKZY6v9roQHaFUxUug6f5DfiwnWqJt3Rk6AQUkPVMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=bkWYNQbM; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="bkWYNQbM"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 15AED240028
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 03:08:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1744679333; bh=FuTM6gRQya84npgDpMLnySLZi5ndPrsQR1RKMSLyiDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:Content-Type:
	 Content-Transfer-Encoding:From;
	b=bkWYNQbM2iv7rk/uah0lHCRSTO3s1ZiX4eFrNpNma7CPQdP+ANDCMvi3PbYrOfiUV
	 61BAXGIEuO8iC2up5GXptaiVLGAS9PHudk9sFu3/zh3qWnc2bNO7sGcDOAGFazsJrg
	 iDgUvbrRFcZ9X0Wtn1cWBL3+D+Uwdr2IaTi1usLbYJeeq9LDsTwP/4IaJTh+7UNAsi
	 C1uvfYWFB5dZIGvPW/+wdXjH9QbGC+IYW4SBULphGrmD3wznA6Qk9+jB4pBBRz8LiA
	 v+WM/QhzEhCm1auPJJh7dcCwmHdX25IthfBnpFg8rZnen9rCzsV1vSKpMbU0DzzB+c
	 OMK0oheLEwAjg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4Zc5dc2Vk6z9rxF;
	Tue, 15 Apr 2025 03:08:52 +0200 (CEST)
Message-ID: <f265594f-6676-459e-9900-ae10f2efa0d5@posteo.net>
Date: Tue, 15 Apr 2025 01:08:50 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Verify DA node btree hash order
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250412-xfs-hash-check-v1-1-fec1fef5d006@posteo.net>
 <20250414221559.GC25675@frogsfrogsfrogs>
Content-Language: en-US
From: Charalampos Mitrodimas <charmitro@posteo.net>
In-Reply-To: <20250414221559.GC25675@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 15/4/25 01:15, Darrick J. Wong wrote:
> On Sat, Apr 12, 2025 at 08:03:57PM +0000, Charalampos Mitrodimas wrote:
>> The xfs_da3_node_verify() function checks the integrity of directory
>> and attribute B-tree node blocks. However, it was missing a check to
>> ensure that the hash values of the btree entries within the node are
>> strictly increasing, as required by the B-tree structure.
>>
>> Add a loop to iterate through the btree entries and verify that each
>> entry's hash value is greater than the previous one. If an
>> out-of-order hash value is detected, return failure to indicate
>> corruption.
>>
>> This addresses the "XXX: hash order check?" comment and improves
>> corruption detection for DA node blocks.
>>
>> Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
>> ---
>>   fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> index 17d9e6154f1978ce5a5cb82176eea4d6b9cd768d..6c748911e54619c3ceae9b81f55cf61da6735f01 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.c
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -247,7 +247,16 @@ xfs_da3_node_verify(
>>   	    ichdr.count > mp->m_attr_geo->node_ents)
>>   		return __this_address;
>>   
>> -	/* XXX: hash order check? */
>> +	/* Check hash order */
>> +	uint32_t prev_hash = be32_to_cpu(ichdr.btree[0].hashval);
>> +
>> +	for (int i = 1; i < ichdr.count; i++) {
>> +		uint32_t curr_hash = be32_to_cpu(ichdr.btree[i].hashval);
>> +
>> +		if (curr_hash <= prev_hash)
> Does XFS support a directory with two names that hash to the same value?


Hi Darrick,

I believe so, yes. These are handled at the leaf level by comparing the
actual names. This adds a check which ensures the intermediate node's
internal B-tree entries are strictly ordered by hash.

C. Mitrodimas

>
> --D
>
>> +			return __this_address;
>> +		prev_hash = curr_hash;
>> +	}
>>   
>>   	return NULL;
>>   }
>>
>> ---
>> base-commit: ecd5d67ad602c2c12e8709762717112ef0958767
>> change-id: 20250412-xfs-hash-check-be7397881a2c
>>
>> Best regards,
>> -- 
>> Charalampos Mitrodimas <charmitro@posteo.net>
>>
>>
