Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8B1171A7
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723169059; cv=none; b=EtstVaIJRTt8YP++Ur+VhHh2q2L1B9V+NLRYzQnuSvYlY3IP3zC/E5RFv8H5QRYhTX0627NulR/EM9DLEXebZBYCLBR7zvusOEJA1yWhycdt9R2EJegPczz1y2hfOY6eWaoy+ikOP6RsmQIw9gReiVFBz50pxzxltGM/ENIqvhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723169059; c=relaxed/simple;
	bh=FxItbLgqsEnbWhW4kyaXdJ+yd/HIXrdrFC/3uiE/eOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JGJuETPJQQbldrEO01M3fmK4QxmE3lIaILphnL0H4sFGeFurryMecFeUP3udFhwQJ74oT3W6o1PP4R7Q9w+70yUYvQijRSEgKGTpZvkd5s44l03hnyGWQx+l6QSPVY/kjq9awzIBauqFUasqjJ84y5xjtzVfnY097KESpoPoLZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=mFwxXtVw; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="mFwxXtVw"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DB3E35CE9D7;
	Thu,  8 Aug 2024 21:04:15 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net DB3E35CE9D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1723169055;
	bh=/PBjzIKS00fyGdiMfado0DO6O5TxhBuGQGQUL2KnEXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mFwxXtVwHJz5erONw5PISFJW+BjHm841yrK1yYlKczoy3p1l97y5oblZhX1ZDPo6R
	 Slv0LJGpdauM2VX3nqn4F52Fydq/wJqVnbifooNSwqbVV6Gbg9v+UNHuuQqLMdQQr3
	 R4Ios2UUn291Y/R9bs1bG9sXpczNI6CFB6PZ1zc+RtMeYgu+/x2braQq63VF0kdA/v
	 6XSigds2xgqiJCbCi49yNz/Y22oqU7jzr2Nt0QAEMCY7Nq4rBM1kxEPw+Lz36D5MFG
	 wMvhLLTrei1pxGDd0dB4R7drU09w8Imy6ASHBvB+VCLLiIn9IkUGTXn3lUILlGXR2V
	 B/maHzrhdmgNQ==
Message-ID: <c59bc461-0d27-45c9-8d24-0a6cbe646400@sandeen.net>
Date: Thu, 8 Aug 2024 21:04:14 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_db: release ip resource before returning from
 get_next_unlinked()
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 cem@kernel.org
References: <20240807193801.248101-3-bodonnel@redhat.com>
 <20240808182833.GR6051@frogsfrogsfrogs>
 <3a91d785-8c8f-4d2b-998f-a4cd92353120@sandeen.net>
 <ZrUfc57VJ-RPreCL@redhat.com> <ZrU0_r_PP-YKiKfE@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZrU0_r_PP-YKiKfE@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/8/24 4:13 PM, Bill O'Donnell wrote:
> On Thu, Aug 08, 2024 at 02:41:39PM -0500, Bill O'Donnell wrote:
>> On Thu, Aug 08, 2024 at 02:00:22PM -0500, Eric Sandeen wrote:
>>> On 8/8/24 1:28 PM, Darrick J. Wong wrote:
>>>> On Wed, Aug 07, 2024 at 02:38:03PM -0500, Bill O'Donnell wrote:
>>>>> Fix potential memory leak in function get_next_unlinked(). Call
>>>>> libxfs_irele(ip) before exiting.
>>>>>
>>>>> Details:
>>>>> Error: RESOURCE_LEAK (CWE-772):
>>>>> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
>>>>> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
>>>>> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
>>>>> #   74|   	libxfs_buf_relse(ino_bp);
>>>>> #   75|
>>>>> #   76|-> 	return ret;
>>>>> #   77|   bad:
>>>>> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>>>>>
>>>>> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
>>>>> ---
>>>>> v2: cover error case.
>>>>> v3: fix coverage to not release unitialized variable.
>>>>> ---
>>>>>  db/iunlink.c | 7 +++++--
>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/db/iunlink.c b/db/iunlink.c
>>>>> index d87562e3..57e51140 100644
>>>>> --- a/db/iunlink.c
>>>>> +++ b/db/iunlink.c
>>>>> @@ -66,15 +66,18 @@ get_next_unlinked(
>>>>>  	}
>>>>>  
>>>>>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
>>>>> -	if (error)
>>>>> +	if (error) {
>>>>> +		libxfs_buf_relse(ino_bp);
>>>>
>>>> Sorry, I think I've led you astray -- it's not necessary to
>>>> libxfs_buf_relse in any of the bailouts.
>>>>
>>>> --D
>>>>
>>>>>  		goto bad;
>>>>> -
>>>>> +	}
>>>>>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>>>>>  	ret = be32_to_cpu(dip->di_next_unlinked);
>>>>>  	libxfs_buf_relse(ino_bp);
>>>>> +	libxfs_irele(ip);
>>>>>  
>>>>>  	return ret;
>>>>>  bad:
>>>>> +	libxfs_irele(ip);
>>>
>>> And this addition results in a libxfs_irele of an ip() which failed iget()
>>> via the first goto bad, so you're releasing a thing which was never obtained,
>>> which doesn't make sense.
>>>
>>>
>>> There are 2 relevant actions here. The libxfs_iget, and the libxfs_imap_to_bp.
>>> Only after libxfs_iget(ip) /succeeds/ does it need a libxfs_irele(ip), on either
>>> error paths or normal exit. The fact that it does neither leads to the two leaks
>>> noted in CID 1554242.
>>
>> In libxfs_iget, -ENOMEM is returned when kmem_cache_zalloc() fails. For all other
>> error cases in that function, kmem_cache_free() releases the memory that was presumably
>> successfully allocated. I had wondered if we need to use libxfs_irele() at all in
>> get_next_unlinked() (except for the success case)?
> 
> So, if that's the case, I'm back to v1 of this patch.
> -Bill

when libxfs_iget succeeds, it has obtained an inode.

After that has happened, libxfs_irele needs to be called either in the normal
return path, or any subsequent error path, to free that inode in this function.

As Darrick pointed out in his first reply, V1 missed irele on the error path,
so it was not sufficient.

-Eric

