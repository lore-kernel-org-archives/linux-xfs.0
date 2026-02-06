Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF8C3101DC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404109; cv=none; b=I8DR8uvtLOG9tp7mVOXVexSnwzs4Mgd7UH4R76JHRNFtLobWnm7bNTE9jcAj4zYRWAC2Ty4lVUol7LHoBZPCegoGXI0piPRLHitjbwJmO4jPzCh/ZEpEnH4+kNlYj1xoaSMDBTaRdDwpnxhIi31fJnMQlI8Z3Y/AAvpxi6UtZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404109; c=relaxed/simple;
	bh=hKCxXArb5MmLDQXsH2llw87ui4iuwN50i4e3U/xLpO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5DV4cs5em+AaYrbk0AKRCqFW3GJgt5kPD+0bpTEDUL5Xl5vzpgeiuobsjzbLe3uMdUHgKv2jHnbpVDBmv126K/0ReL1MkLMfbySMU6NtmouHuWcsUWH7I/CWnbEizkTaEf4yI/Iiy+DYhgMmYMAwbcuom/aTm5xOVjBk3UPtMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Csw0BfHw; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Csw0BfHw"
Message-ID: <37e584d1-1256-46ad-9ddf-0c4b8186db08@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZnCvjkBOiI3vs/EIfb+uZh3BeeEsDL1JmDGkWIqg1o=;
	b=Csw0BfHwNtQYzpRzS2SLNyiBhnOcCmi+9MqjruxtOErCUmSpv+5nI8Wqvjfmxo0p73K8Th
	WlQb0hu7T8LQsUcEB6rqVlCBlu3DP+Ch9VYGx3iYsCgV8xbKVE5KufCLNOFGmnKz6Th8pn
	WchHdPO4aCKbv7JyMB1U5jG1ltqdVNA=
Date: Fri, 6 Feb 2026 19:54:51 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 02/11] xfs: start creating infrastructure for health
 monitoring
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, p.raghav@samsung.com
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs>
 <176852588582.2137143.1283636639551788931.stgit@frogsfrogsfrogs>
 <tq3nyswm72gackesz6v476qqvin5eaa67f4hf6lg52exzv7k7p@tczjh5n777tc>
 <20260206174742.GI7693@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260206174742.GI7693@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2/6/26 18:47, Darrick J. Wong wrote:
> On Fri, Feb 06, 2026 at 02:07:56PM +0100, Pankaj Raghav (Samsung) wrote:
>>> +static DEFINE_SPINLOCK(xfs_healthmon_lock);
>>> +
>>> +/* Grab a reference to the healthmon object for a given mount, if any. */
>>> +static struct xfs_healthmon *
>>> +xfs_healthmon_get(
>>> +	struct xfs_mount		*mp)
>>> +{
>>> +	struct xfs_healthmon		*hm;
>>> +
>>> +	rcu_read_lock();
>>> +	hm = mp->m_healthmon;
>>
>> Nit: Should we do a READ_ONCE(mp->m_healthmon) here to avoid any
>> compiler tricks that can result in an undefined behaviour? I am not sure
>> if I am being paranoid here.
> 
> Compiler tricks?  We've taken the rcu read lock, which adds an
> optimization barrier so that the mp->m_healthmon access can't be
> reordered before the rcu_read_lock.  I'm not sure if that answers your
> question.
> 

This answers. So this is my understanding: RCU guarantees that we get a valid
object (actual data of m_healthmon) but does not guarantee the compiler will not reread
the pointer between checking if hm is !NULL and accessing the pointer as we are doing it
lockless.

So just a barrier() call in rcu_read_lock is enough to make sure this doesn't happen and probably
adding a READ_ONCE() is not needed?

--
Pankaj
