Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A7E3A5E67
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772635173; cv=none; b=WF7O9QQgo8RKIxmvfQ2TtUE/uf27ZkRCzg/+K5do68fspZXAv/zCaSP2AG9llbgJ6CzxJSpr0cG8tfetsNfre2fXBhfAyI4tkVuTq8ECPXpTGRyOoUvyPSxCqDxqrEZh8EwjSAALbhvLbxj8C7pTbEzztI8jmPa78xpfOgKgQ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772635173; c=relaxed/simple;
	bh=A2lJzrYt1fHuEe07iuYxsRPXr/Xa3J2tnCZTBCqGAII=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TnUj9oY+ogfNvrGfnF88xYZYQQLI/54NqrcI73l0OLder+qe4w0GwYYdx3pc9y6BAfcBn2QoTpV0H2NM0dBC0BdMDdaMo1TiEiySJckC2hgNRx0bsZkVA9j2vptueV7rvR0+q2QqTo70a1yro9OrVj0gLhDiyK37OP67lCHCh8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 53C2D180F2FB;
	Wed, 04 Mar 2026 15:39:17 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id xbLqCRVEqGn0BxgAKEJqOA
	(envelope-from <lukas@herbolt.com>); Wed, 04 Mar 2026 15:39:17 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 04 Mar 2026 15:39:17 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 bfoster@redhat.com, dchinner@redhat.com, "Darrick J . Wong"
 <djwong@kernel.org>, gost.dev@samsung.com, andres@anarazel.de
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
In-Reply-To: <ecd24894-bd95-40d1-9f3f-579a6b666391@linux.dev>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
 <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
 <aaf6QgbmQQ56ZlhH@nidhogg.toxiclabs.cc>
 <ecd24894-bd95-40d1-9f3f-579a6b666391@linux.dev>
Message-ID: <c4839f9ca3959790aefe153b505aeb8c@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-04 10:46, Pankaj Raghav wrote:
> On 3/4/2026 10:31 AM, Carlos Maiolino wrote:
>>>>> @@ -646,7 +646,8 @@ int
>>>>>   xfs_alloc_file_space(
>>>>>   	struct xfs_inode	*ip,
>>>>>   	xfs_off_t		offset,
>>>>> -	xfs_off_t		len)
>>>>> +	xfs_off_t		len,
>>>>> +	uint32_t flags)
>>>> 
>>>> Messed up indentation.
>>>> 
>>> Oops.
>>> 
>>>> Given that we've been through this for a lot of iterations, what
>>>> about you just take Lukas' existing patch and help improving it?
>>> 
>>> I did review his patch[1]. The patches were broken when I tested it 
>>> but I
>>> did not get a reply from him after I reported them. That is why I 
>>> decided
>>> to send a new version.
>>> 
>>> [1] 
>>> https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/
>> 
>> If I properly got the timeline, you barely gave him time to reply:
>> 
>> your reply to the original patch: Date: Thu, 26 Feb 2026 14:44:05 
>> +0000
>> your RFC time: Date: Fri, 27 Feb 2026 15:08:40 +0100
>> 
>> You are around enough time to know that people usually requires more
>> than 24 hours to reply.
>> 
> 
> I started working on this in parallel before I realized it was already 
> being worked on. I could have waited a bit longer after responding to 
> his patches. :) . Sorry for that.
> 
>> Please, work with him to get this done. It's not a nice thing to do 
>> IMHO
>> to pass over somebody's else work if you are aware there is work being
>> done.
>> 
>> FWIW you also didn't Cc'ed him in your RFC as you used the wrong email
>> address... I'm fixing the headers so he gets aware of it.
>> 
> 
> Yes, I replied back to the thread with the correct ID [1].
> 
>> If by any means I got the timeline wrong above, forget everything I 
>> said
>> other than the "work with him to get this done".
>> 
> 
> His patches are not working properly. It is almost a week since I sent 
> that message on his thread. I have messaged him again on how to 
> proceed. I will wait and see what he replies :)

Sorry, the original CC somehow messed the filtering and it fell trough 
the cracks
of the email folders. If you agree I would add the `two stage Ext4 like` 
into the
original patch still utilizing the xfs_falloc_zero_range. Doing the the 
default
XFS_BMAPI_PREALLOC and sending the XFS_BMAPI_ZERO|XFS_BMAPI_CONVERT if 
the WR_ZERO
is set and the device supports it.

I think that would still be quite readable without the of duplicating 
the code.

-- 
-lhe
