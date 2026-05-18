Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCE52367D3
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 09:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779095860; cv=none; b=XjVS7ORgQTvbzlhVS0zdpoDfvj6f4Dxecj2qeU4l3BIDgbPRAmgYN27Qw6OuhzKjFnk1UMDMrx/jA+fBArEFwQl12BJyCYjxOGHup9HdRRvK+oI8I4lAZCaDmSHJHTmUhte7SMRLNNS7xxsjScjsXfGlx0Fu6C9qLe+u9UI9v+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779095860; c=relaxed/simple;
	bh=rXZf417gEJOPwax0Dkt5Cp5n/CRMboinSOm9Kj5GX+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6VrAmaA+dGFvem7irXc9ZcYWGqqOqB4HXW8PlW1p7k3LgwR3YjbRFKXzWDiZShj+ahgC5Rwqf0NCZ7z433KP8HFGr6hbIEzp3f9cJ56y27tXUI/naCA93B/wFEZ/J8tq15x2m7ZSTvWsdcDj3zNHVGZETk/XD/SHZTevSBdIAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ID0u6IyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ID0u6IyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62159C2BCB7;
	Mon, 18 May 2026 09:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779095860;
	bh=rXZf417gEJOPwax0Dkt5Cp5n/CRMboinSOm9Kj5GX+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ID0u6IySgCQ63ZzmO6p5wmjzVB6Y0ekf67DZD+12DRR6YId+booWqplSQ+tBrpwj6
	 qbb/hh8lkGaA4kXAhT2pP/NhPXLGZ8RGCLkNs5w9+M6E9Q6fyRHz+/Zum4uBle9ycV
	 QM1/tBpKroPnerq9qA70Iydoh12qUvkbrfgkxlN7tFGCnfdVERlhJey/bTTPqme5IY
	 6OyudjMZhsDgGvyw57G1frLMyz3iJhXNRiHUmACiiIQ+qR/SvJecKYY7fEg2mr2L3R
	 QNQ/R52ak5O58UqYVDuWwWMN56h033ArqhT4FEKOo15ed3DW3fxlocrdQApMmA3GAh
	 /fSn6ItRKA7pw==
Message-ID: <126ecd45-0760-4853-9e40-f97b121fa8ad@kernel.org>
Date: Mon, 18 May 2026 11:17:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
To: Hans Holmberg <Hans.Holmberg@wdc.com>, Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
 <agrERjRq10bm0rrY@dread> <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/18 10:55, Hans Holmberg wrote:
> On 18/05/2026 09:48, Dave Chinner wrote:
>> On Mon, May 18, 2026 at 08:52:24AM +0200, Hans Holmberg wrote:
>>> Under heavy garbage collection pressure from RocksDB workloads,
>>> filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
>>> xfs_iget() returns -EINVAL for deleted files.
>>>
>>> Fix this by handling -EINVAL just like we handle -ENOENT, allowing
>>> zone GC to safely ignore stale mappings.
>>>
>>> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
>>> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
>>> ---
>>>
>>> v2:
>>> - handle -EINVAL in the the caller in stead of switching error code
>>>   in xfs_imap_lookup
>>>
>>> v1:
>>> https://lore.kernel.org/linux-xfs/20260513063745.8067-1-hans.holmberg@wdc.com/
>>>
>>>
>>>  fs/xfs/xfs_zone_gc.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
>>> index fedcc47048af..96f14d811db2 100644
>>> --- a/fs/xfs/xfs_zone_gc.c
>>> +++ b/fs/xfs/xfs_zone_gc.c
>>> @@ -400,7 +400,7 @@ xfs_zone_gc_iter_irec(
>>>  		/*
>>>  		 * If the inode was already deleted, skip over it.
>>>  		 */
>>> -		if (error == -ENOENT) {
>>> +		if (error == -ENOENT || error == -EINVAL) {
>>>  			iter->rec_idx++;
>>>  			goto retry;
>>>  		}
>>
>> Why did you choose to do this? I was expecting the updated fix to be
>> dropping XFS_IGET_UNTRUSTED from the xfs_iget() call because the
>> inode numbers are coming from a trusted source (i.e. the rmapbt) and
>> this would then return the expected -ENOENT on unlink races instead
>> of -EINVAL....
>>
>> -Dave.
> 
> I kept the XFS_IGET_UNTRUSTED because the xfs_rmap_query_range lookup
> that we do in xfs_zone_gc_query may not be valid by the time we call
> xfs_iget in xfs_zone_gc_iter_irec.

Maybe improve the comment above the change to document this ?

> 
> Cheers,
> Hans
> 
> 
> 
> 
> 
> 
> 
> 


-- 
Damien Le Moal
Western Digital Research
