Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437B22D063E
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 09:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025107; cv=none; b=H+oW478P2DdDQJ3pUzhAUjI3FC+VI1ymnsbe50pj1B3xrGutiTQ/P9er/NXWGUXLhkUSbwvxthhZxf6x9edx1HFrTqQrDbl1T42Rv9Clb7i5VVW42DwyH+/7mKQ4oFMWmpZPkWn7JZO2yV3MWZXzA2TYta/snX6/2lraXybW1PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025107; c=relaxed/simple;
	bh=XRr8+5NUY9ERDErNEgfqghZ6alrOg8PuQVRIhlthpEI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=DcxCUu0xFfAvUqK9fuRu05J8MA92zo65NuFRe/4wgWcvgNLHLCkWtk5Yu8tybAguw9lJ/LqAPRxacLhoGrpw35L7oKpmRxou2r776Rzu9EVlPg+pf3YJZwKuaWVbTDHWdYwPxjX63kinVgNKj7K/WcEvCK/Iiyvvw/WfE1mS68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id B7D69180F2D5;
	Mon, 02 Feb 2026 10:38:20 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id dk5MLIxwgGkFahsAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 02 Feb 2026 10:38:20 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Feb 2026 10:38:20 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
In-Reply-To: <aYBUNFoHNo58kgjO@infradead.org>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <aYBUNFoHNo58kgjO@infradead.org>
Message-ID: <e247760a6411ebd35eace5bac43cecaf@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-02-02 08:37, Christoph Hellwig wrote:
>> +STATIC int
> 
> We're phasing out the magic STATIC, so pleae just use plain static
> here.
> 
>> +xfs_uuid_insert(uuid_t *uuid)
> 
> The somewhat unique XFS coding style uses separate lines for each
> argument:
> 
> static int
> xfs_uuid_insert(
> 	uuid_t			*uuid)
> 
>> +{
>> +	uint32_t index = 0;
> 
> .. and aligns the variables the same way:
> 
> {
> 	uint32_t		index = 0;
> 
> Although this one will go away with Darrick's suggestion anyway.
> 
>> +
>> +	return xa_alloc(&xfs_uuid_table, &index, uuid,
>> +			xa_limit_32b, GFP_KERNEL);
>> +}
>> +
>> +STATIC uuid_t
>> +*xfs_uuid_search(uuid_t *new_uuid)
> 
> The * for pointers goes with the type:
> 
> static uuid_t *
> xfs_uuid_search(
> 	uuid_t			*new_uuid)
> 
>> +	uuid_t *uuid = NULL;
> 
> no need to initialize the iterator to NULL before xa_for_each.
> 
>> +STATIC void
>> +xfs_uuid_delete(uuid_t *uuid)
>> +{
>> +	unsigned long index = 0;
>> +
>> +	xa_for_each(&xfs_uuid_table, index, uuid) {
>> +		xa_erase(&xfs_uuid_table, index);
>> +	}
> 
> I don't think this works as expected, as it just erases all uuids in 
> the
> table.
> 
>> +}
>> 
>>  void
>> -xfs_uuid_table_free(void)
>> +xfs_uuid_table_destroy(void)
> 
> I'd drop this rename.  Free works just fine here as a name.
> 
>> +	if (!xfs_uuid_search(uuid))
>> +		return xfs_uuid_insert(uuid);
>> 
>>  	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", 
>> uuid);
>>  	return -EINVAL;
> 
> Just return an error here if xfs_uuid_search finds something, and then
> open code the insert in the straight line path.
> 
>> @@ -110,22 +119,12 @@ xfs_uuid_unmount(
>>  	struct xfs_mount	*mp)
>>  {
>>  	uuid_t			*uuid = &mp->m_sb.sb_uuid;
>> 
>>  	if (xfs_has_nouuid(mp))
>>  		return;
>> +	xfs_uuid_delete(uuid);
>> +	return;
> 
> No need for the last return.  Also I think you can just open code
> xfs_uuid_delete here.

Thank you for all the comments! I will do all the changes.
-- 
-lhe
